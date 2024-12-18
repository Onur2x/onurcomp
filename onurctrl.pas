unit onurctrl;

{$mode objfpc}{$H+}
{$modeswitch advancedrecords}
{$R 'onur.rc' onres.res}

interface

uses
  Windows, SysUtils, Forms, LCLType, LCLIntf, Classes,
  Controls, Graphics, BGRABitmap, BGRABitmapTypes,BGRACanvas,
  types, LazUTF8, Zipper, Dialogs,LMessages;

type
  TONURButtonState = (obshover, obspressed, obsnormal);
  TONURExpandStatus = (oExpanded, oCollapsed);
  TONURButtonDirection = (obleft, obright, obup, obdown);
  TONURSwichState = (FonN, FonH, FoffN, FoffH);
  TONURKindState = (oVertical, oHorizontal);
  TONURScroll = (FDown, FUp);
  TONURCapDirection = (ocup, ocdown, ocleft, ocright);


  { TonPersistent }
  TONURPersistent = class(TPersistent)
    owner: TPersistent;
  public
    constructor Create(AOwner: TPersistent); overload virtual;
  end;

 // type

  { TONURCustomCrop }

  TONURCustomCrop = class//record
  //private
   //FSLeft, FSTop, FSright, FSBottom: integer;
   public
   Croprect,Targetrect : Trect;
   Fontcolor           : Tcolor;
   Cropname            : string;
   constructor Create(fcropname: string);
  end;


  { TONURCUSTOMCROP }

{  TONURCustomCrop1 = class
    fFontcolor: Tcolor;
  public
    cropname: string;
    FSLeft, FSTop, FSright, FSBottom: integer;
    Targetrect: Trect;
    function Croprect: Trect;
    function Width: integer;
    function Height: integer;
    constructor Create;//override;
  published
    property Fontcolor: Tcolor read ffontcolor write ffontcolor;
    property Left: integer read FSLeft write FSLeft;
    property Top: integer read FSTop write FSTop;
    property Right: integer read FSright write FSright;
    property Bottom: integer read FSBottom write FSBottom;
  end;
  }
  { TONImg }

  { TONURImg }

  TONURImg = class(TComponent)
  private
    Fopacity: byte;
    FRes: TPicture;
    List: TStringList;
    fparent     : TForm;


    Fleft, FTopleft, FBottomleft, FRight, FTopRight,
    FBottomRight, FTop, FBottom, FCenter: TONURCUSTOMCROP;

    skinread,fformactive: boolean;
    Frmain, tempbitmap: TBGRABitmap;
    //clrr: string;
    ffilename: TFileName;
 //   fapplication:TApplication;
    //  const
    ColorTheme: string;//= 'ClNone';
    procedure Colorbgrabitmap;
    procedure CropToimgForm(Buffer: TBGRABitmap);
    procedure deactive(Sender:TObject);
    function GetColor: string;
    procedure ImageSet(Sender: TObject);
    // Procedure Loadskin2;
    procedure mousedwn(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: integer);
    procedure pant(Sender: TObject);
    procedure Setloadskin(AValue: string);
    procedure Setopacity(Avalue: byte);
    procedure Setcolor(colr: string);
    procedure resize(Sender: TObject);
    procedure setWindowState(a:TWindowState);
    function  getWindowState: TWindowState;
  public
    Fimage: TBGRABitmap;
    Blend, ThemeStyle, Skinname, Version, Author, Email,
    Homepage, Comment, Screenshot: string;

    Customcroplist: TList;
   // Fparent: TForm;

    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure ReadSkinsComp(Com: TComponent);


    procedure Loadskin(FileName: string; const Resource: boolean = False);
    procedure GetSkinInfo(const FileName: string; const Resource: boolean = False);
    procedure Saveskin(filename: string);
    procedure Refresh;
    procedure formactive(xx:boolean);
    property SkinFilename :string read ffilename;
    property WindowState:TWindowState read getWindowState write setWindowState;
  published

    property MColor: string read GetColor write Setcolor;
    property Picture: TPicture read FRes write Fres;
    property Opacity: byte read fopacity write SetOpacity;
    property LoadSkins: string read ffilename write Setloadskin;//Loadskin;
  end;

 { TONURWinControl = class(TWinControl)
  private
   FSkindata: TONURImg;
   FAlignment: TAlignment;
   Fkind: TONURkindstate;
   Fskinname: string;
   falpha: byte;
   Fcanvas : TControlCanvas;
   function GetSkindata: TONURImg;
   procedure WMEraseBkgnd(var Message: TWMEraseBkgnd); message WM_ERASEBKGND;
   procedure CreateParams(var Params: TCreateParams);
   procedure SetAlignment(const Value: TAlignment);
   function GetTransparent: boolean;
   procedure SetTransparent(NewTransparent: boolean);
   function Getkind: Tonurkindstate;
   procedure setalpha(val: byte);
   procedure WMPaint(var Msg: TLMPaint); message LM_PAINT;
  public
    { Public declarations }
    Captionvisible: boolean;
    resim: TBGRABitmap;
    Customcroplist: TFPList;//TList;
    Backgroundbitmaped: boolean;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
 //   procedure Paint; override;
  protected
    procedure Resize; override;
    procedure SetKind(AValue: TONURkindstate); virtual;
    procedure SetSkindata(Aimg: TONURImg); virtual;
    procedure Setskinname(Avalue: string); virtual;
    property Kind: TONURkindstate read Getkind
      write Setkind default oHorizontal;
  published
    property Align;
    property Alignment: TAlignment read FAlignment
      write SetAlignment default taCenter;
    property Alpha: byte read falpha write setalpha default 255;
    property Transparent: boolean read GetTransparent
      write SetTransparent default True;
    property Skindata: TONURImg read GetSkindata write SetSkindata;
    property Skinname: string read fskinname write Setskinname;
    property Anchors;
    property AutoSize;
    property BorderSpacing;
    property BidiMode;
    //property Caption;
    property ClientHeight;
    property ClientWidth;
    property Color;
    property Constraints;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property Font;
    property ParentBidiMode;
    property ParentColor;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property Visible;
    property OnClick;
    property OnContextPopup;
    property OnDblClick;
    property OnEndDock;
    property OnEndDrag;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnMouseWheel;
    property OnMouseWheelDown;
    property OnMouseWheelUp;
    property OnResize;
  end;
  }
  { TONURGraphicControl }

  TONURGraphicControl = class(TGraphicControl)
  private
    FSkindata: TONURImg;
    FAlignment: TAlignment;
    Fkind: TONURkindstate;
    Fskinname: string;
    falpha: byte;

    function GetSkindata: TONURImg;
    procedure WMEraseBkgnd(var Message: TWMEraseBkgnd); message WM_ERASEBKGND;
    procedure CreateParams(var Params: TCreateParams);
    procedure SetAlignment(const Value: TAlignment);
    function GetTransparent: boolean;
    procedure SetTransparent(NewTransparent: boolean);
    function Getkind: Tonurkindstate;

    procedure setalpha(val: byte);
  public
    { Public declarations }
    Captionvisible: boolean;
    resim: TBGRABitmap;
    Customcroplist: TFPList;//TList;
    Backgroundbitmaped: boolean;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Paint; override;
  protected
    procedure Resize; override;
    procedure SetKind(AValue: TONURkindstate); virtual;
    procedure SetSkindata(Aimg: TONURImg); virtual;
    procedure Setskinname(Avalue: string); virtual;
    property Kind: TONURkindstate read Getkind
      write Setkind default oHorizontal;
  published
    property Align;
    property Alignment: TAlignment read FAlignment
      write SetAlignment default taCenter;
    property Alpha: byte read falpha write setalpha default 255;
    property Transparent: boolean read GetTransparent
      write SetTransparent default True;
    property Skindata: TONURImg read GetSkindata write SetSkindata;
    property Skinname: string read fskinname write Setskinname;
    property Anchors;
    property AutoSize;
    property BorderSpacing;
    property BidiMode;
    //property Caption;
    property ClientHeight;
    property ClientWidth;
    property Color;
    property Constraints;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property Font;
    property ParentBidiMode;
    property ParentColor;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property Visible;
    property OnClick;
    property OnContextPopup;
    property OnDblClick;
    property OnEndDock;
    property OnEndDrag;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnMouseWheel;
    property OnMouseWheelDown;
    property OnMouseWheelUp;
    property OnPaint;
    property OnResize;
  end;

  { Tonurcustomcontrol }

  TONURCustomControl = class(TCustomControl)
  private
    Fcrop: boolean;
    FSkindata: TONURImg;
    FAlignment: TAlignment;

    Fkind: TonURkindstate;
    fskinname: string;
    falpha: byte;
    function GetSkindata: TONURImg;
    function Getskinname: string;
    procedure SetCrop(Value: boolean);
    function Getkind: TonURkindstate;
    procedure SetKind(AValue: TonURkindstate);

    procedure SetAlignment(const Value: TAlignment);

    procedure setalpha(val: byte);
    procedure WMEraseBkgnd(var Message: TWMEraseBkgnd); message WM_ERASEBKGND;
     procedure CreateParams(var Params: TCreateParams);
  public
    { Public declarations }
    resim: TBGRABitmap;
    //WindowRgn: HRGN;
    Captionvisible: boolean;
    Backgroundbitmaped: boolean;
    Customcroplist: TFPList;//TList;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Paint; override;
  protected
    procedure Resize; override;
    procedure CropToimg(Buffer: TBGRABitmap); virtual;
    procedure SetSkindata(Aimg: TONURImg); virtual;
    procedure Setskinname(Avalue: string); virtual;
    property Kind: TonURkindstate read Getkind write Setkind default
      oHorizontal;
  published
    property Align;
    property Alignment: TAlignment
      read FAlignment write SetAlignment default taCenter;
    property Alpha: byte read falpha write setalpha default 255;
    property Skindata: TONURImg read GetSkindata write SetSkindata;
    property Skinname: string read Getskinname write Setskinname;
    property Crop: boolean read Fcrop write SetCrop default False;
    property Anchors;
    property AutoSize;
    property BidiMode;
   // property Caption;
    property ChildSizing;
    property ClientHeight;
    property ClientWidth;
    property Color;
    property Constraints;
    property DockSite;
    property DoubleBuffered;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property Font;
    property ParentBackground;
    property ParentBidiMode;
    property ParentColor;
    property ParentDoubleBuffered;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property UseDockManager default True;
    property Visible;
    property OnClick;
    property OnContextPopup;
    property OnDockDrop;
    property OnDockOver;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property ONENTER;
    property OnExit;
    property OnGetSiteInfo;
    property OnGetDockCaption;
    property OnMouseDown;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseMove;
    property OnMouseUp;
    property OnMouseWheel;
    property OnMouseWheelDown;
    property OnMouseWheelUp;
    property OnPaint;
    property OnResize;
    property OnStartDock;
    property OnStartDrag;
    property OnUnDock;
  end;



procedure DrawPartnormali(ARect: TRect; Target: TOnURCustomControl;
  x, y, w, h: integer; Opaque: byte);

procedure DrawPartnormali(ARect: TRect; Target: TONURGraphicControl;
  x, y, w, h: integer; Opaque: byte);

procedure DrawPartnormali(ARect: TRect; Target: TOnURCustomControl;
  x, y, w, h: integer; Opaque: byte; txt: string; Txtalgn: TAlignment; colorr: TBGRAPixel);

procedure DrawPartnormali(t:TOnURCustomControl;ARect: TRect; Target: TBGRABitmap;
  x, y, w, h: integer; Opaque: byte; txt: string; Txtalgn: TAlignment; colorr: TBGRAPixel);

procedure DrawPartnormali(t:TOnURCustomControl;ARect: TRect; Target: TBGRABitmap;
  x, y, w, h: integer; Opaque: byte);

procedure DrawPartnormal(ARect: TRect; Target: TOnURCustomControl;
  ATargetRect: TRect; Opaque: byte);

procedure DrawPartnormaltext(ARect: TRect; Target: TOnURCustomControl;
  ATargetRect: TRect; Opaque: byte; txt: string; Txtalgn: TAlignment; colorr: TBGRAPixel);

procedure DrawPartnormaltext(t:TONURCustomControl;ARect: TRect; Target: TBGRABitmap;
  ATargetRect: TRect; Opaque: byte; txt: string; Txtalgn: TAlignment; colorr: TBGRAPixel);

procedure DrawPartnormaltext(t:TONURImg;ARect:TRect;Target:TBGRABitmap;ATargetRect:TRect;
  Opaque:byte;txt:string;Txtalgn:TAlignment;colorr:TBGRAPixel);

procedure DrawPartstrechRegion(ARect: TRect; Target: TOnURCustomControl;
  NewWidth, NewHeight: integer; ATargetRect: TRect; Opaque: byte);

procedure DrawPartstrechRegion(ARect: TRect; Target: TOnURGraphicControl;
  NewWidth, NewHeight: integer; ATargetRect: TRect; Opaque: byte);

procedure DrawPartnormal(ARect: TRect; Target: TOnURGraphicControl;
  ATargetRect: TRect; Opaque: byte);

procedure DrawPartnormal(ARect: TRect; Target, Desc: TBgrabitmap;
  ATargetRect: TRect; Opaque: byte);

procedure DrawPartstrechRegion(ARect: TRect; Target,desc: TBgrabitmap;
  NewWidth, NewHeight: integer; ATargetRect: TRect; Opaque: byte);

procedure DrawPartnormalbmp(ARect: TRect;
  Target: TOnURGraphicControl; Targetbmp: TBGRABitmap; ATargetRect: TRect;
  Opaque: byte);

procedure DrawPartstrech(ARect: TRect; Target: TOnURGraphicControl;
  w, h: integer; Opaque: byte);

procedure DrawPartstrech(ARect: TRect; Target: TOnURCustomControl;
  w, h: integer; Opaque: byte);

procedure DrawPartnormalBGRABitmap(ARect: TRect;
  Target: TBGRABitmap; Skindatap: Tonurimg; ATargetRect: TRect; Opaque: byte);

function ValueRange(const Value, Min, Max: integer): integer;
function maxlengthstring(s: string; len: integer): string;

procedure yaziyaz(TT: TCanvas; TF: TFont; re: TRect; Fcap: string; asd: TAlignment);
procedure yaziyaz(TT: TCanvas; TF: TFont; re: TRect; Fcap: string; X,Y:integer);
procedure yaziyazBGRA(TT: TBGRACanvas; TF: TFont; re: TRect; Fcap: string; asd: TAlignment);

procedure replacepixel(BMP{, Bmp2}: TBGRABitmap; clr: TBGRAPixel);

procedure Register;



implementation



uses //onuredit, onurbar, onurbutton, onurpage, onurlist,   onurpanel,
onurmenu,onurbutton,
  inifiles,BGRAGrayscaleMask;

procedure Register;
begin
  RegisterComponents('ONUR', [TONURImg]);
end;

function maxlengthstring(s: string; len: integer): string;
begin
  if len = 0 then
  begin
    Result := s;
    exit;
  end;
  if Length(s) >= len then
    Result := LeftStr(s, len) + '..'
  else
    Result := s;
end;


function StringLeftJustify(Space: word; Str: string): string;
var
  str_all: string;
  i: word;
begin
  str_all := '';
  if Length(Str) < Space then
  begin
    for i := 1 to Space - Length(Str) do
    begin
      Insert(' ', str_all, 1);
    end;
    str_all := Concat(Str, str_all);
    Result := str_all;
  end
  else
    Result := Str;
end;

function StringRigthJustify(Space: word; Str: string): string;
var
  str_all: string;
  i: word;
begin
  str_all := '';
  if Length(Str) < Space then
  begin
    for i := 1 to Space - Length(Str) do
    begin
      Insert(' ', str_all, 1);
    end;
    str_all := Concat(str_all, Str);
    Result := str_all;
  end
  else
    Result := Str;
end;

function randomNumber(LowBound, HighBound: integer): integer;
begin
  randomize;
  Result := LowBound + random(HighBound - LowBound + 1);
end;

function RandomString(PWLen: integer): string;
const
  StrTable: string =
    '!#$%&/()=?@<>|{[]}\*~+#;:.-_' + 'ABCDEFGHIJKLMabcdefghijklm' +
    '0123456789' + 'NOPQRSTUVWXYZnopqrstuvwxyz';
var
  N, K, X, Y: integer;
begin

  Randomize;
  if (PWlen > Length(StrTable)) then K := Length(StrTable) - 1
  else
    K := PWLen;
  SetLength(Result, K);
  Y := Length(StrTable);
  N := 0;

  while N < K do
  begin
    X := Random(Y) + 1;
    if (pos(StrTable[X], Result) = 0) then
    begin
      Inc(N);
      Result[N] := StrTable[X];
    end;
  end;
end;

function colortohtml(clr: Tcolor): Tcolor;
var
  TheRgbValue: TColorRef;
begin
  TheRgbValue := ColorToRGB(Clr);
  Result := stringtocolor(Format('#%.2x%.2x%.2x',
    [GetRValue(TheRGBValue), GetGValue(TheRGBValue), GetBValue(TheRGBValue)]));

end;

function GetTempDirOLD: string;
var
  lng: DWORD;
begin
  SetLength(Result, MAX_PATH);
  lng := GetTempPath(MAX_PATH, PChar(Result));
  SetLength(Result, lng);
end;

procedure yaziyaz(TT: TCanvas; TF: TFont; re: TRect; Fcap: string; asd: TAlignment);
// For caption
var
  stl: TTextStyle;
begin
  TT.Font.Quality := fqClearType;
  TT.Font.Name := TF.Name;
  TT.Font.Size := TF.size;
  TT.Font.Color := TF.Color;
  TT.Font.style := TF.style;
  TT.Font.Orientation := TF.Orientation;
  TT.Brush.Style := bsClear;
  stl.Alignment := asd;
  stl.Wordbreak := True;
  stl.Layout := tlCenter;
  stl.SingleLine := False;

  {fcap:= maxlengthstring(fcap,RE.Width;  }
  TT.TextRect(RE, 0, 0, fcap, stl);
end;

procedure yaziyaz(TT: TCanvas; TF: TFont; re: TRect; Fcap: string; X, Y: integer
  );
var
  stl: TTextStyle;
begin
  TT.Font.Quality     := fqCleartype;
  TT.Font.Name        := TF.Name;
  TT.Font.Height      := TF.size+20;
  TT.Font.Color       := TF.Color;// xor $FFFFFF;
  TT.Font.style       := TF.style;
  TT.Font.Orientation := TF.Orientation;
  TT.Brush.Style      := bsClear;
//  stl.Alignment       := asd;
  stl.Wordbreak       := True;
  stl.Layout          := tlCenter;
  stl.SingleLine      := False;
  TT.TextRect(re, X, Y, Fcap, stl);

end;

procedure yaziyazBGRA(TT: TBGRACanvas; TF: TFont; re: TRect; Fcap: string; asd: TAlignment);
// For caption
var
  stl: TTextStyle;
begin
  TT.Font.Quality     := fqSystemClearType;
  TT.Font.Name        := TF.Name;
  TT.Font.Height      := TF.size+10;
  TT.Font.Color       := TF.Color;// xor $FFFFFF;
  TT.Font.style       := TF.style;
 // TT.Font.Opacity     := 255;
  TT.Font.Orientation := TF.Orientation;
  TT.Brush.Style      := bsClear;
  stl.Alignment       := asd;
  stl.Wordbreak       := True;
  stl.Layout          := tlCenter;
  stl.SingleLine      := False;
  TT.TextRect(re, 0, 0, Fcap, stl);
end;






function ValueRange(const Value, Min, Max: integer): integer;
begin
  if Value < Min then
    Result := Min
  else if Value > Max then
    Result := Max
  else
    Result := Value;
end;

function PercentValue(const Value, Percent: integer): integer;
begin
  Result := Round(Value / 100 * Percent);
end;

function PercentValue(const Value, Percent: double): double;
begin
  Result := Value / 100 * Percent;
end;


function GetScreenClient(Control: TControl): TPoint;
var
  p: TPoint;
begin
  p := Control.ClientOrigin;
  ScreenToClient(Control.Parent.Handle, p);
  Result := p;
end;


function RegionFromBGRABitmap(const ABMP: TBGRABitmap): HRGN;
var
  Rgn1, Rgn2: HRGN;
  x, y, z: integer;
begin
  Rgn1 := 0;
  for y := 0 to ABMP.Height - 1 do
  begin
    x := 0;
    while (x <= ABMP.Width) do
    begin
      while (ABMP.GetPixel(x, y).alpha {<255)  GetAlpha(ABMP.GetPixel(x, y]^)))} <
          255) and (x < ABMP.Width) do
        Inc(x);
      z := x;
      while (ABMP.GetPixel(x, y).alpha{(GetAlpha(ABMP.PixelPtr[x, y]^))} = 255) and
        (x < ABMP.Width) do
        Inc(x);

      if Rgn1 = 0 then
        Rgn1 := CreateRectRGN(z, y, x, y + 1)
      else
      begin
        Rgn2 := CreateRectRgn(z, y, x, y + 1);
        if Rgn2 <> 0 then
        begin
          CombineRgn(Rgn1, Rgn1, Rgn2, RGN_OR);
          DeleteObject(Rgn2);
        end;
      end;
      Inc(x);
    end;
  end;
  Result := Rgn1;
end;


procedure Premultiply(BMP: TBGRABitmap);
var
  iX, iY: integer;
  p: PBGRAPixel;
begin

  for iY := 0 to BMP.Height - 1 do
  begin
    p := BMP.Scanline[iY];
    for iX := BMP.Width - 1 downto 0 do
    begin
      if p^.Alpha = 0 then
        p^ := BGRAPixelTransparent
      else
      begin
        p^.Red := p^.Red * (p^.Alpha + 1) shr 8;
        p^.Green := p^.Green * (p^.Alpha + 1) shr 8;
        p^.Blue := p^.Blue * (p^.Alpha + 1) shr 8;
      end;
      Inc(p);
    end;
  end;
end;

procedure CropBGRA(var LBitmap : TBgraBitmap);
const
     CThreshold = 25;
var
     LMask: TGrayscaleMask;
     LData: PByte;
     LRect: TRect;
     LIndex: integer;
begin
     // make a copy of the alpha channel
     LMask := TGrayscaleMask.Create(LBitmap, cAlpha);
     LData := LMask.Data;
     for LIndex := LMask.NbPixels - 1 downto 0 do
     begin
       if LData^ < CThreshold then
         LData^ := 0;
       Inc(LData);
     end;
     // get bounds of the modified mask
     LRect := LMask.GetImageBounds;
     LMask.Free;
     BGRAReplace(LBitmap, LBitmap.GetPart(LRect));
end;


procedure replacepixel(BMP, Bmp2: TBGRABitmap; clr: TBGRAPixel);
var
  i: integer;
  p, k: PBGRAPixel;
begin
  k := bmp.Data;
  p := bmp2.Data;
  //for i := 0 to bmp.NbPixels - 1 do
  for i := bmp.NbPixels - 1 downto 0 do
  begin
    if k^.alpha <> 0 then
      p^ := clr;

    Inc(k);
    Inc(p);
  end;
end;

procedure replacepixel(BMP: TBGRABitmap; clr: TBGRAPixel);
var
  i: integer;
  k: PBGRAPixel;
begin
  k := bmp.Data;

  for i := bmp.NbPixels - 1 downto 0 do
  begin
    if k^.alpha <> 0 then
      k^ := clr;

    Inc(k);

  end;
end;

procedure DrawPartstrech(ARect: TRect; Target: TOnURCustomControl;
  w, h: integer; Opaque: byte);
var
  img: TBGRACustomBitmap;
  partial: TBGRACustomBitmap;
begin
 { if (ARect.Left = 0) and (ARect.Top = 0) and (ARect.Right = W) and
    (ARect.Bottom = h) then
    Target.resim.PutImage(0, 0, Target.FSkindata.Fimage, dmDrawWithTransparency, Opaque) }
  if (ARect.Width = 0) and (ARect.Height = 0) then
   Target.resim.Fill(BGRA(190, 208, 190), dmSet)

  else
  begin
    img := Target.FSkindata.Fimage.GetPart(ARect);
    if img <> nil then
    begin
      Target.resim.ResampleFilter := rfBestQuality;
      img.ResampleFilter := rfBestQuality;

      partial := img.Resample(w, h, rmFineResample) as TBGRABitmap;
      if partial <> nil then
        Target.resim.PutImage(0, 0, partial, dmDrawWithTransparency, Opaque);
      FreeAndNil(partial);
    end;
    FreeAndNil(img);
  end;
end;

procedure DrawPartstrech(ARect: TRect; Target: TOnURGraphicControl;
  w, h: integer; Opaque: byte);
var
  img: TBGRACustomBitmap;
  partial: TBGRACustomBitmap;
begin
 { if (ARect.Left = 0) and (ARect.Top = 0) and (ARect.Right = W) and
    (ARect.Bottom = h) then
    Target.resim.PutImage(0, 0, Target.FSkindata.Fimage, dmDrawWithTransparency, Opaque)}
 if (ARect.Width = 0) and (ARect.Height = 0) then
   Target.resim.Fill(BGRA(190, 208, 190), dmSet)
  else
  begin
    img := Target.FSkindata.Fimage.GetPart(ARect);
    if img <> nil then
    begin
      Target.resim.ResampleFilter := rfBestQuality;
      img.ResampleFilter := rfBestQuality;
      partial := img.Resample(w, h, rmFineResample) as TBGRABitmap;
      if partial <> nil then
        Target.resim.PutImage(0, 0, partial, dmDrawWithTransparency, Opaque);
      FreeAndNil(partial);
    end;
    FreeAndNil(img);
  end;

end;


procedure DrawPartnormalbmp(ARect: TRect; Target: TOnURGraphicControl;
  Targetbmp: TBGRABitmap; ATargetRect: TRect; Opaque: byte);
var
  partial: TBGRACustomBitmap;
begin
 { if (ARect.Left = 0) and (ARect.Top = 0) and (ARect.Right = Target.Width) and
    (ARect.Bottom = Target.Height) then
    Target.FSkindata.Fimage.Draw(Target.Canvas, ATargetRect, False)  }
  if (ARect.Width = 0) and (ARect.Height = 0) then
   Target.fSkindata.Fimage.Fill(BGRA(190, 208, 190), dmSet)
  else
  begin
    partial := Target.FSkindata.Fimage.GetPart(ARect);

    if partial <> nil then
      partial.Draw(Targetbmp.Canvas, ATargetRect, False);
    FreeAndNil(partial);
  end;

end;


procedure DrawPartnormal(ARect: TRect; Target: TOnURCustomControl;
  ATargetRect: TRect; Opaque: byte);
var
  partial: TBGRACustomBitmap;
begin
  {if (ARect.Left = 0) and (ARect.Top = 0) and (ARect.Right = Target.Width) and
    (ARect.Bottom = Target.Height) then
    Target.resim.StretchPutImage(ATargetRect, Target.FSkindata.Fimage, dmSet, Opaque) }
  if (ARect.Width = 0) and (ARect.Height = 0) then
   Target.resim.Fill(BGRA(190, 208, 190), dmSet)
  else
  begin
    partial := Target.FSkindata.Fimage.GetPart(ARect);

    if partial <> nil then
      Target.resim.StretchPutImage(ATargetRect, partial, dmDrawWithTransparency, Opaque);
    FreeAndNil(partial);
  end;

end;


procedure DrawPartnormal(ARect: TRect; Target: TOnURGraphicControl;
  ATargetRect: TRect; Opaque: byte);
var
  partial: TBGRACustomBitmap;
begin
  {if (ARect.Left = 0) and (ARect.Top = 0) and (ARect.Right = Target.Width) and
    (ARect.Bottom = Target.Height) then
    Target.FSkindata.Fimage.Draw(Target.Canvas, ATargetRect, False) }
     if (ARect.Width = 0) and (ARect.Height = 0) then
   Target.FSkindata.Fimage.Fill(BGRA(190, 208, 190), dmSet)
  else
  begin
    partial := Target.FSkindata.Fimage.GetPart(ARect);
    if partial <> nil then
      Target.resim.StretchPutImage(ATargetRect, partial, dmDrawWithTransparency, Opaque);
    FreeAndNil(partial);
  end;

end;

procedure DrawPartnormalBGRABitmap(ARect: TRect; Target: TBGRABitmap; Skindatap: TONURImg;
  ATargetRect: TRect; Opaque: byte);
var
  partial: TBGRACustomBitmap;
begin
 { if (ARect.Left = 0) and (ARect.Top = 0) and (ARect.Right = Target.Width) and
    (ARect.Bottom = Target.Height) then
    Skindatap.Fimage.Draw(Target.Canvas, ATargetRect, False) }
   if (ARect.Width = 0) and (ARect.Height = 0) then
   Skindatap.Fimage.Fill(BGRA(190, 208, 190), dmSet)
  else
  begin
    partial := Skindatap.Fimage.GetPart(ARect);
    if partial <> nil then
      Target.StretchPutImage(ATargetRect, partial, dmDrawWithTransparency, Opaque);
    FreeAndNil(partial);
  end;

end;


procedure DrawPartnormal(ARect: TRect; Target, Desc: TBgrabitmap;
  ATargetRect: TRect; Opaque: byte);
var
  partial: TBGRACustomBitmap;
begin
  {if (ARect.Left = 0) and (ARect.Top = 0) and (ARect.Right = Target.Width) and
    (ARect.Bottom = Target.Height) then
    Target.Draw(Target.Canvas, ATargetRect, False)  }
   if (ARect.Width = 0) and (ARect.Height = 0) then
   Target.Fill(BGRA(190, 208, 190), dmSet)
  else
  begin
    partial := Desc.GetPart(ARect);

    if partial <> nil then
      Target.StretchPutImage(ATargetRect, partial, dmDrawWithTransparency, Opaque);
    FreeAndNil(partial);
  end;

end;
procedure DrawPartstrechRegion(ARect:TRect;Target,desc:TBgrabitmap;NewWidth,
  NewHeight:integer;ATargetRect:TRect;Opaque:byte);
var
  img: TBGRACustomBitmap;
  partial: TBGRACustomBitmap;
begin

  img := Desc.GetPart(ARect);
  if img <> nil then
  begin
    partial := TBGRABitmap.Create(NewWidth, NewHeight);
    partial := img.Resample(NewWidth, NewHeight) as TBGRABitmap;
    if partial <> nil then
    begin
      Target.StretchPutImage(ATargetRect, partial, dmDrawWithTransparency, Opaque);
    end;
    FreeAndNil(partial);
  end;
  FreeAndNil(img);
end;

procedure DrawPartstrechRegion(ARect: TRect; Target: TOnURGraphicControl;
  NewWidth, NewHeight: integer; ATargetRect: TRect; Opaque: byte);
var
  img: TBGRACustomBitmap;
  partial: TBGRACustomBitmap;
begin
  img := Target.FSkindata.Fimage.GetPart(ARect);
  if img <> nil then
  begin
    partial := TBGRABitmap.Create(NewWidth, NewHeight);
    partial := img.Resample(NewWidth, NewHeight) as TBGRABitmap;

    if partial <> nil then
      Target.resim.StretchPutImage(ATargetRect, partial, dmDrawWithTransparency, Opaque);
    FreeAndNil(partial);
  end;
  FreeAndNil(img);
end;


procedure DrawPartstrechRegion(ARect: TRect; Target: TOnURCustomControl;
  NewWidth, NewHeight: integer; ATargetRect: TRect; Opaque: byte);
var
  img: TBGRACustomBitmap;
  partial: TBGRACustomBitmap;
begin

  img := Target.FSkindata.Fimage.GetPart(ARect);
  if img <> nil then
  begin
    partial := TBGRABitmap.Create(NewWidth, NewHeight);
    partial := img.Resample(NewWidth, NewHeight) as TBGRABitmap;
    if partial <> nil then
    begin
      Target.resim.StretchPutImage(ATargetRect, partial, dmDrawWithTransparency, Opaque);
    end;
    FreeAndNil(partial);
  end;
  FreeAndNil(img);

end;




procedure DrawPartnormaltext(ARect: TRect; Target: TOnURCustomControl;
  ATargetRect: TRect; Opaque: byte; txt: string; Txtalgn: TAlignment; colorr: TBGRAPixel);
var
  partial: TBGRACustomBitmap;
begin
 { if (ARect.Left = 0) and (ARect.Top = 0) and (ARect.Right = Target.Width) and
    (ARect.Bottom = Target.Height) then
    Target.resim.StretchPutImage(ATargetRect, Target.FSkindata.Fimage, dmSet, Opaque) }
     if (ARect.Width = 0) and (ARect.Height = 0) then
   Target.resim.Fill(BGRA(190, 208, 190), dmSet)
  else
  begin
    partial := Target.FSkindata.Fimage.GetPart(ARect);

    if partial <> nil then
    begin
      Target.resim.StretchPutImage(ATargetRect, partial, dmDrawWithTransparency, Opaque);
      ATargetRect.left := ATargetRect.left + 1;
      ATargetRect.right := ATargetRect.right - 1;
      ATargetRect.top := ATargetRect.top + 1;
      ATargetRect.bottom := ATargetRect.bottom - 1;
      ATargetRect.Left:=ATargetRect.Left+10;
      Target.resim.TextRect(ATargetRect, txt, Txtalgn, tlCenter, colorr);
    end;
    FreeAndNil(partial);
  end;

end;


procedure DrawPartnormali(ARect: TRect; Target: TOnURCustomControl;
  x, y, w, h: integer; Opaque: byte; txt: string; Txtalgn: TAlignment; colorr: TBGRAPixel);
var
  partial: TBGRACustomBitmap;
  r: Trect;
begin
  partial := Target.FSkindata.Fimage.GetPart(ARect);
  r := Rect(x, y, w, h);
  if partial <> nil then
    Target.resim.StretchPutImage(R, partial, dmDrawWithTransparency, Opaque);
  Target.resim.TextOut(x + 5, y + 5, txt, colorr);
  partial.Free;
end;

procedure DrawPartnormali(ARect: TRect; Target: TOnURCustomControl;
  x, y, w, h: integer; Opaque: byte);
var
  partial: TBGRACustomBitmap;
begin
  partial := Target.FSkindata.Fimage.GetPart(ARect);
  if partial <> nil then
    Target.resim.StretchPutImage(Rect(x, y, w, h), partial,
      dmDrawWithTransparency, Opaque);
  partial.Free;
end;

procedure DrawPartnormali(ARect: TRect; Target: TONURGraphicControl;
  x, y, w, h: integer; Opaque: byte);
var
  partial: TBGRACustomBitmap;
begin
  partial := Target.FSkindata.Fimage.GetPart(ARect);
  if partial <> nil then
    Target.resim.StretchPutImage(Rect(x, y, w, h), partial,
      dmDrawWithTransparency, Opaque);
  partial.Free;
end;

procedure DrawPartnormaltext(t:TONURCustomControl;ARect:TRect;Target:TBGRABitmap;ATargetRect:TRect;
  Opaque:byte;txt:string;Txtalgn:TAlignment;colorr:TBGRAPixel);
var
  partial: TBGRACustomBitmap;
begin
  if (ARect.Width = 0) and (ARect.Height = 0) then
   Target.Fill(BGRA(190, 208, 190), dmSet)
  else
  begin
    partial := t.FSkindata.Fimage.GetPart(ARect);

    if partial <> nil then
    begin
      target.StretchPutImage(ATargetRect, partial, dmDrawWithTransparency, Opaque);
      ATargetRect.left := ATargetRect.left + 1;
      ATargetRect.right := ATargetRect.right - 1;
      ATargetRect.top := ATargetRect.top + 1;
      ATargetRect.bottom := ATargetRect.bottom - 1;
      ATargetRect.Left:=ATargetRect.Left+10;
      Target.TextRect(ATargetRect, txt, Txtalgn, tlCenter, colorr);
    end;
    FreeAndNil(partial);
  end;
end;



procedure DrawPartnormaltext(t:TONURImg;ARect:TRect;Target:TBGRABitmap;
  ATargetRect:TRect;Opaque:byte;txt:string;Txtalgn:TAlignment;colorr:TBGRAPixel)
  ;
var
  partial: TBGRACustomBitmap;
begin
  if (ARect.Width = 0) and (ARect.Height = 0) then
   Target.Fill(BGRA(190, 208, 190), dmSet)
  else
  begin
    partial := t.Fimage.GetPart(ARect);

    if partial <> nil then
    begin
      target.StretchPutImage(ATargetRect, partial, dmDrawWithTransparency, Opaque);
      ATargetRect.left := ATargetRect.left + 1;
      ATargetRect.right := ATargetRect.right - 1;
      ATargetRect.top := ATargetRect.top + 1;
      ATargetRect.bottom := ATargetRect.bottom - 1;
      ATargetRect.Left:=ATargetRect.Left+10;
      Target.TextRect(ATargetRect, txt, Txtalgn, tlCenter, colorr);
    end;
    FreeAndNil(partial);
  end;
end;


procedure DrawPartnormali(t:TOnURCustomControl;ARect:TRect;Target:TBGRABitmap;x,
  y,w,h:integer;Opaque:byte;txt:string;Txtalgn:TAlignment;colorr:TBGRAPixel);
var
  partial: TBGRACustomBitmap;
  r: Trect;
begin
  partial := T.FSkindata.Fimage.GetPart(ARect);
  r := Rect(x, y, w, h);
  if partial <> nil then
    Target.StretchPutImage(R, partial, dmDrawWithTransparency, Opaque);
  Target.TextOut(x + 5, y + 5, txt, colorr);
  partial.Free;
end;

procedure DrawPartnormali(t:TOnURCustomControl;ARect:TRect;Target:TBGRABitmap;x,
  y,w,h:integer;Opaque:byte);
var
  partial: TBGRACustomBitmap;
begin
  partial := T.FSkindata.Fimage.GetPart(ARect);
  if partial <> nil then
    Target.StretchPutImage(Rect(x, y, w, h), partial,
      dmDrawWithTransparency, Opaque);
  partial.Free;

end;




procedure cropparse(Crp: TONURCustomCrop; val: string);
var
  myst: TStringList;
begin
  if val.Length > 0 then
  begin
    myst := TStringList.Create;
    try
      myst.Delimiter     := ',';
      myst.DelimitedText := val;
    {  Crp.Croprect.LEFT           := StrToIntDef(myst.Strings[0], 2);
      Crp.Croprect.TOP            := StrToIntDef(myst.Strings[1], 2);
      Crp.Croprect.RIGHT          := StrToIntDef(myst.Strings[2], 4);
      Crp.Croprect.BOTTOM         := StrToIntDef(myst.Strings[3], 4);
     }

      Crp.Croprect       := Rect(StrToIntDef(myst.Strings[0], 2),StrToIntDef(myst.Strings[1], 4),StrToIntDef(myst.Strings[2], 4),StrToIntDef(myst.Strings[3], 4));

      if Crp.Croprect.IsEmpty then
      Crp.Croprect       := Rect(0,0,1,1);

      Crp.Fontcolor      := StringToColorDef(myst.Strings[4], clNone);
    finally
      myst.Free;
    end;
  end;
end;

function croptostring(Crp: TONURCustomCrop): string;
begin
 // Result := '';
  //if Crp <> nil then
  Result := IntToStr(Crp.Croprect.LEFT) + ',' + IntToStr(Crp.Croprect.TOP) + ',' +
      IntToStr(Crp.Croprect.RIGHT) + ',' + IntToStr(Crp.Croprect.BOTTOM) + ',' +
      ColorToString(Crp.Fontcolor);
end;



{ TONURCUSTOMCROP }
 {
function TONURCustomCrop.Croprect: Trect;
begin
  Result := rect(0, 0, 0, 0);
  if (Right > 0) and (Bottom > 0) then
    Result := rect(Left, Top, Right, Bottom);
end;

function TONURCustomCrop.Width: integer;
begin
  Result := 0;
  if Right > 0 then
    Result := Right - Left;
end;

function TONURCustomCrop.Height: integer;
begin
  Result := 0;
  if Bottom > 0 then
    Result := Bottom - Top;
end;
 }
constructor TONURCustomCrop.Create(fcropname: string);
begin
  inherited Create;
  if fcropname<>'' then
   Cropname:=fcropname;

end;




{ TonPersistent }

constructor tonURpersistent.Create(aowner: TPersistent);
begin
  inherited Create;
  owner := Aowner;
end;


{ Tonimg }

// -----------------------------------------------------------------------------
constructor TONURImg.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  fparent               := TForm(AOwner);
  Fparent.OnResize      := @Resize;
//  Fparent.OnActivate    := @deactive;
//  Fparent.OnDeactivate  := @deactive;
  fformactive           := true;
  FTop                  := TONURCUSTOMCROP.Create('TOP');
  FBottom               := TONURCUSTOMCROP.Create('BOTTOM');
  FCenter               := TONURCUSTOMCROP.Create('CENTER');
  FRight                := TONURCUSTOMCROP.Create('RIGHT');
  FTopRight             := TONURCUSTOMCROP.Create('TOPRIGHT');
  FBottomRight          := TONURCUSTOMCROP.Create('BOTTOMRIGHT');
  Fleft                 := TONURCUSTOMCROP.Create('LEFT');
  FTopleft              := TONURCUSTOMCROP.Create('TOPLEFT');
  FBottomleft           := TONURCUSTOMCROP.Create('BOTTOMLEFT');
  Customcroplist        := TList.Create;

  Customcroplist.Add(FTopleft);
  Customcroplist.Add(FTop);
  Customcroplist.Add(FTopRight);
  Customcroplist.Add(FBottomleft);
  Customcroplist.Add(FBottom);
  Customcroplist.Add(FBottomRight);
  Customcroplist.Add(Fleft);
  Customcroplist.Add(FRight);
  Customcroplist.Add(FCenter);

  Fimage                := TBGRABitmap.Create();
  FRes                  := TPicture.Create;
  Fres.OnChange         := @ImageSet;
  ColorTheme            := 'clnone';
  Fopacity              := 255;
  frmain                := TBGRABitmap.Create(self.fparent.clientWidth,
    self.fparent.clientHeight);
  tempbitmap            := TBGRABitmap.Create(self.fparent.clientWidth,
    self.fparent.clientHeight);
  List                  := TStringList.Create;

  if not (csDesigning in ComponentState) then
    //  exit;

    if ffilename <> '' then
      Loadskin(ffilename, False)
    else
      Loadskin('', True);

  //  if ffilename<>'' then
  //  ShowMessage(ffilename);
end;


destructor TONURImg.Destroy;
var
  i: byte;
begin
  for i := 0 to Customcroplist.Count - 1 do
    TONURCUSTOMCROP(Customcroplist.Items[i]).Free;

  Customcroplist.Clear;
  FreeAndNil(Customcroplist);

  FreeAndNil(List);
  FreeAndNil(Frmain);
  FreeAndNil(tempbitmap);
  FreeAndNil(FImage);
  FreeAndNil(FRes);
  inherited Destroy;

end;

procedure TONURImg.deactive(Sender: TObject);
//var
 // i:Integer;
begin
{for i:=0 to application.componentcount-1 do
   if application.components[i] is TForm then
   begin
   ReadSkinsComp(application.components[i]);
   end;}
end;
procedure TONURImg.ImageSet(Sender: TObject);
begin
  FreeAndNil(FImage);
  Fimage := TBGRABitmap.Create(Fres.Width, Fres.Height);
  Fimage.Assign(Fres.Bitmap);
  tempbitmap.Assign(Fimage);
end;


procedure TONURImg.Setcolor(colr: string);
begin
  if csDesigning in ComponentState then
    exit;
  ColorTheme := 'clnone';

  if (colr <> 'clnone') and (colr <> '') then
  begin
    ColorTheme := colr;

    // Frmain.PutImage(0, 0, Fimage, dmDrawWithTransparency, Fopacity);

    // Loadskin2;
    Colorbgrabitmap;
//    replacepixel(tempbitmap, ColorToBGRA(StringToColor(clrr), Fopacity));
  end;
end;

procedure TONURImg.resize(Sender: TObject);
begin

//  CropToimg(Fimage);

end;

procedure TONURImg.setWindowState(a:TWindowState);
begin
 if fparent.WindowState<>a then
  fparent.WindowState:=a;
end;

function TONURImg.getWindowState:TWindowState;
begin
 result:=fparent.WindowState;
end;


procedure TONURImg.Colorbgrabitmap;
var
  a: TBGRABitmap;
begin
  a := Tbgrabitmap.Create;
  try
    a.SetSize(tempbitmap.Width, tempbitmap.Height);
    replacepixel(tempbitmap, a, ColorToBGRA(StringToColor(ColorTheme), Opacity));
   // a.InvalidateBitmap;

    // Frmain.BlendImage(0, 0, a, boTransparent);
    Fimage.BlendImage(0, 0, a, boTransparent);
    //CropToimg(a);
    Refresh;
    // Loadskin2;
  finally
    FreeAndNil(a);
  end;
end;

procedure TONURImg.Setopacity(Avalue: byte);
var
  a: TBGRABitmap;
begin
  if Fopacity = Avalue then Exit;
  Fopacity := Avalue;

  a := TBGRABitmap.Create(Frmain.Width, Frmain.Height);
  try
    a.PutImage(0, 0, Fimage{tempbitmap}, dmDrawWithTransparency, 255);
    Frmain.SetSize(0, 0);
    Frmain.SetSize(a.Width, a.Height);
    Frmain.PutImage(0, 0, a, dmDrawWithTransparency, Fopacity);
    fparent.Invalidate;
  finally
    FreeAndNil(a);
  end;
end;

procedure TONURImg.CropToimgForm(Buffer: TBGRABitmap);
var
  x, y: integer;
  hdc1, SpanRgn: hdc;//integer;
  WindowRgn: HRGN;
  TrgtRect: Trect;
  p: PBGRAPixel;

  procedure DrawPart(ARect, ATargetRect: TRect);
  var
    partial: TBGRACustomBitmap;
  begin
    if (ARect.Left = 0) and (ARect.Top = 0) and (ARect.Right = buffer.Width) and
      (ARect.Bottom = buffer.Height) then
      Buffer.Draw(frmain.Canvas, ATargetRect, False)
    else
    begin
      partial := buffer.GetPart(ARect);
      if partial <> nil then
        frmain.StretchPutImage(ATargetRect, partial, dmDrawWithTransparency, 255);
      FreeAndNil(partial);
    end;
  end;

begin
  if csDesigning in ComponentState then
    exit;




  Frmain.SetSize(0, 0);
  frmain.SetSize(self.fparent.ClientWidth, self.fparent.ClientHeight);
  //TOPLEFT   //SOLÜST

  TrgtRect := Rect(0, 0, FTopleft.Croprect.Width, FTopleft.Croprect.Height);
  DrawPart(FTopleft.Croprect, TrgtRect);


  //TOPRIGHT //SAĞÜST
  TrgtRect := Rect(self.fparent.clientWidth - FTopRight.Croprect.Width, 0,
    self.fparent.ClientWidth, FTopRight.Croprect.Height);
  DrawPart(FTopRight.Croprect, TrgtRect);

  //TOP  //ÜST
  TrgtRect := Rect(FTopleft.Croprect.Width, 0, self.fparent.ClientWidth -
    FTopRight.Croprect.Width, FTop.Croprect.Height);
  DrawPart(FTop.Croprect, TrgtRect);



  //BOTTOMLEFT // SOLALT
  TrgtRect := Rect(0, self.fparent.ClientHeight - FBottomleft.Croprect.Height,
    FBottomleft.Croprect.Width, self.fparent.ClientHeight);
  DrawPart(FBottomleft.Croprect, TrgtRect);

  //BOTTOMRIGHT  //SAĞALT
  TrgtRect := Rect(self.fparent.ClientWidth - FBottomRight.Croprect.Width,
    self.fparent.ClientHeight - FBottomRight.Croprect.Height, self.fparent.ClientWidth,
    self.fparent.ClientHeight);
  DrawPart(FBottomRight.Croprect, TrgtRect);

  //BOTTOM  //ALT
  TrgtRect := Rect(FBottomleft.Croprect.Width, self.fparent.ClientHeight -
    FBottom.Croprect.Height, self.fparent.ClientWidth - FBottomRight.Croprect.Width,
    self.fparent.ClientHeight);
  DrawPart(fbottom.Croprect, TrgtRect);



  //CENTERLEFT // SOLORTA
  TrgtRect := Rect(0, FTopleft.Croprect.Height, Fleft.Croprect.Width,
    self.fparent.ClientHeight - FBottomleft.Croprect.Height);
  DrawPart(Fleft.Croprect, TrgtRect);

  //CENTERRIGHT // SAĞORTA
  TrgtRect := Rect(self.fparent.ClientWidth - FRight.Croprect.Width, FTopRight.Croprect.Height,
    self.fparent.ClientWidth, self.fparent.ClientHeight - FBottomRight.Croprect.Height);
  DrawPart(FRight.Croprect, TrgtRect);

  //CENTER //ORTA
  TrgtRect := Rect(Fleft.Croprect.Width, FTop.Croprect.Height, fparent.ClientWidth -
    FRight.Croprect.Width, fparent.ClientHeight - FBottom.Croprect.Height);
  DrawPart(FCenter.Croprect, TrgtRect);


  self.fparent.ChildSizing.LeftRightSpacing := Fleft.Croprect.Width;//+FRight.Width;
  self.fparent.ChildSizing.TopBottomSpacing := FTop.Croprect.Height;//+FBottom.Height;


  if ThemeStyle = 'modern' then        // if Theme style modern region corner
  begin
    WindowRgn := CreateRectRgn(0, 0, frmain.Width, frmain.Height);


  //  CropBGRA(frmain);



    for Y := 0 to frmain.Height - 1 do
    begin
      p := frmain.Scanline[Y];
      for X := frmain.Width - 1 downto 0 do
      begin

        if p^.Alpha < 20 then//<255 then
        begin
          p^ := BGRAPixelTransparent;
          SpanRgn := CreateRectRgn(x, y, x + 1, y + 1);
          CombineRgn(WindowRgn, WindowRgn, SpanRgn, RGN_DIFF);
          DeleteObject(SpanRgn);
       { end
        else
        begin
          p^.Red := p^.Red * (p^.Alpha + 1) shr 8;
          p^.Green := p^.Green * (p^.Alpha + 1) shr 8;
          p^.Blue := p^.Blue * (p^.Alpha + 1) shr 8;   }
        end;
        Inc(p);
      end;
    end;




    frmain.InvalidateBitmap;


    SetWindowRgn(self.fparent.Handle, WindowRgn, True);
    hdc1 := GetDC(fparent.Handle);
    ReleaseDC(self.fparent.Handle, hdc1);
    DeleteObject(WindowRgn);
    DeleteObject(hdc1);
  end;

end;

function TONURImg.GetColor: string;
begin
  result:=colortheme;
end;


procedure TONURImg.pant(Sender: TObject);
begin
  frmain.Draw(self.fparent.Canvas, 0, 0, False);
end;

procedure TONURImg.Setloadskin(AValue: string);
begin
  if (ffilename = AValue) or (ffilename = '') then Exit;
  ffilename := AValue;
  Loadskin(ffilename, False);
end;

procedure TONURImg.mousedwn(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: integer);
begin
  ReleaseCapture;
  SendMessage(self.fparent.Handle, WM_SYSCOMMAND, $F012, 0);
end;





procedure TONURImg.ReadSkinsComp(Com: TComponent);
var
  skn: TIniFile;
  a: integer;
begin


  if not FileExists(GetTempDir + 'skins.ini') then exit;
  skn := TIniFile.Create(GetTempDir + 'skins.ini');

 // writeln(GetTempDir);
  try
    with skn do
    begin

      if (Com is TForm) then
      begin
        if (Fimage <> nil) and (ThemeStyle = 'modern')
        {and (fparent.Name<>'skinsbuildier')} then
        begin
          cropparse(FTopleft, ReadString('FORM', FTOPLEFT.cropname,
            '0,0,0,0,clblack'));
          cropparse(FTopRight, ReadString('FORM', FTOPRIGHT.cropname,
            '0,0,0,0,clblack'));
          cropparse(FTop, ReadString('FORM', FTOP.cropname, '0,0,0,0,clblack'));
          cropparse(FBottomleft, ReadString('FORM',
            FBOTTOMLEFT.cropname, '0,0,0,0,clblack'));
          cropparse(FBottomRight, ReadString('FORM',
            FBOTTOMRIGHT.cropname, '0,0,0,0,clblack'));
          cropparse(FBottom, ReadString('FORM', FBOTTOM.cropname, '0,0,0,0,clblack'));
          cropparse(Fleft, ReadString('FORM', FLEFT.cropname, '0,0,0,0,clblack'));
          cropparse(FRight, ReadString('FORM', FRIGHT.cropname, '0,0,0,0,clblack'));
          cropparse(FCenter, ReadString('FORM', FCENTER.cropname, '0,0,0,0,clblack'));
          tempbitmap.SetSize(0,0);
          tempbitmap.putimage(0, 0, Fimage, dmSetExceptTransparent, 255);

          colortheme := ReadString('FORM', 'Color', 'ClNone');
          Opacity    := ReadInteger('FORM', 'Opacity', 255);

          if fformactive then
          begin
           CropToimgForm(Fimage); // for crop Tform
           Self.fparent.OnPaint := @pant;
          end;

        // CropToimg(Fimage); // for crop Tform
        end;
      end;

      if (com is TdenemeButton) and (TdenemeButton(com).Skindata = Self)  then
      begin
        with (TdenemeButton(com)) do
        begin
          for a := 0 to Customcroplist.Count - 1 do
          cropparse(TONURCustomCrop(Customcroplist[a]), ReadString(Skinname, TONURCustomCrop(Customcroplist[a]).cropname, '0,0,1,1,clblack'));
        end;
      end;

      if (com is TDenemeEdit) and (TDenemeEdit(com).Skindata = Self)  then
      begin
        with (TDenemeEdit(com)) do
        begin
          for a := 0 to Customcroplist.Count - 1 do
            cropparse(TONURCustomCrop(Customcroplist[a]), ReadString(Skinname, TONURCustomCrop(Customcroplist[a]).cropname, '0,0,1,1,clblack'));
        end;
      end;

      if (com is TDenemeMemo) and (TDenemeMemo(com).Skindata = Self) then
      begin
        with (TDenemeMemo(com)) do
        begin
          for a := 0 to Customcroplist.Count - 1 do
           cropparse(TONURCustomCrop(Customcroplist[a]), ReadString(Skinname, TONURCustomCrop(Customcroplist[a]).cropname, '0,0,1,1,clblack'));
        end;
      end;

      if (com is TDenemeListbox) and (TDenemeListbox(com).Skindata = Self)  then
      begin
        with (TDenemeListbox(com)) do
        begin
          for a := 0 to Customcroplist.Count - 1 do
            cropparse(TONURCustomCrop(Customcroplist[a]), ReadString(Skinname, TONURCustomCrop(Customcroplist[a]).cropname, '0,0,1,1,clblack'));
        end;
      end;

      if (com is TDenemeCheckBox) and (TDenemeCheckBox(com).Skindata = Self) then
      begin
        with (TDenemeCheckBox(com)) do
        begin
          for a := 0 to Customcroplist.Count - 1 do
            cropparse(TONURCustomCrop(Customcroplist[a]), ReadString(Skinname, TONURCustomCrop(Customcroplist[a]).cropname, '0,0,1,1,clblack'));
        end;
      end;



      if (com is TONURCustomControl) and (TONURCustomControl(com).Skindata = Self) then
      begin
        with (TONURCustomControl(com)) do
          for a := 0 to Customcroplist.Count - 1 do
          begin
            cropparse(TONURCustomCrop(Customcroplist[a]), ReadString(Skinname, TONURCustomCrop(Customcroplist[a]).cropname, '0,0,1,1,clblack'));
           end;
      end;

      if (com is TONURGraphicControl) and (TONURGraphicControl(com).Skindata = Self) then
      begin
        with (TONURGraphicControl(com)) do
          for a := 0 to Customcroplist.Count - 1 do
          begin
            cropparse(TONURCustomCrop(Customcroplist[a]), ReadString(Skinname, TONURCustomCrop(Customcroplist[a]).cropname, '0,0,1,1,clblack'));

          end;
      end;



      if (com is TONURPopupMenu) and (TONURPopupMenu(com).Skindata = Self) then
      begin

        with (TONURPopupMenu(com)) do
          for a := 0 to Customcroplist.Count - 1 do
          begin
            cropparse(TONURCustomCrop(Customcroplist[a]), ReadString(Skinname, TONURCustomCrop(Customcroplist[a]).cropname, '0,0,1,1,clblack'));
          end;
      end;


      if (com is TONURMainMenu) and (TONURMainMenu(com).Skindata = Self) then
      begin
        with (TONURMainMenu(com)) do
          for a := 0 to Customcroplist.Count - 1 do
          begin
            cropparse(TONURCustomCrop(Customcroplist[a]), ReadString(Skinname, TONURCustomCrop(Customcroplist[a]).cropname, '0,0,1,1,clblack'));
          end;
      end;

    end;

  finally
    FreeAndNil(skn);
  end;
end;


procedure TONURImg.Refresh;
var
  Dir: string;
  i, a: integer;
  skn: TIniFile;
begin

  if not FileExists(GetTempDir + 'skins.ini') then exit;
  skn := TIniFile.Create(dir + 'skins.ini');



  skinread := True;
  try
    with skn do
    begin

      // skin info
      Skinname := ReadString('GENERAL', 'SKINNAME', 'DEFAULT');
      version := ReadString('GENERAL', 'VERSION', '1.0');
      author := ReadString('GENERAL', 'AUTHOR', 'SKIN CODER');
      email := ReadString('GENERAL', 'EMAIL', 'mail@mail.com');
      homepage := ReadString('GENERAL', 'HOMEPAGE', 'www.lazarus-ide.com');
      comment := ReadString('GENERAL', 'COMMENT', 'SKIN COMMENT');
      screenshot := ReadString('GENERAL', 'SCREENSHOT', '');

      // skin info finish

      // Fimage.SetSize(0,0);

      // Skin image reading
      if FileExists(dir + ReadString('FORM', 'IMAGE', '')) then
        Fimage.LoadFromFile(dir + ReadString('FORM', 'IMAGE', ''))
      else
        Fimage.Fill(BGRA(207, 220, 207), dmSet);

      tempbitmap.SetSize(0,0);
      tempbitmap.putimage(0, 0, Fimage, dmSetExceptTransparent, 255);  // for color

      // if MColor<>'clNone' then
      //  colorbgrabitmap;

      // Skin image ok
      ThemeStyle := ReadString('FORM', 'style', '');
      colortheme := ReadString('FORM', 'Color', 'ClNone');
     // Opacity    := ReadInteger('FORM', 'Opacity', 255);
      fparent.Font.Name := ReadString('FORM', 'Fontname', 'calibri');
      fparent.Font.color := StringToColor(ReadString('FORM', 'Fontcolor', 'clblack'));
      fparent.Font.size := ReadInteger('FORM', 'Fontzie', 11);



      // For TForm.   If modern form.  eliptic or etc..
      if (Fimage <> nil) and (ThemeStyle = 'modern')
      {and (fparent.Name<>'skinsbuildier')} then
      begin
        cropparse(FTopleft, ReadString('FORM', FTOPLEFT.cropname,
          '0,0,0,0,clblack'));
        cropparse(FTopRight, ReadString('FORM', FTOPRIGHT.cropname,
          '0,0,0,0,clblack'));
        cropparse(FTop, ReadString('FORM', FTOP.cropname, '0,0,0,0,clblack'));
        cropparse(FBottomleft, ReadString('FORM',
          FBOTTOMLEFT.cropname, '0,0,0,0,clblack'));
        cropparse(FBottomRight, ReadString('FORM',
          FBOTTOMRIGHT.cropname, '0,0,0,0,clblack'));
        cropparse(FBottom, ReadString('FORM', FBOTTOM.cropname, '0,0,0,0,clblack'));
        cropparse(Fleft, ReadString('FORM', FLEFT.cropname, '0,0,0,0,clblack'));
        cropparse(FRight, ReadString('FORM', FRIGHT.cropname, '0,0,0,0,clblack'));
        cropparse(FCenter, ReadString('FORM', FCENTER.cropname, '0,0,0,0,clblack'));
      {  if clrr = '' then
          colortheme := ReadString('FORM', 'Color', 'ClNone')
        else
          colortheme := clrr;
        }

        Opacity    := ReadInteger('FORM', 'Opacity', 255);

        if fformactive then
        begin
         CropToimgForm(Fimage); // for crop Tform
         Self.fparent.OnPaint := @pant;
        end;

       // CropToimg(Fimage); // for crop Tform
      end;
      // Tform ok



      // Tform component reading
      for i := 0 to fparent.ComponentCount - 1 do
      begin
        if (fparent.Components[i] is TONURCustomControl) and
          (TONURCustomControl(fparent.Components[i]).Skindata = Self) then
        begin
          with (TONURCustomControl(fparent.Components[i])) do
            for a := 0 to Customcroplist.Count - 1 do
             cropparse(TONURCustomCrop(Customcroplist[a]), ReadString( Skinname, TONURCustomCrop(Customcroplist[a]).cropname, '0,0,1,1,clblack'))
        end;

        if (fparent.Components[i] is TONURGraphicControl) and
          (TONURGraphicControl(fparent.Components[i]).Skindata = Self) then
        begin
          with (TONURGraphicControl(fparent.Components[i])) do
            for a := 0 to Customcroplist.Count - 1 do
             cropparse(TONURCustomCrop(Customcroplist[a]), ReadString(Skinname, TONURCustomCrop(Customcroplist[a]).cropname, '0,0,1,1,clblack'));
        end;


        if (fparent.Components[i] is TONURPopupMenu) and (TONURPopupMenu(fparent.Components[i]).Skindata = Self) then
        begin
          with (TONURPopupMenu(fparent.Components[i])) do
           for a := 0 to Customcroplist.Count - 1 do
            cropparse(TONURCustomCrop(Customcroplist[a]), ReadString(Skinname, TONURCustomCrop(Customcroplist[a]).cropname, '0,0,1,1,clblack'));
        end;


        if (fparent.Components[i] is TONURMainMenu) and (TONURMainMenu(fparent.Components[i]).Skindata = Self) then
        begin
          with (TONURMainMenu(fparent.Components[i])) do
           for a := 0 to Customcroplist.Count - 1 do
            cropparse(TONURCustomCrop(Customcroplist[a]), ReadString(Skinname, TONURCustomCrop(Customcroplist[a]).cropname, '0,0,1,1,clblack'));
        end;

      end;
    end;
    //   end;

  finally
    self.fparent.Invalidate;// Repaint;
    FreeAndNil(skn);
  end;

end;

procedure TONURImg.formactive(xx: boolean);
begin
 fformactive:=xx;
end;




procedure TONURImg.Loadskin(FileName: string; const Resource: boolean);
var
  Res: TResourceStream;
  //  VerOk: boolean;  // skin version control
  Dir: string;
  UnZipper: TUnZipper;
  i, a: integer;
  skn: TIniFile;
begin

  if (Resource = False) and (ExtractFileExt(filename) <> '.osf') then exit;

  if csDesigning in ComponentState then
    exit;


  if Resource then
  begin
    res := TResourceStream.Create(HInstance, 'skn', RT_RCDATA);
    try
      res.Position := 0;
      Dir := GetTempDir;
      res.SaveToFile(Dir + 'skins.osf');
      UnZipper := TUnZipper.Create;
      try
        UnZipper.FileName := Dir + 'skins.osf';
        UnZipper.OutputPath := dir;
        UnZipper.Examine;
        UnZipper.UnZipAllFiles;
      finally
        UnZipper.Free;
      end;
      //List.LoadFromStream(Strm);
    finally
      res.Free;
    end;
  end
  else //if (FileName = '') then
  begin

    if ExtractFileExt(FileName) = '' then
      Dir := ExtractFilePath(Application.ExeName) + 'skins\' + FileName + '\'
    else
    begin
      Dir := GetTempDir;

      if not DirectoryExists(Dir) then ForceDirectories(Dir);

      UnZipper := TUnZipper.Create;
      try

        UnZipper.FileName := filename;
        UnZipper.OutputPath := dir;
        UnZipper.Examine;
        UnZipper.UnZipAllFiles;
      finally
        UnZipper.Free;
      end;
    end;
  end;



  //VerOk := False;


  skn := TIniFile.Create(dir + 'skins.ini');


  skinread := True;
  try
    with skn do
    begin
      //  if not VerOk then //version control
      //   begin


      //      if ReadString('GENERAL', 'VERSION', '1.0') = '1.0' then
      //        VerOk := True
      //      else
      //      begin  ///Skin version NOT supported
      //        Exit;
      //      end;


      //  end else // version control finish
      //   begin

      // skin info
      Skinname   := ReadString('GENERAL', 'SKINNAME', 'DEFAULT');
      version    := ReadString('GENERAL', 'VERSION', '1.0');
      author     := ReadString('GENERAL', 'AUTHOR', 'SKIN CODER');
      email      := ReadString('GENERAL', 'EMAIL', 'mail@mail.com');
      homepage   := ReadString('GENERAL', 'HOMEPAGE', 'www.lazarus-ide.com');
      comment    := ReadString('GENERAL', 'COMMENT', 'SKIN COMMENT');
      screenshot := ReadString('GENERAL', 'SCREENSHOT', '');

      // skin info finish



      // Skin image reading
      if FileExists(dir + ReadString('FORM', 'IMAGE', '')) then
        Fimage.LoadFromFile(dir + ReadString('FORM', 'IMAGE', ''))
      else
        Fimage.Fill(BGRA(190, 208, 190, Opacity), dmSet);
      // Skin image ok

      tempbitmap.SetSize(0,0);
      tempbitmap.putimage(0, 0, Fimage, dmSetExceptTransparent, 255);  // for color



      ThemeStyle := ReadString('FORM', 'style', '');
      ColorTheme := ReadString('FORM', 'Color', '');
     // Opacity    := ReadInteger('FORM', 'Opacity', 255);
      fparent.Font.Name := ReadString('FORM', 'Fontname', 'calibri');
      fparent.Font.color := StringToColor(ReadString('FORM', 'Fontcolor', 'clblack'));
      fparent.Font.size := ReadInteger('FORM', 'Fontzie', 11);



      // For TForm.   If modern form.  eliptic or etc..
      if (Fimage <> nil) and (ThemeStyle = 'modern')
      {and (fparent.Name<>'skinsbuildier')} then
      begin
        cropparse(FTopleft, ReadString('FORM', FTOPLEFT.cropname,
          '0,0,0,0,clblack'));
        cropparse(FTopRight, ReadString('FORM', FTOPRIGHT.cropname,
          '0,0,0,0,clblack'));
        cropparse(FTop, ReadString('FORM', FTOP.cropname, '0,0,0,0,clblack'));
        cropparse(FBottomleft, ReadString('FORM',
          FBOTTOMLEFT.cropname, '0,0,0,0,clblack'));
        cropparse(FBottomRight, ReadString('FORM',
          FBOTTOMRIGHT.cropname, '0,0,0,0,clblack'));
        cropparse(FBottom, ReadString('FORM', FBOTTOM.cropname, '0,0,0,0,clblack'));
        cropparse(Fleft, ReadString('FORM', FLEFT.cropname, '0,0,0,0,clblack'));
        cropparse(FRight, ReadString('FORM', FRIGHT.cropname, '0,0,0,0,clblack'));
        cropparse(FCenter, ReadString('FORM', FCENTER.cropname, '0,0,0,0,clblack'));
        colortheme := ReadString('FORM', 'Color', 'ClNone');
        Opacity    := ReadInteger('FORM', 'Opacity', 255);

        self.fparent.BorderStyle := bsNone;
        self.fparent.OnMouseDown := @mousedwn;

        if fformactive then
        begin
         CropToimgForm(Fimage); // for crop Tform
         Self.fparent.OnPaint := @pant;
        end;
      end;
      // Tform ok



      // Tform component reading
      for i := 0 to fparent.ComponentCount - 1 do
      begin

        if (fparent.Components[i] is TONURCustomControl) and
          (TONURCustomControl(fparent.Components[i]).Skindata = Self) then
        begin

          with (TONURCustomControl(fparent.Components[i])) do
          begin
            for a := 0 to Customcroplist.Count - 1 do
              cropparse(TONURCustomCrop(Customcroplist[a]), ReadString(Skinname, TONURCustomCrop(Customcroplist[a]).cropname, '0,0,1,1,clblack'));

           Skindata:=self;
          end;
        end;

        if (fparent.Components[i] is TONURGraphicControl) and
          (TONURGraphicControl(fparent.Components[i]).Skindata = Self) then
        begin
          with (TONURGraphicControl(fparent.Components[i])) do
          begin
             for a := 0 to Customcroplist.Count - 1 do
              cropparse(TONURCustomCrop(Customcroplist[a]), ReadString(Skinname,  TONURCustomCrop(Customcroplist[a]).cropname, '0,0,1,1,clblack'));
       //    Skindata:=self;
          end;
        end;


        if (fparent.Components[i] is TdenemeButton) and
          (TdenemeButton(fparent.Components[i]).Skindata = Self) then
        begin
          with (TdenemeButton(fparent.Components[i])) do
          begin
             for a := 0 to Customcroplist.Count - 1 do
              cropparse(TONURCustomCrop(Customcroplist[a]), ReadString(Skinname,  TONURCustomCrop(Customcroplist[a]).cropname, '0,0,1,1,clblack'));
       //    Skindata:=self;
          end;
        end;

        if (fparent.Components[i] is TDenemeEdit) and
          (TDenemeEdit(fparent.Components[i]).Skindata = Self) then
        begin
          with (TDenemeEdit(fparent.Components[i])) do
          begin
             for a := 0 to Customcroplist.Count - 1 do
              cropparse(TONURCustomCrop(Customcroplist[a]), ReadString(Skinname,  TONURCustomCrop(Customcroplist[a]).cropname, '0,0,1,1,clblack'));
       //    Skindata:=self;
          end;
        end;

        if (fparent.Components[i] is TDenemeListbox) and
          (TDenemeListbox(fparent.Components[i]).Skindata = Self) then
        begin
          with (TDenemeListbox(fparent.Components[i])) do
          begin
             for a := 0 to Customcroplist.Count - 1 do
              cropparse(TONURCustomCrop(Customcroplist[a]), ReadString(Skinname,  TONURCustomCrop(Customcroplist[a]).cropname, '0,0,1,1,clblack'));
       //    Skindata:=self;
          end;
        end;

        if (fparent.Components[i] is TDenemeMemo) and
          (TDenemeMemo(fparent.Components[i]).Skindata = Self) then
        begin
          with (TDenemeMemo(fparent.Components[i])) do
          begin
             for a := 0 to Customcroplist.Count - 1 do
              cropparse(TONURCustomCrop(Customcroplist[a]), ReadString(Skinname,  TONURCustomCrop(Customcroplist[a]).cropname, '0,0,1,1,clblack'));
        //   Skindata:=self;
          end;
        end;


        if (fparent.Components[i] is TDenemeCheckBox) and
          (TDenemeCheckBox(fparent.Components[i]).Skindata = Self) then
        begin
          with (TDenemeCheckBox(fparent.Components[i])) do
          begin
             for a := 0 to Customcroplist.Count - 1 do
              cropparse(TONURCustomCrop(Customcroplist[a]), ReadString(Skinname,  TONURCustomCrop(Customcroplist[a]).cropname, '0,0,1,1,clblack'));
           Skindata:=self;
          end;
        end;


        if (fparent.Components[i] is TONURPopupMenu) and (TONURPopupMenu(fparent.Components[i]).Skindata = Self) then
        with (TONURPopupMenu(fparent.Components[i])) do
          for a := 0 to Customcroplist.Count - 1 do
          begin
            cropparse(TONURCustomCrop(Customcroplist[a]), ReadString(Skinname, TONURCustomCrop(Customcroplist[a]).cropname, '0,0,1,1,clblack'));
          end;


        if (fparent.Components[i] is TONURMainMenu) and (TONURMainMenu(fparent.Components[i]).Skindata = Self) then
        with (TONURMainMenu(fparent.Components[i])) do
          for a := 0 to Customcroplist.Count - 1 do
          begin
            cropparse(TONURCustomCrop(Customcroplist[a]), ReadString(Skinname, TONURCustomCrop(Customcroplist[a]).cropname, '0,0,1,1,clblack'));
          end;
      end;
    end;
  finally
    self.fparent.Invalidate;
    FreeAndNil(skn);
  end;
end;


procedure TONURImg.GetSkinInfo(const FileName: string; const Resource: boolean);
var
  Unzipper: TUnZipper;
  Dir: string;
  skn: TIniFile;

begin
  Skinname := '';
  Version := '';
  Author := '';
  Email := '';
  HomePage := '';
  Comment := '';
  Screenshot := '';

  if FileName <> '' then
  begin
    if ExtractFileExt(FileName) = '' then
      Dir := ExtractFilePath(Application.ExeName) + 'skins\' + FileName + '\'
    else
    begin
      Dir := GetTempDir;
      if not DirectoryExists(Dir) then ForceDirectories(Dir);

      UnZipper := TUnZipper.Create;
      try

        UnZipper.FileName := filename;
        UnZipper.OutputPath := dir;
        UnZipper.Examine;
        UnZipper.UnZipAllFiles;
      finally
        UnZipper.Free;
      end;
    end;



    skn := TIniFile.Create(dir + 'skin.ini');

    try
      with skn do
      begin
        Skinname := ReadString('GENERAL', 'SKINNAME', 'DEFAULT');
        version := ReadString('GENERAL', 'VERSION', '0.1');
        author := ReadString('GENERAL', 'AUTHOR', 'SKIN CODER');
        email := ReadString('GENERAL', 'EMAIL', 'mail@mail.com');
        homepage := ReadString('GENERAL', 'HOMEPAGE', 'www.lazarus-ide.com');
        comment := ReadString('GENERAL', 'COMMENT', 'SKIN COMMENT');
        screenshot := ReadString('GENERAL', 'SCREENSHOT', '');
      end;

    finally
      FreeAndNil(skn);
    end;
  end;
end;


procedure TONURImg.Saveskin(filename: string);
var
  Zipper: TZipper;
  i, a: integer;
  skn: TIniFile;
begin

  if csDesigning in ComponentState then
    exit;

  DeleteFile(GetTempDir + 'tmp/skins.ini');
  DeleteFile(GetTempDir + 'tmp/skins.png');


  skn := TIniFile.Create(GetTempDir + 'tmp/skins.ini');



  try
    with skn do
    begin
   {   EraseSection('GENERAL');
      EraseSection('FORM');
   }

      // skin info
      writeString('GENERAL', 'SKINNAME', Skinname);
      writeString('GENERAL', 'VERSION', version);
      writeString('GENERAL', 'AUTHOR', author);
      writeString('GENERAL', 'EMAIL', email);
      writeString('GENERAL', 'HOMEPAGE', homepage);
      writeString('GENERAL', 'COMMENT', comment);
      writeString('GENERAL', 'SCREENSHOT', screenshot);
      // skin info finish

      Fimage.SaveToFile(GetTempDir + 'tmp/skins.png');

      writeString('FORM', 'IMAGE', 'skins.png');
      // Skin image ok

      // For TForm.   If modern form.  eliptic or etc..
      writeString('FORM', 'style', ThemeStyle);
      WriteString('FORM', 'Color', ColorTheme);
      WriteInteger('FORM', 'Opacity',Opacity);

      writeString('FORM', FTOPLEFT.cropname, croptostring(FTopleft));
      writeString('FORM', FTOPRIGHT.cropname, croptostring(FTopRight));
      writeString('FORM', FTOP.cropname, croptostring(FTop));
      writeString('FORM', FBOTTOMLEFT.cropname, croptostring(FBottomleft));
      writeString('FORM', FBOTTOMRIGHT.cropname, croptostring(FBottomRight));
      writeString('FORM', FBOTTOM.cropname, croptostring(FBottom));
      writeString('FORM', FLEFT.cropname, croptostring(Fleft));
      writeString('FORM', FRIGHT.cropname, croptostring(FRight));
      writeString('FORM', FCENTER.cropname, croptostring(FCenter));
      WriteString('FORM', 'Fontname', self.fparent.font.Name);
      WriteString('FORM', 'Fontcolor', colortostring(self.fparent.font.color));
      WriteInteger('FORM', 'Fontsize', self.fparent.font.Size);

      // Tform ok

      // Tform component reading
      for i := 0 to fparent.ComponentCount - 1 do
      begin

        if (fparent.Components[i] is TONURCustomControl) then
        begin
          with (TONURCustomControl(fparent.Components[i])) do
              for a := 0 to Customcroplist.Count - 1 do
              writeString(Skinname, TONURCustomCrop(Customcroplist[a]).cropname,
                croptostring(TONURCustomCrop(Customcroplist[a])));
        end;


        if (fparent.Components[i] is TONURGraphicControl) then
        begin
          with (TONURGraphicControl(fparent.Components[i])) do

            for a := 0 to Customcroplist.Count - 1 do
              writeString(Skinname, TONURCustomCrop(Customcroplist[a]).cropname,
                croptostring(TONURCustomCrop(Customcroplist[a])));
        end;


        if (fparent.Components[i] is TONURPopupMenu) then
        begin
          with (TONURPopupMenu(fparent.Components[i])) do

            for a := 0 to Customcroplist.Count - 1 do
              writeString(Skinname, TONURCustomCrop(Customcroplist[a]).cropname,
                croptostring(TONURCustomCrop(Customcroplist[a])));
        end;

        if (fparent.Components[i] is TONURMainMenu) then
        begin
          with (TONURMainMenu(fparent.Components[i])) do

            for a := 0 to Customcroplist.Count - 1 do
              writeString(Skinname, TONURCustomCrop(Customcroplist[a]).cropname,
                croptostring(TONURCustomCrop(Customcroplist[a])));
        end;
      end;
    end;

    Zipper := TZipper.Create;
    try
      Zipper.FileName := filename;
      zipper.Entries.AddFileEntry(GetTempDir + 'tmp/skins.ini', 'skins.ini');
      zipper.Entries.AddFileEntry(GetTempDir + 'tmp/skins.png', 'skins.png');
   //   Zipper.ZipAllFiles;
      Zipper.SaveToFile(filename);
    finally
      Zipper.Free;
    end;

  finally
    FreeAndNil(skn);
  end;
end;


// -----------------------------------------------------------------------------
{ TONURGraphicControl }
// -----------------------------------------------------------------------------



constructor TONURGraphicControl.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  parent             := TWinControl(Aowner);
  ControlStyle       := ControlStyle + [csClickEvents, csCaptureMouse,
    csDoubleClicks, csParentBackground];
  Width              := 100;
  Height             := 30;
  Fkind              := oHorizontal;
  Transparent        := True;
  Backgroundbitmaped := True;
  ParentColor        := True;
  FAlignment         := taCenter;
  self.font.size     := 10;
  self.font.Name     := 'calibri';
  self.Font.color    := clWhite;
  resim              := TBGRABitmap.Create(clientWidth,clientHeight);
  Captionvisible     := True;
  falpha             := 255;
  Customcroplist     := TFPList.Create;
end;

destructor TONURGraphicControl.Destroy;
var
i:byte;
begin
  for i:=0 to Customcroplist.Count-1 do
   TONURCUSTOMCROP(Customcroplist.Items[i]).free;

  if Assigned(resim) then
  FreeAndNil(resim);
  Customcroplist.Free;
  inherited Destroy;
end;


// -----------------------------------------------------------------------------
procedure TONURGraphicControl.WMEraseBkgnd(var Message: TWMEraseBkgnd);
begin
  SetBkMode(Message.dc, 1);
  Message.Result := 1;
end;


function TONURGraphicControl.GetSkindata: TONURImg;
begin
  Result := FSkindata;
end;

// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
procedure TONURGraphicControl.CreateParams(var Params: TCreateParams);
begin
  params.exstyle := params.exstyle or WS_EX_TRANSPARENT or WS_EX_LAYERED or
    WS_CLIPCHILDREN;
end;


// -----------------------------------------------------------------------------
procedure TONURGraphicControl.SetAlignment(const Value: TAlignment);
begin
  if FAlignment <> Value then
  begin
    FAlignment := Value;
  end;
end;
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
function TONURGraphicControl.GetTransparent: boolean;
begin
  Result := Color = clNone;
end;

procedure TONURGraphicControl.SetTransparent(NewTransparent: boolean);
begin
  if Transparent = NewTransparent then
    exit;
  if NewTransparent = True then
    Color := clNone
  else
  if Color = clNone then
    Color := clBackground;
end;

function TONURGraphicControl.Getkind: Tonurkindstate;
begin
  Result := Fkind;
end;

procedure TONURGraphicControl.SetKind(AValue: TONURkindstate);
begin
  if avalue = Fkind then exit;
  Fkind := avalue;
  Invalidate;
end;

procedure TONURGraphicControl.SetSkindata(Aimg: TONURImg);
begin
  if (Aimg <> nil) then
  begin
    fSkindata := nil;
    fSkindata := Aimg;
    Skindata.ReadskinsComp(self);
    Invalidate;
  end
  else
  begin
    FSkindata := nil;
  end;
end;

procedure TONURGraphicControl.Setskinname(avalue: string);
begin
  if Fskinname = avalue then exit;
    Fskinname := avalue;
end;

procedure TONURGraphicControl.Resize;
begin
  inherited Resize;
  if Skindata <> nil then SetSkindata(Skindata);
end;

procedure TONURGraphicControl.setalpha(val: byte);
begin
  if falpha = val then exit;
  falpha := ValueRange(val,0,255);// val;
  Invalidate;
end;


// -----------------------------------------------------------------------------
procedure TONURGraphicControl.Paint;
var
  a: TBGRABitmap;
begin
  inherited Paint;
  if (resim <> nil) and (resim.NbPixels <> 0) then
  begin

    if (Assigned(Skindata)) and (self.Skindata.mcolor <> 'clnone') and
      (self.Skindata.mcolor <> '') then
    begin
      a := Tbgrabitmap.Create(resim.Width,resim.Height);
      try
        replacepixel(resim,a, ColorToBGRA(StringToColor(self.Skindata.mcolor), self.Skindata.opacity));
        a.InvalidateBitmap;
        resim.BlendImage(0, 0, a, boTransparent);
      finally
        FreeAndNil(a);
      end;
    end;
  end
  else
  begin
    resim.GradientFill(0, 0, Width, Height, BGRA(40, 40, 40), BGRA(80, 80, 80), gtLinear,
      PointF(0, 0), PointF(0, Height), dmSet);
  end;


  if Captionvisible then
    yaziyazBGRA(resim.CanvasBGRA, self.Font, self.ClientRect, Caption, Alignment);
  // yaziyaz(self.Canvas, self.Font, self.ClientRect, Caption, Alignment);
  resim.Draw(self.canvas, 0, 0, False);
end;



// -----------------------------------------------------------------------------




// -----------------------------------------------------------------------------
{ TONURCustomControl }
// -----------------------------------------------------------------------------


constructor TONURCustomControl.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  parent             := TWinControl(Aowner);
  ControlStyle       := ControlStyle + [csParentBackground, csAcceptsControls,
    csClickEvents, csCaptureMouse, csDoubleClicks];
  FAlignment         := taCenter;
  DoubleBuffered     := True;
  ParentBackground   := True;
  Fkind              := oHorizontal;
  Backgroundbitmaped := True;
  Width              := 100;
  Height             := 30;
  self.font.size     := 10;
  self.font.Name     := 'calibri';
  self.Font.color    := clWhite;
  resim              := TBGRABitmap.Create(ClientWidth,ClientHeight);
  Captionvisible     := True;
  falpha             := 255;
  Customcroplist     := TFPList.Create;
end;

destructor TONURCustomControl.Destroy;
begin
  if Assigned(resim) then
  FreeAndNil(resim);
  FreeAndNil(Customcroplist);
  inherited Destroy;
end;


// -----------------------------------------------------------------------------
procedure TONURCustomControl.WMEraseBkgnd(var Message: TWMEraseBkgnd);
begin
  SetBkMode(Message.dc, TRANSPARENT);
  Message.Result := 1;
end;
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------

procedure TONURCustomControl.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  params.exstyle := params.exstyle or WS_EX_TRANSPARENT or WS_EX_LAYERED or
    WS_CLIPCHILDREN;
end;


// -----------------------------------------------------------------------------
procedure TONURCustomControl.SetAlignment(const Value: TAlignment);
begin
  if FAlignment <> Value then
  begin
    FAlignment := Value;
  end;
end;

procedure TONURCustomControl.SetSkindata(Aimg: TONURImg);
begin
  if Aimg <> nil then
  begin
    FSkindata := Aimg;
    Skindata.ReadskinsComp(self);
  end
  else
  begin
    FSkindata := nil;
  end;
end;

procedure TONURCustomControl.setalpha(val: byte);
begin
  if falpha = val then exit;
  falpha := val;
  Invalidate;
end;

// -----------------------------------------------------------------------------
procedure TONURCustomControl.SetCrop(Value: boolean);
begin
  if Fcrop <> Value then
  begin
    Fcrop := Value;
  end;
end;

function TONURCustomControl.GetSkindata: TONURImg;
begin
  Result := FSkindata;
end;

function TONURCustomControl.Getskinname: string;
begin
  Result := fskinname;
end;

function TONURCustomControl.Getkind: TonURkindstate;
begin
  Result := Fkind;
end;

procedure TONURCustomControl.SetKind(AValue: TonURkindstate);
begin
  if avalue = Fkind then exit;
  Fkind := avalue;
  Invalidate;
end;

procedure TONURCustomControl.Setskinname(avalue: string);
begin
  if Fskinname = avalue then exit;
    Fskinname := avalue;
end;

// --------------------:=---------------------------------------------------------

procedure TONURCustomControl.CropToimg(Buffer: TBGRABitmap);
var
  x, y: integer;
  WindowRgn, SpanRgn: HRGN;//hdc;
  p: PBGRAPixel;
begin
   WindowRgn := CreateRectRgn(0, 0, buffer.Width, buffer.Height);
   for Y := 0 to buffer.Height - 1 do
    begin
      p := buffer.Scanline[Y];
      for X := buffer.Width - 1 downto 0 do
       begin

        if p^=BGRAPixelTransparent then  // if p^.Alpha <20 then
        begin
        //  p^ := BGRAPixelTransparent;
          SpanRgn := CreateRectRgn(x, y, x +1, y +1);
          CombineRgn(WindowRgn, WindowRgn, SpanRgn,RGN_DIFF);//RGN_OR);//
          DeleteObject(SpanRgn);

       { end
        else
        begin
          p^.Red := p^.Red * (p^.Alpha + 1) shr 8;
          p^.Green := p^.Green * (p^.Alpha + 1) shr 8;
          p^.Blue := p^.Blue * (p^.Alpha + 1) shr 8;     }
        end;
        Inc(p);
      end;
    end;
  SetWindowRgn(Handle, WindowRgn, True);
  DeleteObject(WindowRgn);
end;
// -----------------------------------------------------------------------------
procedure TONURCustomControl.Paint;
var
  a: TBGRABitmap;
begin
  inherited;
  if (resim <> nil) and (resim.NbPixels <> 0) then
  begin

    if (Assigned(Skindata)) and (self.Skindata.mcolor <> 'clnone') and
      (self.Skindata.mcolor <> '') then
    begin
      a := Tbgrabitmap.Create(resim.Width,resim.Height);
      try
        replacepixel(resim,a, ColorToBGRA(StringToColor(self.Skindata.mcolor), self.Skindata.opacity));
        a.InvalidateBitmap;
        resim.BlendImage(0, 0, a, boTransparent);
      finally
        FreeAndNil(a);
      end;
    end;
  end
  else
  begin
    resim.GradientFill(0, 0, Width, Height, BGRA(40, 40, 40), BGRA(80, 80, 80), gtLinear,
      PointF(0, 0), PointF(0, Height), dmSet);
  end;


  if Crop then
  begin
 //  CropBGRA(resim);
   //SetShape(resim.Bitmap);
   CropToimg(resim);
  end;




  if (Captionvisible=true) and (Length(caption)>0) then
    yaziyazBGRA(resim.CanvasBGRA, self.Font, self.ClientRect, Caption, Alignment);
   // yaziyaz(self.Canvas, self.Font, self.ClientRect, Caption, Alignment);
  resim.Draw(self.canvas, 0, 0, False);

end;

procedure TONURCustomControl.Resize;
begin
inherited Resize;
  if Skindata <> nil then SetSkindata(Skindata);
//  inherited Resize;
//  Writeln('CUSTOM CONTROL RESIZE');
//  if Skindata <> nil then SetSkindata(Skindata);
end;



// -----------------------------------------------------------------------------




end.

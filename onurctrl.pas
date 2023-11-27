unit onurctrl;

{$mode objfpc}{$H+}

{$R 'onur.rc' onres.res}

interface

uses
  {$IFDEF UNIX} linux {$ELSE} Windows{$ENDIF},LMessages ,SysUtils, Forms, LCLType, LCLIntf, Classes,
  Controls, Graphics, BGRABitmap, BGRABitmapTypes,
   types, LazUTF8, Zipper,Dialogs;

type
  TONURButtonState = (obshover, obspressed, obsnormal);
  TONURExpandStatus = (oExpanded, oCollapsed);
  TONURButtonDirection = (obleft, obright,obup,obdown);
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



  { TONURCUSTOMCROP }

  TONURCustomCrop = class
    fFontcolor  : Tcolor;
  public
    cropname: string;
    FSLeft, FSTop, FSright, FSBottom: integer;
    Targetrect : Trect;
    Function Croprect:Trect;
    Function Width:integer;
    Function Height:integer;
  published
    property Fontcolor  : Tcolor  read ffontcolor  write ffontcolor;
    property Left       : integer read FSLeft      write FSLeft;
    property Top        : integer read FSTop       write FSTop;
    property Right      : integer read FSright     write FSright;
    property Bottom     : integer read FSBottom    write FSBottom;
  end;

  { TONImg }

  { TONURImg }

  TONURImg = class(TComponent)
  private
    Fopacity    : Byte;
    FRes        : TPicture;
    List        : TStringList;
    fparent     : TForm;

    skinread    : boolean;
    Frmain,
    tempbitmap  : TBGRABitmap;
    clrr        : string;
    ffilename   : TFileName;
    {$IFDEF UNIX}
     movef      : boolean;
     x9,y9      : integer;
    {$ENDIF}
    Procedure Colorbgrabitmap;
    procedure CropToimg(Buffer: TBGRABitmap);
    procedure ImageSet(Sender: TObject);
    Procedure Loadskin2;
    procedure mousedwn(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: integer);

     {$IFDEF UNIX}
    procedure FormMouseUpp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
    procedure FormMouseMovee(Sender: TObject; Shift: TShiftState; X, Y: Integer);
     {$ENDIF}

    procedure pant(Sender: TObject);
    procedure Setloadskin(AValue: String);
    Procedure Setopacity(Avalue: Byte);
    procedure Setcolor(colr: string);

  public
    Fimage     : TBGRABitmap;
    Blend,
    ThemeStyle,
    Skinname,
    Version,
    Author,
    Email,
    Homepage,
    Comment,
    Screenshot : string;
    Fleft,
    FTopleft,
    FBottomleft,
    FRight,
    FTopRight,
    FBottomRight,
    FTop,
    FBottom,
    FCenter    : TONURCUSTOMCROP;
    Customcroplist:TList;
    const
    ColorTheme : string = 'ClNone';
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure ReadSkinsComp(Com: TComponent);
    procedure Loadskin(FileName: string; const Resource: boolean = False);
    procedure GetSkinInfo(const FileName: string; const Resource: boolean = False);
    procedure Saveskin(filename: string);


  published

    property MColor    : string   read clrr        write Setcolor;
    property Picture   : TPicture read FRes        write Fres;
    property Opacity   : byte     read fopacity    write SetOpacity;
    property LoadSkins : String   read ffilename   write Setloadskin;//Loadskin;
  end;




  { TONURGraphicControl }

  TONURGraphicControl = class(TGraphicControl)
  private
    FSkindata   : TONURImg;
    FAlignment  : TAlignment;
    Fkind       : TONURkindstate;
    Fskinname   : string;
    falpha      : byte;

{$IFDEF UNIX} Procedure WMEraseBkgnd(var Message: TLMEraseBkgnd); message LM_ERASEBKGND;
{$ELSE} Procedure WMEraseBkgnd(var Message: TWMEraseBkgnd); message WM_ERASEBKGND;  {$ENDIF}
//    procedure WMEraseBkgnd(var Message: TWMEraseBkgnd); message WM_ERASEBKGND;
    procedure CreateParams(var Params: TCreateParams);
    procedure SetAlignment(const Value: TAlignment);
    function GetTransparent: boolean;
    procedure SetTransparent(NewTransparent: boolean);
    function Getkind: Tonurkindstate;


    procedure Setskinname(avalue: string);
    procedure setalpha(val: byte);
  public
    { Public declarations }
    Captionvisible     : boolean;
    resim: TBGRABitmap;
    Customcroplist:TList;
    Backgroundbitmaped : boolean;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Paint; override;
  protected
    procedure SetKind(AValue: TONURkindstate); virtual;
    procedure SetSkindata(Aimg: TONURImg); virtual;
    property Kind        : TONURkindstate read Getkind        write Setkind default oHorizontal;
  published
    property Align;
    property Alignment   : TAlignment   read FAlignment     write SetAlignment default taCenter;
    property Alpha       : Byte         read falpha         write setalpha default 255;
    property Transparent : Boolean      read GetTransparent write SetTransparent default True;
    property Skindata    : TONURImg       read FSkindata      write SetSkindata;
    property Skinname    : string       read fskinname      write Setskinname;
    property Anchors;
    property AutoSize;
    property BorderSpacing;
    property BidiMode;
    property Caption;
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
    Fcrop      : Boolean;
    FSkindata  : TONURImg;
    FAlignment : TAlignment;

    Fkind      : TonURkindstate;
    fskinname  : String;
    falpha     : Byte;
    procedure SetCrop(Value: boolean);
    function Getkind: TonURkindstate;
    procedure SetKind(AValue: TonURkindstate);
    procedure Setskinname(avalue: string);
    procedure SetAlignment(const Value: TAlignment);

    procedure setalpha(val: byte);
    {$IFDEF UNIX}
     procedure WMEraseBkgnd(var Message: TLMEraseBkgnd); message LM_ERASEBKGND;
    {$ELSE}
    procedure WMEraseBkgnd(var Message: TWMEraseBkgnd); message WM_ERASEBKGND;
    {$ENDIF}
    procedure CreateParams(var Params: TCreateParams);
  public
    { Public declarations }
    resim: TBGRABitmap;
    WindowRgn  : HRGN;
    Captionvisible     : boolean;
    Backgroundbitmaped : boolean;
    Customcroplist:TList;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Paint; override;
  protected
    procedure CropToimg(Buffer: TBGRABitmap); virtual;
    procedure SetSkindata(Aimg: TONURImg); virtual;
    property Kind      : TonURkindstate read Getkind    write Setkind default oHorizontal;
  published
    property Align;
    property Alignment : TAlignment   read FAlignment write SetAlignment default taCenter;
    property Alpha     : Byte         read falpha     write setalpha default 255;
    property Skindata  : TONURImg       read FSkindata  write SetSkindata;
    property Skinname  : String       read fskinname  write Setskinname;
    property Crop      : Boolean      read Fcrop      write SetCrop default False;
    property Anchors;
    property AutoSize;
    property BidiMode;
    property Caption;
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
     x,y,w,h:integer; Opaque: byte);

    procedure DrawPartnormali(ARect: TRect; Target: TONURGraphicControl;
   x,y,w,h:integer; Opaque: byte);

    procedure DrawPartnormali(ARect: TRect; Target: TOnURCustomControl;
     x,y,w,h:integer; Opaque: byte;txt:string;Txtalgn:TAlignment;colorr:TBGRAPixel);

    procedure DrawPartnormal(ARect: TRect; Target: TOnURCustomControl;
    ATargetRect: TRect; Opaque: byte);

    procedure DrawPartnormaltext(ARect: TRect; Target: TOnURCustomControl;
    ATargetRect: TRect; Opaque: byte; txt:string;Txtalgn:TAlignment ;colorr:TBGRAPixel);

    procedure DrawPartstrechRegion(ARect: TRect; Target: TOnURCustomControl;
    NewWidth, NewHeight: integer; ATargetRect: TRect; Opaque: byte);

    procedure DrawPartstrechRegion(ARect: TRect; Target: TOnURGraphicControl;
    NewWidth, NewHeight: integer; ATargetRect: TRect; Opaque: byte);

    procedure DrawPartnormal(ARect: TRect; Target: TOnURGraphicControl;
      ATargetRect: TRect; Opaque: byte);

    procedure DrawPartnormal(ARect: TRect; Target, Desc: TBgrabitmap;
      ATargetRect: TRect; Opaque: byte);

    procedure DrawPartnormalbmp(ARect: TRect; Target: TOnURGraphicControl;Targetbmp:TBGRABitmap;
      ATargetRect: TRect; Opaque: byte);

    procedure DrawPartstrech(ARect: TRect; Target: TOnURGraphicControl;
      w, h: integer; Opaque: byte);

    procedure DrawPartstrech(ARect: TRect; Target: TOnURCustomControl;
      w, h: integer; Opaque: byte);

    procedure DrawPartnormalBGRABitmap(ARect: TRect; Target: TBGRABitmap;Skindatap:Tonurimg;
  ATargetRect: TRect; Opaque: byte);

    function ValueRange(const Value, Min, Max: integer): integer;
    function maxlengthstring(s: string; len: integer): string;


procedure Register;



implementation

uses  inifiles,  onurpanel,onuredit,onurpage,onurbutton,onurbar,onurlist;


procedure Register;
begin
  RegisterComponents('ONUR', [TONURImg]);
end;

function maxlengthstring(s: string; len: integer): string;
begin
  if len=0 then
  begin
   Result:=s;
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

{
function GetTempDir: string;
var
  lng: DWORD;
begin
  SetLength(Result, MAX_PATH);
  lng := GetTempPath(MAX_PATH, PChar(Result));
  SetLength(Result, lng);
end;
}

procedure yaziyaz(TT: TCanvas; TF: TFont; re: TRect; Fcap: string; asd: TAlignment);  // For caption
var
  stl: TTextStyle;
begin
  TT.Font.Quality      := fqCleartype;
  TT.Font.Name         := TF.Name;
  TT.Font.Size         := TF.size;
  TT.Font.Color        := TF.Color;
  TT.Font.style        := TF.style;
  TT.Font.Orientation  := TF.Orientation;
  TT.Brush.Style       := bsClear;
  stl.Alignment        := asd;
  stl.Wordbreak        := True;
  stl.Layout           := tlCenter;
  stl.SingleLine       := False;
  TT.TextRect(RE, 0, 0, Fcap, stl);
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


procedure replacepixel(BMP, Bmp2: TBGRABitmap; clr: TBGRAPixel);
var
  i: integer;
  p, k: PBGRAPixel;
begin
  k := bmp.Data;
  p := bmp2.Data;
  for i := 0 to bmp.NbPixels - 1 do
  begin
    if k^.alpha <> 0 then
      p^ := clr;
    Inc(k);
     Inc(p);
  end;


end;

procedure DrawPartstrech(ARect: TRect; Target: TOnURCustomControl;
  w, h: integer; Opaque: byte);
var
  img: TBGRACustomBitmap;
  partial: TBGRACustomBitmap;
begin
  if (ARect.Left = 0) and (ARect.Top = 0) and (ARect.Right = W) and
    (ARect.Bottom = h) then
    Target.resim.PutImage(0, 0, Target.FSkindata.Fimage, dmDrawWithTransparency, Opaque)
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
  if (ARect.Left = 0) and (ARect.Top = 0) and (ARect.Right = W) and
    (ARect.Bottom = h) then
    Target.resim.PutImage(0, 0, Target.FSkindata.Fimage, dmDrawWithTransparency, Opaque)
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


procedure DrawPartnormalbmp(ARect: TRect; Target: TOnURGraphicControl;Targetbmp:TBGRABitmap;
  ATargetRect: TRect; Opaque: byte);
var
  partial: TBGRACustomBitmap;
begin
  if (ARect.Left = 0) and (ARect.Top = 0) and (ARect.Right = Target.Width) and
    (ARect.Bottom = Target.Height) then
    Target.FSkindata.Fimage.Draw(Target.Canvas, ATargetRect, False)
  else
  begin
    partial := Target.FSkindata.Fimage.GetPart(ARect);

    if partial <> nil then
      partial.Draw(Targetbmp.Canvas, ATargetRect, false);
    FreeAndNil(partial);
  end;

end;

procedure DrawPartnormal(ARect: TRect; Target, Desc: TBgrabitmap;
  ATargetRect: TRect; Opaque: byte);
var
  partial: TBGRACustomBitmap;
begin
  if (ARect.Left = 0) and (ARect.Top = 0) and (ARect.Right = Target.Width) and
    (ARect.Bottom = Target.Height) then
    Target.Draw(Target.Canvas, ATargetRect, False)
  else
  begin
    partial := Desc.GetPart(ARect);

    if partial <> nil then
      Target.StretchPutImage(ATargetRect, partial, dmDrawWithTransparency, Opaque);
    FreeAndNil(partial);
  end;

end;

procedure DrawPartnormal(ARect: TRect; Target: TOnURCustomControl;
  ATargetRect: TRect; Opaque: byte);
var
  partial: TBGRACustomBitmap;
begin
  if (ARect.Left = 0) and (ARect.Top = 0) and (ARect.Right = Target.Width) and
    (ARect.Bottom = Target.Height) then
    Target.resim.StretchPutImage(ATargetRect, Target.FSkindata.Fimage, dmSet, Opaque)
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
  if (ARect.Left = 0) and (ARect.Top = 0) and (ARect.Right = Target.Width) and
    (ARect.Bottom = Target.Height) then
    Target.FSkindata.Fimage.Draw(Target.Canvas, ATargetRect, False)
  else
  begin
    partial := Target.FSkindata.Fimage.GetPart(ARect);
    if partial <> nil then
      Target.resim.StretchPutImage(ATargetRect, partial, dmDrawWithTransparency, Opaque);
    FreeAndNil(partial);
  end;

end;

procedure DrawPartnormalBGRABitmap(ARect: TRect; Target: TBGRABitmap;Skindatap:TONURImg;
  ATargetRect: TRect; Opaque: byte);
var
  partial: TBGRACustomBitmap;
begin
  if (ARect.Left = 0) and (ARect.Top = 0) and (ARect.Right = Target.Width) and
    (ARect.Bottom = Target.Height) then
    Skindatap.Fimage.Draw(Target.Canvas, ATargetRect, False)
  else
  begin
    partial := Skindatap.Fimage.GetPart(ARect);
    if partial <> nil then
     Target.StretchPutImage(ATargetRect, partial, dmDrawWithTransparency, Opaque);
   FreeAndNil(partial);
  end;

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
  ATargetRect: TRect; Opaque: byte; txt:string;Txtalgn:TAlignment ;colorr:TBGRAPixel);
var
  partial: TBGRACustomBitmap;
begin
  if (ARect.Left = 0) and (ARect.Top = 0) and (ARect.Right = Target.Width) and
    (ARect.Bottom = Target.Height) then
    Target.resim.StretchPutImage(ATargetRect, Target.FSkindata.Fimage, dmSet, Opaque)
  else
  begin
    partial := Target.FSkindata.Fimage.GetPart(ARect);

    if partial <> nil then
    begin
      Target.resim.StretchPutImage(ATargetRect, partial, dmDrawWithTransparency, Opaque);
      ATargetRect.left:=ATargetRect.left+1;
      ATargetRect.right:=ATargetRect.right-1;
      ATargetRect.top:=ATargetRect.top+1;
      ATargetRect.bottom:=ATargetRect.bottom-1;
      Target.resim.TextRect(ATargetRect,txt,Txtalgn,tlCenter,colorr);
     end;
   FreeAndNil(partial);
  end;

end;


procedure DrawPartnormali(ARect: TRect; Target: TOnURCustomControl;
   x,y,w,h:integer; Opaque: byte;txt:string;Txtalgn:TAlignment;colorr:TBGRAPixel);
var
  partial: TBGRACustomBitmap;
  r:Trect;
begin
    partial := Target.FSkindata.Fimage.GetPart(ARect);
    r:=Rect(x,y,w,h);
    if partial <> nil then
      Target.resim.StretchPutImage(R, partial, dmDrawWithTransparency, Opaque);
    Target.resim.TextOut(x+5,y+5,txt,colorr);
    partial.Free;
end;

procedure DrawPartnormali(ARect: TRect; Target: TOnURCustomControl;
   x,y,w,h:integer; Opaque: byte);
var
  partial: TBGRACustomBitmap;
begin
    partial := Target.FSkindata.Fimage.GetPart(ARect);
    if partial <> nil then
      Target.resim.StretchPutImage(Rect(x,y,w,h), partial, dmDrawWithTransparency, Opaque);
    partial.Free;
end;

procedure DrawPartnormali(ARect: TRect; Target: TONURGraphicControl;
   x,y,w,h:integer; Opaque: byte);
var
  partial: TBGRACustomBitmap;
begin
    partial := Target.FSkindata.Fimage.GetPart(ARect);
    if partial <> nil then
      Target.resim.StretchPutImage(Rect(x,y,w,h), partial, dmDrawWithTransparency, Opaque);
    partial.Free;
end;


{ TONURCUSTOMCROP }

function TONURCustomCrop.Croprect: Trect;
Begin
  result:=rect(0,0,0,0);
  if (Right>0) and (Bottom>0) then
  Result:=rect(Left,Top,Right,Bottom);
End;

function TONURCustomCrop.Width: integer;
begin
 Result:=0;
 if  Right>0 then
 Result := Right-Left;
end;

function TONURCustomCrop.Height: integer;
begin
  Result:=0;
  if  Bottom>0 then
  Result := Bottom-Top;
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
  fparent := TForm(AOwner);
  FTop := TONURCUSTOMCROP.Create;
  FTop.cropname := 'TOP';
  FBottom := TONURCUSTOMCROP.Create;
  FBottom.cropname := 'BOTTOM';
  FCenter := TONURCUSTOMCROP.Create;
  FCenter.cropname := 'CENTER';
  FRight := TONURCUSTOMCROP.Create;
  FRight.cropname := 'RIGHT';
  FTopRight := TONURCUSTOMCROP.Create;
  FTopRight.cropname := 'TOPRIGHT';
  FBottomRight := TONURCUSTOMCROP.Create;
  FBottomRight.cropname := 'BOTTOMRIGHT';
  Fleft := TONURCUSTOMCROP.Create;
  Fleft.cropname := 'LEFT';
  FTopleft := TONURCUSTOMCROP.Create;
  FTopleft.cropname := 'TOPLEFT';
  FBottomleft := TONURCUSTOMCROP.Create;
  FBottomleft.cropname := 'BOTTOMLEFT';
  Customcroplist:=TList.Create;
  Customcroplist.Add(FTopleft);
  Customcroplist.Add(FTop);
  Customcroplist.Add(FTopRight);
  Customcroplist.Add(FBottomleft);
  Customcroplist.Add(FBottom);
  Customcroplist.Add(FBottomRight);
   Customcroplist.Add(Fleft);
  Customcroplist.Add(FCenter);
  Customcroplist.Add(FRight);

  Fimage := TBGRABitmap.Create();
  FRes := TPicture.Create;
  Fres.OnChange := @ImageSet;
  clrr := 'clnone';
  Fopacity:=255;

  frmain     := TBGRABitmap.Create(self.fparent.clientWidth, self.fparent.clientHeight);
  tempbitmap := TBGRABitmap.Create(self.fparent.clientWidth, self.fparent.clientHeight);


  List := TStringList.Create;

  //if not (csDesigning in ComponentState) then
  //  exit;



    if ffilename<>'' then
     Loadskin(ffilename,false)
    else
     Loadskin('', True);

//  if ffilename<>'' then
//  ShowMessage(ffilename);
 end;


destructor TONURImg.Destroy;
var
  i:byte;
begin
  for i:=0 to Customcroplist.Count-1 do
  TONURCUSTOMCROP(Customcroplist.Items[i]).free;

  Customcroplist.Clear;
  FreeAndNil(Customcroplist);
{begin
  FreeAndNil(FTop);
  FreeAndNil(FTopleft);
  FreeAndNil(FTopRight);
  FreeAndNil(FBottom);
  FreeAndNil(FBottomleft);
  FreeAndNil(FBottomRight);
  FreeAndNil(Fleft);
  FreeAndNil(FRight);
  FreeAndNil(FCenter);  }
  FreeAndNil(Frmain);
  FreeAndNil(tempbitmap);
  FreeAndNil(FImage);
  FreeAndNil(FRes);
  FreeAndNil(List);
  inherited;
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
  clrr := 'clnone';

  if (colr <> 'clnone') and (colr <> '') then
  begin
    clrr := colr;
    Loadskin2;
  end;
end;


procedure TONURImg.Colorbgrabitmap;
var
  a: TBGRABitmap;
begin
   a := Tbgrabitmap.Create;
    try
      a.SetSize(tempbitmap.Width, tempbitmap.Height);
      replacepixel(tempbitmap, a, ColorToBGRA(StringToColor(clrr), 150));
      a.InvalidateBitmap;
      Fimage.BlendImage(0, 0, a, boTransparent);
    finally
      FreeAndNil(a);
    end;
End;

procedure TONURImg.Setopacity(Avalue: Byte);
var
  a:TBGRABitmap;
Begin
  If Fopacity=Avalue Then Exit;
  Fopacity:=Avalue;

  a:=TBGRABitmap.Create(Frmain.Width,Frmain.Height);
  try
   a.PutImage(0, 0, tempbitmap, dmDrawWithTransparency, 255);
   Frmain.SetSize(0,0);
   Frmain.SetSize(a.Width,a.Height);
   Frmain.PutImage(0, 0, a, dmDrawWithTransparency, Fopacity);
   fparent.Invalidate;
  Finally
   FreeAndNil(a);
  end;
End;

procedure TONURImg.CropToimg(Buffer: TBGRABitmap);
var
  x, y: integer;
  SpanRgn,hdc1: LCLType.HDC;//integer;
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

  Frmain.SetSize(0,0);
  frmain.SetSize(self.fparent.ClientWidth, self.fparent.ClientHeight);
  //TOPLEFT   //SOLÜST

  TrgtRect := Rect(0, 0, FTopleft.Width,  FTopleft.Height);
  DrawPart(FTopleft.Croprect, TrgtRect);


  //TOPRIGHT //SAĞÜST
  TrgtRect := Rect(self.fparent.clientWidth - FTopRight.Width,
    0, self.fparent.ClientWidth, FTopRight.Height);
  DrawPart(FTopRight.Croprect, TrgtRect);

  //TOP  //ÜST
  TrgtRect := Rect(FTopleft.Width, 0,
    self.fparent.ClientWidth - FTopRight.Width, FTop.Height);
  DrawPart(FTop.Croprect, TrgtRect);



  //BOTTOMLEFT // SOLALT
  TrgtRect := Rect(0, self.fparent.ClientHeight -FBottomleft.Height, FBottomleft.Width, self.fparent.ClientHeight);
  DrawPart(FBottomleft.Croprect, TrgtRect);

  //BOTTOMRIGHT  //SAĞALT
  TrgtRect := Rect(self.fparent.ClientWidth - FBottomRight.Width,
    self.fparent.ClientHeight - FBottomRight.Height,
    self.fparent.ClientWidth, self.fparent.ClientHeight);
  DrawPart(FBottomRight.Croprect, TrgtRect);

  //BOTTOM  //ALT
  TrgtRect := Rect(FBottomleft.Width,
    self.fparent.ClientHeight - FBottom.Height,
    self.fparent.ClientWidth - FBottomRight.Width,
    self.fparent.ClientHeight);
  DrawPart(fbottom.Croprect, TrgtRect);



  //CENTERLEFT // SOLORTA
  TrgtRect := Rect(0, FTopleft.Height,
    Fleft.Width, self.fparent.ClientHeight -FBottomleft.Height);
  DrawPart(Fleft.Croprect, TrgtRect);

  //CENTERRIGHT // SAĞORTA
  TrgtRect := Rect(self.fparent.ClientWidth - FRight.Width,
    FTopRight.Height, self.fparent.ClientWidth,
    self.fparent.ClientHeight - FBottomRight.Height);
  DrawPart(FRight.Croprect, TrgtRect);

  //CENTER //ORTA
  TrgtRect := Rect(Fleft.Width, FTop.Height,
    fparent.ClientWidth - FRight.Width,
    fparent.ClientHeight - FBottom.Height);
  DrawPart(FCenter.Croprect, TrgtRect);


  self.fparent.ChildSizing.LeftRightSpacing:=Fleft.Width;
  self.fparent.ChildSizing.TopBottomSpacing:=FTop.Height;





 if ThemeStyle='modern' then
 begin

  WindowRgn := CreateRectRgn(0, 0, frmain.Width, frmain.Height);

 // Premultiply(frmain);


  //if Frmain.Width>0 then
  {
  for x := 1 to frmain.Width do
  begin
    for y := 1 to frmain.Height do
    begin
      if (frmain.GetPixel(x - 1, y - 1) = BGRAPixelTransparent) then
      begin
        SpanRgn := CreateRectRgn(x - 1, y - 1, x, y);
        CombineRgn(WindowRgn, WindowRgn, SpanRgn, RGN_DIFF);
        DeleteObject(SpanRgn);
      end;
    end;
  end;
  }

  for Y := 0 to frmain.Height-1 do
  begin
    p := frmain.Scanline[Y];
    for X := frmain.Width-1 downto 0 do
    begin
     //  if x<10 then
     //  WriteLn(Y,'  ',X,'  ',P^.alpha);

      if p^.Alpha =0 then//<255 then
      begin
        p^:= BGRAPixelTransparent;
        SpanRgn := CreateRectRgn(x , y, x+1, y+1);
        CombineRgn(WindowRgn, WindowRgn, SpanRgn, RGN_DIFF);
        DeleteObject(SpanRgn);
      end
      else
      begin
        p^.Red := p^.Red * (p^.Alpha + 1) shr 8;
        p^.Green := p^.Green * (p^.Alpha + 1) shr 8;
        p^.Blue := p^.Blue * (p^.Alpha + 1) shr 8;
      end;
      Inc(p);
    end;
  end;


  frmain.InvalidateBitmap;


  SetWindowRgn(self.fparent.Handle, WindowRgn, True);
  hdc1 := GetDC(fparent.Handle);

  ReleaseDC(self.fparent.Handle, hdc1);
  {$ifndef WINDOWS}
  DeleteDC(WindowRgn);
  DeleteDC(hdc1);
  {$else}
   DeleteObject(WindowRgn);
   DeleteObject(hdc1);
  {$endif}
  end;

end;


procedure TONURImg.pant(Sender: TObject);
begin
  frmain.Draw(self.fparent.Canvas, 0, 0, False);
end;

procedure TONURImg.Setloadskin(AValue: String);
begin
  if ffilename=AValue then Exit;
  ffilename:=AValue;
  Loadskin(ffilename,false);
end;

procedure TONURImg.mousedwn(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: integer);
begin
  {$IFDEF UNIX}
  movef := True;
  x9 := x;
  y9 := y;
 // SendMessage(self.fparent.Handle, LM_SYSCOMMAND, $F012, 0);
  {$ELSE}
  ReleaseCapture;
  SendMessage(self.fparent.Handle, WM_SYSCOMMAND, $F012, 0);
  {$ENDIF}
end;


{$IFDEF UNIX}
procedure TONURImg.FormMouseUpp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  movef := False;
end;

procedure TONURImg.FormMouseMovee(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  if movef then
  begin
   self.fparent.Left := self.fparent.Left +x - x9;
   self.fparent.top  := self.fparent.Top +y - y9;
  end;
end;
{$ENDIF}

procedure cropparse(Crp: TONURCustomCrop; val: string);
var
  myst: TStringList;
begin
  if val.Length > 0 then
  begin
    myst := TStringList.Create;
    try
      myst.Delimiter := ',';
      myst.DelimitedText := val;
      Crp.LEFT := StrToIntDef(myst.Strings[0], 2);
      Crp.TOP := StrToIntDef(myst.Strings[1], 2);
      Crp.RIGHT := StrToIntDef(myst.Strings[2], 4);
      Crp.BOTTOM := StrToIntDef(myst.Strings[3], 4);
      Crp.Fontcolor := StringToColorDef(myst.Strings[4], clNone);
    finally
      myst.Free;
    end;
  end;
end;

function croptostring(Crp: TONURCustomCrop): string;
begin
  Result := '';
  if Crp <> nil then
    Result := IntToStr(Crp.LEFT) + ',' + IntToStr(Crp.TOP) + ',' + IntToStr(
      Crp.RIGHT) + ',' + IntToStr(Crp.BOTTOM) + ',' + ColorToString(Crp.Fontcolor);
end;



procedure TONURImg.ReadSkinsComp(Com: TComponent);
var
  skn: TIniFile;
  a: Integer;
begin
  if not FileExists(GetTempDir + 'skins.ini') then exit;

  skn := TIniFile.Create(GetTempDir + 'skins.ini');
  try
    with skn do
    begin


     if (Com is TForm) then
      begin
      if (Fimage <> nil) and (ThemeStyle = 'modern') {and (fparent.Name<>'skinsbuildier')} then
      begin
        cropparse(FTopleft, ReadString('FORM', FTOPLEFT.cropname,
          '0,0,0,0,clblack'));
        cropparse(FTopRight, ReadString(
          'FORM', FTOPRIGHT.cropname, '0,0,0,0,clblack'));
        cropparse(FTop, ReadString('FORM', FTOP.cropname, '0,0,0,0,clblack'));
        cropparse(FBottomleft, ReadString(
          'FORM', FBOTTOMLEFT.cropname, '0,0,0,0,clblack'));
        cropparse(FBottomRight, ReadString(
          'FORM', FBOTTOMRIGHT.cropname, '0,0,0,0,clblack'));
        cropparse(FBottom, ReadString('FORM', FBOTTOM.cropname, '0,0,0,0,clblack'));
        cropparse(Fleft, ReadString('FORM', FLEFT.cropname, '0,0,0,0,clblack'));
        cropparse(FRight, ReadString('FORM', FRIGHT.cropname, '0,0,0,0,clblack'));
        cropparse(FCenter, ReadString('FORM', FCENTER.cropname, '0,0,0,0,clblack'));
        colortheme := ReadString('FORM', 'Color', 'ClNone');
        CropToimg(Fimage); // for crop Tform
        tempbitmap.putimage(0,0,Fimage,dmSetExceptTransparent,255);
      end;
     end;





      if (Com is TONURPageControl) and (TONURPageControl(com).Skindata = Self) then
      begin
        with (TONURPageControl(Com)) do
        begin
           for a:=0 to Customcroplist.Count-1 do
          cropparse(TONURCustomCrop(Customcroplist[a]),ReadString(Skinname, TONURCustomCrop(Customcroplist[a]).cropname, '0,0,0,0,clblack'));
        end;
      end;


      if (Com is TONURPage) and (TONURPage(com).Skindata = Self) then
      begin
        with (TONURPage(Com)) do
        begin
           for a:=0 to Customcroplist.Count-1 do
          cropparse(TONURCustomCrop(Customcroplist[a]),ReadString(Skinname, TONURCustomCrop(Customcroplist[a]).cropname, '0,0,0,0,clblack'));
        end;
      end;

      if (Com is TONURBUTtonareaCntrl) and (TonURbuttonareaCntrl(com).Skindata = Self) then
      begin
        with (TonURbuttonareaCntrl(Com)) do
        begin
          cropparse(OCLIENT, ReadString(Skinname,
            OCLIENT.cropname, '0,0,0,0,clblack'));
        end;
      end;

      if (Com is TONURPageButton) and (TONURPageButton(com).Skindata = Self) then
      begin
        with (TONURPageButton(Com)) do
        begin
           for a:=0 to Customcroplist.Count-1 do
          cropparse(TONURCustomCrop(Customcroplist[a]),ReadString(Skinname, TONURCustomCrop(Customcroplist[a]).cropname, '0,0,0,0,clblack'));
        end;
      end;


      if (Com is TONURsystemButton) and (TONURsystemButton(com).Skindata = Self) then
      begin
        with (TONURsystemButton(Com)) do
        begin
           for a:=0 to Customcroplist.Count-1 do
          cropparse(TONURCustomCrop(Customcroplist[a]),ReadString(Skinname, TONURCustomCrop(Customcroplist[a]).cropname, '0,0,0,0,clblack'));
         end;
      end;



      if (Com is TONURPANEL) and (TONURPANEL(com).Skindata = Self) then
      begin
        with (TONURPANEL(Com)) do
        begin
           for a:=0 to Customcroplist.Count-1 do
          cropparse(TONURCustomCrop(Customcroplist[a]),ReadString(Skinname, TONURCustomCrop(Customcroplist[a]).cropname, '0,0,0,0,clblack'));
        end;
      end;// else

      if (Com is TONURlabel) and (TONURlabel(com).Skindata = Self) then
      begin
        with (TONURlabel(Com)) do
        begin
          cropparse(OCLIENT, ReadString(Skinname,
            OCLIENT.cropname, '0,0,0,0,clblack'));
        end;
      end;// else

      if (Com is TONURLed) and (TONURLed(com).Skindata = Self) then
      begin
        with (TONURLed(Com)) do
        begin
           for a:=0 to Customcroplist.Count-1 do
          cropparse(TONURCustomCrop(Customcroplist[a]),ReadString(Skinname, TONURCustomCrop(Customcroplist[a]).cropname, '0,0,0,0,clblack'));
        end;
      end;// else

      if (Com is TONURKnob) and (TONURKnob(com).Skindata = Self) then
      begin
        with (TONURKnob(Com)) do
        begin
           for a:=0 to Customcroplist.Count-1 do
          cropparse(TONURCustomCrop(Customcroplist[a]),ReadString(Skinname, TONURCustomCrop(Customcroplist[a]).cropname, '0,0,0,0,clblack'));
        end;
      end;

      if (Com is TONURCropButton) and (TONURCropButton(com).Skindata = Self) then
      begin
        with (TONURCropButton(Com)) do
        begin
          for a:=0 to Customcroplist.Count-1 do
          cropparse(TONURCustomCrop(Customcroplist[a]),ReadString(Skinname, TONURCustomCrop(Customcroplist[a]).cropname, '0,0,0,0,clblack'));
         end;
      end;
      if (Com is TONURGraphicsButton) and (TONURGraphicsButton(com).Skindata = Self) then
      begin
        with (TONURGraphicsButton(Com)) do
        begin
           for a:=0 to Customcroplist.Count-1 do
          cropparse(TONURCustomCrop(Customcroplist[a]),ReadString(Skinname, TONURCustomCrop(Customcroplist[a]).cropname, '0,0,0,0,clblack'));
        end;
      end;

      if (Com is TONURComboBox) and (TONURComboBox(com).Skindata = Self) then
      begin
        with (TONURComboBox(Com)) do
        begin
           for a:=0 to Customcroplist.Count-1 do
          cropparse(TONURCustomCrop(Customcroplist[a]),ReadString(Skinname, TONURCustomCrop(Customcroplist[a]).cropname, '0,0,0,0,clblack'));
        end;
      end;// else
      if (Com is TONURCollapExpandPanel) and
        (TONURCollapExpandPanel(com).Skindata = Self) then
      begin
        with (TONURCollapExpandPanel(Com)) do
        begin
           for a:=0 to Customcroplist.Count-1 do
          cropparse(TONURCustomCrop(Customcroplist[a]),ReadString(Skinname, TONURCustomCrop(Customcroplist[a]).cropname, '0,0,0,0,clblack'));
        end;
      end;// else
      if (Com is TONURListBox) and (TONURListBox(com).Skindata = Self) then
      begin
        with (TONURListBox(Com)) do
        begin
           for a:=0 to Customcroplist.Count-1 do
          cropparse(TONURCustomCrop(Customcroplist[a]),ReadString(Skinname, TONURCustomCrop(Customcroplist[a]).cropname, '0,0,0,0,clblack'));
        end;
      end;//else
      if (Com is TONURColumList) and (TONURColumList(com).Skindata = Self) then
      begin
        with (TONURColumList(Com)) do
        begin
           for a:=0 to Customcroplist.Count-1 do
          cropparse(TONURCustomCrop(Customcroplist[a]),ReadString(Skinname, TONURCustomCrop(Customcroplist[a]).cropname, '0,0,0,0,clblack'));
        end;
      end;// else
      if (Com is TONURHeaderPanel) and (TONURHeaderPanel(com).Skindata = Self) then
      begin
        with (TONURHeaderPanel(Com)) do
        begin
           for a:=0 to Customcroplist.Count-1 do
          cropparse(TONURCustomCrop(Customcroplist[a]),ReadString(Skinname, TONURCustomCrop(Customcroplist[a]).cropname, '0,0,0,0,clblack'));
        end;
      end;// else

      if (Com is TONUREdit) and (TONUREdit(com).Skindata = Self) then
      begin
        with (TONUREdit(Com)) do
        begin
           for a:=0 to Customcroplist.Count-1 do
          cropparse(TONURCustomCrop(Customcroplist[a]),ReadString(Skinname, TONURCustomCrop(Customcroplist[a]).cropname, '0,0,0,0,clblack'));
        end;
      end;// else
      if (Com is TONURSpinEdit) and (TONURSpinEdit(com).Skindata = Self) then
        // if component SpinEdit
      begin
        with (TONURSpinEdit(Com)) do
        begin
           for a:=0 to Customcroplist.Count-1 do
          cropparse(TONURCustomCrop(Customcroplist[a]),ReadString(Skinname, TONURCustomCrop(Customcroplist[a]).cropname, '0,0,0,0,clblack'));
        end;
      end;// else
      if (Com is TONURMemo) and (TONURMemo(com).Skindata = Self) then  // if component Memo
      begin
        with (TONURMemo(Com)) do
        begin
           for a:=0 to Customcroplist.Count-1 do
          cropparse(TONURCustomCrop(Customcroplist[a]),ReadString(Skinname, TONURCustomCrop(Customcroplist[a]).cropname, '0,0,0,0,clblack'));
        end;

      end;// else
      if (Com is TONURSwich) and (TONURSwich(com).Skindata = Self) then
      begin
        with (TONURSwich(Com)) do
        begin
           for a:=0 to Customcroplist.Count-1 do
          cropparse(TONURCustomCrop(Customcroplist[a]),ReadString(Skinname, TONURCustomCrop(Customcroplist[a]).cropname, '0,0,0,0,clblack'));
        end;
      end;// else
      if (Com is TONURCheckbox) and (TONURCheckbox(com).Skindata = Self) then
      begin
        with (TONURCheckbox(Com)) do
        begin
           for a:=0 to Customcroplist.Count-1 do
          cropparse(TONURCustomCrop(Customcroplist[a]),ReadString(Skinname, TONURCustomCrop(Customcroplist[a]).cropname, '0,0,0,0,clblack'));
        end;
      end;// else
      if (Com is TONURRadioButton) and (TONURRadioButton(com).Skindata = Self) then
      begin
        with (TONURRadioButton(Com)) do
        begin
           for a:=0 to Customcroplist.Count-1 do
          cropparse(TONURCustomCrop(Customcroplist[a]),ReadString(Skinname, TONURCustomCrop(Customcroplist[a]).cropname, '0,0,0,0,clblack'));
        end;
      end;// else
      if (Com is TONURProgressBar) and (TONURProgressBar(com).Skindata = Self) then
      begin
        with (TONURProgressBar(Com)) do
        begin
           for a:=0 to Customcroplist.Count-1 do
          cropparse(TONURCustomCrop(Customcroplist[a]),ReadString(Skinname, TONURCustomCrop(Customcroplist[a]).cropname, '0,0,0,0,clblack'));
        end;
      end;// else
      if (Com is TONURTrackBar) and (TONURTrackBar(com).Skindata = Self) then
      begin
        with (TONURTrackBar(Com)) do
        begin
           for a:=0 to Customcroplist.Count-1 do
          cropparse(TONURCustomCrop(Customcroplist[a]),ReadString(Skinname, TONURCustomCrop(Customcroplist[a]).cropname, '0,0,0,0,clblack'));
        end;
      end;// else
      if (Com is TONURScrollBar) and (TONURScrollBar(com).Skindata = Self) then
      begin
        with (TONURScrollBar(Com)) do
        begin
            for a:=0 to Customcroplist.Count-1 do
          cropparse(TONURCustomCrop(Customcroplist[a]),ReadString(Skinname, TONURCustomCrop(Customcroplist[a]).cropname, '0,0,0,0,clblack'));
        end;
      end;
    end;

  finally
    FreeAndNil(skn);
  end;
end;



procedure TONURImg.Loadskin2;//(Filename: String; Const Resource: Boolean);
var
  Dir: string;
  i,a: integer;
  skn: Tinifile;
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


      // Skin image reading
    {  if FileExists(dir + ReadString('FORM', 'IMAGE', '')) then
        Fimage.LoadFromFile(dir + ReadString('FORM', 'IMAGE', ''))
      else
        Fimage.Fill(BGRA(207, 220, 207), dmSet);
      }

     // if MColor<>'clNone' then
    //  colorbgrabitmap;

      // Skin image ok
      ThemeStyle := ReadString('FORM', 'style', '');
      ColorTheme := ReadString('FORM', 'Color', 'ClNone');
      self.fparent.Font.Name := ReadString('FORM', 'Fontname', 'calibri');
      self.fparent.Font.color :=
        StringToColor(ReadString('FORM', 'Fontcolor', 'clblack'));
      self.fparent.Font.size := ReadInteger('FORM', 'Fontzie', 11);



      // For TForm.   If modern form.  eliptic or etc..
      if (Fimage <> nil) and (ThemeStyle = 'modern') {and (fparent.Name<>'skinsbuildier')} then
      begin
        cropparse(FTopleft, ReadString('FORM', FTOPLEFT.cropname,
          '0,0,0,0,clblack'));
        cropparse(FTopRight, ReadString(
          'FORM', FTOPRIGHT.cropname, '0,0,0,0,clblack'));
        cropparse(FTop, ReadString('FORM', FTOP.cropname, '0,0,0,0,clblack'));
        cropparse(FBottomleft, ReadString(
          'FORM', FBOTTOMLEFT.cropname, '0,0,0,0,clblack'));
        cropparse(FBottomRight, ReadString(
          'FORM', FBOTTOMRIGHT.cropname, '0,0,0,0,clblack'));
        cropparse(FBottom, ReadString('FORM', FBOTTOM.cropname, '0,0,0,0,clblack'));
        cropparse(Fleft, ReadString('FORM', FLEFT.cropname, '0,0,0,0,clblack'));
        cropparse(FRight, ReadString('FORM', FRIGHT.cropname, '0,0,0,0,clblack'));
        cropparse(FCenter, ReadString('FORM', FCENTER.cropname, '0,0,0,0,clblack'));
        colortheme := ReadString('FORM', 'Color', 'ClNone');

        CropToimg(Fimage); // for crop Tform


      end;
      // Tform ok



      // Tform component reading
      for i := 0 to fparent.ComponentCount - 1 do
      begin

         if (fparent.Components[i] is TONURPageControl) and
            (TONURPageControl(fparent.Components[i]).Skindata = Self) then

         // if component PageControl
         with (TONURPageControl(fparent.Components[i])) do
         begin
           for a:=0 to Customcroplist.Count-1 do
            cropparse(TONURCustomCrop(Customcroplist[a]),ReadString(Skinname, TONURCustomCrop(Customcroplist[a]).cropname, '0,0,0,0,clblack'));
           ReadSkinsComp(btnarea);
         end;

         if (fparent.Components[i] is TONURPage) and
            (TONURPage(fparent.Components[i]).Skindata = Self) then
         with (TONURPage(fparent.Components[i])) do
         begin
           for a:=0 to Customcroplist.Count-1 do
            cropparse(TONURCustomCrop(Customcroplist[a]),ReadString(Skinname, TONURCustomCrop(Customcroplist[a]).cropname, '0,0,0,0,clblack'));
           ReadSkinsComp(Fbutton);
         end;

         if (fparent.Components[i] is TONURBUTtonareaCntrl) and
            (TONURBUTtonareaCntrl(fparent.Components[i]).Skindata = Self) then
         with (TONURBUTtonareaCntrl(fparent.Components[i])) do
         begin
            cropparse(OCLIENT, ReadString(Skinname,  OCLIENT.cropname, '0,0,0,0,clblack'));
         end;

         if (fparent.Components[i] is TONURPageButton) and
           (TONURPageButton(fparent.Components[i]).Skindata = Self) then
         with (TONURPageButton(fparent.Components[i])) do
         begin
           for a:=0 to Customcroplist.Count-1 do
            cropparse(TONURCustomCrop(Customcroplist[a]),ReadString(Skinname, TONURCustomCrop(Customcroplist[a]).cropname, '0,0,0,0,clblack'));
         end;

         if (fparent.Components[i] is TONURsystemButton) and
            (TONURsystemButton(fparent.Components[i]).Skindata = Self) then
         with (TONURsystemButton(fparent.Components[i])) do
         begin
           for a:=0 to Customcroplist.Count-1 do
            cropparse(TONURCustomCrop(Customcroplist[a]),ReadString(Skinname, TONURCustomCrop(Customcroplist[a]).cropname, '0,0,0,0,clblack'));
         end;


         if (fparent.Components[i] is TONURGraphicsButton) and
          (TONURGraphicsButton(fparent.Components[i]).Skindata = Self) then
          // if component GraphicButton
         with (TONURGraphicsButton(fparent.Components[i])) do
         begin
           for a:=0 to Customcroplist.Count-1 do
            cropparse(TONURCustomCrop(Customcroplist[a]),ReadString(Skinname, TONURCustomCrop(Customcroplist[a]).cropname, '0,0,0,0,clblack'));

         end;

         if (fparent.Components[i] is TONURlabel) and
          (TONURlabel(fparent.Components[i]).Skindata = Self) then   // if component GraphicButton
         with (TONURlabel(fparent.Components[i])) do
         begin
            cropparse(OCLIENT, ReadString(Skinname, OCLIENT.cropname, '0,0,0,0,clblack'));
         end;



         if (fparent.Components[i] is TONURKnob) and
          (TONURKnob(fparent.Components[i]).Skindata = Self) then   // if component GraphicButton
         with (TONURKnob(fparent.Components[i])) do
         begin
           for a:=0 to Customcroplist.Count-1 do
            cropparse(TONURCustomCrop(Customcroplist[a]),ReadString(Skinname, TONURCustomCrop(Customcroplist[a]).cropname, '0,0,0,0,clblack'));
           calcsize;
         end;

         if (fparent.Components[i] is TONURLed) and
          (TONURLed(fparent.Components[i]).Skindata = Self) then   // if component GraphicButton
         with (TONURLed(fparent.Components[i])) do
         begin
           for a:=0 to Customcroplist.Count-1 do
            cropparse(TONURCustomCrop(Customcroplist[a]),ReadString(Skinname, TONURCustomCrop(Customcroplist[a]).cropname, '0,0,0,0,clblack'));
         end;

         if (fparent.Components[i] is TONURCropButton) and
          (TONURCropButton(fparent.Components[i]).Skindata = Self) then   // if component CropButton
         with (TONURCropButton(fparent.Components[i])) do
         begin
           for a:=0 to Customcroplist.Count-1 do
            cropparse(TONURCustomCrop(Customcroplist[a]),ReadString(Skinname, TONURCustomCrop(Customcroplist[a]).cropname, '0,0,0,0,clblack'));
         end;

         if (fparent.Components[i] is TONURPanel) and
          (TONURPanel(fparent.Components[i]).Skindata = Self) then    // if component Panel
         with (TONURPanel(fparent.Components[i])) do
         begin
           for a:=0 to Customcroplist.Count-1 do
            cropparse(TONURCustomCrop(Customcroplist[a]),ReadString(Skinname, TONURCustomCrop(Customcroplist[a]).cropname, '0,0,0,0,clblack'));
         end;

         if (fparent.Components[i] is TONURCollapExpandPanel) and
          (TONURCollapExpandPanel(fparent.Components[i]).Skindata = Self) then
          // if component CollapsedExpandedPanel
         with (TONURCollapExpandPanel(fparent.Components[i])) do
         begin
           for a:=0 to Customcroplist.Count-1 do
            cropparse(TONURCustomCrop(Customcroplist[a]),ReadString(Skinname, TONURCustomCrop(Customcroplist[a]).cropname, '0,0,0,0,clblack'));
         end;

         if (fparent.Components[i] is TONUREdit) and
          (TONUREdit(fparent.Components[i]).Skindata = Self) then    // if component Edit
         with (TONUREdit(fparent.Components[i])) do
         begin
           for a:=0 to Customcroplist.Count-1 do
            cropparse(TONURCustomCrop(Customcroplist[a]),ReadString(Skinname, TONURCustomCrop(Customcroplist[a]).cropname, '0,0,0,0,clblack'));
         end;

         if (fparent.Components[i] is TONURSpinEdit) and
          (TONURSpinEdit(fparent.Components[i]).Skindata = Self) then  // if component SpinEdit
         with (TONURSpinEdit(fparent.Components[i])) do
         begin
           for a:=0 to Customcroplist.Count-1 do
            cropparse(TONURCustomCrop(Customcroplist[a]),ReadString(Skinname, TONURCustomCrop(Customcroplist[a]).cropname, '0,0,0,0,clblack'));
         end;

         if (fparent.Components[i] is TONURMemo) and
          (TONURMemo(fparent.Components[i]).Skindata = Self) then  // if component Memo
         with (TONURMemo(fparent.Components[i])) do
         begin
           for a:=0 to Customcroplist.Count-1 do
            cropparse(TONURCustomCrop(Customcroplist[a]),ReadString(Skinname, TONURCustomCrop(Customcroplist[a]).cropname, '0,0,0,0,clblack'));
         end;

         if (fparent.Components[i] is TONURComboBox) and
          (TONURComboBox(fparent.Components[i]).Skindata = Self) then  // if component Combobox
         with (TONURComboBox(fparent.Components[i])) do
         begin
           for a:=0 to Customcroplist.Count-1 do
            cropparse(TONURCustomCrop(Customcroplist[a]),ReadString(Skinname, TONURCustomCrop(Customcroplist[a]).cropname, '0,0,0,0,clblack'));
         end;

         if (fparent.Components[i] is TONURSwich) and
          (TONURSwich(fparent.Components[i]).Skindata = Self) then
         with (TONURSwich(fparent.Components[i])) do
         begin
           for a:=0 to Customcroplist.Count-1 do
            cropparse(TONURCustomCrop(Customcroplist[a]),ReadString(Skinname, TONURCustomCrop(Customcroplist[a]).cropname, '0,0,0,0,clblack'));
         end;

         if (fparent.Components[i] is TONURCheckbox) and
          (TONURCheckbox(fparent.Components[i]).Skindata = Self) then
         with (TONURCheckbox(fparent.Components[i])) do
         begin
           for a:=0 to Customcroplist.Count-1 do
            cropparse(TONURCustomCrop(Customcroplist[a]),ReadString(Skinname, TONURCustomCrop(Customcroplist[a]).cropname, '0,0,0,0,clblack'));
         end;


         if (fparent.Components[i] is TONURRadioButton) and
          (TONURRadioButton(fparent.Components[i]).Skindata = Self) then
         with (TONURRadioButton(fparent.Components[i])) do
         begin
            for a:=0 to Customcroplist.Count-1 do
            cropparse(TONURCustomCrop(Customcroplist[a]),ReadString(Skinname, TONURCustomCrop(Customcroplist[a]).cropname, '0,0,0,0,clblack'));
         end;

         if (fparent.Components[i] is TONURProgressBar) and
          (TONURProgressBar(fparent.Components[i]).Skindata = Self) then
         with (TONURProgressBar(fparent.Components[i])) do
         begin
           for a:=0 to Customcroplist.Count-1 do
            cropparse(TONURCustomCrop(Customcroplist[a]),ReadString(Skinname, TONURCustomCrop(Customcroplist[a]).cropname, '0,0,0,0,clblack'));
           calcsize;
         end;

         if (fparent.Components[i] is TONURTrackBar) and
          (TONURTrackBar(fparent.Components[i]).Skindata = Self) then
         with (TONURTrackBar(fparent.Components[i])) do
         begin
           for a:=0 to Customcroplist.Count-1 do
            cropparse(TONURCustomCrop(Customcroplist[a]),ReadString(Skinname, TONURCustomCrop(Customcroplist[a]).cropname, '0,0,0,0,clblack'));
           calcsize;
         end;

         if (fparent.Components[i] is TONURScrollBar) and
          (TONURScrollBar(fparent.Components[i]).Skindata = Self) then
         with (TONURScrollBar(fparent.Components[i])) do
         begin
           for a:=0 to Customcroplist.Count-1 do
            cropparse(TONURCustomCrop(Customcroplist[a]),ReadString(Skinname, TONURCustomCrop(Customcroplist[a]).cropname, '0,0,0,0,clblack'));
         end;

         if (fparent.Components[i] is TONURColumList) and
          (TONURColumList(fparent.Components[i]).Skindata = Self) then
         with (TONURColumList(fparent.Components[i])) do
         begin
           for a:=0 to Customcroplist.Count-1 do
            cropparse(TONURCustomCrop(Customcroplist[a]),ReadString(Skinname, TONURCustomCrop(Customcroplist[a]).cropname, '0,0,0,0,clblack'));
         end;


         if (fparent.Components[i] is TONURListBox) and
          (TONURListBox(fparent.Components[i]).Skindata = Self) then
         with (TONURListBox(fparent.Components[i])) do
         begin
           for a:=0 to Customcroplist.Count-1 do
            cropparse(TONURCustomCrop(Customcroplist[a]),ReadString(Skinname, TONURCustomCrop(Customcroplist[a]).cropname, '0,0,0,0,clblack'));
         end;

         if (fparent.Components[i] is TONURHeaderPanel) and
          (TONURHeaderPanel(fparent.Components[i]).Skindata = Self) then
         with (TONURHeaderPanel(fparent.Components[i])) do
         begin
           for a:=0 to Customcroplist.Count-1 do
            cropparse(TONURCustomCrop(Customcroplist[a]),ReadString(Skinname, TONURCustomCrop(Customcroplist[a]).cropname, '0,0,0,0,clblack'));
         end;
      end;
    end;
  finally
    self.fparent.Invalidate;// Repaint;
    FreeAndNil(skn);
  end;
end;


procedure TONURImg.Loadskin(FileName: string; const Resource: boolean);
var
  Res: TResourceStream;
//  VerOk: boolean;  // skin version control
  Dir: string;
  UnZipper: TUnZipper;
  i, a: integer;
  skn: Tinifile;
  onlistb:TONURListBox;
  onlistcol:TONURColumList;
begin

  if (Resource=false) and (ExtractFileExt(filename)<>'.osf') then exit;

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
      Dir := ExtractFilePath(Application.ExeName) +  {$IFDEF UNIX} 'skins/' + FileName + '/' {$ELSE}'skins\' + FileName + '\' {$ENDIF}
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
      Skinname := ReadString('GENERAL', 'SKINNAME', 'DEFAULT');
      version := ReadString('GENERAL', 'VERSION', '1.0');
      author := ReadString('GENERAL', 'AUTHOR', 'SKIN CODER');
      email := ReadString('GENERAL', 'EMAIL', 'mail@mail.com');
      homepage := ReadString('GENERAL', 'HOMEPAGE', 'www.lazarus-ide.com');
      comment := ReadString('GENERAL', 'COMMENT', 'SKIN COMMENT');
      screenshot := ReadString('GENERAL', 'SCREENSHOT', '');

      // skin info finish



      // Skin image reading
      if FileExists(dir + ReadString('FORM', 'IMAGE', '')) then
        Fimage.LoadFromFile(dir + ReadString('FORM', 'IMAGE', ''))
      else
        Fimage.Fill(BGRA(190, 208, 190,Opacity), dmSet);
      // Skin image ok


      tempbitmap.putimage(0,0,Fimage,dmSetExceptTransparent,255);  // for color





      ThemeStyle := ReadString('FORM', 'style', '');
      ColorTheme := ReadString('FORM', 'Color', 'ClNone');
      self.fparent.Font.Name := ReadString('FORM', 'Fontname', 'calibri');
      self.fparent.Font.color :=
        StringToColor(ReadString('FORM', 'Fontcolor', 'clblack'));
      self.fparent.Font.size := ReadInteger('FORM', 'Fontzie', 11);



      // For TForm.   If modern form.  eliptic or etc..
      if (Fimage <> nil) and (ThemeStyle = 'modern') {and (fparent.Name<>'skinsbuildier')} then
      begin
        cropparse(FTopleft, ReadString('FORM', FTOPLEFT.cropname,
          '0,0,0,0,clblack'));
        cropparse(FTopRight, ReadString(
          'FORM', FTOPRIGHT.cropname, '0,0,0,0,clblack'));
        cropparse(FTop, ReadString('FORM', FTOP.cropname, '0,0,0,0,clblack'));
        cropparse(FBottomleft, ReadString(
          'FORM', FBOTTOMLEFT.cropname, '0,0,0,0,clblack'));
        cropparse(FBottomRight, ReadString(
          'FORM', FBOTTOMRIGHT.cropname, '0,0,0,0,clblack'));
        cropparse(FBottom, ReadString('FORM', FBOTTOM.cropname, '0,0,0,0,clblack'));
        cropparse(Fleft, ReadString('FORM', FLEFT.cropname, '0,0,0,0,clblack'));
        cropparse(FRight, ReadString('FORM', FRIGHT.cropname, '0,0,0,0,clblack'));
        cropparse(FCenter, ReadString('FORM', FCENTER.cropname, '0,0,0,0,clblack'));
        colortheme := ReadString('FORM', 'Color', 'ClNone');

        self.fparent.BorderStyle := bsNone;
        self.fparent.OnMouseDown := @mousedwn;

       {$IFDEF UNIX}
        self.fparent.OnMouseMove := @FormMouseMovee;
        self.fparent.OnMouseUp   := @formmouseupp;
       {$ENDIF}




        CropToimg(Fimage); // for crop Tform

        Self.fparent.OnPaint := @pant;

      end;
      // Tform ok



      // Tform component reading
      for i := 0 to fparent.ComponentCount - 1 do
      begin


        if (fparent.Components[i] is TONURPageControl) and
        (TONURPageControl(fparent.Components[i]).Skindata = Self) then

          // if component PageControl
        with (TONURPageControl(fparent.Components[i])) do
        begin
          for a:=0 to Customcroplist.Count-1 do
            cropparse(TONURCustomCrop(Customcroplist[a]),ReadString(Skinname, TONURCustomCrop(Customcroplist[a]).cropname, '0,0,0,0,clblack'));
          ReadSkinsComp(btnarea);
        end;

        if (fparent.Components[i] is TONURPage) and
          (TONURPage(fparent.Components[i]).Skindata = Self) then
        with (TONURPage(fparent.Components[i])) do
        begin
          for a:=0 to Customcroplist.Count-1 do
           cropparse(TONURCustomCrop(Customcroplist[a]),ReadString(Skinname, TONURCustomCrop(Customcroplist[a]).cropname, '0,0,0,0,clblack'));
          ReadSkinsComp(Fbutton);
        end;




        if (fparent.Components[i] is TONURBUTtonareaCntrl) and
          (TONURBUTtonareaCntrl(fparent.Components[i]).Skindata = Self) then
        with (TONURBUTtonareaCntrl(fparent.Components[i])) do
        begin
          cropparse(OCLIENT, ReadString(Skinname,
            OCLIENT.cropname, '0,0,0,0,clblack'));
        end;


        if (fparent.Components[i] is TONURPageButton) and
          (TONURPageButton(fparent.Components[i]).Skindata = Self) then
        with (TONURPageButton(fparent.Components[i])) do
        begin
         for a:=0 to Customcroplist.Count-1 do
          cropparse(TONURCustomCrop(Customcroplist[a]),ReadString(Skinname, TONURCustomCrop(Customcroplist[a]).cropname, '0,0,0,0,clblack'));
        end;

        if (fparent.Components[i] is TONURsystemButton) and
          (TONURsystemButton(fparent.Components[i]).Skindata = Self) then
        with (TONURsystemButton(fparent.Components[i])) do
        begin
         for a:=0 to Customcroplist.Count-1 do
          cropparse(TONURCustomCrop(Customcroplist[a]),ReadString(Skinname, TONURCustomCrop(Customcroplist[a]).cropname, '0,0,0,0,clblack'));
        end;

        if (fparent.Components[i] is TONURGraphicsButton) and
          (TONURGraphicsButton(fparent.Components[i]).Skindata = Self) then
          // if component GraphicButton
        with (TONURGraphicsButton(fparent.Components[i])) do
        begin
         for a:=0 to Customcroplist.Count-1 do
          cropparse(TONURCustomCrop(Customcroplist[a]),ReadString(Skinname, TONURCustomCrop(Customcroplist[a]).cropname, '0,0,0,0,clblack'));
        end;

        if (fparent.Components[i] is TONURlabel) and
          (TONURlabel(fparent.Components[i]).Skindata = Self) then   // if component GraphicButton
        with (TONURlabel(fparent.Components[i])) do
        begin
         cropparse(OCLIENT, ReadString(Skinname, OCLIENT.cropname, '0,0,0,0,clblack'));
        end;

        if (fparent.Components[i] is TONURKnob) and
          (TONURKnob(fparent.Components[i]).Skindata = Self) then   // if component GraphicButton
        with (TONURKnob(fparent.Components[i])) do
        begin
         for a:=0 to Customcroplist.Count-1 do
          cropparse(TONURCustomCrop(Customcroplist[a]),ReadString(Skinname, TONURCustomCrop(Customcroplist[a]).cropname, '0,0,0,0,clblack'));
        end;

        if (fparent.Components[i] is TONURLed) and
          (TONURLed(fparent.Components[i]).Skindata = Self) then   // if component GraphicButton
        with (TONURLed(fparent.Components[i])) do
        begin
             for a:=0 to Customcroplist.Count-1 do
          cropparse(TONURCustomCrop(Customcroplist[a]),ReadString(Skinname, TONURCustomCrop(Customcroplist[a]).cropname, '0,0,0,0,clblack'));
        end;

        if (fparent.Components[i] is TONURCropButton) and
          (TONURCropButton(fparent.Components[i]).Skindata = Self) then   // if component CropButton
        with (TONURCropButton(fparent.Components[i])) do
        begin
         for a:=0 to Customcroplist.Count-1 do
          cropparse(TONURCustomCrop(Customcroplist[a]),ReadString(Skinname, TONURCustomCrop(Customcroplist[a]).cropname, '0,0,0,0,clblack'));
        end;

        if (fparent.Components[i] is TONURPanel) and
          (TONURPanel(fparent.Components[i]).Skindata = Self) then    // if component Panel
        with (TONURPanel(fparent.Components[i])) do
        begin
         for a:=0 to Customcroplist.Count-1 do
          cropparse(TONURCustomCrop(Customcroplist[a]),ReadString(Skinname, TONURCustomCrop(Customcroplist[a]).cropname, '0,0,0,0,clblack'));
        end;

        if (fparent.Components[i] is TONURCollapExpandPanel) and
          (TONURCollapExpandPanel(fparent.Components[i]).Skindata = Self) then
          // if component CollapsedExpandedPanel
        with (TONURCollapExpandPanel(fparent.Components[i])) do
        begin
             for a:=0 to Customcroplist.Count-1 do
          cropparse(TONURCustomCrop(Customcroplist[a]),ReadString(Skinname, TONURCustomCrop(Customcroplist[a]).cropname, '0,0,0,0,clblack'));
        end;

        if (fparent.Components[i] is TonUREdit) and
          (TonUREdit(fparent.Components[i]).Skindata = Self) then    // if component Edit
        with (TonUREdit(fparent.Components[i])) do
        begin
           for a:=0 to Customcroplist.Count-1 do
            cropparse(TONURCustomCrop(Customcroplist[a]),ReadString(Skinname, TONURCustomCrop(Customcroplist[a]).cropname, '0,0,0,0,clblack'));
        end;

        if (fparent.Components[i] is TONURSpinEdit) and
          (TONURSpinEdit(fparent.Components[i]).Skindata = Self) then  // if component SpinEdit
        with (TONURSpinEdit(fparent.Components[i])) do
        begin
         for a:=0 to Customcroplist.Count-1 do
          cropparse(TONURCustomCrop(Customcroplist[a]),ReadString(Skinname, TONURCustomCrop(Customcroplist[a]).cropname, '0,0,0,0,clblack'));
        end;

        if (fparent.Components[i] is TONURMemo) and
          (TONURMemo(fparent.Components[i]).Skindata = Self) then  // if component Memo
        with (TONURMemo(fparent.Components[i])) do
        begin
         for a:=0 to Customcroplist.Count-1 do
          cropparse(TONURCustomCrop(Customcroplist[a]),ReadString(Skinname, TONURCustomCrop(Customcroplist[a]).cropname, '0,0,0,0,clblack'));
        end;

        if (fparent.Components[i] is TONURcombobox) and
          (TONURcombobox(fparent.Components[i]).Skindata = Self) then  // if component Combobox
        with (TONURcombobox(fparent.Components[i])) do
        begin
         for a:=0 to Customcroplist.Count-1 do
          cropparse(TONURCustomCrop(Customcroplist[a]),ReadString(Skinname, TONURCustomCrop(Customcroplist[a]).cropname, '0,0,0,0,clblack'));
        end;


        if (fparent.Components[i] is TONURSwich) and
          (TONURSwich(fparent.Components[i]).Skindata = Self) then
        with (TONURSwich(fparent.Components[i])) do
        begin
         for a:=0 to Customcroplist.Count-1 do
          cropparse(TONURCustomCrop(Customcroplist[a]),ReadString(Skinname, TONURCustomCrop(Customcroplist[a]).cropname, '0,0,0,0,clblack'));
        end;


        if (fparent.Components[i] is TONURCheckbox) and
          (TONURCheckbox(fparent.Components[i]).Skindata = Self) then
        with (TONURCheckbox(fparent.Components[i])) do
        begin
         for a:=0 to Customcroplist.Count-1 do
          cropparse(TONURCustomCrop(Customcroplist[a]),ReadString(Skinname, TONURCustomCrop(Customcroplist[a]).cropname, '0,0,0,0,clblack'));
        end;

        if (fparent.Components[i] is TOnURRadioButton) and
          (TONURRadioButton(fparent.Components[i]).Skindata = Self) then
        with (TONURRadioButton(fparent.Components[i])) do
        begin
         for a:=0 to Customcroplist.Count-1 do
          cropparse(TONURCustomCrop(Customcroplist[a]),ReadString(Skinname, TONURCustomCrop(Customcroplist[a]).cropname, '0,0,0,0,clblack'));
        end;

        if (fparent.Components[i] is TONURProgressBar) and
          (TONURProgressBar(fparent.Components[i]).Skindata = Self) then
        with (TONURProgressBar(fparent.Components[i])) do
        begin
         for a:=0 to Customcroplist.Count-1 do
          cropparse(TONURCustomCrop(Customcroplist[a]),ReadString(Skinname, TONURCustomCrop(Customcroplist[a]).cropname, '0,0,0,0,clblack'));
        end;

        if (fparent.Components[i] is TONURTrackBar) and
          (TONURTrackBar(fparent.Components[i]).Skindata = Self) then
        with (TONURTrackBar(fparent.Components[i])) do
        begin
         for a:=0 to Customcroplist.Count-1 do
          cropparse(TONURCustomCrop(Customcroplist[a]),ReadString(Skinname, TONURCustomCrop(Customcroplist[a]).cropname, '0,0,0,0,clblack'));
        end;

        if ((fparent.Components[i] is TONURScrollBar) and
          (TONURScrollBar(fparent.Components[i]).Skindata = Self))  then
       // or ( fparent.Components[i] is ToNListBox) or (fparent.Components[i] is TOncolumlist) then
        with (TONURScrollBar(fparent.Components[i])) do
        begin
         for a:=0 to Customcroplist.Count-1 do
          cropparse(TONURCustomCrop(Customcroplist[a]),ReadString(Skinname, TONURCustomCrop(Customcroplist[a]).cropname, '0,0,0,0,clblack'));
        end;

        if (fparent.Components[i] is TONURcolumlist) and
          (TONURcolumlist(fparent.Components[i]).Skindata = Self) then
        with (TONURcolumlist(fparent.Components[i])) do
        begin
         for a:=0 to Customcroplist.Count-1 do
          cropparse(TONURCustomCrop(Customcroplist[a]),ReadString(Skinname, TONURCustomCrop(Customcroplist[a]).cropname, '0,0,0,0,clblack'));
         ReadSkinsComp(HorizontalScroll);
         ReadSkinsComp(VertialScroll);
        end;


        if (fparent.Components[i] is TONURListBox) and
          (TONURListBox(fparent.Components[i]).Skindata = Self) then
        with (TONURListBox(fparent.Components[i])) do
        begin
           for a:=0 to Customcroplist.Count-1 do
            cropparse(TONURCustomCrop(Customcroplist[a]),ReadString(Skinname, TONURCustomCrop(Customcroplist[a]).cropname, '0,0,0,0,clblack'));
           ReadSkinsComp(HorizontalScroll);
           ReadSkinsComp(VertialScroll);
        end;

        if (fparent.Components[i] is TONURHeaderPanel) and
          (TONURHeaderPanel(fparent.Components[i]).Skindata = Self) then
          with (TONURHeaderPanel(fparent.Components[i])) do
          begin
           for a:=0 to Customcroplist.Count-1 do
            cropparse(TONURCustomCrop(Customcroplist[a]),ReadString(Skinname, TONURCustomCrop(Customcroplist[a]).cropname, '0,0,0,0,clblack'));
          end;
      end;
    end;
  finally
    self.fparent.Invalidate;// Repaint;
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
      Dir := ExtractFilePath(Application.ExeName) + {$IFDEF UNIX} '\skins\' {$ELSE} '/skins/'{$ENDIF} + FileName + {$IFDEF UNIX} '\' {$ELSE} '/'{$ENDIF}
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
  skn: Tinifile;

begin

  if csDesigning in ComponentState then
    exit;

  skn := TIniFile.Create(GetTempDir + {$IFDEF UNIX} 'tmp\skins.ini' {$ELSE} 'tmp/skins.ini'{$ENDIF} );

  try
    with skn do
    begin
      // skin info
      writeString('GENERAL', 'SKINNAME', Skinname);
      writeString('GENERAL', 'VERSION', version);
      writeString('GENERAL', 'AUTHOR', author);
      writeString('GENERAL', 'EMAIL', email);
      writeString('GENERAL', 'HOMEPAGE', homepage);
      writeString('GENERAL', 'COMMENT', comment);
      writeString('GENERAL', 'SCREENSHOT', screenshot);
      // skin info finish

      Fimage.SaveToFile(GetTempDir + {$IFDEF UNIX} 'tmp\skins.png' {$ELSE} 'tmp/skins.png'{$ENDIF} );
      writeString('FORM', 'IMAGE', 'skins.png');
      // Skin image ok

      // For TForm.   If modern form.  eliptic or etc..
      writeString('FORM', 'style', ThemeStyle);
      WriteString('FORM', 'Color', ColorTheme);
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
        if fparent.Components[i] is TONURGraphicsButton then  // if component GraphicButton
        with (TONURGraphicsButton(fparent.Components[i])) do
        begin
         for a:=0 to Customcroplist.Count-1 do
          writeString(Skinname, TONURCustomCrop(Customcroplist[a]).cropname, croptostring(TONURCustomCrop(Customcroplist[a])));
        end;

        if fparent.Components[i] is TONURCropButton then   // if component CropButton
        with (TONURCropButton(fparent.Components[i])) do
        begin
         for a:=0 to Customcroplist.Count-1 do
          writeString(Skinname, TONURCustomCrop(Customcroplist[a]).cropname, croptostring(TONURCustomCrop(Customcroplist[a])));
        end;

        if fparent.Components[i] is TONURlabel then   // if component CropButton
        with (TONURlabel(fparent.Components[i])) do
        begin
          writeString(Skinname, OCLIENT.cropname, croptostring(OCLIENT));
        end;

        if fparent.Components[i] is TONURSYSTEMButton then    // if component Panel
        with (TONURSYSTEMButton(fparent.Components[i])) do
        begin
         for a:=0 to Customcroplist.Count-1 do
          writeString(Skinname, TONURCustomCrop(Customcroplist[a]).cropname, croptostring(TONURCustomCrop(Customcroplist[a])));
        end;

        if fparent.Components[i] is TONURKnob then   // if component CropButton
        with (TONURKnob(fparent.Components[i])) do
        begin
         for a:=0 to Customcroplist.Count-1 do
          writeString(Skinname, TONURCustomCrop(Customcroplist[a]).cropname, croptostring(TONURCustomCrop(Customcroplist[a])));
        end;


        if fparent.Components[i] is TONURLed then   // if component CropButton
        with (TONURLed(fparent.Components[i])) do
        begin
         for a:=0 to Customcroplist.Count-1 do
          writeString(Skinname, TONURCustomCrop(Customcroplist[a]).cropname, croptostring(TONURCustomCrop(Customcroplist[a])));
        end;



        if fparent.Components[i] is TONURPageControl then    // if component Panel
        with (TONURPageControl(fparent.Components[i])) do
        begin
         for a:=0 to Customcroplist.Count-1 do
          writeString(Skinname, TONURCustomCrop(Customcroplist[a]).cropname, croptostring(TONURCustomCrop(Customcroplist[a])));
        end;

        if fparent.Components[i] is TONURPage then    // if component Panel
        with (TONURPage(fparent.Components[i])) do
        begin
         for a:=0 to Customcroplist.Count-1 do
          writeString(Skinname, TONURCustomCrop(Customcroplist[a]).cropname, croptostring(TONURCustomCrop(Customcroplist[a])));
        end;

        if fparent.Components[i] is TONURPageButton then    // if component Panel
        with (TONURPageButton(fparent.Components[i])) do
        begin
         for a:=0 to Customcroplist.Count-1 do
          writeString(Skinname, TONURCustomCrop(Customcroplist[a]).cropname, croptostring(TONURCustomCrop(Customcroplist[a])));
        end;

        if fparent.Components[i] is TONURBUTtonareaCntrl then    // if component Panel
        with (TONURBUTtonareaCntrl(fparent.Components[i])) do
        begin
         writeString(Skinname, OCLIENT.cropname, croptostring(OCLIENT));
        end;


        if fparent.Components[i] is TONURPanel then    // if component Panel
        with (TONURPanel(fparent.Components[i])) do
        begin
         for a:=0 to Customcroplist.Count-1 do
          writeString(Skinname, TONURCustomCrop(Customcroplist[a]).cropname, croptostring(TONURCustomCrop(Customcroplist[a])));
        end;

        if fparent.Components[i] is TONURCollapExpandPanel then
          // if component CollapsedExpandedPanel
        with (TONURCollapExpandPanel(fparent.Components[i])) do
        begin
         for a:=0 to Customcroplist.Count-1 do
          writeString(Skinname, TONURCustomCrop(Customcroplist[a]).cropname, croptostring(TONURCustomCrop(Customcroplist[a])));
        end;


        if fparent.Components[i] is TONUREdit then    // if component Edit
        with (TonUREdit(fparent.Components[i])) do
        begin
         for a:=0 to Customcroplist.Count-1 do
          writeString(Skinname, TONURCustomCrop(Customcroplist[a]).cropname, croptostring(TONURCustomCrop(Customcroplist[a])));
        end;

        if fparent.Components[i] is TOnURSpinEdit then  // if component SpinEdit
        with (TOnURSpinEdit(fparent.Components[i])) do
        begin
         for a:=0 to Customcroplist.Count-1 do
          writeString(Skinname, TONURCustomCrop(Customcroplist[a]).cropname, croptostring(TONURCustomCrop(Customcroplist[a])));
        end;

        if fparent.Components[i] is TONURMemo then  // if component Memo
        with (TONURMemo(fparent.Components[i])) do
        begin
         for a:=0 to Customcroplist.Count-1 do
          writeString(Skinname, TONURCustomCrop(Customcroplist[a]).cropname, croptostring(TONURCustomCrop(Customcroplist[a])));
        end;

        if fparent.Components[i] is TONURcombobox then  // if component Combobox
        with (TONURcombobox(fparent.Components[i])) do
        begin
         for a:=0 to Customcroplist.Count-1 do
          writeString(Skinname, TONURCustomCrop(Customcroplist[a]).cropname, croptostring(TONURCustomCrop(Customcroplist[a])));
        end;


        if fparent.Components[i] is TOnURSwich then
        with (TOnURSwich(fparent.Components[i])) do
        begin
         for a:=0 to Customcroplist.Count-1 do
           writeString(Skinname, TONURCustomCrop(Customcroplist[a]).cropname, croptostring(TONURCustomCrop(Customcroplist[a])));
        end;


        if fparent.Components[i] is TOnURCheckbox then
        with (TOnURCheckbox(fparent.Components[i])) do
        begin
         for a:=0 to Customcroplist.Count-1 do
           writeString(Skinname, TONURCustomCrop(Customcroplist[a]).cropname, croptostring(TONURCustomCrop(Customcroplist[a])));
        end;

        if fparent.Components[i] is TOnURRadioButton then
        with (TOnURRadioButton(fparent.Components[i])) do
        begin
          for a:=0 to Customcroplist.Count-1 do
           writeString(Skinname, TONURCustomCrop(Customcroplist[a]).cropname, croptostring(TONURCustomCrop(Customcroplist[a])));
        end;

        if fparent.Components[i] is TONURProgressBar then
        with (TONURProgressBar(fparent.Components[i])) do
        begin
         for a:=0 to Customcroplist.Count-1 do
          writeString(Skinname, TONURCustomCrop(Customcroplist[a]).cropname, croptostring(TONURCustomCrop(Customcroplist[a])));
        end;


        if fparent.Components[i] is TONURTrackBar then
        with (TONURTrackBar(fparent.Components[i])) do
        begin
         for a:=0 to Customcroplist.Count-1 do
          writeString(Skinname, TONURCustomCrop(Customcroplist[a]).cropname, croptostring(TONURCustomCrop(Customcroplist[a])));
        end;



        if fparent.Components[i] is ToNURScrollBar then
        with (ToNURScrollBar(fparent.Components[i])) do
        begin
         for a:=0 to Customcroplist.Count-1 do
          writeString(Skinname, TONURCustomCrop(Customcroplist[a]).cropname, croptostring(TONURCustomCrop(Customcroplist[a])));
        end;


        if fparent.Components[i] is ToNURListBox then
        with (ToNURListBox(fparent.Components[i])) do
        begin
         for a:=0 to Customcroplist.Count-1 do
          writeString(Skinname, TONURCustomCrop(Customcroplist[a]).cropname, croptostring(TONURCustomCrop(Customcroplist[a])));
        end;

        if fparent.Components[i] is TOnURcolumlist then
        with (TOnURcolumlist(fparent.Components[i])) do
        begin
         for a:=0 to Customcroplist.Count-1 do
          writeString(Skinname, TONURCustomCrop(Customcroplist[a]).cropname, croptostring(TONURCustomCrop(Customcroplist[a])));
        end;

        if fparent.Components[i] is TONURHeaderPanel then
        with (TONURHeaderPanel(fparent.Components[i])) do
        begin
         for a:=0 to Customcroplist.Count-1 do
          writeString(Skinname, TONURCustomCrop(Customcroplist[a]).cropname, croptostring(TONURCustomCrop(Customcroplist[a])));
        end;
      end;
    end;
    //   end;

    Zipper := TZipper.Create;
    try
      Zipper.FileName := filename;
      zipper.Entries.AddFileEntry(GetTempDir + {$IFDEF UNIX} 'tmp\skins.ini' {$ELSE} 'tmp/skins.ini'{$ENDIF} , 'skins.ini');
      zipper.Entries.AddFileEntry(GetTempDir + {$IFDEF UNIX} 'tmp\skins.png' {$ELSE} 'tmp/skins.png'{$ENDIF} , 'skins.png');
      Zipper.ZipAllFiles;
    finally
      Zipper.Free;
    end;
  finally
    FreeAndNil(skn);
  end;
end;




// -----------------------------------------------------------------------------
{ TOnGraphicControl }
// -----------------------------------------------------------------------------


constructor TonURgraphiccontrol.Create(Aowner: TComponent);
begin
  inherited Create(AOwner);
  parent := TWinControl(Aowner);
  ControlStyle := ControlStyle + [csClickEvents, csCaptureMouse,
    csDoubleClicks, csParentBackground];
  Width := 100;
  Height := 30;
  Fkind := oHorizontal;
  Transparent := True;
  Backgroundbitmaped := True;
  ParentColor := True;
  FAlignment := taCenter;
  resim := TBGRABitmap.Create;
  Captionvisible := True;
  falpha := 255;
  Customcroplist:=TList.Create;
end;

destructor TonURgraphiccontrol.Destroy;
begin
  if Assigned(resim) then  FreeAndNil(resim);
  Customcroplist.free;
  inherited Destroy;
end;


// -----------------------------------------------------------------------------
//procedure TonURgraphiccontrol.Wmerasebkgnd(var Message: Twmerasebkgnd);
{$IFDEF UNIX} Procedure TonURgraphiccontrol.WMEraseBkgnd(var Message: TLMEraseBkgnd);
{$ELSE} Procedure TonURgraphiccontrol.WMEraseBkgnd(var Message: TWMEraseBkgnd); {$ENDIF}
begin
  SetBkMode(Message.dc, 1);
  Message.Result := 1;
end;
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
procedure TonURgraphiccontrol.Createparams(var Params: Tcreateparams);
begin
  params.exstyle := params.exstyle or WS_EX_TRANSPARENT {$IFNDEF UNIX} or WS_EX_LAYERED {$ENDIF}  or
    WS_CLIPCHILDREN;
end;


// -----------------------------------------------------------------------------
procedure TONURGRAPHICCONTROL.Setalignment(const Value: Talignment);
begin
  if FAlignment <> Value then
  begin
    FAlignment := Value;
  end;
end;
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
function TONURGRAPHICCONTROL.Gettransparent: boolean;
begin
  Result := Color = clNone;
end;

procedure TONURGRAPHICCONTROL.Settransparent(Newtransparent: boolean);
begin
  if Transparent = NewTransparent then
    exit;
  if NewTransparent = True then
    Color := clNone
  else
  if Color = clNone then
    Color := clBackground;
end;

function TONURGRAPHICCONTROL.Getkind: TonURkindstate;
begin
  Result := Fkind;
end;

procedure TONURGRAPHICCONTROL.Setkind(Avalue: TonURkindstate);
begin
  if avalue = Fkind then exit;
  Fkind := avalue;
  Invalidate;
end;

procedure TONURGRAPHICCONTROL.Setskindata(Aimg: TonURimg);
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

procedure TONURGRAPHICCONTROL.Setskinname(Avalue: string);
begin
  if Fskinname <> avalue then
    Fskinname := avalue;
end;

procedure TONURGRAPHICCONTROL.Setalpha(Val: byte);
begin
  if falpha = val then exit;
  falpha := val;
  Invalidate;
end;


// -----------------------------------------------------------------------------
procedure TONURGRAPHICCONTROL.Paint;
var
   a: TBGRABitmap;
begin
  inherited Paint;
  if (resim <> nil) then
  begin

    if (Assigned(Skindata)) and (self.Skindata.mcolor <> 'clnone') and
      (self.Skindata.mcolor <> '') then
    begin

      a := Tbgrabitmap.Create;
      try
        a.SetSize(resim.Width, resim.Height);
        replacepixel(resim, a, ColorToBGRA(StringToColor(self.Skindata.mcolor),
          self.Skindata.opacity));
        a.InvalidateBitmap;
        resim.BlendImage(0, 0, a, boTransparent);
      finally
        FreeAndNil(a);
      end;
    end;

    Canvas.Lock;
    resim.Draw(self.canvas, 0, 0, False);
    canvas.Unlock;


  end
  else
  begin
    resim.Fill(BGRA(190, 208, 190,alpha), dmSet);
    resim.Draw(self.canvas, 0, 0, False);
  end;

  if Captionvisible then
    yaziyaz(self.Canvas, self.Font, self.ClientRect, Caption, Alignment);

end;
// -----------------------------------------------------------------------------




// -----------------------------------------------------------------------------
{ TONControl }
// -----------------------------------------------------------------------------


constructor Tonurcustomcontrol.Create(Aowner: TComponent);
begin
  inherited Create(AOwner);
  parent := TWinControl(Aowner);
  ControlStyle := ControlStyle + [csParentBackground, csAcceptsControls,
    csClickEvents, csCaptureMouse, csDoubleClicks];
  FAlignment := taCenter;
  DoubleBuffered := True;
  ParentBackground := True;
  Fkind := oHorizontal;
  Backgroundbitmaped := True;
  Width := 100;
  Height := 30;
  resim := TBGRABitmap.Create;
  WindowRgn := CreateRectRgn(0, 0, self.Width, self.Height);
  Captionvisible := True;
  falpha := 255;
  Customcroplist:=TList.Create;
end;

destructor Tonurcustomcontrol.Destroy;
begin
  if Assigned(resim) then  FreeAndNil(resim);
  DeleteObject(WindowRgn);
  Customcroplist.free;
  inherited Destroy;
end;


// -----------------------------------------------------------------------------
procedure Tonurcustomcontrol.Wmerasebkgnd(var Message: {$IFDEF UNIX} TLMEraseBkgnd{$ELSE}Twmerasebkgnd {$ENDIF});
begin
  SetBkMode(Message.dc, TRANSPARENT);
  Message.Result := 1;
end;
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
procedure Tonurcustomcontrol.Createparams(var Params: Tcreateparams);
begin
  inherited CreateParams(Params);
  params.exstyle := params.exstyle or WS_EX_TRANSPARENT or {$IFNDEF UNIX}WS_EX_LAYERED or {$ENDIF}
    WS_CLIPCHILDREN;
end;


// -----------------------------------------------------------------------------
procedure Tonurcustomcontrol.Setalignment(const Value: Talignment);
begin
  if FAlignment <> Value then
  begin
    FAlignment := Value;
  end;
end;

procedure Tonurcustomcontrol.Setskindata(Aimg: TonURimg);
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

procedure Tonurcustomcontrol.Setalpha(Val: byte);
begin
  if falpha = val then exit;
  falpha := val;
  Invalidate;
end;

// -----------------------------------------------------------------------------
procedure Tonurcustomcontrol.Setcrop(Value: boolean);
begin
  if Fcrop <> Value then
  begin
    Fcrop := Value;
  end;
end;

function Tonurcustomcontrol.Getkind: TonURkindstate;
begin
  Result := Fkind;
end;

procedure Tonurcustomcontrol.Setkind(Avalue: TonURkindstate);
begin
  if avalue = Fkind then exit;
  Fkind := avalue;
  Invalidate;
end;

procedure Tonurcustomcontrol.Setskinname(Avalue: string);
begin
  if Fskinname <> avalue then
    Fskinname := avalue;
end;

// --------------------:=---------------------------------------------------------

procedure Tonurcustomcontrol.Croptoimg(Buffer: Tbgrabitmap);
var
  x, y: integer;
  hdc1, SpanRgn: hdc;//integer;

 //  TrgtRect: Trect;
   p: PBGRAPixel;
begin

    WindowRgn := CreateRectRgn(0, 0, buffer.Width, buffer.Height);

  for Y := 0 to buffer.Height-1 do
  begin
    p := buffer.Scanline[Y];
    for X := buffer.Width-1 downto 0 do
    begin
     //  if x<10 then
     //  WriteLn(Y,'  ',X,'  ',P^.alpha);

      if p^.Alpha =0 then//<255 then
      begin
        p^:= BGRAPixelTransparent;
        SpanRgn := CreateRectRgn(x , y, x+1, y+1);
        CombineRgn(WindowRgn, WindowRgn, SpanRgn, RGN_DIFF);
        DeleteObject(SpanRgn);
      end
      else
      begin
        p^.Red := p^.Red * (p^.Alpha + 1) shr 8;
        p^.Green := p^.Green * (p^.Alpha + 1) shr 8;
        p^.Blue := p^.Blue * (p^.Alpha + 1) shr 8;
      end;
      Inc(p);
    end;
  end;


  buffer.InvalidateBitmap;

  hdc1 := GetDC(self.Handle);

  SetWindowRgn(self.Handle, WindowRgn, True);
  ReleaseDC(self.Handle, hdc1);

  {$IFDEF UNIX}
  DeleteDC(WindowRgn);
  DeleteDC(hdc1);
  {$ELSE}
  DeleteObject(WindowRgn);
  DeleteObject(hdc1);
  {$ENDIF}
end;
// -----------------------------------------------------------------------------
procedure Tonurcustomcontrol.Paint;
var
  a: TBGRABitmap;
begin
  inherited;
  if (resim <> nil) then
  begin

    if (Assigned(Skindata)) and (self.Skindata.mcolor <> 'clnone') and
      (self.Skindata.mcolor <> '') then
    begin
      a := Tbgrabitmap.Create;
      try
        a.SetSize(resim.Width, resim.Height);
        replacepixel(resim, a, ColorToBGRA(StringToColor(self.Skindata.mcolor),
          self.Skindata.opacity));
        a.InvalidateBitmap;
        resim.BlendImage(0, 0, a, boTransparent);
      finally
        FreeAndNil(a);
      end;
    end;

    resim.Draw(self.canvas, 0, 0, False);

  end
  else
  begin
    resim.Fill(BGRA(190, 208, 190,alpha), dmSet);
    resim.Draw(self.canvas, 0, 0, False);
  end;

  if Captionvisible then
    yaziyaz(self.Canvas, self.Font, self.ClientRect, Caption, Alignment);

end;
// -----------------------------------------------------------------------------




end.

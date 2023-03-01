unit onurctrl;

{$mode objfpc}{$H+}

{$R 'onur.rc' onres.res}

interface

uses
  Windows, SysUtils, Forms, LCLType, LCLIntf, Classes,
  Controls, Graphics, BGRABitmap, BGRABitmapTypes,
   types, LazUTF8, Zipper,Dialogs;

type
  TONButtonState = (obshover, obspressed, obsnormal);
  TONExpandStatus = (oExpanded, oCollapsed);
  TONButtonDirection = (obleft, obright,obup,obdown);
  TONSwichState = (FonN, FonH, FoffN, FoffH);
  TONKindState = (oVertical, oHorizontal);
  TONScroll = (FDown, FUp);
  Tcapdirection = (ocup, ocdown, ocleft, ocright);


  { TonPersistent }
  TonPersistent = class(TPersistent)
    owner: TPersistent;
  public
    constructor Create(AOwner: TPersistent); overload virtual;
  end;



  { TONCustomCrop }

  TONCustomCrop = class
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

  TONImg = class(TComponent)
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
    Procedure Colorbgrabitmap;
    procedure CropToimg(Buffer: TBGRABitmap);
    procedure ImageSet(Sender: TObject);
    Procedure Loadskin2;
    procedure mousedwn(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: integer);
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
    FCenter    : TONCUSTOMCROP;

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




  { TONGraphicControl }

  TONGraphicControl = class(TGraphicControl)
  private
    FSkindata   : TONImg;
    FAlignment  : TAlignment;
    Fkind       : Tonkindstate;
    Fskinname   : string;
    falpha      : byte;
    procedure WMEraseBkgnd(var Message: TWMEraseBkgnd); message WM_ERASEBKGND;
    procedure CreateParams(var Params: TCreateParams);
    procedure SetAlignment(const Value: TAlignment);
    function GetTransparent: boolean;
    procedure SetTransparent(NewTransparent: boolean);
    function Getkind: Tonkindstate;


    procedure Setskinname(avalue: string);
    procedure setalpha(val: byte);
  public
    { Public declarations }
    Captionvisible     : boolean;
    resim: TBGRABitmap;
    Backgroundbitmaped : boolean;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Paint; override;
  protected
    procedure SetKind(AValue: Tonkindstate); virtual;
    procedure SetSkindata(Aimg: TONImg); virtual;
    property Kind        : Tonkindstate read Getkind        write Setkind default oHorizontal;
  published
    property Align;
    property Alignment   : TAlignment   read FAlignment     write SetAlignment default taCenter;
    property Alpha       : Byte         read falpha         write setalpha default 255;
    property Transparent : Boolean      read GetTransparent write SetTransparent default True;
    property Skindata    : TONImg       read FSkindata      write SetSkindata;
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

  { TONCustomControl }

  TONCustomControl = class(TCustomControl)
  private
    Fcrop      : Boolean;
    FSkindata  : TONImg;
    FAlignment : TAlignment;

    Fkind      : Tonkindstate;
    fskinname  : String;
    falpha     : Byte;
    procedure SetCrop(Value: boolean);
    function Getkind: Tonkindstate;
    procedure SetKind(AValue: Tonkindstate);
    procedure Setskinname(avalue: string);
    procedure SetAlignment(const Value: TAlignment);

    procedure setalpha(val: byte);
    procedure WMEraseBkgnd(var Message: TWMEraseBkgnd); message WM_ERASEBKGND;
    procedure CreateParams(var Params: TCreateParams);
  public
    { Public declarations }
    resim: TBGRABitmap;
    WindowRgn  : HRGN;
    Captionvisible     : boolean;
    Backgroundbitmaped : boolean;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Paint; override;
  protected
    procedure CropToimg(Buffer: TBGRABitmap); virtual;
    procedure SetSkindata(Aimg: TONImg); virtual;
    property Kind      : Tonkindstate read Getkind    write Setkind default oHorizontal;
  published
    property Align;
    property Alignment : TAlignment   read FAlignment write SetAlignment default taCenter;
    property Alpha     : Byte         read falpha     write setalpha default 255;
    property Skindata  : TONImg       read FSkindata  write SetSkindata;
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
    property OnEnter;
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



    procedure DrawPartnormali(ARect: TRect; Target: TOnCustomControl;
     x,y,w,h:integer; Opaque: byte);

    procedure DrawPartnormali(ARect: TRect; Target: TONGraphicControl;
   x,y,w,h:integer; Opaque: byte);

    procedure DrawPartnormali(ARect: TRect; Target: TOnCustomControl;
     x,y,w,h:integer; Opaque: byte;txt:string;Txtalgn:TAlignment;colorr:TBGRAPixel);

    procedure DrawPartnormal(ARect: TRect; Target: TOnCustomControl;
    ATargetRect: TRect; Opaque: byte);

    procedure DrawPartnormaltext(ARect: TRect; Target: TOnCustomControl;
    ATargetRect: TRect; Opaque: byte; txt:string;Txtalgn:TAlignment ;colorr:TBGRAPixel);

    procedure DrawPartstrechRegion(ARect: TRect; Target: TOnCustomControl;
    NewWidth, NewHeight: integer; ATargetRect: TRect; Opaque: byte);

    procedure DrawPartstrechRegion(ARect: TRect; Target: TOnGraphicControl;
    NewWidth, NewHeight: integer; ATargetRect: TRect; Opaque: byte);

    procedure DrawPartnormal(ARect: TRect; Target: TOnGraphicControl;
      ATargetRect: TRect; Opaque: byte);

    procedure DrawPartnormal(ARect: TRect; Target, Desc: TBgrabitmap;
      ATargetRect: TRect; Opaque: byte);

    procedure DrawPartnormalbmp(ARect: TRect; Target: TOnGraphicControl;Targetbmp:TBGRABitmap;
      ATargetRect: TRect; Opaque: byte);

    procedure DrawPartstrech(ARect: TRect; Target: TOnGraphicControl;
      w, h: integer; Opaque: byte);

    procedure DrawPartstrech(ARect: TRect; Target: TOnCustomControl;
      w, h: integer; Opaque: byte);

    procedure DrawPartnormalBGRABitmap(ARect: TRect; Target: TBGRABitmap;Skindatap:Tonimg;
  ATargetRect: TRect; Opaque: byte);

    function ValueRange(const Value, Min, Max: integer): integer;
    function maxlengthstring(s: string; len: integer): string;


procedure Register;



implementation

uses  inifiles,  onurpanel,onuredit,onurpage,onurbutton,onurbar,onurlist;


procedure Register;
begin
  RegisterComponents('ONUR', [TONImg]);
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

function GetTempDir: string;
var
  lng: DWORD;
begin
  SetLength(Result, MAX_PATH);
  lng := GetTempPath(MAX_PATH, PChar(Result));
  SetLength(Result, lng);
end;

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

procedure DrawPartstrech(ARect: TRect; Target: TOnCustomControl;
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

procedure DrawPartstrech(ARect: TRect; Target: TOnGraphicControl;
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


procedure DrawPartnormalbmp(ARect: TRect; Target: TOnGraphicControl;Targetbmp:TBGRABitmap;
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

procedure DrawPartnormal(ARect: TRect; Target: TOnCustomControl;
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


procedure DrawPartnormal(ARect: TRect; Target: TOnGraphicControl;
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

procedure DrawPartnormalBGRABitmap(ARect: TRect; Target: TBGRABitmap;Skindatap:Tonimg;
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



procedure DrawPartstrechRegion(ARect: TRect; Target: TOnGraphicControl;
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


procedure DrawPartstrechRegion(ARect: TRect; Target: TOnCustomControl;
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

procedure DrawPartnormaltext(ARect: TRect; Target: TOnCustomControl;
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


procedure DrawPartnormali(ARect: TRect; Target: TOnCustomControl;
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

procedure DrawPartnormali(ARect: TRect; Target: TOnCustomControl;
   x,y,w,h:integer; Opaque: byte);
var
  partial: TBGRACustomBitmap;
begin
    partial := Target.FSkindata.Fimage.GetPart(ARect);
    if partial <> nil then
      Target.resim.StretchPutImage(Rect(x,y,w,h), partial, dmDrawWithTransparency, Opaque);
    partial.Free;
end;

procedure DrawPartnormali(ARect: TRect; Target: TONGraphicControl;
   x,y,w,h:integer; Opaque: byte);
var
  partial: TBGRACustomBitmap;
begin
    partial := Target.FSkindata.Fimage.GetPart(ARect);
    if partial <> nil then
      Target.resim.StretchPutImage(Rect(x,y,w,h), partial, dmDrawWithTransparency, Opaque);
    partial.Free;
end;


{ TONCustomCrop }

function TONCustomCrop.Croprect: Trect;
Begin
  result:=rect(0,0,0,0);
  if (Right>0) and (Bottom>0) then
  Result:=rect(Left,Top,Right,Bottom);
End;

function TONCustomCrop.Width: integer;
begin
 Result:=0;
 if  Right>0 then
 Result := Right-Left;
end;

function TONCustomCrop.Height: integer;
begin
  Result:=0;
  if  Bottom>0 then
  Result := Bottom-Top;
end;


{ TonPersistent }

constructor tonpersistent.Create(aowner: TPersistent);
begin
  inherited Create;
  owner := Aowner;
end;


{ Tonimg }

// -----------------------------------------------------------------------------
constructor TONImg.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  fparent := TForm(AOwner);
  FTop := TONCUSTOMCROP.Create;
  FTop.cropname := 'TOP';
  FBottom := TONCUSTOMCROP.Create;
  FBottom.cropname := 'BOTTOM';
  FCenter := TONCUSTOMCROP.Create;
  FCenter.cropname := 'CENTER';
  FRight := TONCUSTOMCROP.Create;
  FRight.cropname := 'RIGHT';
  FTopRight := TONCUSTOMCROP.Create;
  FTopRight.cropname := 'TOPRIGHT';
  FBottomRight := TONCUSTOMCROP.Create;
  FBottomRight.cropname := 'BOTTOMRIGHT';
  Fleft := TONCUSTOMCROP.Create;
  Fleft.cropname := 'LEFT';
  FTopleft := TONCUSTOMCROP.Create;
  FTopleft.cropname := 'TOPLEFT';
  FBottomleft := TONCUSTOMCROP.Create;
  FBottomleft.cropname := 'BOTTOMLEFT';
  Fimage := TBGRABitmap.Create();
  FRes := TPicture.Create;
  Fres.OnChange := @ImageSet;
  clrr := 'clnone';
  Fopacity:=255;



  frmain := TBGRABitmap.Create(self.fparent.clientWidth, self.fparent.clientHeight);
  tempbitmap:=TBGRABitmap.Create(self.fparent.clientWidth, self.fparent.clientHeight);


  List := TStringList.Create;

  if not (csDesigning in ComponentState) then
  //  exit;



    if ffilename<>'' then
     Loadskin(ffilename,false)
    else
     Loadskin('', True);

//  if ffilename<>'' then
//  ShowMessage(ffilename);
 end;


destructor TONImg.Destroy;
begin
  FreeAndNil(FTop);
  FreeAndNil(FTopleft);
  FreeAndNil(FTopRight);
  FreeAndNil(FBottom);
  FreeAndNil(FBottomleft);
  FreeAndNil(FBottomRight);
  FreeAndNil(Fleft);
  FreeAndNil(FRight);
  FreeAndNil(FCenter);
  FreeAndNil(Frmain);
  FreeAndNil(tempbitmap);
  FreeAndNil(FImage);
  FreeAndNil(FRes);
  FreeAndNil(List);
  inherited;
end;

procedure TONImg.ImageSet(Sender: TObject);
begin
  FreeAndNil(FImage);
  Fimage := TBGRABitmap.Create(Fres.Width, Fres.Height);
  Fimage.Assign(Fres.Bitmap);
  tempbitmap.Assign(Fimage);
end;


procedure TONImg.Setcolor(colr: string);

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


procedure TONImg.Colorbgrabitmap;
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

procedure TONImg.Setopacity(Avalue: Byte);
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

procedure TONImg.CropToimg(Buffer: TBGRABitmap);
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
  DeleteObject(WindowRgn);
  DeleteObject(hdc1);
 end;

end;


procedure TONImg.pant(Sender: TObject);
begin
  frmain.Draw(self.fparent.Canvas, 0, 0, False);
end;

procedure TONImg.Setloadskin(AValue: String);
begin
  if ffilename=AValue then Exit;
  ffilename:=AValue;
  Loadskin(ffilename,false);
end;

procedure TONImg.mousedwn(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: integer);
begin
  ReleaseCapture;
  SendMessage(self.fparent.Handle, WM_SYSCOMMAND, $F012, 0);
end;

procedure cropparse(Crp: TONCustomCrop; val: string);
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

function croptostring(Crp: TONCustomCrop): string;
begin
  Result := '';
  if Crp <> nil then
    Result := IntToStr(Crp.LEFT) + ',' + IntToStr(Crp.TOP) + ',' + IntToStr(
      Crp.RIGHT) + ',' + IntToStr(Crp.BOTTOM) + ',' + ColorToString(Crp.Fontcolor);
end;



procedure TONImg.ReadSkinsComp(Com: TComponent);
var
  skn: TIniFile;
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





      if (Com is TONPageControl) and (TONPageControl(com).Skindata = Self) then
      begin
        with (TONPageControl(Com)) do
        begin
          cropparse(ONTOPLEFT, ReadString(Skinname,
            ONTOPLEFT.cropname, '0,0,0,0,clblack'));
          cropparse(ONTOPRIGHT, ReadString(Skinname,
            ONTOPRIGHT.cropname, '0,0,0,0,clblack'));
          cropparse(ONTOP, ReadString(Skinname, ONTOP.cropname,
            '0,0,0,0,clblack'));
          cropparse(ONBOTTOMLEFT, ReadString(Skinname,
            ONBOTTOMLEFT.cropname, '0,0,0,0,clblack'));
          cropparse(ONBOTTOMRIGHT, ReadString(Skinname,
            ONBOTTOMRIGHT.cropname, '0,0,0,0,clblack'));
          cropparse(ONBOTTOM, ReadString(Skinname, ONBOTTOM.cropname,
            '0,0,0,0,clblack'));
          cropparse(ONLEFT, ReadString(Skinname, ONLEFT.cropname,
            '0,0,0,0,clblack'));
          cropparse(ONRIGHT, ReadString(Skinname, ONRIGHT.cropname,
            '0,0,0,0,clblack'));
          cropparse(ONCENTER, ReadString(Skinname, ONCENTER.cropname,
            '0,0,0,0,clblack'));
          cropparse(ONBUTTONAREA, ReadString(Skinname, ONBUTTONAREA.cropname,
            '0,0,0,0,clblack'));
        end;
      end;


      if (Com is TONPage) and (TONPage(com).Skindata = Self) then
      begin
        with (TONPage(Com)) do
        begin
          cropparse(ONTOPLEFT, ReadString(Skinname{'panel'},
            ONTOPLEFT.cropname, '0,0,0,0,clblack'));
          cropparse(ONTOPRIGHT, ReadString(Skinname{'panel'},
            ONTOPRIGHT.cropname, '0,0,0,0,clblack'));
          cropparse(ONTOP, ReadString(Skinname{'panel'}, ONTOP.cropname,
            '0,0,0,0,clblack'));
          cropparse(ONBOTTOMLEFT, ReadString(Skinname{'panel'},
            ONBOTTOMLEFT.cropname, '0,0,0,0,clblack'));
          cropparse(ONBOTTOMRIGHT, ReadString(Skinname{'panel'},
            ONBOTTOMRIGHT.cropname, '0,0,0,0,clblack'));
          cropparse(ONBOTTOM, ReadString(Skinname{'panel'}, ONBOTTOM.cropname,
            '0,0,0,0,clblack'));
          cropparse(ONLEFT, ReadString(Skinname{'panel'}, ONLEFT.cropname,
            '0,0,0,0,clblack'));
          cropparse(ONRIGHT, ReadString(Skinname{'panel'}, ONRIGHT.cropname,
            '0,0,0,0,clblack'));
          cropparse(ONCENTER, ReadString(Skinname{'panel'}, ONCENTER.cropname,
            '0,0,0,0,clblack'));
        end;
      end;

      if (Com is TonbuttonareaCntrl) and (TonbuttonareaCntrl(com).Skindata = Self) then
      begin
        with (TonbuttonareaCntrl(Com)) do
        begin
          cropparse(ONCLIENT, ReadString(Skinname{'panel'},
            ONCLIENT.cropname, '0,0,0,0,clblack'));
        end;
      end;

      if (Com is TONPageButton) and (TONPageButton(com).Skindata = Self) then
      begin
        with (TONPageButton(Com)) do
        begin
          cropparse(ONENTER, ReadString(Skinname,ONENTER.cropname, '0,0,0,0,clblack'));
          cropparse(ONNORMAL, ReadString(Skinname,ONNORMAL.cropname, '0,0,0,0,clblack'));
          cropparse(ONPRESS, ReadString(Skinname,ONPRESS.cropname, '0,0,0,0,clblack'));
          cropparse(ONDISABLE, ReadString(Skinname, ONDISABLE.cropname, '0,0,0,0,clblack'));
        end;
      end;


      if (Com is TONPANEL) and (TONPANEL(com).Skindata = Self) then
      begin
        with (TONPANEL(Com)) do
        begin
          cropparse(ONTOPLEFT, ReadString(Skinname{'panel'},
            ONTOPLEFT.cropname, '0,0,0,0,clblack'));
          cropparse(ONTOPRIGHT, ReadString(Skinname{'panel'},
            ONTOPRIGHT.cropname, '0,0,0,0,clblack'));
          cropparse(ONTOP, ReadString(Skinname{'panel'}, ONTOP.cropname,
            '0,0,0,0,clblack'));
          cropparse(ONBOTTOMLEFT, ReadString(Skinname{'panel'},
            ONBOTTOMLEFT.cropname, '0,0,0,0,clblack'));
          cropparse(ONBOTTOMRIGHT, ReadString(Skinname{'panel'},
            ONBOTTOMRIGHT.cropname, '0,0,0,0,clblack'));
          cropparse(ONBOTTOM, ReadString(Skinname{'panel'}, ONBOTTOM.cropname,
            '0,0,0,0,clblack'));
          cropparse(ONLEFT, ReadString(Skinname{'panel'}, ONLEFT.cropname,
            '0,0,0,0,clblack'));
          cropparse(ONRIGHT, ReadString(Skinname{'panel'}, ONRIGHT.cropname,
            '0,0,0,0,clblack'));
          cropparse(ONCENTER, ReadString(Skinname{'panel'}, ONCENTER.cropname,
            '0,0,0,0,clblack'));
        end;
      end;// else

      if (Com is TONlabel) and (TONlabel(com).Skindata = Self) then
      begin
        with (TONlabel(Com)) do
        begin
          cropparse(ONCLIENT, ReadString(Skinname{'button'},
            ONCLIENT.cropname, '0,0,0,0,clblack'));
        end;
      end;// else

      if (Com is TONLed) and (TONLed(com).Skindata = Self) then
      begin
        with (TONLed(Com)) do
        begin
          cropparse(ONLEDONNORMAL, ReadString(Skinname{'button'},
            ONLEDONNORMAL.cropname, '0,0,0,0,clblack'));
          cropparse(ONLEDONHOVER, ReadString(Skinname{'button'},
            ONLEDONHOVER.cropname, '0,0,0,0,clblack'));
          cropparse(ONLEDOFFNORMAL, ReadString(Skinname{'button'},
            ONLEDOFFNORMAL.cropname, '0,0,0,0,clblack'));
          cropparse(ONLEDOFFHOVER, ReadString(Skinname{'button'},
            ONLEDOFFHOVER.cropname, '0,0,0,0,clblack'));
          cropparse(ONDISABLED, ReadString(Skinname{'button'},
            ONDISABLED.cropname, '0,0,0,0,clblack'));
        end;
      end;// else

      if (Com is TONKnob) and (TONKnob(com).Skindata = Self) then
      begin
        with (TONKnob(Com)) do
        begin
          cropparse(ONBUTTONNRML, ReadString(Skinname{'button'},
            ONBUTTONNRML.cropname, '0,0,0,0,clblack'));
          cropparse(ONBUTTONHOVR, ReadString(Skinname{'button'},
            ONBUTTONHOVR.cropname, '0,0,0,0,clblack'));
          cropparse(ONBUTTONDOWN, ReadString(Skinname{'button'},
            ONBUTTONDOWN.cropname, '0,0,0,0,clblack'));
          cropparse(ONBUTTONDSBL, ReadString(Skinname{'button'},
            ONBUTTONDSBL.cropname, '0,0,0,0,clblack'));

          cropparse(ONTOPLEFT, ReadString(Skinname{'panel'},
            ONTOPLEFT.cropname, '0,0,0,0,clblack'));
          cropparse(ONTOPRIGHT, ReadString(Skinname{'panel'},
            ONTOPRIGHT.cropname, '0,0,0,0,clblack'));
          cropparse(ONTOP, ReadString(Skinname{'panel'}, ONTOP.cropname,
            '0,0,0,0,clblack'));
          cropparse(ONBOTTOMLEFT, ReadString(Skinname{'panel'},
            ONBOTTOMLEFT.cropname, '0,0,0,0,clblack'));
          cropparse(ONBOTTOMRIGHT, ReadString(Skinname{'panel'},
            ONBOTTOMRIGHT.cropname, '0,0,0,0,clblack'));
          cropparse(ONBOTTOM, ReadString(Skinname{'panel'}, ONBOTTOM.cropname,
            '0,0,0,0,clblack'));
          cropparse(ONLEFT, ReadString(Skinname{'panel'}, ONLEFT.cropname,
            '0,0,0,0,clblack'));
          cropparse(ONRIGHT, ReadString(Skinname{'panel'}, ONRIGHT.cropname,
            '0,0,0,0,clblack'));
          cropparse(ONCENTER, ReadString(Skinname{'panel'}, ONCENTER.cropname,
            '0,0,0,0,clblack'));

        end;
      end;

      if (Com is TONCropButton) and (TONCropButton(com).Skindata = Self) then
      begin
        with (TONCropButton(Com)) do
        begin
          cropparse(ONDISABLELEFT, ReadString(Skinname, ONDISABLELEFT.cropname, '0,0,0,0,clblack'));
          cropparse(ONDISABLERIGHT, ReadString(Skinname, ONDISABLERIGHT.cropname, '0,0,0,0,clblack'));
          cropparse(ONDISABLETOP, ReadString(Skinname, ONDISABLETOP.cropname, '0,0,0,0,clblack'));
          cropparse(ONDISABLEBOTTOM, ReadString(Skinname, ONDISABLEBOTTOM.cropname, '0,0,0,0,clblack'));
          cropparse(ONDISABLE, ReadString(Skinname, ONDISABLE.cropname, '0,0,0,0,clblack'));

          cropparse(ONHOVERLEFT, ReadString(Skinname, ONHOVERLEFT.cropname, '0,0,0,0,clblack'));
          cropparse(ONHOVERRIGHT, ReadString(Skinname, ONHOVERRIGHT.cropname, '0,0,0,0,clblack'));
          cropparse(ONHOVERTOP, ReadString(Skinname, ONHOVERTOP.cropname, '0,0,0,0,clblack'));
          cropparse(ONHOVERBOTTOM, ReadString(Skinname, ONHOVERBOTTOM.cropname, '0,0,0,0,clblack'));
          cropparse(ONHOVER, ReadString(Skinname, ONHOVER.cropname, '0,0,0,0,clblack'));

          cropparse(ONPRESSEDLEFT, ReadString(Skinname, ONPRESSEDLEFT.cropname, '0,0,0,0,clblack'));
          cropparse(ONPRESSEDRIGHT, ReadString(Skinname, ONPRESSEDRIGHT.cropname, '0,0,0,0,clblack'));
          cropparse(ONPRESSEDTOP, ReadString(Skinname, ONPRESSEDTOP.cropname, '0,0,0,0,clblack'));
          cropparse(ONPRESSEDBOTTOM, ReadString(Skinname, ONPRESSEDBOTTOM.cropname, '0,0,0,0,clblack'));
          cropparse(ONPRESSED, ReadString(Skinname, ONPRESSED.cropname, '0,0,0,0,clblack'));

          cropparse(ONNORMALLEFT, ReadString(Skinname, ONNORMALLEFT.cropname, '0,0,0,0,clblack'));
          cropparse(ONNORMALRIGHT, ReadString(Skinname, ONNORMALRIGHT.cropname, '0,0,0,0,clblack'));
          cropparse(ONNORMALTOP, ReadString(Skinname, ONNORMALTOP.cropname, '0,0,0,0,clblack'));
          cropparse(ONNORMALBOTTOM, ReadString(Skinname, ONNORMALBOTTOM.cropname, '0,0,0,0,clblack'));
          cropparse(ONNORMAL, ReadString(Skinname, ONNORMAL.cropname, '0,0,0,0,clblack'));



         { cropparse(ONDISABLE, ReadString(Skinname{'button'},
            ONDISABLE.cropname, '0,0,0,0,clblack'));
          cropparse(ONNORMAL, ReadString(Skinname{'button'},
            ONNORMAL.cropname, '0,0,0,0,clblack'));
          cropparse(ONHOVER, ReadString(Skinname{'button'}, ONHOVER.cropname,
            '0,0,0,0,clblack'));
          cropparse(ONPRESSED, ReadString(Skinname{'button'},
            ONPRESSED.cropname, '0,0,0,0,clblack'));    }
        end;
      end;
      if (Com is TONGraphicsButton) and (TONGraphicsButton(com).Skindata = Self) then
      begin
        with (TONGraphicsButton(Com)) do
        begin
          cropparse(ONDISABLELEFT, ReadString(Skinname, ONDISABLELEFT.cropname, '0,0,0,0,clblack'));
          cropparse(ONDISABLERIGHT, ReadString(Skinname, ONDISABLERIGHT.cropname, '0,0,0,0,clblack'));
          cropparse(ONDISABLETOP, ReadString(Skinname, ONDISABLETOP.cropname, '0,0,0,0,clblack'));
          cropparse(ONDISABLEBOTTOM, ReadString(Skinname, ONDISABLEBOTTOM.cropname, '0,0,0,0,clblack'));
          cropparse(ONDISABLE, ReadString(Skinname, ONDISABLE.cropname, '0,0,0,0,clblack'));

          cropparse(ONHOVERLEFT, ReadString(Skinname, ONHOVERLEFT.cropname, '0,0,0,0,clblack'));
          cropparse(ONHOVERRIGHT, ReadString(Skinname, ONHOVERRIGHT.cropname, '0,0,0,0,clblack'));
          cropparse(ONHOVERTOP, ReadString(Skinname, ONHOVERTOP.cropname, '0,0,0,0,clblack'));
          cropparse(ONHOVERBOTTOM, ReadString(Skinname, ONHOVERBOTTOM.cropname, '0,0,0,0,clblack'));
          cropparse(ONHOVER, ReadString(Skinname, ONHOVER.cropname, '0,0,0,0,clblack'));

          cropparse(ONPRESSEDLEFT, ReadString(Skinname, ONPRESSEDLEFT.cropname, '0,0,0,0,clblack'));
          cropparse(ONPRESSEDRIGHT, ReadString(Skinname, ONPRESSEDRIGHT.cropname, '0,0,0,0,clblack'));
          cropparse(ONPRESSEDTOP, ReadString(Skinname, ONPRESSEDTOP.cropname, '0,0,0,0,clblack'));
          cropparse(ONPRESSEDBOTTOM, ReadString(Skinname, ONPRESSEDBOTTOM.cropname, '0,0,0,0,clblack'));
          cropparse(ONPRESSED, ReadString(Skinname, ONPRESSED.cropname, '0,0,0,0,clblack'));

          cropparse(ONNORMALLEFT, ReadString(Skinname, ONNORMALLEFT.cropname, '0,0,0,0,clblack'));
          cropparse(ONNORMALRIGHT, ReadString(Skinname, ONNORMALRIGHT.cropname, '0,0,0,0,clblack'));
          cropparse(ONNORMALTOP, ReadString(Skinname, ONNORMALTOP.cropname, '0,0,0,0,clblack'));
          cropparse(ONNORMALBOTTOM, ReadString(Skinname, ONNORMALBOTTOM.cropname, '0,0,0,0,clblack'));
          cropparse(ONNORMAL, ReadString(Skinname, ONNORMAL.cropname, '0,0,0,0,clblack'));



         {
          cropparse(ONDISABLE, ReadString(Skinname{'button'},
            ONDISABLE.cropname, '0,0,0,0,clblack'));
          cropparse(ONNORMAL, ReadString(Skinname{'button'},
            ONNORMAL.cropname, '0,0,0,0,clblack'));
          cropparse(ONHOVER, ReadString(Skinname{'button'}, ONHOVER.cropname,
            '0,0,0,0,clblack'));
          cropparse(ONPRESSED, ReadString(Skinname{'button'},
            ONPRESSED.cropname, '0,0,0,0,clblack'));  }
        end;
      end;

      if (Com is TONcombobox) and (TONcombobox(com).Skindata = Self) then
      begin
        with (TONcombobox(Com)) do
        begin
          cropparse(ONTOPLEFT, ReadString(Skinname{'combobox'},
            ONTOPLEFT.cropname, '0,0,0,0,clblack'));
          cropparse(ONTOPRIGHT, ReadString(Skinname{'combobox'},
            ONTOPRIGHT.cropname, '0,0,0,0,clblack'));
          cropparse(ONTOP, ReadString(Skinname{'combobox'}, ONTOP.cropname,
            '0,0,0,0,clblack'));
          cropparse(ONBOTTOMLEFT, ReadString(Skinname{'combobox'},
            ONBOTTOMLEFT.cropname, '0,0,0,0,clblack'));
          cropparse(ONBOTTOMRIGHT, ReadString(Skinname{'combobox'},
            ONBOTTOMRIGHT.cropname, '0,0,0,0,clblack'));
          cropparse(ONBOTTOM, ReadString(Skinname{'combobox'},
            ONBOTTOM.cropname, '0,0,0,0,clblack'));
          cropparse(ONLEFT, ReadString(Skinname{'combobox'},
            ONLEFT.cropname, '0,0,0,0,clblack'));
          cropparse(ONRIGHT, ReadString(Skinname{'combobox'},
            ONRIGHT.cropname, '0,0,0,0,clblack'));
          cropparse(ONCENTER, ReadString(Skinname{'combobox'},
            ONCENTER.cropname, '0,0,0,0,clblack'));
          cropparse(ONBUTONNORMAL, ReadString(Skinname{'combobox'},
            ONBUTONNORMAL.cropname, '0,0,0,0,clblack'));
          cropparse(ONBUTONPRESS, ReadString(Skinname{'combobox'},
            ONBUTONPRESS.cropname, '0,0,0,0,clblack'));
          cropparse(ONBUTONHOVER, ReadString(Skinname{'combobox'},
            ONBUTONHOVER.cropname, '0,0,0,0,clblack'));
          cropparse(ONBUTONDISABLE, ReadString(Skinname{'combobox'},
            ONBUTONDISABLE.cropname, '0,0,0,0,clblack'));
        end;
      end;// else
      if (Com is TONCollapExpandPanel) and
        (TONCollapExpandPanel(com).Skindata = Self) then
      begin
        with (TONCollapExpandPanel(Com)) do
        begin
          cropparse(ONTOPLEFT, ReadString(Skinname{'expandpanel'},
            ONTOPLEFT.cropname, '0,0,0,0,clblack'));
          cropparse(ONTOPRIGHT, ReadString(Skinname{'expandpanel'},
            ONTOPRIGHT.cropname, '0,0,0,0,clblack'));
          cropparse(ONTOP, ReadString(Skinname{'expandpanel'},
            ONTOP.cropname, '0,0,0,0,clblack'));
          cropparse(ONBOTTOMLEFT, ReadString(Skinname{'expandpanel'},
            ONBOTTOMLEFT.cropname, '0,0,0,0,clblack'));
          cropparse(ONBOTTOMRIGHT, ReadString(
            Skinname{'expandpanel'}, ONBOTTOMRIGHT.cropname, '0,0,0,0,clblack'));
          cropparse(ONBOTTOM, ReadString(Skinname{'expandpanel'},
            ONBOTTOM.cropname, '0,0,0,0,clblack'));
          cropparse(ONLEFT, ReadString(Skinname{'expandpanel'},
            ONLEFT.cropname, '0,0,0,0,clblack'));
          cropparse(ONRIGHT, ReadString(Skinname{'expandpanel'},
            ONRIGHT.cropname, '0,0,0,0,clblack'));
          cropparse(ONCENTER, ReadString(Skinname{'expandpanel'},
            ONCENTER.cropname, '0,0,0,0,clblack'));
          cropparse(ONNORMAL, ReadString(Skinname{'expandpanel'},
            ONNORMAL.cropname, '0,0,0,0,clblack'));
          cropparse(ONHOVER, ReadString(Skinname{'expandpanel'},
            ONHOVER.cropname, '0,0,0,0,clblack'));
          cropparse(ONPRESSED, ReadString(Skinname{'expandpanel'},
            ONPRESSED.cropname, '0,0,0,0,clblack'));
          cropparse(ONDISABLE, ReadString(Skinname{'expandpanel'},
            ONDISABLE.cropname, '0,0,0,0,clblack'));
          cropparse(ONCAPTION, ReadString(Skinname{'expandpanel'},
            ONCAPTION.cropname, '0,0,0,0,clblack'));


        end;
      end;// else
      if (Com is ToNListBox) and (ToNListBox(com).Skindata = Self) then
      begin
        with (ToNListBox(Com)) do
        begin
          cropparse(ONTOPLEFT, ReadString(Skinname{'listbox'},
            ONTOPLEFT.cropname, '0,0,0,0,clblack'));
          cropparse(ONTOPRIGHT, ReadString(Skinname{'listbox'},
            ONTOPRIGHT.cropname, '0,0,0,0,clblack'));
          cropparse(ONTOP, ReadString(Skinname{'listbox'}, ONTOP.cropname,
            '0,0,0,0,clblack'));
          cropparse(ONBOTTOMLEFT, ReadString(Skinname{'listbox'},
            ONBOTTOMLEFT.cropname, '0,0,0,0,clblack'));
          cropparse(ONBOTTOMRIGHT, ReadString(Skinname{'listbox'},
            ONBOTTOMRIGHT.cropname, '0,0,0,0,clblack'));
          cropparse(ONBOTTOM, ReadString(Skinname{'listbox'},
            ONBOTTOM.cropname, '0,0,0,0,clblack'));
          cropparse(ONLEFT, ReadString(Skinname{'listbox'}, ONLEFT.cropname,
            '0,0,0,0,clblack'));
          cropparse(ONRIGHT, ReadString(Skinname{'listbox'},
            ONRIGHT.cropname, '0,0,0,0,clblack'));
          cropparse(ONCENTER, ReadString(Skinname{'listbox'},
            ONCENTER.cropname, '0,0,0,0,clblack'));
          cropparse(ONACTIVEITEM, ReadString(Skinname{'listbox'},
            ONACTIVEITEM.cropname, '0,0,0,0,clblack'));
          cropparse(ONITEM, ReadString(Skinname{'listbox'}, ONITEM.cropname,
            '0,0,0,0,clblack'));

        end;
      end;//else
      if (Com is TOncolumlist) and (TOncolumlist(com).Skindata = Self) then
      begin
        with (TOncolumlist(Com)) do
        begin
          cropparse(ONTOPLEFT, ReadString(Skinname, ONTOPLEFT.cropname,
            '0,0,0,0,clblack'));
          cropparse(ONTOPRIGHT, ReadString(Skinname, ONTOPRIGHT.cropname,
            '0,0,0,0,clblack'));
          cropparse(ONTOP, ReadString(Skinname, ONTOP.cropname, '0,0,0,0,clblack'));
          cropparse(ONBOTTOMLEFT, ReadString(
            Skinname, ONBOTTOMLEFT.cropname, '0,0,0,0,clblack'));
          cropparse(ONBOTTOMRIGHT, ReadString(
            Skinname, ONBOTTOMRIGHT.cropname, '0,0,0,0,clblack'));
          cropparse(ONBOTTOM, ReadString(Skinname, ONBOTTOM.cropname, '0,0,0,0,clblack'));
          cropparse(ONLEFT, ReadString(Skinname, ONLEFT.cropname, '0,0,0,0,clblack'));
          cropparse(ONRIGHT, ReadString(Skinname, ONRIGHT.cropname, '0,0,0,0,clblack'));
          cropparse(ONCENTER, ReadString(Skinname, ONCENTER.cropname, '0,0,0,0,clblack'));
          cropparse(ONACTIVEITEM, ReadString(
            Skinname, ONACTIVEITEM.cropname, '0,0,0,0,clblack'));
          cropparse(ONHEADER, ReadString(Skinname, ONHEADER.cropname, '0,0,0,0,clblack'));
          cropparse(ONITEM, ReadString(Skinname{'listbox'}, ONITEM.cropname,
            '0,0,0,0,clblack'));
        end;
      end;// else
      if (Com is TONHeaderPanel) and (TONHeaderPanel(com).Skindata = Self) then
      begin
        with (TONHeaderPanel(Com)) do
        begin
          cropparse(ONTOPLEFT, ReadString(Skinname{'headerpanel'},
            ONTOPLEFT.cropname, '0,0,0,0,clblack'));
          cropparse(ONTOPRIGHT, ReadString(Skinname{'headerpanel'},
            ONTOPRIGHT.cropname, '0,0,0,0,clblack'));
          cropparse(ONTOP, ReadString(Skinname{'headerpanel'},
            ONTOP.cropname, '0,0,0,0,clblack'));
          cropparse(ONBOTTOMLEFT, ReadString(Skinname{'headerpanel'},
            ONBOTTOMLEFT.cropname, '0,0,0,0,clblack'));
          cropparse(ONBOTTOMRIGHT, ReadString(
            Skinname{'headerpanel'}, ONBOTTOMRIGHT.cropname, '0,0,0,0,clblack'));
          cropparse(ONBOTTOM, ReadString(Skinname{'headerpanel'},
            ONBOTTOM.cropname, '0,0,0,0,clblack'));
          cropparse(ONLEFT, ReadString(Skinname{'headerpanel'},
            ONLEFT.cropname, '0,0,0,0,clblack'));
          cropparse(ONRIGHT, ReadString(Skinname{'headerpanel'},
            ONRIGHT.cropname, '0,0,0,0,clblack'));
          cropparse(ONCENTER, ReadString(Skinname{'headerpanel'},
            ONCENTER.cropname, '0,0,0,0,clblack'));
        end;
      end;// else



      if (Com is TonEdit) and (TonEdit(com).Skindata = Self) then
      begin
        with (TonEdit(Com)) do
        begin
          cropparse(ONTOPLEFT, ReadString(Skinname{'edit'},
            ONTOPLEFT.cropname, '0,0,0,0,clblack'));
          cropparse(ONTOPRIGHT, ReadString(Skinname{'edit'},
            ONTOPRIGHT.cropname, '0,0,0,0,clblack'));
          cropparse(ONTOP, ReadString(Skinname{'edit'}, ONTOP.cropname,
            '0,0,0,0,clblack'));
          cropparse(ONBOTTOMLEFT, ReadString(
            Skinname{'edit'}, ONBOTTOMLEFT.cropname, '0,0,0,0,clblack'));
          cropparse(ONBOTTOMRIGHT, ReadString(Skinname{'edit'},
            ONBOTTOMRIGHT.cropname, '0,0,0,0,clblack'));
          cropparse(ONBOTTOM, ReadString(Skinname{'edit'}, ONBOTTOM.cropname,
            '0,0,0,0,clblack'));
          cropparse(ONLEFT, ReadString(Skinname{'edit'}, ONLEFT.cropname,
            '0,0,0,0,clblack'));
          cropparse(ONRIGHT, ReadString(Skinname{'edit'}, ONRIGHT.cropname,
            '0,0,0,0,clblack'));
          cropparse(ONCENTER, ReadString(Skinname{'edit'}, ONCENTER.cropname,
            '0,0,0,0,clblack'));
        end;
      end;// else
      if (Com is TOnSpinEdit) and (TOnSpinEdit(com).Skindata = Self) then
        // if component SpinEdit
      begin
        with (TOnSpinEdit(Com)) do
        begin
          cropparse(ONTOPLEFT, ReadString(Skinname, ONTOPLEFT.cropname,
            '0,0,0,0,clblack'));
          cropparse(ONTOPRIGHT, ReadString(Skinname, ONTOPRIGHT.cropname,
            '0,0,0,0,clblack'));
          cropparse(ONTOP, ReadString(Skinname, ONTOP.cropname, '0,0,0,0,clblack'));
          cropparse(ONBOTTOMLEFT, ReadString(
            Skinname, ONBOTTOMLEFT.cropname, '0,0,0,0,clblack'));
          cropparse(ONBOTTOMRIGHT, ReadString(
            Skinname, ONBOTTOMRIGHT.cropname, '0,0,0,0,clblack'));
          cropparse(ONBOTTOM, ReadString(Skinname, ONBOTTOM.cropname, '0,0,0,0,clblack'));
          cropparse(ONLEFT, ReadString(Skinname, ONLEFT.cropname, '0,0,0,0,clblack'));
          cropparse(ONRIGHT, ReadString(Skinname, ONRIGHT.cropname, '0,0,0,0,clblack'));
          cropparse(ONCENTER, ReadString(Skinname, ONCENTER.cropname, '0,0,0,0,clblack'));
          cropparse(ONUPBUTONNORMAL, ReadString(
            Skinname, ONUPBUTONNORMAL.cropname, '0,0,0,0,clblack'));
          cropparse(ONUPBUTONPRESS, ReadString(
            Skinname, ONUPBUTONPRESS.cropname, '0,0,0,0,clblack'));
          cropparse(ONUPBUTONHOVER, ReadString(
            Skinname, ONUPBUTONHOVER.cropname, '0,0,0,0,clblack'));
          cropparse(ONUPBUTONDISABLE, ReadString(
            Skinname, ONUPBUTONDISABLE.cropname, '0,0,0,0,clblack'));
          cropparse(ONDOWNBUTONNORMAL, ReadString(
            Skinname, ONDOWNBUTONNORMAL.cropname, '0,0,0,0,clblack'));
          cropparse(ONDOWNBUTONPRESS, ReadString(
            Skinname, ONDOWNBUTONPRESS.cropname, '0,0,0,0,clblack'));
          cropparse(ONDOWNBUTONHOVER, ReadString(
            Skinname, ONDOWNBUTONHOVER.cropname, '0,0,0,0,clblack'));
          cropparse(ONDOWNBUTONDISABLE, ReadString(
            Skinname, ONDOWNBUTONDISABLE.cropname, '0,0,0,0,clblack'));
        end;
      end;// else
      if (Com is TONMemo) and (TONMemo(com).Skindata = Self) then  // if component Memo
      begin
        with (TONMemo(Com)) do
        begin
          cropparse(ONTOPLEFT, ReadString(Skinname, ONTOPLEFT.cropname,
            '0,0,0,0,clblack'));
          cropparse(ONTOPRIGHT, ReadString(Skinname, ONTOPRIGHT.cropname,
            '0,0,0,0,clblack'));
          cropparse(ONTOP, ReadString(Skinname, ONTOP.cropname, '0,0,0,0,clblack'));
          cropparse(ONBOTTOMLEFT, ReadString(
            Skinname, ONBOTTOMLEFT.cropname, '0,0,0,0,clblack'));
          cropparse(ONBOTTOMRIGHT, ReadString(
            Skinname, ONBOTTOMRIGHT.cropname, '0,0,0,0,clblack'));
          cropparse(ONBOTTOM, ReadString(Skinname, ONBOTTOM.cropname, '0,0,0,0,clblack'));
          cropparse(ONLEFT, ReadString(Skinname, ONLEFT.cropname, '0,0,0,0,clblack'));
          cropparse(ONRIGHT, ReadString(Skinname, ONRIGHT.cropname, '0,0,0,0,clblack'));
          cropparse(ONCENTER, ReadString(Skinname, ONCENTER.cropname, '0,0,0,0,clblack'));
        end;

      end;// else
      if (Com is TOnSwich) and (TOnSwich(com).Skindata = Self) then
      begin
        with (TOnSwich(Com)) do
        begin
          cropparse(ONOPEN, ReadString(Skinname, ONOPEN.cropname, '0,0,0,0,clblack'));
          cropparse(ONOPENHOVER, ReadString(Skinname, ONOPENHOVER.cropname,
            '0,0,0,0,clblack'));
          cropparse(ONCLOSE, ReadString(Skinname, ONCLOSE.cropname, '0,0,0,0,clblack'));
          cropparse(ONCLOSEHOVER, ReadString(
            Skinname, ONCLOSEHOVER.cropname, '0,0,0,0,clblack'));
          cropparse(ONDISABLE, ReadString(Skinname, ONDISABLE.cropname,
            '0,0,0,0,clblack'));
        end;
      end;// else
      if (Com is TOnCheckbox) and (TOnCheckbox(com).Skindata = Self) then
      begin
        with (TOnCheckbox(Com)) do
        begin
          cropparse(ONNORMAL, ReadString(Skinname, ONNORMAL.cropname, '0,0,0,0,clblack'));
          cropparse(ONNORMALDOWN, ReadString(
            Skinname, ONNORMALDOWN.cropname, '0,0,0,0,clblack'));
          cropparse(ONNORMALHOVER, ReadString(
            Skinname, ONNORMALHOVER.cropname, '0,0,0,0,clblack'));
          cropparse(ONCHECKED, ReadString(Skinname, ONCHECKED.cropname,
            '0,0,0,0,clblack'));
          cropparse(ONCHECKEDHOVER, ReadString(
            Skinname, ONCHECKEDHOVER.cropname, '0,0,0,0,clblack'));
          cropparse(ONDISABLE, ReadString(Skinname, ONDISABLE.cropname,
            '0,0,0,0,clblack'));
        end;
      end;// else
      if (Com is TOnRadioButton) and (TOnRadioButton(com).Skindata = Self) then
      begin
        with (TOnRadioButton(Com)) do
        begin
          cropparse(ONNORMAL, ReadString(Skinname, ONNORMAL.cropname, '0,0,0,0,clblack'));
          cropparse(ONNORMALDOWN, ReadString(
            Skinname, ONNORMALDOWN.cropname, '0,0,0,0,clblack'));
          cropparse(ONNORMALHOVER, ReadString(
            Skinname, ONNORMALHOVER.cropname, '0,0,0,0,clblack'));
          cropparse(ONCHECKED, ReadString(Skinname, ONCHECKED.cropname,
            '0,0,0,0,clblack'));
          cropparse(ONCHECKEDHOVER, ReadString(
            Skinname, ONCHECKEDHOVER.cropname, '0,0,0,0,clblack'));
          cropparse(ONDISABLE, ReadString(Skinname, ONDISABLE.cropname,
            '0,0,0,0,clblack'));
        end;
      end;// else
      if (Com is TONProgressBar) and (TONProgressBar(com).Skindata = Self) then
      begin
        with (TONProgressBar(Com)) do
        begin
          //     if Kind=oHorizontal then
          //     begin
          //        cropparse(ONLEFT_TOP,ReadString(Skinname,ONLEFT.cropname,'0,0,0,0,clblack'));
          //       cropparse(ONRIGHT_BOTTOM,ReadString(Skinname,ONRIGHT.cropname,'0,0,0,0,clblack'));
          //      end else
          //      begin
          cropparse(ONLEFT_TOP, ReadString(Skinname, ONLEFT_TOP.cropname,
            '0,0,0,0,clblack'));
          cropparse(ONRIGHT_BOTTOM, ReadString(
            Skinname, ONRIGHT_BOTTOM.cropname, '0,0,0,0,clblack'));
          //      end;
          cropparse(ONCENTER, ReadString(Skinname, ONCENTER.cropname, '0,0,0,0,clblack'));
          cropparse(ONTOP, ReadString(Skinname, ONTOP.cropname, '0,0,0,0,clblack'));
          cropparse(ONBOTTOM, ReadString(Skinname, ONBOTTOM.cropname, '0,0,0,0,clblack'));
          cropparse(ONBAR, ReadString(Skinname, ONBAR.cropname, '0,0,0,0,clblack'));

        end;
      end;// else
      if (Com is TONTrackBar) and (TONTrackBar(com).Skindata = Self) then
      begin
        with (TONTrackBar(Com)) do
        begin
          cropparse(ONLEFT, ReadString(Skinname, ONLEFT.cropname, '0,0,0,0,clblack'));
          cropparse(ONRIGHT, ReadString(Skinname, ONRIGHT.cropname, '0,0,0,0,clblack'));
          cropparse(ONCENTER, ReadString(Skinname, ONCENTER.cropname, '0,0,0,0,clblack'));
          cropparse(ONBUTONNORMAL, ReadString(
            Skinname, ONBUTONNORMAL.cropname, '0,0,0,0,clblack'));
          cropparse(ONBUTONHOVER, ReadString(
            Skinname, ONBUTONHOVER.cropname, '0,0,0,0,clblack'));
          cropparse(ONBUTONPRESS, ReadString(
            Skinname, ONBUTONPRESS.cropname, '0,0,0,0,clblack'));
          cropparse(ONBUTONDISABLE, ReadString(
            Skinname, ONBUTONDISABLE.cropname, '0,0,0,0,clblack'));
        end;
      end;// else
      if (Com is ToNScrollBar) and (ToNScrollBar(com).Skindata = Self) then
      begin
        with (ToNScrollBar(Com)) do
        begin

          cropparse(ONTOP, ReadString(Skinname, ONTOP.cropname,
            '0,0,0,0,clblack'));
          cropparse(ONBOTTOM, ReadString(Skinname, ONBOTTOM.cropname,
            '0,0,0,0,clblack'));

          cropparse(ONNORMAL, ReadString(Skinname, ONNORMAL.cropname,
            '0,0,0,0,clblack'));
          cropparse(ONBAR, ReadString(Skinname, ONBAR.cropname, '0,0,0,0,clblack'));
          cropparse(ONCENTERBUTNORMAL, ReadString(
            Skinname, ONCENTERBUTNORMAL.cropname, '0,0,0,0,clblack'));
          cropparse(ONCENTERBUTONHOVER, ReadString(
            Skinname, ONCENTERBUTONHOVER.cropname, '0,0,0,0,clblack'));
          cropparse(ONCENTERBUTPRESS, ReadString(
            Skinname, ONCENTERBUTPRESS.cropname, '0,0,0,0,clblack'));
          cropparse(ONCENTERBUTDISABLE, ReadString(
            Skinname, ONCENTERBUTDISABLE.cropname, '0,0,0,0,clblack'));
          cropparse(ONLEFTBUTNORMAL, ReadString(
            Skinname, ONLEFTBUTNORMAL.cropname, '0,0,0,0,clblack'));
          cropparse(ONLEFTBUTONHOVER, ReadString(
            Skinname, ONLEFTBUTONHOVER.cropname, '0,0,0,0,clblack'));
          cropparse(ONLEFTBUTPRESS, ReadString(
            Skinname, ONLEFTBUTPRESS.cropname, '0,0,0,0,clblack'));
          cropparse(ONLEFTBUTDISABLE, ReadString(
            Skinname, ONLEFTBUTDISABLE.cropname, '0,0,0,0,clblack'));
          cropparse(ONRIGHTBUTNORMAL, ReadString(
            Skinname, ONRIGHTBUTNORMAL.cropname, '0,0,0,0,clblack'));
          cropparse(ONRIGHTBUTONHOVER, ReadString(
            Skinname, ONRIGHTBUTONHOVER.cropname, '0,0,0,0,clblack'));
          cropparse(ONRIGHTBUTPRESS, ReadString(
            Skinname, ONRIGHTBUTPRESS.cropname, '0,0,0,0,clblack'));
          cropparse(ONRIGHTBUTDISABLE, ReadString(
            Skinname, ONRIGHTBUTDISABLE.cropname, '0,0,0,0,clblack'));
        end;
      end;
    end;

  finally
    FreeAndNil(skn);
  end;
end;



procedure TONImg.Loadskin2;//(Filename: String; Const Resource: Boolean);
var
  Dir: string;
  i: integer;
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

      if (fparent.Components[i] is TONPageControl) and
          (TONPageControl(fparent.Components[i]).Skindata = Self) then

          // if component PageControl
          with (TONPageControl(fparent.Components[i])) do
          begin
          cropparse(ONTOPLEFT, ReadString(Skinname,
            ONTOPLEFT.cropname, '0,0,0,0,clblack'));
          cropparse(ONTOPRIGHT, ReadString(Skinname,
            ONTOPRIGHT.cropname, '0,0,0,0,clblack'));
          cropparse(ONTOP, ReadString(Skinname, ONTOP.cropname,
            '0,0,0,0,clblack'));
          cropparse(ONBOTTOMLEFT, ReadString(Skinname,
            ONBOTTOMLEFT.cropname, '0,0,0,0,clblack'));
          cropparse(ONBOTTOMRIGHT, ReadString(Skinname,
            ONBOTTOMRIGHT.cropname, '0,0,0,0,clblack'));
          cropparse(ONBOTTOM, ReadString(Skinname, ONBOTTOM.cropname,
            '0,0,0,0,clblack'));
          cropparse(ONLEFT, ReadString(Skinname, ONLEFT.cropname,
            '0,0,0,0,clblack'));
          cropparse(ONRIGHT, ReadString(Skinname, ONRIGHT.cropname,
            '0,0,0,0,clblack'));
          cropparse(ONCENTER, ReadString(Skinname, ONCENTER.cropname,
            '0,0,0,0,clblack'));
          cropparse(ONBUTTONAREA, ReadString(Skinname, ONBUTTONAREA.cropname,
            '0,0,0,0,clblack'));
         end;


        
       if (fparent.Components[i] is TONPage) and
          (TONPage(fparent.Components[i]).Skindata = Self) then
        with (TONPage(fparent.Components[i])) do
        begin
          cropparse(ONTOPLEFT, ReadString(Skinname{'panel'},
            ONTOPLEFT.cropname, '0,0,0,0,clblack'));
          cropparse(ONTOPRIGHT, ReadString(Skinname{'panel'},
            ONTOPRIGHT.cropname, '0,0,0,0,clblack'));
          cropparse(ONTOP, ReadString(Skinname{'panel'}, ONTOP.cropname,
            '0,0,0,0,clblack'));
          cropparse(ONBOTTOMLEFT, ReadString(Skinname{'panel'},
            ONBOTTOMLEFT.cropname, '0,0,0,0,clblack'));
          cropparse(ONBOTTOMRIGHT, ReadString(Skinname{'panel'},
            ONBOTTOMRIGHT.cropname, '0,0,0,0,clblack'));
          cropparse(ONBOTTOM, ReadString(Skinname{'panel'}, ONBOTTOM.cropname,
            '0,0,0,0,clblack'));
          cropparse(ONLEFT, ReadString(Skinname{'panel'}, ONLEFT.cropname,
            '0,0,0,0,clblack'));
          cropparse(ONRIGHT, ReadString(Skinname{'panel'}, ONRIGHT.cropname,
            '0,0,0,0,clblack'));
          cropparse(ONCENTER, ReadString(Skinname{'panel'}, ONCENTER.cropname,
            '0,0,0,0,clblack'));
        end;




      if (fparent.Components[i] is TonbuttonareaCntrl) and
          (TonbuttonareaCntrl(fparent.Components[i]).Skindata = Self) then
        with (TonbuttonareaCntrl(fparent.Components[i])) do
        begin
          cropparse(ONCLIENT, ReadString(Skinname{'panel'},
            ONCLIENT.cropname, '0,0,0,0,clblack'));
        end;


      if (fparent.Components[i] is TONPageButton) and
          (TONPageButton(fparent.Components[i]).Skindata = Self) then
        with (TONPageButton(fparent.Components[i])) do
        begin
          cropparse(ONENTER, ReadString(Skinname{'panel'},
            ONENTER.cropname, '0,0,0,0,clblack'));
          cropparse(ONNORMAL, ReadString(Skinname{'panel'},
            ONNORMAL.cropname, '0,0,0,0,clblack'));
          cropparse(ONPRESS, ReadString(Skinname{'panel'},
            ONPRESS.cropname, '0,0,0,0,clblack'));
          cropparse(ONDISABLE, ReadString(Skinname{'panel'},
            ONDISABLE.cropname, '0,0,0,0,clblack'));
        end;



       if (fparent.Components[i] is TONGraphicsButton) and
          (TONGraphicsButton(fparent.Components[i]).Skindata = Self) then
          // if component GraphicButton
          with (TONGraphicsButton(fparent.Components[i])) do
          begin
            cropparse(ONDISABLELEFT, ReadString(Skinname, ONDISABLELEFT.cropname, '0,0,0,0,clblack'));
            cropparse(ONDISABLERIGHT, ReadString(Skinname, ONDISABLERIGHT.cropname, '0,0,0,0,clblack'));
            cropparse(ONDISABLETOP, ReadString(Skinname, ONDISABLETOP.cropname, '0,0,0,0,clblack'));
            cropparse(ONDISABLEBOTTOM, ReadString(Skinname, ONDISABLEBOTTOM.cropname, '0,0,0,0,clblack'));
            cropparse(ONDISABLE, ReadString(Skinname, ONDISABLE.cropname, '0,0,0,0,clblack'));

            cropparse(ONHOVERLEFT, ReadString(Skinname, ONHOVERLEFT.cropname, '0,0,0,0,clblack'));
            cropparse(ONHOVERRIGHT, ReadString(Skinname, ONHOVERRIGHT.cropname, '0,0,0,0,clblack'));
            cropparse(ONHOVERTOP, ReadString(Skinname, ONHOVERTOP.cropname, '0,0,0,0,clblack'));
            cropparse(ONHOVERBOTTOM, ReadString(Skinname, ONHOVERBOTTOM.cropname, '0,0,0,0,clblack'));
            cropparse(ONHOVER, ReadString(Skinname, ONHOVER.cropname, '0,0,0,0,clblack'));

            cropparse(ONPRESSEDLEFT, ReadString(Skinname, ONPRESSEDLEFT.cropname, '0,0,0,0,clblack'));
            cropparse(ONPRESSEDRIGHT, ReadString(Skinname, ONPRESSEDRIGHT.cropname, '0,0,0,0,clblack'));
            cropparse(ONPRESSEDTOP, ReadString(Skinname, ONPRESSEDTOP.cropname, '0,0,0,0,clblack'));
            cropparse(ONPRESSEDBOTTOM, ReadString(Skinname, ONPRESSEDBOTTOM.cropname, '0,0,0,0,clblack'));
            cropparse(ONPRESSED, ReadString(Skinname, ONPRESSED.cropname, '0,0,0,0,clblack'));

            cropparse(ONNORMALLEFT, ReadString(Skinname, ONNORMALLEFT.cropname, '0,0,0,0,clblack'));
            cropparse(ONNORMALRIGHT, ReadString(Skinname, ONNORMALRIGHT.cropname, '0,0,0,0,clblack'));
            cropparse(ONNORMALTOP, ReadString(Skinname, ONNORMALTOP.cropname, '0,0,0,0,clblack'));
            cropparse(ONNORMALBOTTOM, ReadString(Skinname, ONNORMALBOTTOM.cropname, '0,0,0,0,clblack'));
            cropparse(ONNORMAL, ReadString(Skinname, ONNORMAL.cropname, '0,0,0,0,clblack'));



         {
            cropparse(ONDISABLE, ReadString(Skinname{'button'},
              ONDISABLE.cropname, '0,0,0,0,clblack'));
            cropparse(ONNORMAL, ReadString(Skinname{'button'},
              ONNORMAL.cropname, '0,0,0,0,clblack'));
            cropparse(ONHOVER, ReadString(Skinname{'button'},
              ONHOVER.cropname, '0,0,0,0,clblack'));
            cropparse(ONPRESSED, ReadString(Skinname{'button'},
              ONPRESSED.cropname, '0,0,0,0,clblack')); }
          end;

        if (fparent.Components[i] is TONlabel) and
          (TONlabel(fparent.Components[i]).Skindata = Self) then   // if component GraphicButton
          with (TONlabel(fparent.Components[i])) do
          begin
            cropparse(ONCLIENT, ReadString(Skinname{'button'},
              ONCLIENT.cropname, '0,0,0,0,clblack'));
          end;



        if (fparent.Components[i] is TONKnob) and
          (TONKnob(fparent.Components[i]).Skindata = Self) then   // if component GraphicButton
          with (TONKnob(fparent.Components[i])) do
          begin
            cropparse(ONBUTTONNRML, ReadString(Skinname{'button'},
              ONBUTTONNRML.cropname, '0,0,0,0,clblack'));
            cropparse(ONBUTTONHOVR, ReadString(Skinname{'button'},
            ONBUTTONHOVR.cropname, '0,0,0,0,clblack'));
          cropparse(ONBUTTONDOWN, ReadString(Skinname{'button'},
            ONBUTTONDOWN.cropname, '0,0,0,0,clblack'));
          cropparse(ONBUTTONDSBL, ReadString(Skinname{'button'},
            ONBUTTONDSBL.cropname, '0,0,0,0,clblack'));

          cropparse(ONTOPLEFT, ReadString(Skinname{'panel'},
            ONTOPLEFT.cropname, '0,0,0,0,clblack'));
          cropparse(ONTOPRIGHT, ReadString(Skinname{'panel'},
            ONTOPRIGHT.cropname, '0,0,0,0,clblack'));
          cropparse(ONTOP, ReadString(Skinname{'panel'}, ONTOP.cropname,
            '0,0,0,0,clblack'));
          cropparse(ONBOTTOMLEFT, ReadString(Skinname{'panel'},
            ONBOTTOMLEFT.cropname, '0,0,0,0,clblack'));
          cropparse(ONBOTTOMRIGHT, ReadString(Skinname{'panel'},
            ONBOTTOMRIGHT.cropname, '0,0,0,0,clblack'));
          cropparse(ONBOTTOM, ReadString(Skinname{'panel'}, ONBOTTOM.cropname,
            '0,0,0,0,clblack'));
          cropparse(ONLEFT, ReadString(Skinname{'panel'}, ONLEFT.cropname,
            '0,0,0,0,clblack'));
          cropparse(ONRIGHT, ReadString(Skinname{'panel'}, ONRIGHT.cropname,
            '0,0,0,0,clblack'));
          cropparse(ONCENTER, ReadString(Skinname{'panel'}, ONCENTER.cropname,
            '0,0,0,0,clblack'));


          end;


        if (fparent.Components[i] is TONLed) and
          (TONLed(fparent.Components[i]).Skindata = Self) then   // if component GraphicButton
          with (TONLed(fparent.Components[i])) do
          begin
            cropparse(ONLEDONNORMAL, ReadString(Skinname{'button'},
              ONLEDONNORMAL.cropname, '0,0,0,0,clblack'));
            cropparse(ONLEDONHOVER, ReadString(Skinname{'button'},
              ONLEDONHOVER.cropname, '0,0,0,0,clblack'));
            cropparse(ONLEDOFFNORMAL, ReadString(Skinname{'button'},
              ONLEDOFFNORMAL.cropname, '0,0,0,0,clblack'));
            cropparse(ONLEDOFFHOVER, ReadString(Skinname{'button'},
              ONLEDOFFHOVER.cropname, '0,0,0,0,clblack'));
            cropparse(ONDISABLED, ReadString(Skinname{'button'},
              ONDISABLED.cropname, '0,0,0,0,clblack'));
          end;

        if (fparent.Components[i] is TONCropButton) and
          (TONCropButton(fparent.Components[i]).Skindata = Self) then   // if component CropButton
          with (TONCropButton(fparent.Components[i])) do
          begin
            cropparse(ONDISABLELEFT, ReadString(Skinname, ONDISABLELEFT.cropname, '0,0,0,0,clblack'));
            cropparse(ONDISABLERIGHT, ReadString(Skinname, ONDISABLERIGHT.cropname, '0,0,0,0,clblack'));
            cropparse(ONDISABLETOP, ReadString(Skinname, ONDISABLETOP.cropname, '0,0,0,0,clblack'));
            cropparse(ONDISABLEBOTTOM, ReadString(Skinname, ONDISABLEBOTTOM.cropname, '0,0,0,0,clblack'));
            cropparse(ONDISABLE, ReadString(Skinname, ONDISABLE.cropname, '0,0,0,0,clblack'));

            cropparse(ONHOVERLEFT, ReadString(Skinname, ONHOVERLEFT.cropname, '0,0,0,0,clblack'));
            cropparse(ONHOVERRIGHT, ReadString(Skinname, ONHOVERRIGHT.cropname, '0,0,0,0,clblack'));
            cropparse(ONHOVERTOP, ReadString(Skinname, ONHOVERTOP.cropname, '0,0,0,0,clblack'));
            cropparse(ONHOVERBOTTOM, ReadString(Skinname, ONHOVERBOTTOM.cropname, '0,0,0,0,clblack'));
            cropparse(ONHOVER, ReadString(Skinname, ONHOVER.cropname, '0,0,0,0,clblack'));

            cropparse(ONPRESSEDLEFT, ReadString(Skinname, ONPRESSEDLEFT.cropname, '0,0,0,0,clblack'));
            cropparse(ONPRESSEDRIGHT, ReadString(Skinname, ONPRESSEDRIGHT.cropname, '0,0,0,0,clblack'));
            cropparse(ONPRESSEDTOP, ReadString(Skinname, ONPRESSEDTOP.cropname, '0,0,0,0,clblack'));
            cropparse(ONPRESSEDBOTTOM, ReadString(Skinname, ONPRESSEDBOTTOM.cropname, '0,0,0,0,clblack'));
            cropparse(ONPRESSED, ReadString(Skinname, ONPRESSED.cropname, '0,0,0,0,clblack'));

            cropparse(ONNORMALLEFT, ReadString(Skinname, ONNORMALLEFT.cropname, '0,0,0,0,clblack'));
            cropparse(ONNORMALRIGHT, ReadString(Skinname, ONNORMALRIGHT.cropname, '0,0,0,0,clblack'));
            cropparse(ONNORMALTOP, ReadString(Skinname, ONNORMALTOP.cropname, '0,0,0,0,clblack'));
            cropparse(ONNORMALBOTTOM, ReadString(Skinname, ONNORMALBOTTOM.cropname, '0,0,0,0,clblack'));
            cropparse(ONNORMAL, ReadString(Skinname, ONNORMAL.cropname, '0,0,0,0,clblack'));

            {cropparse(ONDISABLE, ReadString(Skinname{'button'},
              ONDISABLE.cropname, '0,0,0,0,clblack'));
            cropparse(ONNORMAL, ReadString(Skinname{'button'},
              ONNORMAL.cropname, '0,0,0,0,clblack'));
            cropparse(ONHOVER, ReadString(Skinname{'button'},
              ONHOVER.cropname, '0,0,0,0,clblack'));
            cropparse(ONPRESSED, ReadString(Skinname{'button'},
              ONPRESSED.cropname, '0,0,0,0,clblack')); }
          end;

        if (fparent.Components[i] is TONPanel) and
          (TONPanel(fparent.Components[i]).Skindata = Self) then    // if component Panel
          with (TONPanel(fparent.Components[i])) do
          begin
            cropparse(ONTOPLEFT, ReadString(Skinname{'panel'},
              ONTOPLEFT.cropname, '0,0,0,0,clblack'));
            cropparse(ONTOPRIGHT, ReadString(Skinname{'panel'},
              ONTOPRIGHT.cropname, '0,0,0,0,clblack'));
            cropparse(ONTOP, ReadString(Skinname{'panel'},
              ONTOP.cropname, '0,0,0,0,clblack'));
            cropparse(ONBOTTOMLEFT, ReadString(Skinname{'panel'},
              ONBOTTOMLEFT.cropname, '0,0,0,0,clblack'));
            cropparse(ONBOTTOMRIGHT, ReadString(
              Skinname{'panel'}, ONBOTTOMRIGHT.cropname, '0,0,0,0,clblack'));
            cropparse(ONBOTTOM, ReadString(Skinname{'panel'},
              ONBOTTOM.cropname, '0,0,0,0,clblack'));
            cropparse(ONLEFT, ReadString(Skinname{'panel'},
              ONLEFT.cropname, '0,0,0,0,clblack'));
            cropparse(ONRIGHT, ReadString(Skinname{'panel'},
              ONRIGHT.cropname, '0,0,0,0,clblack'));
            cropparse(ONCENTER, ReadString(Skinname{'panel'},
              ONCENTER.cropname, '0,0,0,0,clblack'));
          end;

        if (fparent.Components[i] is TONCollapExpandPanel) and
          (TONCollapExpandPanel(fparent.Components[i]).Skindata = Self) then
          // if component CollapsedExpandedPanel
          with (TONCollapExpandPanel(fparent.Components[i])) do
          begin
            cropparse(ONTOPLEFT, ReadString(
              Skinname{'expandpanel'}, ONTOPLEFT.cropname, '0,0,0,0,clblack'));
            cropparse(ONTOPRIGHT, ReadString(
              Skinname{'expandpanel'}, ONTOPRIGHT.cropname, '0,0,0,0,clblack'));
            cropparse(ONTOP, ReadString(Skinname{'expandpanel'},
              ONTOP.cropname, '0,0,0,0,clblack'));
            cropparse(ONBOTTOMLEFT, ReadString(
              Skinname{'expandpanel'}, ONBOTTOMLEFT.cropname, '0,0,0,0,clblack'));
            cropparse(ONBOTTOMRIGHT, ReadString(
              Skinname{'expandpanel'}, ONBOTTOMRIGHT.cropname, '0,0,0,0,clblack'));
            cropparse(ONBOTTOM, ReadString(Skinname{'expandpanel'},
              ONBOTTOM.cropname, '0,0,0,0,clblack'));
            cropparse(ONLEFT, ReadString(Skinname{'expandpanel'},
              ONLEFT.cropname, '0,0,0,0,clblack'));
            cropparse(ONRIGHT, ReadString(Skinname{'expandpanel'},
              ONRIGHT.cropname, '0,0,0,0,clblack'));
            cropparse(ONCENTER, ReadString(Skinname{'expandpanel'},
              ONCENTER.cropname, '0,0,0,0,clblack'));
            cropparse(ONNORMAL, ReadString(Skinname{'expandpanel'},
              ONNORMAL.cropname, '0,0,0,0,clblack'));
            cropparse(ONHOVER, ReadString(Skinname{'expandpanel'},
              ONHOVER.cropname, '0,0,0,0,clblack'));
            cropparse(ONPRESSED, ReadString(
              Skinname{'expandpanel'}, ONPRESSED.cropname, '0,0,0,0,clblack'));
            cropparse(ONDISABLE, ReadString(
              Skinname{'expandpanel'}, ONDISABLE.cropname, '0,0,0,0,clblack'));

            cropparse(ONCAPTION, ReadString(
              Skinname{'expandpanel'}, ONCAPTION.cropname, '0,0,0,0,clblack'));

          end;

        if (fparent.Components[i] is TonEdit) and
          (TonEdit(fparent.Components[i]).Skindata = Self) then    // if component Edit
          with (TonEdit(fparent.Components[i])) do
          begin
            cropparse(ONTOPLEFT, ReadString(Skinname{'edit'},
              ONTOPLEFT.cropname, '0,0,0,0,clblack'));
            cropparse(ONTOPRIGHT, ReadString(Skinname{'edit'},
              ONTOPRIGHT.cropname, '0,0,0,0,clblack'));
            cropparse(ONTOP, ReadString(Skinname{'edit'}, ONTOP.cropname,
              '0,0,0,0,clblack'));
            cropparse(ONBOTTOMLEFT, ReadString(Skinname{'edit'},
              ONBOTTOMLEFT.cropname, '0,0,0,0,clblack'));
            cropparse(ONBOTTOMRIGHT, ReadString(
              Skinname{'edit'}, ONBOTTOMRIGHT.cropname, '0,0,0,0,clblack'));
            cropparse(ONBOTTOM, ReadString(
              Skinname{'edit'}, ONBOTTOM.cropname, '0,0,0,0,clblack'));
            cropparse(ONLEFT, ReadString(Skinname{'edit'},
              ONLEFT.cropname, '0,0,0,0,clblack'));
            cropparse(ONRIGHT, ReadString(Skinname{'edit'},
              ONRIGHT.cropname, '0,0,0,0,clblack'));
            cropparse(ONCENTER, ReadString(
              Skinname{'edit'}, ONCENTER.cropname, '0,0,0,0,clblack'));
          end;




        if (fparent.Components[i] is TOnSpinEdit) and
          (TOnSpinEdit(fparent.Components[i]).Skindata = Self) then  // if component SpinEdit
          with (TOnSpinEdit(fparent.Components[i])) do
          begin
            cropparse(ONTOPLEFT, ReadString(
              Skinname, ONTOPLEFT.cropname, '0,0,0,0,clblack'));
            cropparse(ONTOPRIGHT, ReadString(
              Skinname, ONTOPRIGHT.cropname, '0,0,0,0,clblack'));
            cropparse(ONTOP, ReadString(Skinname, ONTOP.cropname, '0,0,0,0,clblack'));
            cropparse(ONBOTTOMLEFT, ReadString(
              Skinname, ONBOTTOMLEFT.cropname, '0,0,0,0,clblack'));
            cropparse(ONBOTTOMRIGHT, ReadString(
              Skinname, ONBOTTOMRIGHT.cropname, '0,0,0,0,clblack'));
            cropparse(ONBOTTOM, ReadString(
              Skinname, ONBOTTOM.cropname, '0,0,0,0,clblack'));
            cropparse(ONLEFT, ReadString(Skinname, ONLEFT.cropname, '0,0,0,0,clblack'));
            cropparse(ONRIGHT, ReadString(Skinname, ONRIGHT.cropname,
              '0,0,0,0,clblack'));
            cropparse(ONCENTER, ReadString(
              Skinname, ONCENTER.cropname, '0,0,0,0,clblack'));
            cropparse(ONUPBUTONNORMAL, ReadString(
              Skinname, ONUPBUTONNORMAL.cropname, '0,0,0,0,clblack'));
            cropparse(ONUPBUTONPRESS, ReadString(
              Skinname, ONUPBUTONPRESS.cropname, '0,0,0,0,clblack'));
            cropparse(ONUPBUTONHOVER, ReadString(
              Skinname, ONUPBUTONHOVER.cropname, '0,0,0,0,clblack'));
            cropparse(ONUPBUTONDISABLE, ReadString(
              Skinname, ONUPBUTONDISABLE.cropname, '0,0,0,0,clblack'));
            cropparse(ONDOWNBUTONNORMAL, ReadString(
              Skinname, ONDOWNBUTONNORMAL.cropname, '0,0,0,0,clblack'));
            cropparse(ONDOWNBUTONPRESS, ReadString(
              Skinname, ONDOWNBUTONPRESS.cropname, '0,0,0,0,clblack'));
            cropparse(ONDOWNBUTONHOVER, ReadString(
              Skinname, ONDOWNBUTONHOVER.cropname, '0,0,0,0,clblack'));
            cropparse(ONDOWNBUTONDISABLE, ReadString(
              Skinname, ONDOWNBUTONDISABLE.cropname, '0,0,0,0,clblack'));
          end;

        if (fparent.Components[i] is TONMemo) and
          (TONMemo(fparent.Components[i]).Skindata = Self) then  // if component Memo
          with (TONMemo(fparent.Components[i])) do
          begin
            cropparse(ONTOPLEFT, ReadString(
              Skinname, ONTOPLEFT.cropname, '0,0,0,0,clblack'));
            cropparse(ONTOPRIGHT, ReadString(
              Skinname, ONTOPRIGHT.cropname, '0,0,0,0,clblack'));
            cropparse(ONTOP, ReadString(Skinname, ONTOP.cropname, '0,0,0,0,clblack'));
            cropparse(ONBOTTOMLEFT, ReadString(
              Skinname, ONBOTTOMLEFT.cropname, '0,0,0,0,clblack'));
            cropparse(ONBOTTOMRIGHT, ReadString(
              Skinname, ONBOTTOMRIGHT.cropname, '0,0,0,0,clblack'));
            cropparse(ONBOTTOM, ReadString(
              Skinname, ONBOTTOM.cropname, '0,0,0,0,clblack'));
            cropparse(ONLEFT, ReadString(Skinname, ONLEFT.cropname, '0,0,0,0,clblack'));
            cropparse(ONRIGHT, ReadString(Skinname, ONRIGHT.cropname,
              '0,0,0,0,clblack'));
            cropparse(ONCENTER, ReadString(
              Skinname, ONCENTER.cropname, '0,0,0,0,clblack'));
          end;

        if (fparent.Components[i] is TONcombobox) and
          (TONcombobox(fparent.Components[i]).Skindata = Self) then  // if component Combobox
          with (TONcombobox(fparent.Components[i])) do
          begin
            cropparse(ONTOPLEFT, ReadString(Skinname{'combobox'},
              ONTOPLEFT.cropname, '0,0,0,0,clblack'));
            cropparse(ONTOPRIGHT, ReadString(Skinname{'combobox'},
              ONTOPRIGHT.cropname, '0,0,0,0,clblack'));
            cropparse(ONTOP, ReadString(Skinname{'combobox'},
              ONTOP.cropname, '0,0,0,0,clblack'));
            cropparse(ONBOTTOMLEFT, ReadString(
              Skinname{'combobox'}, ONBOTTOMLEFT.cropname, '0,0,0,0,clblack'));
            cropparse(ONBOTTOMRIGHT, ReadString(
              Skinname{'combobox'}, ONBOTTOMRIGHT.cropname, '0,0,0,0,clblack'));
            cropparse(ONBOTTOM, ReadString(Skinname{'combobox'},
              ONBOTTOM.cropname, '0,0,0,0,clblack'));
            cropparse(ONLEFT, ReadString(Skinname{'combobox'},
              ONLEFT.cropname, '0,0,0,0,clblack'));
            cropparse(ONRIGHT, ReadString(Skinname{'combobox'},
              ONRIGHT.cropname, '0,0,0,0,clblack'));
            cropparse(ONCENTER, ReadString(Skinname{'combobox'},
              ONCENTER.cropname, '0,0,0,0,clblack'));
            cropparse(ONBUTONNORMAL, ReadString(
              Skinname{'combobox'}, ONBUTONNORMAL.cropname, '0,0,0,0,clblack'));
            cropparse(ONBUTONPRESS, ReadString(
              Skinname{'combobox'}, ONBUTONPRESS.cropname, '0,0,0,0,clblack'));
            cropparse(ONBUTONHOVER, ReadString(
              Skinname{'combobox'}, ONBUTONHOVER.cropname, '0,0,0,0,clblack'));
            cropparse(ONBUTONDISABLE, ReadString(
              Skinname{'combobox'}, ONBUTONDISABLE.cropname, '0,0,0,0,clblack'));
          end;


        if (fparent.Components[i] is TOnSwich) and
          (TOnSwich(fparent.Components[i]).Skindata = Self) then
          with (TOnSwich(fparent.Components[i])) do
          begin
            cropparse(ONOPEN, ReadString(Skinname, ONOPEN.cropname, '0,0,0,0,clblack'));
            cropparse(ONOPENHOVER, ReadString(
              Skinname, ONOPENHOVER.cropname, '0,0,0,0,clblack'));
            cropparse(ONCLOSE, ReadString(Skinname, ONCLOSE.cropname,
              '0,0,0,0,clblack'));
            cropparse(ONCLOSEHOVER, ReadString(
              Skinname, ONCLOSEHOVER.cropname, '0,0,0,0,clblack'));
            cropparse(ONDISABLE, ReadString(
              Skinname, ONDISABLE.cropname, '0,0,0,0,clblack'));
          end;


        if (fparent.Components[i] is TOnCheckbox) and
          (TOnCheckbox(fparent.Components[i]).Skindata = Self) then
          with (TOnCheckbox(fparent.Components[i])) do
          begin
            cropparse(ONNORMAL, ReadString(
              Skinname, ONNORMAL.cropname, '0,0,0,0,clblack'));
            cropparse(ONNORMALDOWN, ReadString(
              Skinname, ONNORMALDOWN.cropname, '0,0,0,0,clblack'));
            cropparse(ONNORMALHOVER, ReadString(
              Skinname, ONNORMALHOVER.cropname, '0,0,0,0,clblack'));
            cropparse(ONCHECKED, ReadString(
              Skinname, ONCHECKED.cropname, '0,0,0,0,clblack'));
            cropparse(ONCHECKEDHOVER, ReadString(
              Skinname, ONCHECKEDHOVER.cropname, '0,0,0,0,clblack'));
            cropparse(ONDISABLE, ReadString(
              Skinname, ONDISABLE.cropname, '0,0,0,0,clblack'));
          end;


        if (fparent.Components[i] is TOnRadioButton) and
          (TOnRadioButton(fparent.Components[i]).Skindata = Self) then
          with (TOnRadioButton(fparent.Components[i])) do
          begin
            cropparse(ONNORMAL, ReadString(
              Skinname, ONNORMAL.cropname, '0,0,0,0,clblack'));
            cropparse(ONNORMALDOWN, ReadString(
              Skinname, ONNORMALDOWN.cropname, '0,0,0,0,clblack'));
            cropparse(ONNORMALHOVER, ReadString(
              Skinname, ONNORMALHOVER.cropname, '0,0,0,0,clblack'));
            cropparse(ONCHECKED, ReadString(
              Skinname, ONCHECKED.cropname, '0,0,0,0,clblack'));
            cropparse(ONCHECKEDHOVER, ReadString(
              Skinname, ONCHECKEDHOVER.cropname, '0,0,0,0,clblack'));
            cropparse(ONDISABLE, ReadString(
              Skinname, ONDISABLE.cropname, '0,0,0,0,clblack'));
          end;



        if (fparent.Components[i] is TONProgressBar) and
          (TONProgressBar(fparent.Components[i]).Skindata = Self) then
          with (TONProgressBar(fparent.Components[i])) do
          begin
            //     if Kind=oHorizontal then
            //     begin
            //        cropparse(ONLEFT_TOP,ReadString(Skinname,ONLEFT.cropname,'0,0,0,0,clblack'));
            //       cropparse(ONRIGHT_BOTTOM,ReadString(Skinname,ONRIGHT.cropname,'0,0,0,0,clblack'));
            //      end else
            //      begin
            cropparse(ONLEFT_TOP, ReadString(
              Skinname, ONLEFT_TOP.cropname, '0,0,0,0,clblack'));
            cropparse(ONRIGHT_BOTTOM, ReadString(
              Skinname, ONRIGHT_BOTTOM.cropname, '0,0,0,0,clblack'));
            //      end;
            cropparse(ONCENTER, ReadString(
              Skinname, ONCENTER.cropname, '0,0,0,0,clblack'));

            cropparse(ONTOP, ReadString(Skinname, ONTOP.cropname, '0,0,0,0,clblack'));
            cropparse(ONBOTTOM, ReadString(Skinname, ONBOTTOM.cropname, '0,0,0,0,clblack'));

            cropparse(ONBAR, ReadString(Skinname, ONBAR.cropname, '0,0,0,0,clblack'));
            //  end;
          end;


        if (fparent.Components[i] is TONTrackBar) and
          (TONTrackBar(fparent.Components[i]).Skindata = Self) then
          with (TONTrackBar(fparent.Components[i])) do
          begin
            cropparse(ONLEFT, ReadString(Skinname, ONLEFT.cropname, '0,0,0,0,clblack'));
            cropparse(ONRIGHT, ReadString(Skinname, ONRIGHT.cropname,
              '0,0,0,0,clblack'));
            cropparse(ONCENTER, ReadString(
              Skinname, ONCENTER.cropname, '0,0,0,0,clblack'));
            cropparse(ONBUTONNORMAL, ReadString(
              Skinname, ONBUTONNORMAL.cropname, '0,0,0,0,clblack'));
            cropparse(ONBUTONHOVER, ReadString(
              Skinname, ONBUTONHOVER.cropname, '0,0,0,0,clblack'));
            cropparse(ONBUTONPRESS, ReadString(
              Skinname, ONBUTONPRESS.cropname, '0,0,0,0,clblack'));
            cropparse(ONBUTONDISABLE, ReadString(
              Skinname, ONBUTONDISABLE.cropname, '0,0,0,0,clblack'));
          end;



        if (fparent.Components[i] is ToNScrollBar) and
          (ToNScrollBar(fparent.Components[i]).Skindata = Self) then
          with (ToNScrollBar(fparent.Components[i])) do
          begin
            cropparse(ONTOP, ReadString(Skinname, ONTOP.cropname,
              '256,291,299,271,clblack'));
            cropparse(ONBOTTOM, ReadString(
              Skinname, ONBOTTOM.cropname, '256,299,306,272,clblack'));

            cropparse(ONNORMAL, ReadString(
              Skinname, ONNORMAL.cropname, '0,0,0,0,clblack'));
            cropparse(ONBAR, ReadString(Skinname, ONBAR.cropname, '0,0,0,0,clblack'));
            cropparse(ONCENTERBUTNORMAL, ReadString(
              Skinname, ONCENTERBUTNORMAL.cropname, '0,0,0,0,clblack'));
            cropparse(ONCENTERBUTONHOVER, ReadString(
              Skinname, ONCENTERBUTONHOVER.cropname, '0,0,0,0,clblack'));
            cropparse(ONCENTERBUTPRESS, ReadString(
              Skinname, ONCENTERBUTPRESS.cropname, '0,0,0,0,clblack'));
            cropparse(ONCENTERBUTDISABLE, ReadString(
              Skinname, ONCENTERBUTDISABLE.cropname, '0,0,0,0,clblack'));
            cropparse(ONLEFTBUTNORMAL, ReadString(
              Skinname, ONLEFTBUTNORMAL.cropname, '0,0,0,0,clblack'));
            cropparse(ONLEFTBUTONHOVER, ReadString(
              Skinname, ONLEFTBUTONHOVER.cropname, '0,0,0,0,clblack'));
            cropparse(ONLEFTBUTPRESS, ReadString(
              Skinname, ONLEFTBUTPRESS.cropname, '0,0,0,0,clblack'));
            cropparse(ONLEFTBUTDISABLE, ReadString(
              Skinname, ONLEFTBUTDISABLE.cropname, '0,0,0,0,clblack'));
            cropparse(ONRIGHTBUTNORMAL, ReadString(
              Skinname, ONRIGHTBUTNORMAL.cropname, '0,0,0,0,clblack'));
            cropparse(ONRIGHTBUTONHOVER, ReadString(
              Skinname, ONRIGHTBUTONHOVER.cropname, '0,0,0,0,clblack'));
            cropparse(ONRIGHTBUTPRESS, ReadString(
              Skinname, ONRIGHTBUTPRESS.cropname, '0,0,0,0,clblack'));
            cropparse(ONRIGHTBUTDISABLE, ReadString(
              Skinname, ONRIGHTBUTDISABLE.cropname, '0,0,0,0,clblack'));
          end;

        if (fparent.Components[i] is TOncolumlist) and
          (TOncolumlist(fparent.Components[i]).Skindata = Self) then
          with (TOncolumlist(fparent.Components[i])) do
          begin
            cropparse(ONTOPLEFT, ReadString(Skinname{'listbox'},
              ONTOPLEFT.cropname, '0,0,0,0,clblack'));
            cropparse(ONTOPRIGHT, ReadString(Skinname{'listbox'},
              ONTOPRIGHT.cropname, '0,0,0,0,clblack'));
            cropparse(ONTOP, ReadString(Skinname{'listbox'},
              ONTOP.cropname, '0,0,0,0,clblack'));
            cropparse(ONBOTTOMLEFT, ReadString(
              Skinname{'listbox'}, ONBOTTOMLEFT.cropname, '0,0,0,0,clblack'));
            cropparse(ONBOTTOMRIGHT, ReadString(
              Skinname{'listbox'}, ONBOTTOMRIGHT.cropname, '0,0,0,0,clblack'));
            cropparse(ONBOTTOM, ReadString(Skinname{'listbox'},
              ONBOTTOM.cropname, '0,0,0,0,clblack'));
            cropparse(ONLEFT, ReadString(Skinname{'listbox'},
              ONLEFT.cropname, '0,0,0,0,clblack'));
            cropparse(ONRIGHT, ReadString(Skinname{'listbox'},
              ONRIGHT.cropname, '0,0,0,0,clblack'));
            cropparse(ONCENTER, ReadString(Skinname{'listbox'},
              ONCENTER.cropname, '0,0,0,0,clblack'));
            cropparse(ONACTIVEITEM, ReadString(
              Skinname{'listbox'}, ONACTIVEITEM.cropname, '0,0,0,0,clblack'));
            cropparse(ONHEADER, ReadString(Skinname{'listbox'},
              ONHEADER.cropname, '0,0,0,0,clblack'));
            cropparse(ONITEM, ReadString(Skinname{'listbox'},
              ONITEM.cropname, '0,0,0,0,clblack'));

          end;


        if (fparent.Components[i] is ToNListBox) and
          (ToNListBox(fparent.Components[i]).Skindata = Self) then
          with (ToNListBox(fparent.Components[i])) do
          begin
            cropparse(ONTOPLEFT, ReadString(Skinname{'listbox'},
              ONTOPLEFT.cropname, '0,0,0,0,clblack'));
            cropparse(ONTOPRIGHT, ReadString(Skinname{'listbox'},
              ONTOPRIGHT.cropname, '0,0,0,0,clblack'));
            cropparse(ONTOP, ReadString(Skinname{'listbox'},
              ONTOP.cropname, '0,0,0,0,clblack'));
            cropparse(ONBOTTOMLEFT, ReadString(
              Skinname{'listbox'}, ONBOTTOMLEFT.cropname, '0,0,0,0,clblack'));
            cropparse(ONBOTTOMRIGHT, ReadString(
              Skinname{'listbox'}, ONBOTTOMRIGHT.cropname, '0,0,0,0,clblack'));
            cropparse(ONBOTTOM, ReadString(Skinname{'listbox'},
              ONBOTTOM.cropname, '0,0,0,0,clblack'));
            cropparse(ONLEFT, ReadString(Skinname{'listbox'},
              ONLEFT.cropname, '0,0,0,0,clblack'));
            cropparse(ONRIGHT, ReadString(Skinname{'listbox'},
              ONRIGHT.cropname, '0,0,0,0,clblack'));
            cropparse(ONCENTER, ReadString(Skinname{'listbox'},
              ONCENTER.cropname, '0,0,0,0,clblack'));
            cropparse(ONACTIVEITEM, ReadString(
              Skinname{'listbox'}, ONACTIVEITEM.cropname, '0,0,0,0,clblack'));
            cropparse(ONITEM, ReadString(Skinname{'listbox'},
              ONITEM.cropname, '0,0,0,0,clblack'));
          end;

        if (fparent.Components[i] is TONHeaderPanel) and
          (TONHeaderPanel(fparent.Components[i]).Skindata = Self) then
          with (TONHeaderPanel(fparent.Components[i])) do
          begin
            cropparse(ONTOPLEFT, ReadString(
              Skinname{'headerpanel'}, ONTOPLEFT.cropname, '0,0,0,0,clblack'));
            cropparse(ONTOPRIGHT, ReadString(
              Skinname{'headerpanel'}, ONTOPRIGHT.cropname, '0,0,0,0,clblack'));
            cropparse(ONTOP, ReadString(Skinname{'headerpanel'},
              ONTOP.cropname, '0,0,0,0,clblack'));
            cropparse(ONBOTTOMLEFT, ReadString(
              Skinname{'headerpanel'}, ONBOTTOMLEFT.cropname, '0,0,0,0,clblack'));
            cropparse(ONBOTTOMRIGHT, ReadString(
              Skinname{'headerpanel'}, ONBOTTOMRIGHT.cropname, '0,0,0,0,clblack'));
            cropparse(ONBOTTOM, ReadString(Skinname{'headerpanel'},
              ONBOTTOM.cropname, '0,0,0,0,clblack'));
            cropparse(ONLEFT, ReadString(Skinname{'headerpanel'},
              ONLEFT.cropname, '0,0,0,0,clblack'));
            cropparse(ONRIGHT, ReadString(Skinname{'headerpanel'},
              ONRIGHT.cropname, '0,0,0,0,clblack'));
            cropparse(ONCENTER, ReadString(Skinname{'headerpanel'},
              ONCENTER.cropname, '0,0,0,0,clblack'));
          end;
      end;
    end;
    //   end;

  finally
    self.fparent.Invalidate;// Repaint;
    FreeAndNil(skn);
  end;

end;





procedure TONImg.Loadskin(FileName: string; const Resource: boolean);
var
  Res: TResourceStream;
//  VerOk: boolean;  // skin version control
  Dir: string;
  UnZipper: TUnZipper;
  i: integer;
  skn: Tinifile;
  onlistb:ToNListBox;
  onlistcol:TOncolumlist;
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


        CropToimg(Fimage); // for crop Tform

        Self.fparent.OnPaint := @pant;

      end;
      // Tform ok



      // Tform component reading
      for i := 0 to fparent.ComponentCount - 1 do
      begin


        if (fparent.Components[i] is TONPageControl) and
          (TONPageControl(fparent.Components[i]).Skindata = Self) then

          // if component PageControl
          with (TONPageControl(fparent.Components[i])) do
          begin
         cropparse(ONTOPLEFT, ReadString(Skinname,
            ONTOPLEFT.cropname, '0,0,0,0,clblack'));
          cropparse(ONTOPRIGHT, ReadString(Skinname,
            ONTOPRIGHT.cropname, '0,0,0,0,clblack'));
          cropparse(ONTOP, ReadString(Skinname, ONTOP.cropname,
            '0,0,0,0,clblack'));
          cropparse(ONBOTTOMLEFT, ReadString(Skinname,
            ONBOTTOMLEFT.cropname, '0,0,0,0,clblack'));
          cropparse(ONBOTTOMRIGHT, ReadString(Skinname,
            ONBOTTOMRIGHT.cropname, '0,0,0,0,clblack'));
          cropparse(fBOTTOM, ReadString(Skinname, ONBOTTOM.cropname,
            '0,0,0,0,clblack'));
          cropparse(ONLEFT, ReadString(Skinname, ONLEFT.cropname,
            '0,0,0,0,clblack'));
          cropparse(ONRIGHT, ReadString(Skinname, ONRIGHT.cropname,
            '0,0,0,0,clblack'));
          cropparse(ONCENTER, ReadString(Skinname, ONCENTER.cropname,
            '0,0,0,0,clblack'));
          cropparse(ONBUTTONAREA, ReadString(Skinname, ONBUTTONAREA.cropname,
            '0,0,0,0,clblack'));

         end;

         if (fparent.Components[i] is TONPage) and
          (TONPage(fparent.Components[i]).Skindata = Self) then
        with (TONPage(fparent.Components[i])) do
        begin
          cropparse(ONTOPLEFT, ReadString(Skinname{'panel'},
            ONTOPLEFT.cropname, '0,0,0,0,clblack'));
          cropparse(ONTOPRIGHT, ReadString(Skinname{'panel'},
            ONTOPRIGHT.cropname, '0,0,0,0,clblack'));
          cropparse(ONTOP, ReadString(Skinname{'panel'}, ONTOP.cropname,
            '0,0,0,0,clblack'));
          cropparse(ONBOTTOMLEFT, ReadString(Skinname{'panel'},
            ONBOTTOMLEFT.cropname, '0,0,0,0,clblack'));
          cropparse(ONBOTTOMRIGHT, ReadString(Skinname{'panel'},
            ONBOTTOMRIGHT.cropname, '0,0,0,0,clblack'));
          cropparse(ONBOTTOM, ReadString(Skinname{'panel'}, ONBOTTOM.cropname,
            '0,0,0,0,clblack'));
          cropparse(ONLEFT, ReadString(Skinname{'panel'}, ONLEFT.cropname,
            '0,0,0,0,clblack'));
          cropparse(ONRIGHT, ReadString(Skinname{'panel'}, ONRIGHT.cropname,
            '0,0,0,0,clblack'));
          cropparse(ONCENTER, ReadString(Skinname{'panel'}, ONCENTER.cropname,
            '0,0,0,0,clblack'));
        end;




      if (fparent.Components[i] is TonbuttonareaCntrl) and
          (TonbuttonareaCntrl(fparent.Components[i]).Skindata = Self) then
        with (TonbuttonareaCntrl(fparent.Components[i])) do
        begin
          cropparse(ONCLIENT, ReadString(Skinname{'panel'},
            ONCLIENT.cropname, '0,0,0,0,clblack'));
        end;


      if (fparent.Components[i] is TONPageButton) and
          (TONPageButton(fparent.Components[i]).Skindata = Self) then
        with (TONPageButton(fparent.Components[i])) do
        begin
          cropparse(ONENTER, ReadString(Skinname{'panel'},
            ONENTER.cropname, '0,0,0,0,clblack'));
          cropparse(ONNORMAL, ReadString(Skinname{'panel'},
            ONNORMAL.cropname, '0,0,0,0,clblack'));
          cropparse(ONPRESS, ReadString(Skinname{'panel'},
            ONPRESS.cropname, '0,0,0,0,clblack'));
          cropparse(ONDISABLE, ReadString(Skinname{'panel'},
            ONDISABLE.cropname, '0,0,0,0,clblack'));
        end;



        if (fparent.Components[i] is TONGraphicsButton) and
          (TONGraphicsButton(fparent.Components[i]).Skindata = Self) then
          // if component GraphicButton
          with (TONGraphicsButton(fparent.Components[i])) do
          begin
          cropparse(ONDISABLELEFT, ReadString(Skinname, ONDISABLELEFT.cropname, '0,0,0,0,clblack'));
            cropparse(ONDISABLERIGHT, ReadString(Skinname, ONDISABLERIGHT.cropname, '0,0,0,0,clblack'));
            cropparse(ONDISABLETOP, ReadString(Skinname, ONDISABLETOP.cropname, '0,0,0,0,clblack'));
            cropparse(ONDISABLEBOTTOM, ReadString(Skinname, ONDISABLEBOTTOM.cropname, '0,0,0,0,clblack'));
            cropparse(ONDISABLE, ReadString(Skinname, ONDISABLE.cropname, '0,0,0,0,clblack'));

            cropparse(ONHOVERLEFT, ReadString(Skinname, ONHOVERLEFT.cropname, '0,0,0,0,clblack'));
            cropparse(ONHOVERRIGHT, ReadString(Skinname, ONHOVERRIGHT.cropname, '0,0,0,0,clblack'));
            cropparse(ONHOVERTOP, ReadString(Skinname, ONHOVERTOP.cropname, '0,0,0,0,clblack'));
            cropparse(ONHOVERBOTTOM, ReadString(Skinname, ONHOVERBOTTOM.cropname, '0,0,0,0,clblack'));
            cropparse(ONHOVER, ReadString(Skinname, ONHOVER.cropname, '0,0,0,0,clblack'));

            cropparse(ONPRESSEDLEFT, ReadString(Skinname, ONPRESSEDLEFT.cropname, '0,0,0,0,clblack'));
            cropparse(ONPRESSEDRIGHT, ReadString(Skinname, ONPRESSEDRIGHT.cropname, '0,0,0,0,clblack'));
            cropparse(ONPRESSEDTOP, ReadString(Skinname, ONPRESSEDTOP.cropname, '0,0,0,0,clblack'));
            cropparse(ONPRESSEDBOTTOM, ReadString(Skinname, ONPRESSEDBOTTOM.cropname, '0,0,0,0,clblack'));
            cropparse(ONPRESSED, ReadString(Skinname, ONPRESSED.cropname, '0,0,0,0,clblack'));

            cropparse(ONNORMALLEFT, ReadString(Skinname, ONNORMALLEFT.cropname, '0,0,0,0,clblack'));
            cropparse(ONNORMALRIGHT, ReadString(Skinname, ONNORMALRIGHT.cropname, '0,0,0,0,clblack'));
            cropparse(ONNORMALTOP, ReadString(Skinname, ONNORMALTOP.cropname, '0,0,0,0,clblack'));
            cropparse(ONNORMALBOTTOM, ReadString(Skinname, ONNORMALBOTTOM.cropname, '0,0,0,0,clblack'));
            cropparse(ONNORMAL, ReadString(Skinname, ONNORMAL.cropname, '0,0,0,0,clblack'));



         {
            cropparse(ONDISABLE, ReadString(Skinname{'button'},
              ONDISABLE.cropname, '0,0,0,0,clblack'));
            cropparse(ONNORMAL, ReadString(Skinname{'button'},
              ONNORMAL.cropname, '0,0,0,0,clblack'));
            cropparse(ONHOVER, ReadString(Skinname{'button'},
              ONHOVER.cropname, '0,0,0,0,clblack'));
            cropparse(ONPRESSED, ReadString(Skinname{'button'},
              ONPRESSED.cropname, '0,0,0,0,clblack'));
            }
          end;

        if (fparent.Components[i] is TONlabel) and
          (TONlabel(fparent.Components[i]).Skindata = Self) then   // if component GraphicButton
          with (TONlabel(fparent.Components[i])) do
          begin
            cropparse(ONCLIENT, ReadString(Skinname{'button'},
              ONCLIENT.cropname, '0,0,0,0,clblack'));
          end;



       if (fparent.Components[i] is TONKnob) and
          (TONKnob(fparent.Components[i]).Skindata = Self) then   // if component GraphicButton
          with (TONKnob(fparent.Components[i])) do
          begin
           cropparse(ONBUTTONNRML, ReadString(Skinname{'button'},
            ONBUTTONNRML.cropname, '0,0,0,0,clblack'));
          cropparse(ONBUTTONHOVR, ReadString(Skinname{'button'},
            ONBUTTONHOVR.cropname, '0,0,0,0,clblack'));
          cropparse(ONBUTTONDOWN, ReadString(Skinname{'button'},
            ONBUTTONDOWN.cropname, '0,0,0,0,clblack'));
          cropparse(ONBUTTONDSBL, ReadString(Skinname{'button'},
            ONBUTTONDSBL.cropname, '0,0,0,0,clblack'));

          cropparse(ONTOPLEFT, ReadString(Skinname{'panel'},
            ONTOPLEFT.cropname, '0,0,0,0,clblack'));
          cropparse(ONTOPRIGHT, ReadString(Skinname{'panel'},
            ONTOPRIGHT.cropname, '0,0,0,0,clblack'));
          cropparse(ONTOP, ReadString(Skinname{'panel'}, ONTOP.cropname,
            '0,0,0,0,clblack'));
          cropparse(ONBOTTOMLEFT, ReadString(Skinname{'panel'},
            ONBOTTOMLEFT.cropname, '0,0,0,0,clblack'));
          cropparse(ONBOTTOMRIGHT, ReadString(Skinname{'panel'},
            ONBOTTOMRIGHT.cropname, '0,0,0,0,clblack'));
          cropparse(ONBOTTOM, ReadString(Skinname{'panel'}, ONBOTTOM.cropname,
            '0,0,0,0,clblack'));
          cropparse(ONLEFT, ReadString(Skinname{'panel'}, ONLEFT.cropname,
            '0,0,0,0,clblack'));
          cropparse(ONRIGHT, ReadString(Skinname{'panel'}, ONRIGHT.cropname,
            '0,0,0,0,clblack'));
          cropparse(ONCENTER, ReadString(Skinname{'panel'}, ONCENTER.cropname,
            '0,0,0,0,clblack'));
          end;







        if (fparent.Components[i] is TONLed) and
          (TONLed(fparent.Components[i]).Skindata = Self) then   // if component GraphicButton
          with (TONLed(fparent.Components[i])) do
          begin
            cropparse(ONLEDONNORMAL, ReadString(Skinname{'button'},
              ONLEDONNORMAL.cropname, '0,0,0,0,clblack'));
            cropparse(ONLEDONHOVER, ReadString(Skinname{'button'},
              ONLEDONHOVER.cropname, '0,0,0,0,clblack'));
            cropparse(ONLEDOFFNORMAL, ReadString(Skinname{'button'},
              ONLEDOFFNORMAL.cropname, '0,0,0,0,clblack'));
            cropparse(ONLEDOFFHOVER, ReadString(Skinname{'button'},
              ONLEDOFFHOVER.cropname, '0,0,0,0,clblack'));
            cropparse(ONDISABLED, ReadString(Skinname{'button'},
              ONDISABLED.cropname, '0,0,0,0,clblack'));
          end;

        if (fparent.Components[i] is TONCropButton) and
          (TONCropButton(fparent.Components[i]).Skindata = Self) then   // if component CropButton
          with (TONCropButton(fparent.Components[i])) do
          begin
           cropparse(ONDISABLELEFT, ReadString(Skinname, ONDISABLELEFT.cropname, '0,0,0,0,clblack'));
            cropparse(ONDISABLERIGHT, ReadString(Skinname, ONDISABLERIGHT.cropname, '0,0,0,0,clblack'));
            cropparse(ONDISABLETOP, ReadString(Skinname, ONDISABLETOP.cropname, '0,0,0,0,clblack'));
            cropparse(ONDISABLEBOTTOM, ReadString(Skinname, ONDISABLEBOTTOM.cropname, '0,0,0,0,clblack'));
            cropparse(ONDISABLE, ReadString(Skinname, ONDISABLE.cropname, '0,0,0,0,clblack'));

            cropparse(ONHOVERLEFT, ReadString(Skinname, ONHOVERLEFT.cropname, '0,0,0,0,clblack'));
            cropparse(ONHOVERRIGHT, ReadString(Skinname, ONHOVERRIGHT.cropname, '0,0,0,0,clblack'));
            cropparse(ONHOVERTOP, ReadString(Skinname, ONHOVERTOP.cropname, '0,0,0,0,clblack'));
            cropparse(ONHOVERBOTTOM, ReadString(Skinname, ONHOVERBOTTOM.cropname, '0,0,0,0,clblack'));
            cropparse(ONHOVER, ReadString(Skinname, ONHOVER.cropname, '0,0,0,0,clblack'));

            cropparse(ONPRESSEDLEFT, ReadString(Skinname, ONPRESSEDLEFT.cropname, '0,0,0,0,clblack'));
            cropparse(ONPRESSEDRIGHT, ReadString(Skinname, ONPRESSEDRIGHT.cropname, '0,0,0,0,clblack'));
            cropparse(ONPRESSEDTOP, ReadString(Skinname, ONPRESSEDTOP.cropname, '0,0,0,0,clblack'));
            cropparse(ONPRESSEDBOTTOM, ReadString(Skinname, ONPRESSEDBOTTOM.cropname, '0,0,0,0,clblack'));
            cropparse(ONPRESSED, ReadString(Skinname, ONPRESSED.cropname, '0,0,0,0,clblack'));

            cropparse(ONNORMALLEFT, ReadString(Skinname, ONNORMALLEFT.cropname, '0,0,0,0,clblack'));
            cropparse(ONNORMALRIGHT, ReadString(Skinname, ONNORMALRIGHT.cropname, '0,0,0,0,clblack'));
            cropparse(ONNORMALTOP, ReadString(Skinname, ONNORMALTOP.cropname, '0,0,0,0,clblack'));
            cropparse(ONNORMALBOTTOM, ReadString(Skinname, ONNORMALBOTTOM.cropname, '0,0,0,0,clblack'));
            cropparse(ONNORMAL, ReadString(Skinname, ONNORMAL.cropname, '0,0,0,0,clblack'));

         {   cropparse(ONDISABLE, ReadString(Skinname{'button'},
              ONDISABLE.cropname, '0,0,0,0,clblack'));
            cropparse(ONNORMAL, ReadString(Skinname{'button'},
              ONNORMAL.cropname, '0,0,0,0,clblack'));
            cropparse(ONHOVER, ReadString(Skinname{'button'},
              ONHOVER.cropname, '0,0,0,0,clblack'));
            cropparse(ONPRESSED, ReadString(Skinname{'button'},
              ONPRESSED.cropname, '0,0,0,0,clblack'));    }
          end;

        if (fparent.Components[i] is TONPanel) and
          (TONPanel(fparent.Components[i]).Skindata = Self) then    // if component Panel
          with (TONPanel(fparent.Components[i])) do
          begin
            cropparse(ONTOPLEFT, ReadString(Skinname{'panel'},
              ONTOPLEFT.cropname, '0,0,0,0,clblack'));
            cropparse(ONTOPRIGHT, ReadString(Skinname{'panel'},
              ONTOPRIGHT.cropname, '0,0,0,0,clblack'));
            cropparse(ONTOP, ReadString(Skinname{'panel'},
              ONTOP.cropname, '0,0,0,0,clblack'));
            cropparse(ONBOTTOMLEFT, ReadString(Skinname{'panel'},
              ONBOTTOMLEFT.cropname, '0,0,0,0,clblack'));
            cropparse(ONBOTTOMRIGHT, ReadString(
              Skinname{'panel'}, ONBOTTOMRIGHT.cropname, '0,0,0,0,clblack'));
            cropparse(ONBOTTOM, ReadString(Skinname{'panel'},
              ONBOTTOM.cropname, '0,0,0,0,clblack'));
            cropparse(ONLEFT, ReadString(Skinname{'panel'},
              ONLEFT.cropname, '0,0,0,0,clblack'));
            cropparse(ONRIGHT, ReadString(Skinname{'panel'},
              ONRIGHT.cropname, '0,0,0,0,clblack'));
            cropparse(ONCENTER, ReadString(Skinname{'panel'},
              ONCENTER.cropname, '0,0,0,0,clblack'));
          end;

        if (fparent.Components[i] is TONCollapExpandPanel) and
          (TONCollapExpandPanel(fparent.Components[i]).Skindata = Self) then
          // if component CollapsedExpandedPanel
          with (TONCollapExpandPanel(fparent.Components[i])) do
          begin
            cropparse(ONTOPLEFT, ReadString(
              Skinname{'expandpanel'}, ONTOPLEFT.cropname, '0,0,0,0,clblack'));
            cropparse(ONTOPRIGHT, ReadString(
              Skinname{'expandpanel'}, ONTOPRIGHT.cropname, '0,0,0,0,clblack'));
            cropparse(ONTOP, ReadString(Skinname{'expandpanel'},
              ONTOP.cropname, '0,0,0,0,clblack'));
            cropparse(ONBOTTOMLEFT, ReadString(
              Skinname{'expandpanel'}, ONBOTTOMLEFT.cropname, '0,0,0,0,clblack'));
            cropparse(ONBOTTOMRIGHT, ReadString(
              Skinname{'expandpanel'}, ONBOTTOMRIGHT.cropname, '0,0,0,0,clblack'));
            cropparse(ONBOTTOM, ReadString(Skinname{'expandpanel'},
              ONBOTTOM.cropname, '0,0,0,0,clblack'));
            cropparse(ONLEFT, ReadString(Skinname{'expandpanel'},
              ONLEFT.cropname, '0,0,0,0,clblack'));
            cropparse(ONRIGHT, ReadString(Skinname{'expandpanel'},
              ONRIGHT.cropname, '0,0,0,0,clblack'));
            cropparse(ONCENTER, ReadString(Skinname{'expandpanel'},
              ONCENTER.cropname, '0,0,0,0,clblack'));
            cropparse(ONNORMAL, ReadString(Skinname{'expandpanel'},
              ONNORMAL.cropname, '0,0,0,0,clblack'));
            cropparse(ONHOVER, ReadString(Skinname{'expandpanel'},
              ONHOVER.cropname, '0,0,0,0,clblack'));
            cropparse(ONPRESSED, ReadString(
              Skinname{'expandpanel'}, ONPRESSED.cropname, '0,0,0,0,clblack'));
            cropparse(ONDISABLE, ReadString(
              Skinname{'expandpanel'}, ONDISABLE.cropname, '0,0,0,0,clblack'));
            cropparse(ONCAPTION, ReadString(
              Skinname{'expandpanel'}, ONCAPTION.cropname, '0,0,0,0,clblack'));

          end;

        if (fparent.Components[i] is TonEdit) and
          (TonEdit(fparent.Components[i]).Skindata = Self) then    // if component Edit
          with (TonEdit(fparent.Components[i])) do
          begin
            cropparse(ONTOPLEFT, ReadString(Skinname{'edit'},
              ONTOPLEFT.cropname, '0,0,0,0,clblack'));
            cropparse(ONTOPRIGHT, ReadString(Skinname{'edit'},
              ONTOPRIGHT.cropname, '0,0,0,0,clblack'));
            cropparse(ONTOP, ReadString(Skinname{'edit'}, ONTOP.cropname,
              '0,0,0,0,clblack'));
            cropparse(ONBOTTOMLEFT, ReadString(Skinname{'edit'},
              ONBOTTOMLEFT.cropname, '0,0,0,0,clblack'));
            cropparse(ONBOTTOMRIGHT, ReadString(
              Skinname{'edit'}, ONBOTTOMRIGHT.cropname, '0,0,0,0,clblack'));
            cropparse(ONBOTTOM, ReadString(
              Skinname{'edit'}, ONBOTTOM.cropname, '0,0,0,0,clblack'));
            cropparse(ONLEFT, ReadString(Skinname{'edit'},
              ONLEFT.cropname, '0,0,0,0,clblack'));
            cropparse(ONRIGHT, ReadString(Skinname{'edit'},
              ONRIGHT.cropname, '0,0,0,0,clblack'));
            cropparse(ONCENTER, ReadString(
              Skinname{'edit'}, ONCENTER.cropname, '0,0,0,0,clblack'));
          end;

        if (fparent.Components[i] is TOnSpinEdit) and
          (TOnSpinEdit(fparent.Components[i]).Skindata = Self) then  // if component SpinEdit
          with (TOnSpinEdit(fparent.Components[i])) do
          begin
            cropparse(ONTOPLEFT, ReadString(
              Skinname, ONTOPLEFT.cropname, '0,0,0,0,clblack'));
            cropparse(ONTOPRIGHT, ReadString(
              Skinname, ONTOPRIGHT.cropname, '0,0,0,0,clblack'));
            cropparse(ONTOP, ReadString(Skinname, ONTOP.cropname, '0,0,0,0,clblack'));
            cropparse(ONBOTTOMLEFT, ReadString(
              Skinname, ONBOTTOMLEFT.cropname, '0,0,0,0,clblack'));
            cropparse(ONBOTTOMRIGHT, ReadString(
              Skinname, ONBOTTOMRIGHT.cropname, '0,0,0,0,clblack'));
            cropparse(ONBOTTOM, ReadString(
              Skinname, ONBOTTOM.cropname, '0,0,0,0,clblack'));
            cropparse(ONLEFT, ReadString(Skinname, ONLEFT.cropname, '0,0,0,0,clblack'));
            cropparse(ONRIGHT, ReadString(Skinname, ONRIGHT.cropname,
              '0,0,0,0,clblack'));
            cropparse(ONCENTER, ReadString(
              Skinname, ONCENTER.cropname, '0,0,0,0,clblack'));
            cropparse(ONUPBUTONNORMAL, ReadString(
              Skinname, ONUPBUTONNORMAL.cropname, '0,0,0,0,clblack'));
            cropparse(ONUPBUTONPRESS, ReadString(
              Skinname, ONUPBUTONPRESS.cropname, '0,0,0,0,clblack'));
            cropparse(ONUPBUTONHOVER, ReadString(
              Skinname, ONUPBUTONHOVER.cropname, '0,0,0,0,clblack'));
            cropparse(ONUPBUTONDISABLE, ReadString(
              Skinname, ONUPBUTONDISABLE.cropname, '0,0,0,0,clblack'));
            cropparse(ONDOWNBUTONNORMAL, ReadString(
              Skinname, ONDOWNBUTONNORMAL.cropname, '0,0,0,0,clblack'));
            cropparse(ONDOWNBUTONPRESS, ReadString(
              Skinname, ONDOWNBUTONPRESS.cropname, '0,0,0,0,clblack'));
            cropparse(ONDOWNBUTONHOVER, ReadString(
              Skinname, ONDOWNBUTONHOVER.cropname, '0,0,0,0,clblack'));
            cropparse(ONDOWNBUTONDISABLE, ReadString(
              Skinname, ONDOWNBUTONDISABLE.cropname, '0,0,0,0,clblack'));
          end;

        if (fparent.Components[i] is TONMemo) and
          (TONMemo(fparent.Components[i]).Skindata = Self) then  // if component Memo
          with (TONMemo(fparent.Components[i])) do
          begin
            cropparse(ONTOPLEFT, ReadString(
              Skinname, ONTOPLEFT.cropname, '0,0,0,0,clblack'));
            cropparse(ONTOPRIGHT, ReadString(
              Skinname, ONTOPRIGHT.cropname, '0,0,0,0,clblack'));
            cropparse(ONTOP, ReadString(Skinname, ONTOP.cropname, '0,0,0,0,clblack'));
            cropparse(ONBOTTOMLEFT, ReadString(
              Skinname, ONBOTTOMLEFT.cropname, '0,0,0,0,clblack'));
            cropparse(ONBOTTOMRIGHT, ReadString(
              Skinname, ONBOTTOMRIGHT.cropname, '0,0,0,0,clblack'));
            cropparse(ONBOTTOM, ReadString(
              Skinname, ONBOTTOM.cropname, '0,0,0,0,clblack'));
            cropparse(ONLEFT, ReadString(Skinname, ONLEFT.cropname, '0,0,0,0,clblack'));
            cropparse(ONRIGHT, ReadString(Skinname, ONRIGHT.cropname,
              '0,0,0,0,clblack'));
            cropparse(ONCENTER, ReadString(
              Skinname, ONCENTER.cropname, '0,0,0,0,clblack'));
          end;

        if (fparent.Components[i] is TONcombobox) and
          (TONcombobox(fparent.Components[i]).Skindata = Self) then  // if component Combobox
          with (TONcombobox(fparent.Components[i])) do
          begin
            cropparse(ONTOPLEFT, ReadString(Skinname{'combobox'},
              ONTOPLEFT.cropname, '0,0,0,0,clblack'));
            cropparse(ONTOPRIGHT, ReadString(Skinname{'combobox'},
              ONTOPRIGHT.cropname, '0,0,0,0,clblack'));
            cropparse(ONTOP, ReadString(Skinname{'combobox'},
              ONTOP.cropname, '0,0,0,0,clblack'));
            cropparse(ONBOTTOMLEFT, ReadString(
              Skinname{'combobox'}, ONBOTTOMLEFT.cropname, '0,0,0,0,clblack'));
            cropparse(ONBOTTOMRIGHT, ReadString(
              Skinname{'combobox'}, ONBOTTOMRIGHT.cropname, '0,0,0,0,clblack'));
            cropparse(ONBOTTOM, ReadString(Skinname{'combobox'},
              ONBOTTOM.cropname, '0,0,0,0,clblack'));
            cropparse(ONLEFT, ReadString(Skinname{'combobox'},
              ONLEFT.cropname, '0,0,0,0,clblack'));
            cropparse(ONRIGHT, ReadString(Skinname{'combobox'},
              ONRIGHT.cropname, '0,0,0,0,clblack'));
            cropparse(ONCENTER, ReadString(Skinname{'combobox'},
              ONCENTER.cropname, '0,0,0,0,clblack'));
            cropparse(ONBUTONNORMAL, ReadString(
              Skinname{'combobox'}, ONBUTONNORMAL.cropname, '0,0,0,0,clblack'));
            cropparse(ONBUTONPRESS, ReadString(
              Skinname{'combobox'}, ONBUTONPRESS.cropname, '0,0,0,0,clblack'));
            cropparse(ONBUTONHOVER, ReadString(
              Skinname{'combobox'}, ONBUTONHOVER.cropname, '0,0,0,0,clblack'));
            cropparse(ONBUTONDISABLE, ReadString(
              Skinname{'combobox'}, ONBUTONDISABLE.cropname, '0,0,0,0,clblack'));
          end;


        if (fparent.Components[i] is TOnSwich) and
          (TOnSwich(fparent.Components[i]).Skindata = Self) then
          with (TOnSwich(fparent.Components[i])) do
          begin
            cropparse(ONOPEN, ReadString(Skinname, ONOPEN.cropname, '0,0,0,0,clblack'));
            cropparse(ONOPENHOVER, ReadString(
              Skinname, ONOPENHOVER.cropname, '0,0,0,0,clblack'));
            cropparse(ONCLOSE, ReadString(Skinname, ONCLOSE.cropname,
              '0,0,0,0,clblack'));
            cropparse(ONCLOSEHOVER, ReadString(
              Skinname, ONCLOSEHOVER.cropname, '0,0,0,0,clblack'));
            cropparse(ONDISABLE, ReadString(
              Skinname, ONDISABLE.cropname, '0,0,0,0,clblack'));
          end;


        if (fparent.Components[i] is TOnCheckbox) and
          (TOnCheckbox(fparent.Components[i]).Skindata = Self) then
          with (TOnCheckbox(fparent.Components[i])) do
          begin
            cropparse(ONNORMAL, ReadString(
              Skinname, ONNORMAL.cropname, '0,0,0,0,clblack'));
            cropparse(ONNORMALDOWN, ReadString(
              Skinname, ONNORMALDOWN.cropname, '0,0,0,0,clblack'));
            cropparse(ONNORMALHOVER, ReadString(
              Skinname, ONNORMALHOVER.cropname, '0,0,0,0,clblack'));
            cropparse(ONCHECKED, ReadString(
              Skinname, ONCHECKED.cropname, '0,0,0,0,clblack'));
            cropparse(ONCHECKEDHOVER, ReadString(
              Skinname, ONCHECKEDHOVER.cropname, '0,0,0,0,clblack'));
            cropparse(ONDISABLE, ReadString(
              Skinname, ONDISABLE.cropname, '0,0,0,0,clblack'));
          end;


        if (fparent.Components[i] is TOnRadioButton) and
          (TOnRadioButton(fparent.Components[i]).Skindata = Self) then
          with (TOnRadioButton(fparent.Components[i])) do
          begin
            cropparse(ONNORMAL, ReadString(
              Skinname, ONNORMAL.cropname, '0,0,0,0,clblack'));
            cropparse(ONNORMALDOWN, ReadString(
              Skinname, ONNORMALDOWN.cropname, '0,0,0,0,clblack'));
            cropparse(ONNORMALHOVER, ReadString(
              Skinname, ONNORMALHOVER.cropname, '0,0,0,0,clblack'));
            cropparse(ONCHECKED, ReadString(
              Skinname, ONCHECKED.cropname, '0,0,0,0,clblack'));
            cropparse(ONCHECKEDHOVER, ReadString(
              Skinname, ONCHECKEDHOVER.cropname, '0,0,0,0,clblack'));
            cropparse(ONDISABLE, ReadString(
              Skinname, ONDISABLE.cropname, '0,0,0,0,clblack'));
          end;



        if (fparent.Components[i] is TONProgressBar) and
          (TONProgressBar(fparent.Components[i]).Skindata = Self) then
          with (TONProgressBar(fparent.Components[i])) do
          begin
            //     if Kind=oHorizontal then
            //     begin
            //        cropparse(ONLEFT_TOP,ReadString(Skinname,ONLEFT.cropname,'0,0,0,0,clblack'));
            //       cropparse(ONRIGHT_BOTTOM,ReadString(Skinname,ONRIGHT.cropname,'0,0,0,0,clblack'));
            //      end else
            //      begin
            cropparse(ONLEFT_TOP, ReadString(
              Skinname, ONLEFT_TOP.cropname, '0,0,0,0,clblack'));
            cropparse(ONRIGHT_BOTTOM, ReadString(
              Skinname, ONRIGHT_BOTTOM.cropname, '0,0,0,0,clblack'));
            //      end;
            cropparse(ONCENTER, ReadString(
              Skinname, ONCENTER.cropname, '0,0,0,0,clblack'));
            cropparse(ONTOP, ReadString(Skinname, ONTOP.cropname, '0,0,0,0,clblack'));
            cropparse(ONBOTTOM, ReadString(Skinname, ONBOTTOM.cropname, '0,0,0,0,clblack'));

            cropparse(ONBAR, ReadString(Skinname, ONBAR.cropname, '0,0,0,0,clblack'));

            //  end;
          end;


        if (fparent.Components[i] is TONTrackBar) and
          (TONTrackBar(fparent.Components[i]).Skindata = Self) then
          with (TONTrackBar(fparent.Components[i])) do
          begin
            cropparse(ONLEFT, ReadString(Skinname, ONLEFT.cropname, '0,0,0,0,clblack'));
            cropparse(ONRIGHT, ReadString(Skinname, ONRIGHT.cropname,
              '0,0,0,0,clblack'));
            cropparse(ONCENTER, ReadString(
              Skinname, ONCENTER.cropname, '0,0,0,0,clblack'));
            cropparse(ONBUTONNORMAL, ReadString(
              Skinname, ONBUTONNORMAL.cropname, '0,0,0,0,clblack'));
            cropparse(ONBUTONHOVER, ReadString(
              Skinname, ONBUTONHOVER.cropname, '0,0,0,0,clblack'));
            cropparse(ONBUTONPRESS, ReadString(
              Skinname, ONBUTONPRESS.cropname, '0,0,0,0,clblack'));
            cropparse(ONBUTONDISABLE, ReadString(
              Skinname, ONBUTONDISABLE.cropname, '0,0,0,0,clblack'));
          end;



        if ((fparent.Components[i] is ToNScrollBar) and
          (ToNScrollBar(fparent.Components[i]).Skindata = Self))  then
       // or ( fparent.Components[i] is ToNListBox) or (fparent.Components[i] is TOncolumlist) then
          with (ToNScrollBar(fparent.Components[i])) do
          begin
            cropparse(ONTOP, ReadString(Skinname, ONTOP.cropname,
              '0,0,0,0,clblack'));
            cropparse(ONBOTTOM, ReadString(
              Skinname, ONBOTTOM.cropname, '0,0,0,0,clblack'));

            cropparse(ONNORMAL, ReadString(
              Skinname, ONNORMAL.cropname, '0,0,0,0,clblack'));
            cropparse(ONBAR, ReadString(Skinname, ONBAR.cropname, '0,0,0,0,clblack'));
            cropparse(ONCENTERBUTNORMAL, ReadString(
              Skinname, ONCENTERBUTNORMAL.cropname, '0,0,0,0,clblack'));
            cropparse(ONCENTERBUTONHOVER, ReadString(
              Skinname, ONCENTERBUTONHOVER.cropname, '0,0,0,0,clblack'));
            cropparse(ONCENTERBUTPRESS, ReadString(
              Skinname, ONCENTERBUTPRESS.cropname, '0,0,0,0,clblack'));
            cropparse(ONCENTERBUTDISABLE, ReadString(
              Skinname, ONCENTERBUTDISABLE.cropname, '0,0,0,0,clblack'));
            cropparse(ONLEFTBUTNORMAL, ReadString(
              Skinname, ONLEFTBUTNORMAL.cropname, '0,0,0,0,clblack'));
            cropparse(ONLEFTBUTONHOVER, ReadString(
              Skinname, ONLEFTBUTONHOVER.cropname, '0,0,0,0,clblack'));
            cropparse(ONLEFTBUTPRESS, ReadString(
              Skinname, ONLEFTBUTPRESS.cropname, '0,0,0,0,clblack'));
            cropparse(ONLEFTBUTDISABLE, ReadString(
              Skinname, ONLEFTBUTDISABLE.cropname, '0,0,0,0,clblack'));
            cropparse(ONRIGHTBUTNORMAL, ReadString(
              Skinname, ONRIGHTBUTNORMAL.cropname, '0,0,0,0,clblack'));
            cropparse(ONRIGHTBUTONHOVER, ReadString(
              Skinname, ONRIGHTBUTONHOVER.cropname, '0,0,0,0,clblack'));
            cropparse(ONRIGHTBUTPRESS, ReadString(
              Skinname, ONRIGHTBUTPRESS.cropname, '0,0,0,0,clblack'));
            cropparse(ONRIGHTBUTDISABLE, ReadString(
              Skinname, ONRIGHTBUTDISABLE.cropname, '0,0,0,0,clblack'));
          end;

        if (fparent.Components[i] is TOncolumlist) and
          (TOncolumlist(fparent.Components[i]).Skindata = Self) then
          with (TOncolumlist(fparent.Components[i])) do
          begin
            cropparse(ONTOPLEFT, ReadString(Skinname{'listbox'},
              ONTOPLEFT.cropname, '0,0,0,0,clblack'));
            cropparse(ONTOPRIGHT, ReadString(Skinname{'listbox'},
              ONTOPRIGHT.cropname, '0,0,0,0,clblack'));
            cropparse(ONTOP, ReadString(Skinname{'listbox'},
              ONTOP.cropname, '0,0,0,0,clblack'));
            cropparse(ONBOTTOMLEFT, ReadString(
              Skinname{'listbox'}, ONBOTTOMLEFT.cropname, '0,0,0,0,clblack'));
            cropparse(ONBOTTOMRIGHT, ReadString(
              Skinname{'listbox'}, ONBOTTOMRIGHT.cropname, '0,0,0,0,clblack'));
            cropparse(ONBOTTOM, ReadString(Skinname{'listbox'},
              ONBOTTOM.cropname, '0,0,0,0,clblack'));
            cropparse(ONLEFT, ReadString(Skinname{'listbox'},
              ONLEFT.cropname, '0,0,0,0,clblack'));
            cropparse(ONRIGHT, ReadString(Skinname{'listbox'},
              ONRIGHT.cropname, '0,0,0,0,clblack'));
            cropparse(ONCENTER, ReadString(Skinname{'listbox'},
              ONCENTER.cropname, '0,0,0,0,clblack'));
            cropparse(ONACTIVEITEM, ReadString(
              Skinname{'listbox'}, ONACTIVEITEM.cropname, '0,0,0,0,clblack'));
            cropparse(ONHEADER, ReadString(Skinname{'listbox'},
              ONHEADER.cropname, '0,0,0,0,clblack'));
            cropparse(ONITEM, ReadString(Skinname{'listbox'},
              ONITEM.cropname, '0,0,0,0,clblack'));
            ReadSkinsComp(HorizontalScroll);
            ReadSkinsComp(VertialScroll);

          end;


        if (fparent.Components[i] is ToNListBox) and
          (ToNListBox(fparent.Components[i]).Skindata = Self) then
          with (ToNListBox(fparent.Components[i])) do
          begin
            cropparse(ONTOPLEFT, ReadString(Skinname{'listbox'},
              ONTOPLEFT.cropname, '0,0,0,0,clblack'));
            cropparse(ONTOPRIGHT, ReadString(Skinname{'listbox'},
              ONTOPRIGHT.cropname, '0,0,0,0,clblack'));
            cropparse(ONTOP, ReadString(Skinname{'listbox'},
              ONTOP.cropname, '0,0,0,0,clblack'));
            cropparse(ONBOTTOMLEFT, ReadString(
              Skinname{'listbox'}, ONBOTTOMLEFT.cropname, '0,0,0,0,clblack'));
            cropparse(ONBOTTOMRIGHT, ReadString(
              Skinname{'listbox'}, ONBOTTOMRIGHT.cropname, '0,0,0,0,clblack'));
            cropparse(ONBOTTOM, ReadString(Skinname{'listbox'},
              ONBOTTOM.cropname, '0,0,0,0,clblack'));
            cropparse(ONLEFT, ReadString(Skinname{'listbox'},
              ONLEFT.cropname, '0,0,0,0,clblack'));
            cropparse(ONRIGHT, ReadString(Skinname{'listbox'},
              ONRIGHT.cropname, '0,0,0,0,clblack'));
            cropparse(ONCENTER, ReadString(Skinname{'listbox'},
              ONCENTER.cropname, '0,0,0,0,clblack'));
            cropparse(ONACTIVEITEM, ReadString(
              Skinname{'listbox'}, ONACTIVEITEM.cropname, '0,0,0,0,clblack'));
            cropparse(ONITEM, ReadString(Skinname{'listbox'},
              ONITEM.cropname, '0,0,0,0,clblack'));

            ReadSkinsComp(HorizontalScroll);
            ReadSkinsComp(VertialScroll);
          end;

        if (fparent.Components[i] is TONHeaderPanel) and
          (TONHeaderPanel(fparent.Components[i]).Skindata = Self) then
          with (TONHeaderPanel(fparent.Components[i])) do
          begin
            cropparse(ONTOPLEFT, ReadString(
              Skinname{'headerpanel'}, ONTOPLEFT.cropname, '0,0,0,0,clblack'));
            cropparse(ONTOPRIGHT, ReadString(
              Skinname{'headerpanel'}, ONTOPRIGHT.cropname, '0,0,0,0,clblack'));
            cropparse(ONTOP, ReadString(Skinname{'headerpanel'},
              ONTOP.cropname, '0,0,0,0,clblack'));
            cropparse(ONBOTTOMLEFT, ReadString(
              Skinname{'headerpanel'}, ONBOTTOMLEFT.cropname, '0,0,0,0,clblack'));
            cropparse(ONBOTTOMRIGHT, ReadString(
              Skinname{'headerpanel'}, ONBOTTOMRIGHT.cropname, '0,0,0,0,clblack'));
            cropparse(ONBOTTOM, ReadString(Skinname{'headerpanel'},
              ONBOTTOM.cropname, '0,0,0,0,clblack'));
            cropparse(ONLEFT, ReadString(Skinname{'headerpanel'},
              ONLEFT.cropname, '0,0,0,0,clblack'));
            cropparse(ONRIGHT, ReadString(Skinname{'headerpanel'},
              ONRIGHT.cropname, '0,0,0,0,clblack'));
            cropparse(ONCENTER, ReadString(Skinname{'headerpanel'},
              ONCENTER.cropname, '0,0,0,0,clblack'));
          end;
      end;
    end;
    //   end;

  finally
    self.fparent.Invalidate;// Repaint;
    FreeAndNil(skn);
  end;

end;


procedure TONImg.GetSkinInfo(const FileName: string; const Resource: boolean);
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


procedure TONImg.Saveskin(filename: string);
var
  Zipper: TZipper;
  i: integer;
  skn: Tinifile;

begin

  if csDesigning in ComponentState then
    exit;

  skn := TIniFile.Create(GetTempDir + 'tmp/skins.ini');

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

      Fimage.SaveToFile(GetTempDir + 'tmp/skins.png');
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
        if fparent.Components[i] is TONGraphicsButton then  // if component GraphicButton
          with (TONGraphicsButton(fparent.Components[i])) do
          begin
            writeString(Skinname, ONDISABLELEFT.cropname, croptostring(ONDISABLELEFT));
            writeString(Skinname, ONDISABLERIGHT.cropname, croptostring(ONDISABLERIGHT));
            writeString(Skinname, ONDISABLETOP.cropname, croptostring(ONDISABLETOP));
            writeString(Skinname, ONDISABLEBOTTOM.cropname, croptostring(ONDISABLEBOTTOM));
            writeString(Skinname, ONDISABLE.cropname, croptostring(ONDISABLE));

            writeString(Skinname, ONHOVERLEFT.cropname, croptostring(ONHOVERLEFT));
            writeString(Skinname, ONHOVERRIGHT.cropname, croptostring(ONHOVERRIGHT));
            writeString(Skinname, ONHOVERTOP.cropname, croptostring(ONHOVERTOP));
            writeString(Skinname, ONHOVERBOTTOM.cropname, croptostring(ONHOVERBOTTOM));
            writeString(Skinname, ONHOVER.cropname, croptostring(ONHOVER));

            writeString(Skinname, ONPRESSEDLEFT.cropname, croptostring(ONPRESSEDLEFT));
            writeString(Skinname, ONPRESSEDRIGHT.cropname, croptostring(ONPRESSEDRIGHT));
            writeString(Skinname, ONPRESSEDTOP.cropname, croptostring(ONPRESSEDTOP));
            writeString(Skinname, ONPRESSEDBOTTOM.cropname, croptostring(ONPRESSEDBOTTOM));
            writeString(Skinname, ONPRESSED.cropname, croptostring(ONPRESSED));

            writeString(Skinname, ONNORMALLEFT.cropname, croptostring(ONNORMALLEFT));
            writeString(Skinname, ONNORMALRIGHT.cropname, croptostring(ONNORMALRIGHT));
            writeString(Skinname, ONNORMALTOP.cropname, croptostring(ONNORMALTOP));
            writeString(Skinname, ONNORMALBOTTOM.cropname, croptostring(ONNORMALBOTTOM));
            writeString(Skinname, ONNORMAL.cropname, croptostring(ONNORMAL));
           { writeString(Skinname, ONNORMAL.cropname, croptostring(ONNORMAL));
            writeString(Skinname, ONHOVER.cropname, croptostring(ONHOVER));
            writeString(Skinname, ONPRESSED.cropname, croptostring(ONPRESSED));
            writeString(Skinname, ONDISABLE.cropname, croptostring(ONDISABLE));  }
          end;

        if fparent.Components[i] is TONCropButton then   // if component CropButton
          with (TONCropButton(fparent.Components[i])) do
          begin

            writeString(Skinname, ONDISABLELEFT.cropname, croptostring(ONDISABLELEFT));
            writeString(Skinname, ONDISABLERIGHT.cropname, croptostring(ONDISABLERIGHT));
            writeString(Skinname, ONDISABLETOP.cropname, croptostring(ONDISABLETOP));
            writeString(Skinname, ONDISABLEBOTTOM.cropname, croptostring(ONDISABLEBOTTOM));
            writeString(Skinname, ONDISABLE.cropname, croptostring(ONDISABLE));

            writeString(Skinname, ONHOVERLEFT.cropname, croptostring(ONHOVERLEFT));
            writeString(Skinname, ONHOVERRIGHT.cropname, croptostring(ONHOVERRIGHT));
            writeString(Skinname, ONHOVERTOP.cropname, croptostring(ONHOVERTOP));
            writeString(Skinname, ONHOVERBOTTOM.cropname, croptostring(ONHOVERBOTTOM));
            writeString(Skinname, ONHOVER.cropname, croptostring(ONHOVER));

            writeString(Skinname, ONPRESSEDLEFT.cropname, croptostring(ONPRESSEDLEFT));
            writeString(Skinname, ONPRESSEDRIGHT.cropname, croptostring(ONPRESSEDRIGHT));
            writeString(Skinname, ONPRESSEDTOP.cropname, croptostring(ONPRESSEDTOP));
            writeString(Skinname, ONPRESSEDBOTTOM.cropname, croptostring(ONPRESSEDBOTTOM));
            writeString(Skinname, ONPRESSED.cropname, croptostring(ONPRESSED));

            writeString(Skinname, ONNORMALLEFT.cropname, croptostring(ONNORMALLEFT));
            writeString(Skinname, ONNORMALRIGHT.cropname, croptostring(ONNORMALRIGHT));
            writeString(Skinname, ONNORMALTOP.cropname, croptostring(ONNORMALTOP));
            writeString(Skinname, ONNORMALBOTTOM.cropname, croptostring(ONNORMALBOTTOM));
            writeString(Skinname, ONNORMAL.cropname, croptostring(ONNORMAL));

          end;

        if fparent.Components[i] is TONlabel then   // if component CropButton
          with (TONlabel(fparent.Components[i])) do
          begin
            writeString(Skinname, ONCLIENT.cropname, croptostring(ONCLIENT));
          end;


         if fparent.Components[i] is TONKnob then   // if component CropButton
          with (TONKnob(fparent.Components[i])) do
          begin
            writeString(Skinname, ONBUTTONNRML.cropname, croptostring(ONBUTTONNRML));
            writeString(Skinname, ONBUTTONHOVR.cropname, croptostring(ONBUTTONHOVR));
            writeString(Skinname, ONBUTTONDOWN.cropname, croptostring(ONBUTTONDOWN));
            writeString(Skinname, ONBUTTONDSBL.cropname, croptostring(ONBUTTONDSBL));
            writeString(Skinname, ONTOPLEFT.cropname, croptostring(ONTOPLEFT));
            writeString(Skinname, ONTOPRIGHT.cropname, croptostring(ONTOPRIGHT));
            writeString(Skinname, ONTOP.cropname, croptostring(ONTOP));
            writeString(Skinname, ONBOTTOMLEFT.cropname, croptostring(ONBOTTOMLEFT));
            writeString(Skinname, ONBOTTOMRIGHT.cropname,
              croptostring(ONBOTTOMRIGHT));
            writeString(Skinname, ONBOTTOM.cropname, croptostring(ONBOTTOM));
            writeString(Skinname, ONLEFT.cropname, croptostring(ONLEFT));
            writeString(Skinname, ONRIGHT.cropname, croptostring(ONRIGHT));
            writeString(Skinname, ONCENTER.cropname, croptostring(ONCENTER));

          end;


        if fparent.Components[i] is TONLed then   // if component CropButton
          with (TONLed(fparent.Components[i])) do
          begin
            writeString(Skinname, ONLEDONNORMAL.cropname, croptostring(ONLEDONNORMAL));
            writeString(Skinname, ONLEDONHOVER.cropname, croptostring(ONLEDONHOVER));

            writeString(Skinname, ONLEDOFFNORMAL.cropname, croptostring(ONLEDOFFNORMAL));
            writeString(Skinname, ONLEDOFFHOVER.cropname, croptostring(ONLEDOFFHOVER));
            writeString(Skinname, ONDISABLED.cropname, croptostring(ONDISABLED));

          end;



        if fparent.Components[i] is TONPageControl then    // if component Panel
          with (TONPageControl(fparent.Components[i])) do
          begin
            writeString(Skinname, FTOPLEFT.cropname, croptostring(FTOPLEFT));
            writeString(Skinname, FTOPRIGHT.cropname, croptostring(FTOPRIGHT));
            writeString(Skinname, FTOP.cropname, croptostring(FTOP));
            writeString(Skinname, FBOTTOMLEFT.cropname, croptostring(FBOTTOMLEFT));
            writeString(Skinname, FBOTTOMRIGHT.cropname,
              croptostring(FBOTTOMRIGHT));
            writeString(Skinname, FBOTTOM.cropname, croptostring(FBOTTOM));
            writeString(Skinname, FLEFT.cropname, croptostring(FLEFT));
            writeString(Skinname, FRIGHT.cropname, croptostring(FRIGHT));
            writeString(Skinname, FCENTER.cropname, croptostring(FCENTER));
            writeString(Skinname, ONBUTTONAREA.cropname, croptostring(ONBUTTONAREA));
          end;

         if fparent.Components[i] is TONPage then    // if component Panel
          with (TONPage(fparent.Components[i])) do
          begin
            writeString(Skinname, FTOPLEFT.cropname, croptostring(FTOPLEFT));
            writeString(Skinname, FTOPRIGHT.cropname, croptostring(FTOPRIGHT));
            writeString(Skinname, FTOP.cropname, croptostring(FTOP));
            writeString(Skinname, FBOTTOMLEFT.cropname, croptostring(FBOTTOMLEFT));
            writeString(Skinname, FBOTTOMRIGHT.cropname,
              croptostring(FBOTTOMRIGHT));
            writeString(Skinname, FBOTTOM.cropname, croptostring(FBOTTOM));
            writeString(Skinname, FLEFT.cropname, croptostring(FLEFT));
            writeString(Skinname, FRIGHT.cropname, croptostring(FRIGHT));
            writeString(Skinname, FCENTER.cropname, croptostring(FCENTER));
          end;

         if fparent.Components[i] is TONPageButton then    // if component Panel
          with (TONPageButton(fparent.Components[i])) do
          begin
            writeString(Skinname, ONENTER.cropname, croptostring(ONENTER));
            writeString(Skinname, ONNORMAL.cropname, croptostring(ONNORMAL));
            writeString(Skinname, ONPRESS.cropname, croptostring(ONPRESS));
            writeString(Skinname, ONDISABLE.cropname, croptostring(ONDISABLE));
          end;

         if fparent.Components[i] is TonbuttonareaCntrl then    // if component Panel
          with (TonbuttonareaCntrl(fparent.Components[i])) do
          begin
            writeString(Skinname, ONCLIENT.cropname, croptostring(ONCLIENT));
          end;


        if fparent.Components[i] is TONPanel then    // if component Panel
          with (TONPanel(fparent.Components[i])) do
          begin
            writeString(Skinname, ONTOPLEFT.cropname, croptostring(ONTOPLEFT));
            writeString(Skinname, ONTOPRIGHT.cropname, croptostring(ONTOPRIGHT));
            writeString(Skinname, ONTOP.cropname, croptostring(ONTOP));
            writeString(Skinname, ONBOTTOMLEFT.cropname, croptostring(ONBOTTOMLEFT));
            writeString(Skinname, ONBOTTOMRIGHT.cropname,
              croptostring(ONBOTTOMRIGHT));
            writeString(Skinname, ONBOTTOM.cropname, croptostring(ONBOTTOM));
            writeString(Skinname, ONLEFT.cropname, croptostring(ONLEFT));
            writeString(Skinname, ONRIGHT.cropname, croptostring(ONRIGHT));
            writeString(Skinname, ONCENTER.cropname, croptostring(ONCENTER));
          end;

        if fparent.Components[i] is TONCollapExpandPanel then
          // if component CollapsedExpandedPanel
          with (TONCollapExpandPanel(fparent.Components[i])) do
          begin
            writeString(Skinname, ONTOPLEFT.cropname, croptostring(ONTOPLEFT));
            writeString(Skinname, ONTOPRIGHT.cropname, croptostring(ONTOPRIGHT));
            writeString(Skinname, ONTOP.cropname, croptostring(ONTOP));
            writeString(Skinname, ONBOTTOMLEFT.cropname, croptostring(ONBOTTOMLEFT));
            writeString(Skinname, ONBOTTOMRIGHT.cropname,
              croptostring(ONBOTTOMRIGHT));
            writeString(Skinname, ONBOTTOM.cropname, croptostring(ONBOTTOM));
            writeString(Skinname, ONLEFT.cropname, croptostring(ONLEFT));
            writeString(Skinname, ONRIGHT.cropname, croptostring(ONRIGHT));
            writeString(Skinname, ONCENTER.cropname, croptostring(ONCENTER));
            writeString(Skinname, ONNORMAL.cropname, croptostring(ONNORMAL));
            writeString(Skinname, ONHOVER.cropname, croptostring(ONHOVER));
            writeString(Skinname, ONPRESSED.cropname, croptostring(ONPRESSED));
            writeString(Skinname, ONDISABLE.cropname, croptostring(ONDISABLE));
            writeString(Skinname, ONDISABLE.cropname, croptostring(ONCAPTION));


          end;





        if fparent.Components[i] is TonEdit then    // if component Edit
          with (TonEdit(fparent.Components[i])) do
          begin
            writeString(Skinname, ONTOPLEFT.cropname, croptostring(ONTOPLEFT));
            writeString(Skinname, ONTOPRIGHT.cropname, croptostring(ONTOPRIGHT));
            writeString(Skinname, ONTOP.cropname, croptostring(ONTOP));
            writeString(Skinname, ONBOTTOMLEFT.cropname, croptostring(ONBOTTOMLEFT));
            writeString(Skinname, ONBOTTOMRIGHT.cropname,
              croptostring(ONBOTTOMRIGHT));
            writeString(Skinname, ONBOTTOM.cropname, croptostring(ONBOTTOM));
            writeString(Skinname, ONLEFT.cropname, croptostring(ONLEFT));
            writeString(Skinname, ONRIGHT.cropname, croptostring(ONRIGHT));
            writeString(Skinname, ONCENTER.cropname, croptostring(ONCENTER));
          end;

        if fparent.Components[i] is TOnSpinEdit then  // if component SpinEdit
          with (TOnSpinEdit(fparent.Components[i])) do
          begin
            writeString(Skinname, ONTOPLEFT.cropname, croptostring(ONTOPLEFT));
            writeString(Skinname, ONTOPRIGHT.cropname, croptostring(ONTOPRIGHT));
            writeString(Skinname, ONTOP.cropname, croptostring(ONTOP));
            writeString(Skinname, ONBOTTOMLEFT.cropname, croptostring(ONBOTTOMLEFT));
            writeString(Skinname, ONBOTTOMRIGHT.cropname,
              croptostring(ONBOTTOMRIGHT));
            writeString(Skinname, ONBOTTOM.cropname, croptostring(ONBOTTOM));
            writeString(Skinname, ONLEFT.cropname, croptostring(ONLEFT));
            writeString(Skinname, ONRIGHT.cropname, croptostring(ONRIGHT));
            writeString(Skinname, ONCENTER.cropname, croptostring(ONCENTER));
            writeString(Skinname, ONUPBUTONNORMAL.cropname,
              croptostring(ONUPBUTONNORMAL));
            writeString(Skinname, ONUPBUTONPRESS.cropname, croptostring(
              ONUPBUTONPRESS));
            writeString(Skinname, ONUPBUTONHOVER.cropname, croptostring(
              ONUPBUTONHOVER));
            writeString(Skinname, ONUPBUTONDISABLE.cropname,
              croptostring(ONUPBUTONDISABLE));
            writeString(Skinname, ONDOWNBUTONNORMAL.cropname,
              croptostring(ONDOWNBUTONNORMAL));
            writeString(Skinname, ONDOWNBUTONPRESS.cropname,
              croptostring(ONDOWNBUTONPRESS));
            writeString(Skinname, ONDOWNBUTONHOVER.cropname,
              croptostring(ONDOWNBUTONHOVER));
            writeString(Skinname, ONDOWNBUTONDISABLE.cropname,
              croptostring(ONDOWNBUTONDISABLE));
          end;

        if fparent.Components[i] is TONMemo then  // if component Memo
          with (TONMemo(fparent.Components[i])) do
          begin
            writeString(Skinname, ONTOPLEFT.cropname, croptostring(ONTOPLEFT));
            writeString(Skinname, ONTOPRIGHT.cropname, croptostring(ONTOPRIGHT));
            writeString(Skinname, ONTOP.cropname, croptostring(ONTOP));
            writeString(Skinname, ONBOTTOMLEFT.cropname, croptostring(ONBOTTOMLEFT));
            writeString(Skinname, ONBOTTOMRIGHT.cropname,
              croptostring(ONBOTTOMRIGHT));
            writeString(Skinname, ONBOTTOM.cropname, croptostring(ONBOTTOM));
            writeString(Skinname, ONLEFT.cropname, croptostring(ONLEFT));
            writeString(Skinname, ONRIGHT.cropname, croptostring(ONRIGHT));
            writeString(Skinname, ONCENTER.cropname, croptostring(ONCENTER));
          end;

        if fparent.Components[i] is TONcombobox then  // if component Combobox
          with (TONcombobox(fparent.Components[i])) do
          begin
            writeString(Skinname, ONTOPLEFT.cropname, croptostring(ONTOPLEFT));
            writeString(Skinname, ONTOPRIGHT.cropname, croptostring(ONTOPRIGHT));
            writeString(Skinname, ONTOP.cropname, croptostring(ONTOP));
            writeString(Skinname, ONBOTTOMLEFT.cropname, croptostring(ONBOTTOMLEFT));
            writeString(Skinname, ONBOTTOMRIGHT.cropname,
              croptostring(ONBOTTOMRIGHT));
            writeString(Skinname, ONBOTTOM.cropname, croptostring(ONBOTTOM));
            writeString(Skinname, ONLEFT.cropname, croptostring(ONLEFT));
            writeString(Skinname, ONRIGHT.cropname, croptostring(ONRIGHT));
            writeString(Skinname, ONCENTER.cropname, croptostring(ONCENTER));
            writeString(Skinname, ONBUTONNORMAL.cropname,
              croptostring(ONBUTONNORMAL));
            writeString(Skinname, ONBUTONPRESS.cropname, croptostring(ONBUTONPRESS));
            writeString(Skinname, ONBUTONHOVER.cropname, croptostring(ONBUTONHOVER));
            writeString(Skinname, ONBUTONDISABLE.cropname, croptostring(
              ONBUTONDISABLE));
          end;


        if fparent.Components[i] is TOnSwich then
          with (TOnSwich(fparent.Components[i])) do
          begin
            writeString(Skinname, ONOPEN.cropname, croptostring(ONOPEN));
            writeString(Skinname, ONOPENHOVER.cropname, croptostring(ONOPENHOVER));
            writeString(Skinname, ONCLOSE.cropname, croptostring(ONCLOSE));
            writeString(Skinname, ONCLOSEHOVER.cropname, croptostring(ONCLOSEHOVER));
            writeString(Skinname, ONDISABLE.cropname, croptostring(ONDISABLE));
          end;


        if fparent.Components[i] is TOnCheckbox then
          with (TOnCheckbox(fparent.Components[i])) do
          begin
            writeString(Skinname, ONNORMAL.cropname, croptostring(ONNORMAL));
            writeString(Skinname, ONNORMALDOWN.cropname, croptostring(ONNORMALDOWN));
            writeString(Skinname, ONNORMALHOVER.cropname, croptostring(ONNORMALHOVER));
            writeString(Skinname, ONCHECKED.cropname, croptostring(ONCHECKED));
            writeString(Skinname, ONCHECKEDHOVER.cropname,
              croptostring(ONCHECKEDHOVER));
            writeString(Skinname, ONDISABLE.cropname, croptostring(ONDISABLE));
          end;


        if fparent.Components[i] is TOnRadioButton then
          with (TOnRadioButton(fparent.Components[i])) do
          begin
            writeString(Skinname, ONNORMAL.cropname, croptostring(ONNORMAL));
            writeString(Skinname, ONNORMALDOWN.cropname, croptostring(ONNORMALDOWN));
            writeString(Skinname, ONNORMALHOVER.cropname, croptostring(ONNORMALHOVER));
            writeString(Skinname, ONCHECKED.cropname, croptostring(ONCHECKED));
            writeString(Skinname, ONCHECKEDHOVER.cropname,
              croptostring(ONCHECKEDHOVER));
            writeString(Skinname, ONDISABLE.cropname, croptostring(ONDISABLE));
          end;



        if fparent.Components[i] is TONProgressBar then
          with (TONProgressBar(fparent.Components[i])) do
          begin
            writeString(Skinname, ONLEFT_TOP.cropname, croptostring(ONLEFT_TOP));
            writeString(Skinname, ONRIGHT_BOTTOM.cropname,
              croptostring(ONRIGHT_BOTTOM));
            writeString(Skinname, ONCENTER.cropname, croptostring(ONCENTER));
            writeString(Skinname, ONTOP.cropname, croptostring(ONTOP));
            writeString(Skinname, ONBOTTOM.cropname, croptostring(ONBOTTOM));
            writeString(Skinname, ONBAR.cropname, croptostring(ONBAR));

          end;


        if fparent.Components[i] is TONTrackBar then
          with (TONTrackBar(fparent.Components[i])) do
          begin
            writeString(Skinname, ONLEFT.cropname, croptostring(ONLEFT));
            writeString(Skinname, ONRIGHT.cropname, croptostring(ONRIGHT));
            writeString(Skinname, ONCENTER.cropname, croptostring(ONCENTER));
            writeString(Skinname, ONBUTONNORMAL.cropname,
              croptostring(ONBUTONNORMAL));
            writeString(Skinname, ONBUTONHOVER.cropname, croptostring(ONBUTONHOVER));
            writeString(Skinname, ONBUTONPRESS.cropname, croptostring(ONBUTONPRESS));
            writeString(Skinname, ONBUTONDISABLE.cropname, croptostring(
              ONBUTONDISABLE));
          end;



        if fparent.Components[i] is ToNScrollBar then
          with (ToNScrollBar(fparent.Components[i])) do
          begin
            writeString(Skinname, ONTOP.cropname, croptostring(ONTOP));
            writeString(Skinname, ONBOTTOM.cropname, croptostring(ONBOTTOM));


            writeString(Skinname, ONNORMAL.cropname, croptostring(ONNORMAL));
            writeString(Skinname, ONBAR.cropname, croptostring(ONBAR));
            writeString(Skinname, ONCENTERBUTNORMAL.cropname,
              croptostring(ONCENTERBUTNORMAL));
            writeString(Skinname, ONCENTERBUTONHOVER.cropname,
              croptostring(ONCENTERBUTONHOVER));
            writeString(Skinname, ONCENTERBUTPRESS.cropname,
              croptostring(ONCENTERBUTPRESS));
            writeString(Skinname, ONCENTERBUTDISABLE.cropname,
              croptostring(ONCENTERBUTDISABLE));

            writeString(Skinname, ONLEFTBUTNORMAL.cropname,
              croptostring(ONLEFTBUTNORMAL));
            writeString(Skinname, ONLEFTBUTONHOVER.cropname,
              croptostring(ONLEFTBUTONHOVER));
            writeString(Skinname, ONLEFTBUTPRESS.cropname,
              croptostring(ONLEFTBUTPRESS));
            writeString(Skinname, ONLEFTBUTDISABLE.cropname,
              croptostring(ONLEFTBUTDISABLE));


            writeString(Skinname, ONRIGHTBUTNORMAL.cropname,
              croptostring(ONRIGHTBUTNORMAL));
            writeString(Skinname, ONRIGHTBUTONHOVER.cropname,
              croptostring(ONRIGHTBUTONHOVER));
            writeString(Skinname, ONRIGHTBUTPRESS.cropname,
              croptostring(ONRIGHTBUTPRESS));
            writeString(Skinname, ONRIGHTBUTDISABLE.cropname,
              croptostring(ONRIGHTBUTDISABLE));
          end;


        if fparent.Components[i] is ToNListBox then
          with (ToNListBox(fparent.Components[i])) do
          begin
            writeString(Skinname, ONTOPLEFT.cropname, croptostring(ONTOPLEFT));
            writeString(Skinname, ONTOPRIGHT.cropname, croptostring(ONTOPRIGHT));
            writeString(Skinname, ONTOP.cropname, croptostring(ONTOP));
            writeString(Skinname, ONBOTTOMLEFT.cropname, croptostring(ONBOTTOMLEFT));
            writeString(Skinname, ONBOTTOMRIGHT.cropname,
              croptostring(ONBOTTOMRIGHT));
            writeString(Skinname, ONBOTTOM.cropname, croptostring(ONBOTTOM));
            writeString(Skinname, ONLEFT.cropname, croptostring(ONLEFT));
            writeString(Skinname, ONRIGHT.cropname, croptostring(ONRIGHT));
            writeString(Skinname, ONCENTER.cropname, croptostring(ONCENTER));
            writeString(Skinname, ONITEM.cropname, croptostring(ONITEM));
            writeString(Skinname, ONACTIVEITEM.cropname, croptostring(ONACTIVEITEM));

          end;

        if fparent.Components[i] is TOncolumlist then
          with (TOncolumlist(fparent.Components[i])) do
          begin
            writeString(Skinname, ONTOPLEFT.cropname, croptostring(ONTOPLEFT));
            writeString(Skinname, ONTOPRIGHT.cropname, croptostring(ONTOPRIGHT));
            writeString(Skinname, ONTOP.cropname, croptostring(ONTOP));
            writeString(Skinname, ONBOTTOMLEFT.cropname, croptostring(ONBOTTOMLEFT));
            writeString(Skinname, ONBOTTOMRIGHT.cropname,
              croptostring(ONBOTTOMRIGHT));
            writeString(Skinname, ONBOTTOM.cropname, croptostring(ONBOTTOM));
            writeString(Skinname, ONLEFT.cropname, croptostring(ONLEFT));
            writeString(Skinname, ONRIGHT.cropname, croptostring(ONRIGHT));
            writeString(Skinname, ONCENTER.cropname, croptostring(ONCENTER));
            writeString(Skinname, ONITEM.cropname, croptostring(ONITEM));
            writeString(Skinname, ONACTIVEITEM.cropname, croptostring(ONACTIVEITEM));
            writeString(Skinname, ONHEADER.cropname, croptostring(ONHEADER));
          end;

        if fparent.Components[i] is TONHeaderPanel then
          with (TONHeaderPanel(fparent.Components[i])) do
          begin
            writeString(Skinname, ONTOPLEFT.cropname, croptostring(ONTOPLEFT));
            writeString(Skinname, ONTOPRIGHT.cropname, croptostring(ONTOPRIGHT));
            writeString(Skinname, ONTOP.cropname, croptostring(ONTOP));
            writeString(Skinname, ONBOTTOMLEFT.cropname, croptostring(ONBOTTOMLEFT));
            writeString(Skinname, ONBOTTOMRIGHT.cropname,
              croptostring(ONBOTTOMRIGHT));
            writeString(Skinname, ONBOTTOM.cropname, croptostring(ONBOTTOM));
            writeString(Skinname, ONLEFT.cropname, croptostring(ONLEFT));
            writeString(Skinname, ONRIGHT.cropname, croptostring(ONRIGHT));
            writeString(Skinname, ONCENTER.cropname, croptostring(ONCENTER));
          end;
      end;
    end;
    //   end;

    Zipper := TZipper.Create;
    try
      Zipper.FileName := filename;
      zipper.Entries.AddFileEntry(GetTempDir + 'tmp/skins.ini', 'skins.ini');
      zipper.Entries.AddFileEntry(GetTempDir + 'tmp/skins.png', 'skins.png');
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


constructor Tongraphiccontrol.Create(Aowner: TComponent);
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
end;

destructor Tongraphiccontrol.Destroy;
begin
  if Assigned(resim) then  FreeAndNil(resim);
  inherited Destroy;
end;


// -----------------------------------------------------------------------------
procedure Tongraphiccontrol.Wmerasebkgnd(var Message: Twmerasebkgnd);
begin
  SetBkMode(Message.dc, 1);
  Message.Result := 1;
end;
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
procedure Tongraphiccontrol.Createparams(var Params: Tcreateparams);
begin
  params.exstyle := params.exstyle or WS_EX_TRANSPARENT or WS_EX_LAYERED or
    WS_CLIPCHILDREN;
end;


// -----------------------------------------------------------------------------
procedure Tongraphiccontrol.Setalignment(const Value: Talignment);
begin
  if FAlignment <> Value then
  begin
    FAlignment := Value;
  end;
end;
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
function Tongraphiccontrol.Gettransparent: boolean;
begin
  Result := Color = clNone;
end;

procedure Tongraphiccontrol.Settransparent(Newtransparent: boolean);
begin
  if Transparent = NewTransparent then
    exit;
  if NewTransparent = True then
    Color := clNone
  else
  if Color = clNone then
    Color := clBackground;
end;

function Tongraphiccontrol.Getkind: Tonkindstate;
begin
  Result := Fkind;
end;

procedure Tongraphiccontrol.Setkind(Avalue: Tonkindstate);
begin
  if avalue = Fkind then exit;
  Fkind := avalue;
  Invalidate;
end;

procedure Tongraphiccontrol.Setskindata(Aimg: Tonimg);
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

procedure Tongraphiccontrol.Setskinname(Avalue: string);
begin
  if Fskinname <> avalue then
    Fskinname := avalue;
end;

procedure Tongraphiccontrol.Setalpha(Val: byte);
begin
  if falpha = val then exit;
  falpha := val;
  Invalidate;
end;


// -----------------------------------------------------------------------------
procedure Tongraphiccontrol.Paint;
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


constructor Toncustomcontrol.Create(Aowner: TComponent);
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
end;

destructor Toncustomcontrol.Destroy;
begin
  if Assigned(resim) then  FreeAndNil(resim);
  DeleteObject(WindowRgn);
  inherited Destroy;
end;


// -----------------------------------------------------------------------------
procedure Toncustomcontrol.Wmerasebkgnd(var Message: Twmerasebkgnd);
begin
  SetBkMode(Message.dc, TRANSPARENT);
  Message.Result := 1;
end;
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
procedure Toncustomcontrol.Createparams(var Params: Tcreateparams);
begin
  inherited CreateParams(Params);
  params.exstyle := params.exstyle or WS_EX_TRANSPARENT or WS_EX_LAYERED or
    WS_CLIPCHILDREN;
end;


// -----------------------------------------------------------------------------
procedure Toncustomcontrol.Setalignment(const Value: Talignment);
begin
  if FAlignment <> Value then
  begin
    FAlignment := Value;
  end;
end;

procedure Toncustomcontrol.Setskindata(Aimg: Tonimg);
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

procedure Toncustomcontrol.Setalpha(Val: byte);
begin
  if falpha = val then exit;
  falpha := val;
  Invalidate;
end;

// -----------------------------------------------------------------------------
procedure Toncustomcontrol.Setcrop(Value: boolean);
begin
  if Fcrop <> Value then
  begin
    Fcrop := Value;
  end;
end;

function Toncustomcontrol.Getkind: Tonkindstate;
begin
  Result := Fkind;
end;

procedure Toncustomcontrol.Setkind(Avalue: Tonkindstate);
begin
  if avalue = Fkind then exit;
  Fkind := avalue;
  Invalidate;
end;

procedure Toncustomcontrol.Setskinname(Avalue: string);
begin
  if Fskinname <> avalue then
    Fskinname := avalue;
end;

// --------------------:=---------------------------------------------------------

procedure Toncustomcontrol.Croptoimg(Buffer: Tbgrabitmap);
var
  x, y: integer;
  hdc1, SpanRgn: hdc;//integer;

   TrgtRect: Trect;
   p: PBGRAPixel;
begin

{  Premultiply(buffer);
  for x := 1 to buffer.Bitmap.Width do
  begin
    for y := 1 to buffer.Bitmap.Height do
    begin
      if (buffer.GetPixel(x - 1, y - 1) = BGRAPixelTransparent) then
      begin
        SpanRgn := CreateRectRgn(x - 1, y - 1, x, y);
        CombineRgn(WindowRgn, WindowRgn, SpanRgn, RGN_DIFF);
        DeleteObject(SpanRgn);

      end;
    end;
  end;
}
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
  DeleteObject(WindowRgn);
  DeleteObject(hdc1);
end;
// -----------------------------------------------------------------------------
procedure Toncustomcontrol.Paint;
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

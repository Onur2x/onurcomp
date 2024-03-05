unit resim;

{$P+,S-,W-,R-}
{$OPTIMIZATION OFF}
{$WARNINGS OFF}
{$HINTS OFF}

interface

uses Graphics, Classes,  Windows;

const

  hSection = 0;

type

  TEColor  = record b,g,r:Byte end;
  TAColor  = record r,g,b,a:Byte end;
  PEColor  =^TEColor;
  TLine    = array[0..0]of TEColor;
  PLine    =^TLine;
  TPLines  = array[0..0]of PLine;
  PPLines  =^TPLines;

  TKSDevRGB=class
  public
    Gap,    // space between scanlines
    RowInc, // distance to next scanline
    Size,   // size of Bits
    Width,
    Height: Integer;
    Pixels: PPLines;  // Pixels[y,x]:=TEColor; Pixels[y]:=PLine;
    Bits:   Pointer;
  end;

  TksBmp = class(TKSDevRGB)
  private
    FName: string;
    FRect: TRect;
    procedure   Initialize;
  public
    Count: Integer;
    Handle,
    hDC:        Integer;
    bmInfo:     TBitmapInfo;
    bmHeader:   TBitmapInfoHeader;
    // constructors
    constructor Create(cx,cy:Integer);
    constructor  CreateFromHandle(HBmp: Cardinal); overload;
    constructor CreateFromFile(FileName: string);
    constructor CreateFromStream(Stream: TStream);
    constructor  CreateCopy(hBmp:TksBmp); overload;
    destructor  Destroy; override;
    procedure FreeBmp;
    function GetCopy: TksBmp;
    // I\O
    procedure LoadFromFile(FileName: string);
    procedure SaveToFile(FileName: string);
    procedure LoadFromStream(Stream: TStream);
    procedure SaveToStream(Stream: TStream);
    // gdi routines
    procedure Draw(hDst, x, y: Integer);
    procedure Stretch(hDst, x,y, cx,cy: Integer);
    procedure StretchLinear(hDC, x, y, cx, cy: Integer);
    procedure DrawRect(hDst,x,y,sx,sy,cx,cy:Integer);
    procedure TileDraw(hDst,x,y,cx,cy:Integer);
    { Transparent }
    procedure StretchTransparent(CT: TCanvas; x, y, cx, cy: Integer;
      TransColor: TColor);
    procedure TileDrawTransparent(CT: TCanvas; x, y, cx, cy: Integer;
      TransColor: TColor);
    procedure DrawTransparent(CT: TCanvas; x, y: Integer; TransColor: TColor);
    // software (non gdi) routines
    procedure Resize(Dst:TksBmp);
    procedure CopyRect(Dst: TksBmp; x,y,sx,sy,cx,cy:Integer); overload;
    procedure CopyRect1(Dst: TksBmp; R: TRect; x,y: Integer); overload;
    procedure Tile(Dst:TksBmp);
    //
    function GetTopNotTrans(V: integer; TransColor: TColor): integer;
    function GetLeftNotTrans(V: integer; TransColor: TColor): integer;
    function GetRightNotTrans(V: integer; TransColor: TColor): integer;
    function GetBottomNotTrans(V: integer; TransColor: TColor): integer;
    { properties }
    property Name: string read FName write FName;
    property Rect: TRect read FRect write FRect;
  end;

function ColorToEColor(Color: TColor): TEColor;
function ERGB(r,g,b:Byte): TEColor;
function IntToByte(i:Integer): Byte;
function TrimInt(i,Min,Max:Integer): Integer;

function CreateRgnDataFromBitmapRect(FB: TksBmp; var RgnData: PRgnData;
  X, Y: integer; R: TRect; TransColor: TColor): integer;

function CreateRgnDataFromBitmap(FB: TksBmp; var RgnData: PRgnData; TransColor: TColor): integer;
function CreateRgnFromBitmap(FB: TksBmp; TransColor: TColor): HRgn;

function CreateOffsetRgnFromBitmap(FB: TksBmp; X, Y: integer; TransColor: TColor): HRgn;
function CreateOffsetRgnFromBitmapRect(FB: TksBmp; X, Y: integer; R: TRect; TransColor: TColor): HRgn;
function CreateRgnFromBitmapRect(FB: TksBmp; BitmapRect: TRect; TransColor: TColor): HRgn;

procedure DrawSmallIcon(Canvas: TCanvas; X, Y: integer; Icon: TIcon;
  MaskColor: TColor);

{ image transform }

procedure Fade(Result, Source, Dest: TksBmp; Kf: Double);
procedure Slide(Result, Source, Dest: TksBmp; Kf: Double);

implementation {===============================================================}

uses Forms, ShellAPI, SysUtils;

{ functions ===================================================================}

procedure DrawSmallIcon(Canvas: TCanvas; X, Y: integer; Icon: TIcon;
  MaskColor: TColor);
begin
  if Icon = nil then Exit;
  with Canvas do
  begin
    Brush.Color := MaskColor;
    DrawIconEx(Handle, X, Y, Icon.Handle, 16, 16, 0,
      Brush.Handle, DI_MASK);
  end;
end;

function ColorToEColor(Color: TColor): TEColor;
begin
  Result.r := GetRValue(Color);
  Result.g := GetGValue(Color);
  Result.b := GetBValue(Color);
end;

function ERGB(r,g,b:Byte):TEColor;
begin
  Result.r:=r;
  Result.g:=g;
  Result.b:=b;
end;

function IntToByte(i:Integer):Byte;
begin
  if      i>255 then Result:=255
  else if i<0   then Result:=0
  else               Result:=i;
end;

function TrimInt(i,Min,Max:Integer):Integer;
begin
  if      i>Max then Result:=Max
  else if i<Min then Result:=Min
  else               Result:=i;
end;

{ TksBmp }

constructor TksBmp.Create(cx,cy:Integer);
begin
  Width:=cx;
  Height:=cy;
  if (cx = 0) or (cy = 0) then
    Exit;
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
                   Bits,
                   hSection,
                   0);
  Initialize;
end;

 constructor TksBmp.CreateFromHandle(HBmp: Cardinal);
var
  Bmp:   TBITMAP;
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
                 Bits,
                 hSection,
                 0);
  memDC:=GetDC(0);
  GetDIBits(memDC,hBmp,0,Height,Bits,bmInfo,DIB_RGB_COLORS);
  ReleaseDC(0,memDC);
  Initialize;
end;


 constructor  TksBmp.CreateCopy(hBmp:TksBmp);
begin
  bmHeader:=hBmp.bmHeader;
  bmInfo:=hBmp.bmInfo;
  Width:=hBmp.Width;
  Height:=hBmp.Height;
  Size:=hBmp.Size;
  Handle:=CreateDIBSection(0,
                 bmInfo,
                 DIB_RGB_COLORS,
                 Bits,
                 hSection,
                 0);
  CopyMemory(Bits,hBmp.Bits,Size);
  Initialize;
end;

destructor TksBmp.Destroy;
begin
  if hDC <> 0 then
    DeleteDC(hDC);
  if Handle <> 0 then
    DeleteObject(Handle);
  if (Pixels <> nil) then
    FreeMem(Pixels);
  inherited;
end;

procedure TksBmp.FreeBmp;
begin
  Dec(Count);
  if Count > 0 then Exit;
  Free;
end;

procedure TksBmp.Initialize;
var
  x,i: Integer;
begin
  GetMem(Pixels,Height*SizeOf(PLine));
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

  Count := 1;
end;

function TksBmp.GetCopy: TksBmp;
begin
  Inc(Count);
  Result := Self;
end;

constructor TksBmp.CreateFromFile(FileName: string);
var
  BMP: Graphics.TBitmap;
begin
  BMP := Graphics.TBitmap.Create;
  try
    BMP.LoadFromFile(FileName);
    CreateFromHandle(BMP.Handle);
  finally
    BMP.Free;
  end;
end;

constructor TksBmp.CreateFromStream(Stream: TStream);
var
  BMP: Graphics.TBitmap;
begin
  BMP := Graphics.TBitmap.Create;
  try
    BMP.LoadFromStream(Stream);
    CreateFromHandle(BMP.Handle);
  finally
    BMP.Free;
  end;
end;

procedure TksBmp.LoadFromFile(FileName: string);
var
  BMP: Graphics.TBitmap;
begin
  BMP := Graphics.TBitmap.Create;
  try
    BMP.LoadFromFile(FileName);
    CreateFromHandle(BMP.Handle);
  finally
    BMP.Free;
  end;
end;

procedure TksBmp.SaveToFile(FileName: string);
var
  BMP: Graphics.TBitmap;
begin
  BMP := Graphics.TBitmap.Create;
  try
    BMP.Width := Width;
    BMP.Height := Height;
    Draw(BMP.Canvas.Handle, 0, 0);
    BMP.SaveToFile(FileName);
  finally
    BMP.Free;
  end;
end;

procedure TksBmp.LoadFromStream(Stream: TStream);
var
  BMP: Graphics.TBitmap;
begin
  BMP := Graphics.TBitmap.Create;
  try
    BMP.LoadFromStream(Stream);
    CreateFromHandle(BMP.Handle);
  finally
    BMP.Free;
  end;
end;

procedure TksBmp.SaveToStream(Stream: TStream);
var
  BMP: Graphics.TBitmap;
begin
  BMP := Graphics.TBitmap.Create;
  try
    BMP.Width := Width;
    BMP.Height := Height;
    Draw(BMP.Canvas.Handle, 0, 0);
    BMP.SaveToStream(Stream);
  finally
    BMP.Free;
  end;
end;

procedure TksBmp.DrawTransparent(CT: TCanvas; x, y: Integer; TransColor: TColor);
var
  Bitmap: Graphics.TBitmap;
  SaveIndex: integer;
begin
  try
    SaveIndex := SaveDC(CT.Handle);

    Bitmap := Graphics.TBitmap.Create;
    try
      Bitmap.Width := Width;
      Bitmap.Height := Height;
      Draw(Bitmap.Canvas.Handle, 0, 0);
      Bitmap.TransparentColor := TransColor;
      Bitmap.Transparent := true;
      CT.Draw(x, y, Bitmap);
    finally
      Bitmap.Free;
    end;
  finally
    RestoreDC(CT.Handle, SaveIndex);
  end;
end;

procedure TksBmp.Draw(hDst,x,y:Integer);
begin
  BitBlt(hDst,x,y,Width,Height,hDC,0,0,SRCCOPY);
end;

procedure TksBmp.Stretch(hDst,x,y,cx,cy:Integer);
begin
  // some video drivers don't implement stretching dibs
  // very well. (diamond stealth fails when the scaling
  // factor is greater then 255). for reliable resizing
  // use the native 'resize' method.
  SetStretchBltMode(hDst,STRETCH_DELETESCANS);
  StretchBlt(hDst,x,y,cx,cy,hDC,0,0,Width,Height,SRCCOPY);
end;

procedure TksBmp.StretchTransparent(CT: TCanvas; x,y,cx,cy:Integer; TransColor: TColor);
var
  Bitmap: Graphics.TBitmap;
  SaveIndex: integer;
begin
  try
    SaveIndex := SaveDC(CT.Handle);

    Bitmap := Graphics.TBitmap.Create;
    try
      Bitmap.Width := cx;
      Bitmap.Height := cy;
      Stretch(Bitmap.Canvas.Handle, 0, 0, cx, cy);
      Bitmap.TransparentColor := TransColor;
      Bitmap.Transparent := true;
      CT.Draw(x, y, Bitmap);
    finally
      Bitmap.Free;
    end;
  finally
    RestoreDC(CT.Handle, SaveIndex);
  end;
end;

procedure TksBmp.DrawRect(hDst,x,y,sx,sy,cx,cy:Integer);
begin
  BitBlt(hDst,x,y,cx,cy,hDC,sx,sy,SRCCOPY);
end;

procedure TksBmp.TileDraw(hDst,x,y,cx,cy:Integer);
var
w,h,
hBmp,
memDC: Integer;
begin
  memDC:=CreateCompatibleDC(hDst);
  hBmp:=CreateCompatibleBitmap(hDst,cx,cy);
  SelectObject(memDC,hBmp);
  Draw(memDC,0,0);
  w:=Width;
  h:=Height;
  while w<cx do
  begin
    BitBlt(memDC,w,0,w*2,cy,memDC,0,0,SRCCOPY);
    Inc(w,w);
  end;
  while h<cy do
  begin
    BitBlt(memDC,0,h,w,h*2,memDC,0,0,SRCCOPY);
    Inc(h,h);
  end;
  BitBlt(hDst,x,y,cx,cy,memDC,0,0,SRCCOPY);
  DeleteDC(memDC);
  DeleteObject(hBmp);
end;

procedure TksBmp.TileDrawTransparent(CT: TCanvas; x,y,cx,cy:Integer; TransColor: TColor);
var
  Bitmap: Graphics.TBitmap;
  SaveIndex: integer;
begin
  try
    SaveIndex := SaveDC(CT.Handle);

    Bitmap := Graphics.TBitmap.Create;
    try
      Bitmap.Width := cx;
      Bitmap.Height := cy;
      TileDraw(Bitmap.Canvas.Handle, 0, 0, cx, cy);
      Bitmap.TransparentColor := TransColor;
      Bitmap.Transparent := true;
      CT.Draw(x, y, Bitmap);
    finally
      Bitmap.Free;
    end;
  finally
    RestoreDC(CT.Handle, SaveIndex);
  end;
end;

procedure TksBmp.Resize(Dst:TksBmp);
var
xCount,
yCount,
x,y,xP,yP,
xD,yD,
yiScale,
xiScale:  Integer;
xScale,
yScale:   Single;
Read,
Line:     PLine;
Tmp:      TEColor;
pc:       PEColor;
begin
  if(Dst.Width=0)or(Dst.Height=0)then Exit;
  if(Dst.Width=Width)and(Dst.Height=Height)then
  begin
    CopyMemory(Dst.Bits,Bits,Size);
    Exit;
  end;

  xScale:=Dst.Width/Width;
  yScale:=Dst.Height/Height;
  if(xScale<1)or(yScale<1)then
  begin  // shrinking
    xiScale:=(Width shl 16) div Dst.Width;
    yiScale:=(Height shl 16) div Dst.Height;
    yP:=0;
    for y:=0 to Dst.Height-1 do
    begin
      xP:=0;
      read:=Pixels[yP shr 16];
      pc:=@Dst.Pixels[y,0];
      for x:=0 to Dst.Width-1 do
      begin
        pc^:=Read[xP shr 16];
        Inc(pc);
        Inc(xP,xiScale);
      end;
      Inc(yP,yiScale);
    end;
  end
  else   // expanding
  begin
    yiScale:=Round(yScale+0.5);
    xiScale:=Round(xScale+0.5);
    GetMem(Line,Dst.Width*3);
    for y:=0 to Height-1 do
    begin
      yP:=Trunc(yScale*y);
      Read:=Pixels[y];
      for x:=0 to Width-1 do
      begin
        xP:=Trunc(xScale*x);
        Tmp:=Read[x];
        for xCount:=0 to xiScale-1 do
        begin
          xD:=xCount+xP;
          if xD>=Dst.Width then Break;
          Line[xD]:=Tmp;
        end;
      end;
      for yCount:=0 to yiScale-1 do
      begin
        yD:=yCount+yP;
        if yD>=Dst.Height then Break;
        CopyMemory(Dst.Pixels[yD],Line,Dst.Width*3);
      end;
    end;
    FreeMem(Line);
  end;
end;

procedure TksBmp.CopyRect1(Dst: TksBmp; R: TRect; x, y: Integer);
begin
  CopyRect(Dst, x, y, R.left, R.top, R.right-R.left+1, R.bottom-R.top+1);
end;

procedure TksBmp.CopyRect(Dst:TksBmp;x,y,sx,sy,cx,cy:Integer);
var
n1,n2: Pointer;
i:     Integer;
begin
  if Pixels = nil then Exit;

  if cy+sy>Height    then cy:=cy-((cy+sy)-Height);
  if cx+sx>Width     then cx:=cx-((cx+sx)-Width);
  if cy+y>Dst.Height then cy:=cy-((cy+y)-Dst.Height);
  if cx+x>Dst.Width  then cx:=cx-((cx+x)-Dst.Width);

  n1:=@Dst.Pixels[y,x];
  n2:=@Pixels[sy,sx];
  for i:=0 to cy-1 do
  begin
    CopyMemory(n1,n2,cx*3);
    n1:=Pointer(Integer(n1)+Dst.RowInc);
    n2:=Pointer(Integer(n2)+RowInc);
  end;
end;

procedure TksBmp.Tile(Dst: TksBmp);
var
w,h,cy,cx: Integer;
begin
  CopyRect(Dst,0,0,0,0,Width,Height);
  w:=Width;      h:=Height;
  cx:=Dst.Width; cy:=Dst.Height;
  while w<cx do
  begin
    Dst.CopyRect(Dst,w,0,0,0,w*2,cy);
    Inc(w,w);
  end;
  while h<cy do
  begin
    Dst.CopyRect(Dst,0,h,0,0,w,h*2);
    Inc(h,h);
  end;
end;

function TksBmp.GetBottomNotTrans(V: integer; TransColor: TColor): integer;
var
  i: integer;
begin
  Result := 0;
  for i := Height-1 downto 0 do
    if (Pixels[i, V].r <> $FF) and
       (Pixels[i, V].g <> 0) and
       (Pixels[i, V].b <> $FF)
    then
    begin
      Result := Height - i - 1;
      Exit;
    end;
end;

function TksBmp.GetLeftNotTrans(V: integer; TransColor: TColor): integer;
var
  i: integer;
begin
  Result := 0;
  for i := 0 to Width-1 do
    if (Pixels[V, i].r <> $FF) and
       (Pixels[V, i].g <> 0) and
       (Pixels[V, i].b <> $FF)
    then
    begin
      Result := i;
      Exit;
    end;
end;

function TksBmp.GetRightNotTrans(V: integer; TransColor: TColor): integer;
var
  i: integer;
begin
  Result := Width;
  for i := Width-1 downto 0 do
    if (Pixels[V, i].r <> $FF) and
       (Pixels[V, i].g <> 0) and
       (Pixels[V, i].b <> $FF)
    then
    begin
      Result := Width - i - 1;
      Exit;
    end;
end;

function TksBmp.GetTopNotTrans(V: integer; TransColor: TColor): integer;
var
  i: integer;
begin
  Result := 0;
  for i := 0 to Height-1 do
    if (Pixels[i, V].r <> $FF) and
       (Pixels[i, V].g <> 0) and
       (Pixels[i, V].b <> $FF)
    then
    begin
      Result := i;
      Exit;
    end;
end;

procedure TksBmp.StretchLinear(hDC, x, y, cx, cy: Integer);
var
  Copy: TksBmp;
begin
  Copy := TksBmp.Create(cx, cy);
//  Bilinear(Self, Copy);
  Copy.Draw(hDC, x, y);
end;

{ Regions =====================================================================}

function CreateRgnDataFromBitmapRect(FB: TksBmp; var RgnData: PRgnData;
  X, Y: integer; R: TRect; TransColor: TColor): integer;
{
  X, Y - position in window
  R - rect in bitmap
}
const
  max    = 10000;
var
  j, i, i1: integer;
  C: TEColor;
  Rts: array [0..max] of TRect;
  Count: integer;
  TrColor: TEColor;
begin
  Result := 0;
  TrColor := ColorToEColor(TransColor);
  if FB.Width = 0 then Exit;
  Count := 0;
  for j := R.top to R.bottom-1 do
  begin
    i := R.left-1;
    while i < R.right-1 do
    begin
      repeat
        Inc(i);
        C := TEColor(FB.Pixels[j, i]);
        if i >= R.right then Break;
      until not ((C.R = TrColor.R) and (C.G = TrColor.G) and (C.B = TrColor.B));
      if i >= R.right then Break;
      i1 := i;
      repeat
        Inc(i1);
        If (i1 >= R.right) or (i1 >= FB.Width) Then Break;
        C := TEColor(FB.Pixels[j, i1]);
      until (C.R = TrColor.R) and (C.G = TrColor.G) and (C.B = TrColor.B);
      if i <> i1 then
      begin
        Rts[Count] := Rect(X+i, Y+j, X+i1, Y+j+1);
        OffsetRect(Rts[Count], -R.left, -R.top);
        Inc(Count);
      end;
      i := i1;
    end;
  end;
  // Make Region data
  Result := Count*SizeOf(TRect);
  GetMem(Rgndata, SizeOf(TRgnDataHeader)+Result);
  FillChar(Rgndata^, SizeOf(TRgnDataHeader)+Result, 0);
  RgnData^.rdh.dwSize := SizeOf(TRgnDataHeader);
  RgnData^.rdh.iType := RDH_RECTANGLES;
  RgnData^.rdh.nCount := Count;
  RgnData^.rdh.nRgnSize := 0;
  RgnData^.rdh.rcBound := Rect(0, 0, FB.Width, FB.Height);
  // Update New Region
  Move(Rts, RgnData^.Buffer, Result);
  Result := SizeOf(TRgnDataHeader)+Count*SizeOf(TRect);
end;

function CreateRgnDataFromBitmap(FB: TksBmp; var RgnData: PRgnData; TransColor: TColor): integer;
begin
  Result := CreateRgnDataFromBitmapRect(FB, RgnData, 0, 0,
    Rect(0, 0, FB.Width, FB.Height), TransColor);
end;

function CreateRgnFromBitmap(FB: TksBmp; TransColor: TColor): HRgn;
var
  RgnData: PRgnData;
  Size: integer;
begin
  RgnData := nil;
  Size := CreateRgnDataFromBitmap(FB, RgnData, TransColor);
  if Size <> 0 then
  begin
    Result := ExtCreateRegion(nil, Size, RgnData^);
    FreeMem(RgnData, Size);
  end;
end;

function CreateOffsetRgnFromBitmap(FB: TksBmp; X, Y: integer; TransColor: TColor): HRgn;
var
  RgnData: PRgnData;
  Size: integer;
begin
  RgnData := nil;
  Size := CreateRgnDataFromBitmapRect(FB, RgnData, X, Y,
    Rect(0, 0, FB.Width, FB.Height), TransColor);
  if Size <> 0 then
  begin
    Result := ExtCreateRegion(nil, Size, RgnData^);
    FreeMem(RgnData, Size);
  end;
end;

function CreateOffsetRgnFromBitmapRect(FB: TksBmp; X, Y: integer; R: TRect; TransColor: TColor): HRgn;
// R - in bitmap
var
  RgnData: PRgnData;
  Size: integer;
begin
  RgnData := nil;
  Size := CreateRgnDataFromBitmapRect(FB, RgnData, X, Y, R, TransColor);
  if Size <> 0 then
  begin
    Result := ExtCreateRegion(nil, Size, RgnData^);
    FreeMem(RgnData, Size);
  end;
end;

function CreateRgnFromBitmapRect(FB: TksBmp; BitmapRect: TRect; TransColor: TColor): HRgn;
var
  RgnData: PRgnData;
  Size: integer;
begin
  RgnData := nil;
  Size := CreateRgnDataFromBitmapRect(FB, RgnData, 0, 0, BitmapRect, TransColor);
  if Size <> 0 then
  begin
    Result := ExtCreateRegion(nil, Size, RgnData^);
    FreeMem(RgnData, Size);
  end;
end;

{ TEffectThread }

{ Effects =====================================================================}

procedure FadeRect(Result, Source, Dest: TksBmp; Kf: Double;
  Rct: TRect; StartX, StartY: Integer);
var
  x,y,x1,y1,r,g,b: Integer;
  Line, L: PLine;
begin
  y1 := StartY;
  for y := Rct.Top to Rct.Bottom do
  begin
    Line := Source.Pixels[y];
    L := Dest.Pixels[y1];
    x1 := StartX;
    for x := Rct.Left to Rct.Right do
    begin
      r := Round(Line^[x].r * (1 - kf) + L^[x1].r * kf);
      g := Round(Line^[x].g * (1 - kf) + L^[x1].g * kf);
      b := Round(Line^[x].b * (1 - kf) + L^[x1].b * kf);
      if r > 255 then r := 255 else if r < 0 then r := 0;
      if g > 255 then g := 255 else if g < 0 then g := 0;
      if b > 255 then b := 255 else if b < 0 then b := 0;
      Line^[x].r := r;
      Line^[x].g := g;
      Line^[x].b := b;
      Inc(x1);
    end;
    Move(Line^, Result.Pixels[y]^, Source.Width*3);;
    Inc(y1);
  end;
end;

procedure Fade(Result, Source, Dest: TksBmp; Kf: Double);
begin
  if (Source.Width <> Dest.Width) or (Source.Height <> Dest.Height) then Exit;
  if Kf < 0 then Kf := 0;
  if Kf > 1 then Kf := 1;

  FadeRect(Result, Source, Dest, Kf, Rect(0, 0, Source.Width-1, Source.Height-1),
    0, 0);
end;

procedure Slide(Result, Source, Dest: TksBmp; Kf: Double);
var
  i, j: integer;
begin
  if (Source.Width <> Dest.Width) or (Source.Height <> Dest.Height) then Exit;

  if kf < 0 then kf := 0;
  if kf > 1 then kf := 1;

  Source.Draw(Result.hDC, 0, 0);

end;

end.

unit resimyazi;

interface

uses
  Windows, Classes, Graphics, Controls;

type
  Tresimyazim = class(TGraphicControl)
  private
   Fresim  : TBitmap;
   Fyazi : String;
   Fharf:byte;
   fdus:byte;
   fmaskerengi:tcolor;
   procedure Setyazi(const AValue : string);
   procedure Setharf(Value : byte);
   procedure Setdus(Value : byte);
   procedure Setresim(Value: TBitmap);
   procedure SetTransparent(Value: Boolean);
   function GetTransparent: Boolean;
   function GetBitmap: TBitmap;
   procedure SetMaskerengi(const Value: TColor);
   protected
   procedure Setname(const Value: TComponentName); override;

  public
    constructor Create(AOwner : TComponent); override;
    destructor  Destroy; override;
    procedure   Paint; override;
  published
    property Yazi : string read Fyazi write Setyazi;
    property Harfaraligi : byte read Fharf write Setharf;
    property Dusulecek : byte read Fdus write Setdus;
    property resim :TBitmap read GetBitmap write Setresim;
    property Transparent: Boolean read GetTransparent write SetTransparent default True;
    property Maskerengi:Tcolor read fmaskerengi write SetMaskerengi default clblack;
    property Enabled;
    property ShowHint;
    property Visible;
    property Height;
    property Width;
    property OnClick;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
  end;
 procedure Register;
implementation
uses math;
procedure Register;
begin
  RegisterComponents('Onur', [Tresimyazim]);
end;
constructor Tresimyazim.Create(AOwner: TComponent);
begin
  inherited;
  Width := 32;
  Height := 10;
  FHarf:=16;
  fdus:=32;
 fmaskerengi:=clblack;
  ControlStyle := ControlStyle + [csSetCaption];
end;

destructor Tresimyazim.Destroy;
begin
  Fresim.Free;
  inherited;
end;
procedure Tresimyazim.SetTransparent(Value: Boolean);
begin
  if Fresim = nil then Exit;
  if (Value <> Fresim.Transparent) then
    Fresim.Transparent := Value;
end;
procedure Tresimyazim.Setmaskerengi(const Value: TColor);
begin
if Value <> fmaskerengi then begin
fmaskerengi:= Value;     Invalidate; end;
end;

function Tresimyazim.GetTransparent: Boolean;
begin
  if Fresim = nil then
    Result := False
  else
    Result := Fresim.Transparent;
end;

procedure Tresimyazim.Setresim(Value: TBitmap);
begin
  if Fresim = nil then
  begin
    Fresim := TBitmap.Create;
  //  Fresim.Transparent := True;
  end;
{  if Value = nil then
    Fresim.Free
  else}
    Fresim.Assign(Value);
end;

function Tresimyazim.GetBitmap: TBitmap;
begin
  if Fresim = nil then
  begin
    Fresim := TBitmap.Create;
    Fresim.Transparent := True;
  end;
  Result := Fresim;
end;
procedure Tresimyazim.Paint;
var CH : char;
SrcRect, DstRect: TRect;
k,i: Integer;
begin
  inherited;
if resim = nil then exit else
//  Height:=Fresim.Height;
  Fresim.TransparentColor:=fmaskerengi;
//  Width :=fharf *Length(Fyazi);  //resim boyuTU
  for i :=1 to Length(Fyazi) do
   begin
     if Fyazi[i] < ' ' then
      ch := ' ' else
       ch := Fyazi[i];
     K := ord(ch) - fdus;
    case ch of
{    'a':k:=1;    'b':k:=2;
    'c':k:=3;    'ç':k:=4;
    'd':k:=5;    'e':k:=6;
    'f':k:=7;    'g':k:=8;
    'ð':k:=9;    'h':k:=10;
    'ý':k:=11;    'i':k:=12;
    'j':k:=13;    'k':k:=14;
    'l':k:=15;    'm':k:=16;
    'n':k:=17;    'o':k:=18;
    'ö':k:=19;    'p':k:=20;
    'r':k:=21;    'q':k:=22;
    's':k:=23;    'þ':k:=24;
    't':k:=25;    'u':k:=26;
    'ü':k:=27;    'v':k:=28;
    'w':k:=29;    'x':k:=30;
    'y':k:=31;    'z':k:=32;
    '&':k:=33;    '%':k:=34;
    '(':k:=35;    ')':k:=36;
    '[':k:=37;    ']':k:=38;
    '=':k:=39;    '-':k:=40;
    '_':k:=41;     '+':k:=42;
    '/':k:=43;    ' ':k:=44;
    ':':k:=45;     '0':k:=46;
    '1':k:=47;     '2':k:=48;
    '3':k:=49;     '4':k:=50;
    '5':k:=51;     '6':k:=52;
    '7':k:=53;     '8':k:=54;
    '9':k:=55;    '.':k:=56;
    ',':k:=57;       '<':k:=58;
    '>':k:=59;       '*':k:=60;  }

    'Ç':k:=35;//64
    'Ð':k:=39;//65
    'Ý':k:=41;//66
    'Ö':k:=47;//67
    'Þ':k:=51;//68
    'Ü':k:=53;//69
    end;
SrcRect := Rect(k*Fharf ,0, k*Fharf + Fharf,20);
DstRect := Rect((i-1)* Fharf, 0, (i-1)*Fharf + Fharf ,20);
Canvas.CopyRect(DstRect, Fresim.Canvas, SrcRect);
end;


end;
Function Buyut(Yazim:string):string;
var
Harfim:char;
Sayim:Byte;
begin
for Sayim:=1 to length(yazim) do
begin
Harfim:=Yazim[sayim];
Case Harfim of
'a'..'h','j'..'z':Harfim:=Chr(Ord(Harfim)-32);
'ö':Harfim:='Ö';
'ð':Harfim:='Ð';
'ü':Harfim:='Ü';
'þ':Harfim:='Þ';
'i':Harfim:='Ý';
'ý':Harfim:='I';
'ç':Harfim:='Ç';
end;
Yazim[Sayim]:=Harfim;
end;
Buyut:=Yazim;
end;

procedure Tresimyazim.Setyazi(const AValue: string);
begin
  if AValue <> Fyazi then
   begin
    Fyazi :=Buyut(AValue);
    Invalidate;
   end;
end;

procedure Tresimyazim.Setname(const Value: TComponentName);
begin
  inherited;
  yazi := Value;
end;
procedure Tresimyazim.Setdus(Value: byte);
begin
if Value <> fdus then
begin
fdus := Value;
Invalidate;
end;end;
procedure Tresimyazim.Setharf(Value: byte);
begin
if Value <> Fharf then
begin
Fharf := Value;
Invalidate;
end;
end;
end.

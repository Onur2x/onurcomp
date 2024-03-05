unit oizleme;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
   StdCtrls, ExtCtrls, panelresim,resim,SkinIniFiles;

type
  TForm2 = class(TForm)
    ana: TResimPanel;
    transparent: TLabel;
    secili: TLabel;
    sayi: TLabel;
    o1: TResimPanel;
    o2: TResimPanel;
    o3: TResimPanel;
    o4: TResimPanel;
    o5: TResimPanel;
    o6: TResimPanel;
    o7: TResimPanel;
    o8: TResimPanel;
    o9: TResimPanel;
    o10: TResimPanel;
    o11: TResimPanel;
    o12: TResimPanel;
    o13: TResimPanel;
    o14: TResimPanel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;
   p:String;
   i: byte;

   const
Sign = 'MoonAndStar Skin Dosyasý';
Suyari='Lütfen Bu Dosyada Hiç Bir Deðiþiklik Uygulamayýn Aksi Halde Skin Dosyasýný Çalýþtýramazsýnýz';
sImagesSection= 'Resimler';
RE='onur.Msd';

implementation

uses Unit1;

{$R *.dfm}

function izal(var S: string): string;
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
function ExtractTileStyle(S: string):TStil;
begin
  Result := ortala;
  if LowerCase(S) = 'Ortala' then Result := Ortala;
  if LowerCase(S) = 'Normal' then Result := Normal;
  if LowerCase(S) = 'Döþe' then Result := dose;
end;

function ExtractColor(S: string): TColor; // extract color from 0,0,0 string
var
  R, G, B: byte;
begin
  R := StrToInt(izal(S));
  G := StrToInt(izal(S));
  B := StrToInt(izal(S));
  Result := RGB(R, G, B);
end;

function GetImage(Images: TList; Name: string): TksBmp;
var
  i: integer;
begin
  for i := 0 to Images.Count-1 do
    if LowerCase(TksBmp(Images[i]).Name) = LowerCase(Name) then
    begin
      Result := Images[i];
      Exit;
    end;
  Result := nil;
end;
function ExtractImage(SourceImage: TksBmp; S: string): TksBmp;
var
  R: TRect;
  str: string;
begin
 if S = '' then
  begin
    Result := SourceImage.GetCopy;
  end
  else
  begin
    // Load rectangle
    try
      R := Rect(0, 0, SourceImage.Width, SourceImage.Height);
      str := izal(S);
      if str <> '' then R.left := StrToInt(str);
      str := izal(S);
      if str <> '' then R.top := StrToInt(str);
      str := izal(S);
      if str <> '' then R.right := StrToInt(str);
      str := izal(S);
      if str <> '' then R.bottom := StrToInt(str);

      Result := TksBmp.Create(R.right-R.left+1, R.bottom-R.top+1);
      SourceImage.CopyRect1(Result, R, 0, 0);
      Result.Rect := R;
    except
    end;
  end;
  end;



end.

unit onurskin;

{$mode objfpc}{$H+}

interface

uses
  Classes, Controls, ExtCtrls, Windows, SysUtils, Graphics, fpjson, jsonparser,
  BGRABitmap, BGRABitmapTypes,
  Zipper, types;

type
  // Animasyon Tipleri

  TONURAnimationType = (oatNone, oatFade, oatSlide, oatScale, oatPulse, oatCustom);
  // Easing Fonksiyonları
  TONURAnimationEasing = (
    oaeLinear,        // Sabit hız
    oaeEaseIn,        // Yavaş başla, hızlan
    oaeEaseOut,       // Hızlı başla, yavaşla
    oaeEaseInOut      // Yavaş başla, yavaş bitir
    );



  { TONURAnimation }
  // Genel animasyon sınıfı
  TONURAnimation = class
  private
    FDuration: integer;      // Animasyon süresi (ms)
    FStartTime: QWord;       // Başlangıç zamanı
    FAnimationType: TONURAnimationType;
    FEasing: TONURAnimationEasing;
    FOnComplete: TNotifyEvent;
    FTag: integer;           // Özel kullanım için
    function ApplyEasing(Progress: single): single;
  public
    constructor Create(AType: TONURAnimationType; ADuration: integer;
      AEasing: TONURAnimationEasing = oaeEaseOut);

    function GetProgress: single;  // 0.0 - 1.0 arası ilerleme
    function GetEasedProgress: single; // Easing uygulanmış ilerleme
    function IsFinished: boolean;
    procedure Reset;

    property AnimationType: TONURAnimationType read FAnimationType;
    property Duration: integer read FDuration write FDuration;
    property Easing: TONURAnimationEasing read FEasing write FEasing;
    property Tag: integer read FTag write FTag;
    property OnComplete: TNotifyEvent read FOnComplete write FOnComplete;
  end;

  { TONURSkinPart }
  // Bir bileşenin tek bir parçasını temsil eder (Örn: Button -> Hover)
  TONURSkinPart = class
  private
    FName: string;
    FRect: TRect; // Atlas üzerindeki koordinat
    FMargin: TRect; // 9-slice scaling için (Left, Top, Right, Bottom)
    FCachedBitmap: TBGRABitmap; // Kesilmiş ve önbelleğe alınmış resim
  public
    constructor Create(AName: string);
    destructor Destroy; override;

    property Name: string read FName;
    property Rect: TRect read FRect write FRect;
    property Margin: TRect read FMargin write FMargin;
    property CachedBitmap: TBGRABitmap read FCachedBitmap write FCachedBitmap;
  end;

  { TONURSkinElement }
  // Bir bileşeni temsil eder (Örn: Button, ScrollBar)
  // İçinde birden fazla parça barındırır (Normal, Hover, Pressed vb.)
  TONURSkinElement = class
  private
    FName: string;
    FParts: TStringList; // TONURSkinPart listesi
    function GetPart(PartName: string): TONURSkinPart;
  public
    constructor Create(AName: string);
    destructor Destroy; override;

    procedure AddPart(APart: TONURSkinPart);
    property Name: string read FName;
    property Parts[PartName: string]: TONURSkinPart read GetPart; default;
  end;

  { TONURSkinManager }
  // Skin sistemini yöneten ana bileşen
  TONURSkinManager = class(TComponent)
  private
    FAtlas: TBGRABitmap; // Tüm skin resimlerini içeren büyük resim
    FElements: TStringList; // TONURSkinElement listesi
    FControls: TList; // Bağlı kontrollerin listesi
    FSkinName: string;
    FAuthor: string;
    FVersion: string;

    procedure ClearSkin;
    function MarginFromString(const AStr: string): TRect;
    procedure ParseJSON(JSONData: TJSONData);
    function RectFromString(S: string): TRect;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    // Kontrol Kayıt
    procedure RegisterControl(AControl: TControl);
    procedure UnRegisterControl(AControl: TControl);
    procedure NotifyControls;

    // Skin Yükleme
    procedure LoadSkinFromFile(FileName: string); // .osk (ZIP) dosyasından yükle
    procedure LoadSkinFromStream(Stream: TStream);

    // Skin Kullanımı
    function GetPart(ElementName, PartName: string): TONURSkinPart;
    function GetBitmap(ElementName, PartName: string): TBGRABitmap;
    // Doğrudan bitmap döner (Cache veya Crop)

    property SkinName: string read FSkinName;
    property Author: string read FAuthor;
    property Version: string read FVersion;
  end;

  { TONURSkinGraphicControl }
  // TGraphicControl tabanlı skinli bileşenler için base sınıf
  TONURSkinGraphicControl = class(TGraphicControl)
  private
    FSkinManager: TONURSkinManager;
    FSkinElement: string;
    FAnimation: TONURAnimation;
    FAnimationTimer: TTimer;
    procedure OnAnimationTimer(Sender: TObject);
    procedure SetSkinManager(AValue: TONURSkinManager);
    procedure SetSkinElement(AValue: string);
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    // Yardımcı çizim metodu
    function DrawPart(PartName: string; TargetCanvas: TCanvas;
      TargetRect: TRect; Alpha: byte = 255): boolean; overload;
    function DrawPart(PartName: string; TargetBitmap: TBGRABitmap;
      TargetRect: TRect; Alpha: byte = 255): boolean; overload;
    procedure AnimationTick(Sender: TObject); virtual;
    procedure StartAnimation(AType: TONURAnimationType; ADuration: integer;
      AEasing: TONURAnimationEasing = oaeEaseOut); virtual;
    procedure StopAnimation; virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property Animation: TONURAnimation read FAnimation;
  published
    property SkinManager: TONURSkinManager read FSkinManager write SetSkinManager;
    property SkinElement: string read FSkinElement write SetSkinElement;
  end;

  { TONURSkinCustomControl }
  // TCustomControl tabanlı skinli bileşenler için base sınıf
  TONURSkinCustomControl = class(TCustomControl)
  private
    FSkinManager: TONURSkinManager;
    FSkinElement: string;
    FAnimation: TONURAnimation;
    FAnimationTimer: TTimer;
    procedure OnAnimationTimer(Sender: TObject);
    procedure SetSkinManager(AValue: TONURSkinManager);
    procedure SetSkinElement(AValue: string);
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    // Yardımcı çizim metodu
    function DrawPart(PartName: string; TargetCanvas: TCanvas;
      TargetRect: TRect; Alpha: byte = 255): boolean; overload;
    function DrawPart(PartName: string; TargetBitmap: TBGRABitmap;
      TargetRect: TRect; Alpha: byte = 255): boolean; overload;
    procedure AnimationTick(Sender: TObject); virtual;
    procedure StartAnimation(AType: TONURAnimationType; ADuration: integer;
      AEasing: TONURAnimationEasing = oaeEaseOut); virtual;
    procedure StopAnimation; virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property Animation: TONURAnimation read FAnimation;
  published
    property SkinManager: TONURSkinManager read FSkinManager write SetSkinManager;
    property SkinElement: string read FSkinElement write SetSkinElement;
  end;

procedure Register;
function RegionFromBGRABitmap(const ABMP: TBGRABitmap): HRGN;

implementation

procedure Register;
begin
  RegisterComponents('ONUR Base', [TONURSkinManager]);
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

// 9-Slice (NinePatch) çizim yardımcı metodu
procedure Draw9Slice(Source: TBGRABitmap; Target: TBGRABitmap;
  TargetRect: TRect; Margin: TRect; Alpha: byte = 255);
var
  SrcW, SrcH, DstW, DstH: integer;
  ML, MT, MR, MB: integer; // Margin Left, Top, Right, Bottom
begin
  SrcW := Source.Width;
  SrcH := Source.Height;
  DstW := TargetRect.Width;
  DstH := TargetRect.Height;

  ML := Margin.Left;
  MT := Margin.Top;
  MR := Margin.Right;
  MB := Margin.Bottom;

  // Eğer margin yoksa, normal stretch yap
  if (ML = 0) and (MT = 0) and (MR = 0) and (MB = 0) then
  begin
    Target.StretchPutImage(TargetRect, Source, dmDrawWithTransparency, Alpha);
    Exit;
  end;

  // 9 Parça:
  // 1. Sol Üst Köşe (sabit)
  Target.PutImage(TargetRect.Left, TargetRect.Top,
    Source.GetPart(Rect(0, 0, ML, MT)) as TBGRABitmap, dmDrawWithTransparency, Alpha);

  // 2. Sağ Üst Köşe (sabit)
  Target.PutImage(TargetRect.Right - MR, TargetRect.Top,
    Source.GetPart(Rect(SrcW - MR, 0, SrcW, MT)) as TBGRABitmap,
    dmDrawWithTransparency, Alpha);

  // 3. Sol Alt Köşe (sabit)
  Target.PutImage(TargetRect.Left, TargetRect.Bottom - MB,
    Source.GetPart(Rect(0, SrcH - MB, ML, SrcH)) as TBGRABitmap,
    dmDrawWithTransparency, Alpha);

  // 4. Sağ Alt Köşe (sabit)
  Target.PutImage(TargetRect.Right - MR, TargetRect.Bottom - MB,
    Source.GetPart(Rect(SrcW - MR, SrcH - MB, SrcW, SrcH)) as
    TBGRABitmap, dmDrawWithTransparency, Alpha);

  // 5. Üst Kenar (yatay uzar)
  Target.StretchPutImage(Rect(TargetRect.Left + ML, TargetRect.Top,
    TargetRect.Right - MR, TargetRect.Top + MT),
    Source.GetPart(Rect(ML, 0, SrcW - MR, MT)) as TBGRABitmap,
    dmDrawWithTransparency, Alpha);

  // 6. Alt Kenar (yatay uzar)
  Target.StretchPutImage(Rect(TargetRect.Left + ML, TargetRect.Bottom - MB,
    TargetRect.Right - MR, TargetRect.Bottom),
    Source.GetPart(Rect(ML, SrcH - MB, SrcW - MR, SrcH)) as TBGRABitmap,
    dmDrawWithTransparency, Alpha);

  // 7. Sol Kenar (dikey uzar)
  Target.StretchPutImage(Rect(TargetRect.Left, TargetRect.Top + MT,
    TargetRect.Left + ML, TargetRect.Bottom - MB),
    Source.GetPart(Rect(0, MT, ML, SrcH - MB)) as TBGRABitmap,
    dmDrawWithTransparency, Alpha);

  // 8. Sağ Kenar (dikey uzar)
  Target.StretchPutImage(Rect(TargetRect.Right - MR, TargetRect.Top +
    MT, TargetRect.Right, TargetRect.Bottom - MB),
    Source.GetPart(Rect(SrcW - MR, MT, SrcW, SrcH - MB)) as TBGRABitmap,
    dmDrawWithTransparency, Alpha);

  // 9. Merkez (her iki yönde uzar)
  Target.StretchPutImage(Rect(TargetRect.Left + ML, TargetRect.Top +
    MT, TargetRect.Right - MR, TargetRect.Bottom - MB),
    Source.GetPart(Rect(ML, MT, SrcW - MR, SrcH - MB)) as TBGRABitmap,
    dmDrawWithTransparency, Alpha);
end;

{ TONURSkinPart }

constructor TONURSkinPart.Create(AName: string);
begin
  FName := AName;
  FCachedBitmap := nil;
  FRect := types.Rect(0, 0, 0, 0);
  FMargin := types.Rect(0, 0, 0, 0);
end;

destructor TONURSkinPart.Destroy;
begin
  if Assigned(FCachedBitmap) then FreeAndNil(FCachedBitmap);
  inherited Destroy;
end;

{ TONURSkinElement }

constructor TONURSkinElement.Create(AName: string);
begin
  FName := AName;
  FParts := TStringList.Create;
  FParts.OwnsObjects := True; // Listeyi silince partları da sil
end;

destructor TONURSkinElement.Destroy;
begin
  FreeAndNil(FParts);
  inherited Destroy;
end;

procedure TONURSkinElement.AddPart(APart: TONURSkinPart);
begin
  FParts.AddObject(APart.Name, APart);
end;

function TONURSkinElement.GetPart(PartName: string): TONURSkinPart;
var
  Index: integer;
begin
  Index := FParts.IndexOf(PartName);
  if Index >= 0 then
    Result := TONURSkinPart(FParts.Objects[Index])
  else
    Result := nil;
end;

{ TONURSkinManager }

constructor TONURSkinManager.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FElements := TStringList.Create;
  FElements.OwnsObjects := True;
  FControls := TList.Create;
  FAtlas := nil;
end;

destructor TONURSkinManager.Destroy;
begin
  ClearSkin;
  FreeAndNil(FElements);
  FreeAndNil(FControls);
  inherited Destroy;
end;

procedure TONURSkinManager.RegisterControl(AControl: TControl);
begin
  if FControls.IndexOf(AControl) < 0 then
    FControls.Add(AControl);
end;

procedure TONURSkinManager.UnRegisterControl(AControl: TControl);
begin
  if Assigned(AControl) then
    FControls.Remove(AControl);
end;

procedure TONURSkinManager.NotifyControls;
var
  I: integer;
begin
  for I := 0 to FControls.Count - 1 do
  begin
    TControl(FControls[I]).Invalidate;
    // writeln(TControl(FControls[I]).name,'   OK');
  end;
end;

procedure TONURSkinManager.ClearSkin;
begin
  FElements.Clear;
  if Assigned(FAtlas) then FreeAndNil(FAtlas);
  FSkinName := '';
  FAuthor := '';
  FVersion := '';
  //FAtlasFileName := '';
end;

{
function TONURSkinManager.RectFromString(S: string): TRect;
var
  Parts: TStringList;
begin
  Result := Rect(0, 0, 0, 0);
  Parts := TStringList.Create;
  try
    Parts.Delimiter := ',';
    Parts.StrictDelimiter := True;
    Parts.DelimitedText := S;
    if Parts.Count >= 4 then
      Result := Rect(StrToIntDef(Parts[0], 0), StrToIntDef(Parts[1], 0),
        StrToIntDef(Parts[0], 0) + StrToIntDef(Parts[2], 0), // X + Width
        StrToIntDef(Parts[1], 0) + StrToIntDef(Parts[3], 0)); // Y + Height
  finally
    Parts.Free;
  end;
end;

 procedure TONURSkinManager.ParseJSON(JSONData: TJSONData);
var
  Root, ElementsNode, ElementNode, PartsNode, PartNode: TJSONObject;
  MetaNode: TJSONObject;
  I, J: integer;
  ElemName, PartName: string;
  NewElement: TONURSkinElement;
  NewPart: TONURSkinPart;
  RectStr: string;
begin
  Root := TJSONObject(JSONData);

  // Meta Bilgileri

  NewElement := TONURSkinElement.Create(ElemName);
  FElements.AddObject(ElemName, NewElement);

  for J := 0 to ElementNode.Count - 1 do
  begin
    PartName := ElementNode.Names[J];
    if ElementNode.Items[J].JSONType = jtObject then
    begin
      PartNode := TJSONObject(ElementNode.Items[J]);

      // Eğer "rect" alanı varsa bu bir parçadır
      if PartNode.Find('rect') <> nil then
      begin
        NewPart := TONURSkinPart.Create(PartName);
        RectStr := PartNode.Get('rect', '0,0,0,0');
        NewPart.Rect := RectFromString(RectStr);
        // Padding vb. eklenebilir
        NewElement.AddPart(NewPart);
      end;
    end;
  end;

end;   }



procedure TONURSkinManager.ParseJSON(JSONData: TJSONData);
var
  Root, ElementNode, PartNode: TJSONObject;
  ElementsNode: TJSONData;
  I, J: integer;
  ElementName, PartName: string;
  NewElement: TONURSkinElement;
  NewPart: TONURSkinPart;
  RectStr, MarginStr: string;
  ElementData: TJSONData;
begin
  if not Assigned(JSONData) then
    raise Exception.Create('JSONData is nil');

  try
    Root := TJSONObject(JSONData);

    // Meta bilgilerini al
    FSkinName := Root.Get('name', '');
    FVersion := Root.Get('version', '');
    FAuthor := Root.Get('author', '');
    //    FDescription := Root.Get('description', '');
    //   FAtlas := Root.Get('atlas', '');

    // Elements düğümünü al
    ElementsNode := Root.Find('elements');
    if not Assigned(ElementsNode) or (ElementsNode.JSONType <> jtObject) then
      raise Exception.Create('Invalid or missing "elements" node in skin JSON');

    // Her element için
    for I := 0 to TJSONObject(ElementsNode).Count - 1 do
    begin
      ElementName := TJSONObject(ElementsNode).Names[I];
      ElementData := TJSONObject(ElementsNode).Items[I];

      if ElementData.JSONType = jtObject then
      begin
        ElementNode := TJSONObject(ElementData);
        NewElement := TONURSkinElement.Create(ElementName);

        try
          // Elementin altındaki parçaları işle
          for J := 0 to ElementNode.Count - 1 do
          begin
            PartName := ElementNode.Names[J];
            if ElementNode.Items[J].JSONType = jtObject then
            begin
              PartNode := TJSONObject(ElementNode.Items[J]);

              // Sadece rect özelliği olanları parça olarak ekle
              if PartNode.IndexOfName('rect') >= 0 then
              begin
                NewPart := TONURSkinPart.Create(PartName);
                try
                  // Rect değerini al
                  RectStr := PartNode.Get('rect', '0,0,0,0');
                  NewPart.Rect := RectFromString(RectStr);

                  // Margin değerini al (varsa)
                  if PartNode.IndexOfName('margin') >= 0 then
                  begin
                    MarginStr := PartNode.Get('margin', '0,0,0,0');
                    NewPart.Margin := MarginFromString(MarginStr);
                  end;

                  NewElement.AddPart(NewPart);
                except
                  NewPart.Free;
                  raise;
                end;
              end;
            end;
          end;

          // Elementi koleksiyona ekle
          FElements.AddObject(ElementName, NewElement);
        except
          NewElement.Free;
          raise;
        end;
      end;
    end;
  except
    on E: Exception do
      raise Exception.Create('Error parsing skin JSON: ' + E.Message);
  end;
end;

// Yardımcı fonksiyon: String'den TRect'e dönüşüm
function TONURSkinManager.RectFromString(S: string): TRect;
var
  Parts: TStringArray;
begin
  Parts := s.Split([',']);
  if Length(Parts) <> 4 then
    raise Exception.Create('Invalid rect format. Expected "left,top,width,height"');

  Result.Left := StrToIntDef(Trim(Parts[0]), 0);
  Result.Top := StrToIntDef(Trim(Parts[1]), 0);
  Result.Width := StrToIntDef(Trim(Parts[2]), 0);
  Result.Height := StrToIntDef(Trim(Parts[3]), 0);
end;

// Yardımcı fonksiyon: String'den TMargins'e dönüşüm
function TONURSkinManager.MarginFromString(const AStr: string): TRect;
var
  Parts: TStringArray;
begin
  Parts := AStr.Split([',']);
  if Length(Parts) = 4 then
  begin
    Result.Left := StrToIntDef(Trim(Parts[0]), 0);
    Result.Top := StrToIntDef(Trim(Parts[1]), 0);
    Result.Right := StrToIntDef(Trim(Parts[2]), 0);
    Result.Bottom := StrToIntDef(Trim(Parts[3]), 0);
  end
  else if Length(Parts) = 1 then
  begin
    // Tüm kenarlar aynı değer
    Result.Left := StrToIntDef(Trim(Parts[0]), 0);
    Result.Top := Result.Left;
    Result.Right := Result.Left;
    Result.Bottom := Result.Left;
  end
  else
  begin
    // Varsayılan değerler
    Result.Left := 0;
    Result.Top := 0;
    Result.Right := 0;
    Result.Bottom := 0;
  end;
end;



procedure TONURSkinManager.LoadSkinFromFile(FileName: string);
var
  UnZipper: TUnZipper;
  JSONStream, ImageStream: TMemoryStream;
  JSONData: TJSONData;
  Parser: TJSONParser;
begin
  if not FileExists(FileName) then Exit;

  ClearSkin;

  UnZipper := TUnZipper.Create;
  JSONStream := TMemoryStream.Create;
  ImageStream := TMemoryStream.Create;
  try
    UnZipper.FileName := FileName;
    UnZipper.OutputPath := GetTempDir + 'onurskin_temp' + PathDelim;
    ForceDirectories(UnZipper.OutputPath);
    UnZipper.UnZipAllFiles;

    // JSON Oku
    if FileExists(UnZipper.OutputPath + 'skin.json') then
    begin
      JSONStream.LoadFromFile(UnZipper.OutputPath + 'skin.json');
      JSONStream.Position := 0;
      Parser := TJSONParser.Create(JSONStream);
      try
        JSONData := Parser.Parse;
        ParseJSON(JSONData);
      finally
        Parser.Free;
        JSONData.Free;
      end;
      if FileExists(UnZipper.OutputPath + 'skin.png') then
        FAtlas := TBGRABitmap.Create(UnZipper.OutputPath + 'skin.png');
      //  writeln('OK');
    end;



    // Kontrolleri Güncelle
    NotifyControls;



  finally
    UnZipper.Free;
    JSONStream.Free;
    ImageStream.Free;
  end;
end;

procedure TONURSkinManager.LoadSkinFromStream(Stream: TStream);
begin
  // Stream'den ZIP okuma (İleri seviye)
  // Şimdilik boş
end;

function TONURSkinManager.GetPart(ElementName, PartName: string): TONURSkinPart;
var
  Index: integer;
  Element: TONURSkinElement;
begin
  Index := FElements.IndexOf(ElementName);
  if Index >= 0 then
  begin
    Element := TONURSkinElement(FElements.Objects[Index]);
    Result := Element.Parts[PartName];
  end
  else
    Result := nil;
end;

function TONURSkinManager.GetBitmap(ElementName, PartName: string): TBGRABitmap;
var
  Part: TONURSkinPart;
begin
  Result := nil;
  if FAtlas = nil then Exit;

  Part := GetPart(ElementName, PartName);
  if Part = nil then Exit;

  // Cache kontrolü
  if Part.CachedBitmap <> nil then
  begin
    Result := Part.CachedBitmap; // Referans dönüyoruz, çağıran kişi Free etmemeli!
    Exit;
  end;

  // Cache yoksa Atlas'tan kes
  if (Part.Rect.Width > 0) and (Part.Rect.Height > 0) then
  begin
    Part.CachedBitmap := FAtlas.GetPart(Part.Rect) as TBGRABitmap;
    Result := Part.CachedBitmap;
  end;
end;


{ TONURSkinGraphicControl }

constructor TONURSkinGraphicControl.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FSkinElement := '';
  FAnimation := nil;
  FAnimationTimer := TTimer.Create(Self);
  FAnimationTimer.Enabled := False;
  FAnimationTimer.Interval := 16; // ~60 FPS
  FAnimationTimer.OnTimer := @OnAnimationTimer;
end;

destructor TONURSkinGraphicControl.Destroy;
begin
  if FSkinManager <> nil then
    FSkinManager.UnRegisterControl(Self);

  StopAnimation; // Animasyonu durdur
  FreeAndNil(FAnimationTimer);
  inherited Destroy;
end;

procedure TONURSkinGraphicControl.SetSkinManager(AValue: TONURSkinManager);
begin
  if FSkinManager = AValue then Exit;

  if FSkinManager <> nil then
    FSkinManager.UnRegisterControl(Self);

  FSkinManager := AValue;

  if FSkinManager <> nil then
  begin
    FSkinManager.FreeNotification(Self);
    FSkinManager.RegisterControl(Self);
  end;

  Invalidate;
end;

procedure TONURSkinGraphicControl.SetSkinElement(AValue: string);
begin
  if FSkinElement = AValue then Exit;
  FSkinElement := AValue;
  Invalidate;
end;

procedure TONURSkinGraphicControl.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (AComponent = FSkinManager) then
  begin
    if FSkinManager <> nil then
      FSkinManager.UnRegisterControl(Self);
    FSkinManager := nil;
  end;
end;

function TONURSkinGraphicControl.DrawPart(PartName: string;
  TargetCanvas: TCanvas; TargetRect: TRect; Alpha: byte): boolean;
var
  Bmp: TBGRABitmap;
begin
  Result := False;
  if (FSkinManager = nil) or (FSkinElement = '') then Exit;

  Bmp := FSkinManager.GetBitmap(FSkinElement, PartName);
  if Bmp <> nil then
  begin
    // BGRACanvas üzerine çizim
    Result := True;
  end;
end;


function TONURSkinGraphicControl.DrawPart(PartName: string;
  TargetBitmap: TBGRABitmap; TargetRect: TRect; Alpha: byte): boolean;
var
  Bmp: TBGRABitmap;
  Part: TONURSkinPart; // EKLE
begin
  Result := False;
  if (FSkinManager = nil) or (FSkinElement = '') then Exit;

  Part := FSkinManager.GetPart(FSkinElement, PartName); // EKLE
  if Part = nil then Exit; // EKLE

  Bmp := Part.CachedBitmap; // DEĞİŞTİR
  if Bmp = nil then
  begin
    Bmp := FSkinManager.GetBitmap(FSkinElement, PartName);
    if Bmp = nil then Exit;
  end;

  Draw9Slice(Bmp, TargetBitmap, TargetRect, Part.Margin, Alpha); // DEĞİŞTİR
  Result := True;
end;

procedure TONURSkinGraphicControl.OnAnimationTimer(Sender: TObject);
begin
  if (FAnimation <> nil) and FAnimation.IsFinished then
  begin
    if Assigned(FAnimation.OnComplete) then
      FAnimation.OnComplete(Self);
    StopAnimation;
  end
  else
    AnimationTick(Sender);
end;

procedure TONURSkinGraphicControl.AnimationTick(Sender: TObject);
begin
  // Alt sınıflar override edecek
  Invalidate;
end;

procedure TONURSkinGraphicControl.StartAnimation(AType: TONURAnimationType;
  ADuration: integer; AEasing: TONURAnimationEasing);
begin
  StopAnimation;
  FAnimation := TONURAnimation.Create(AType, ADuration, AEasing);
  FAnimationTimer.Enabled := True;
end;

procedure TONURSkinGraphicControl.StopAnimation;
begin
  FAnimationTimer.Enabled := False;
  if FAnimation <> nil then
    FreeAndNil(FAnimation);
end;


{ TONURSkinCustomControl }

constructor TONURSkinCustomControl.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FSkinElement := '';
  FAnimation := nil;
  FAnimationTimer := TTimer.Create(Self);
  FAnimationTimer.Enabled := False;
  FAnimationTimer.Interval := 16; // ~60 FPS
  FAnimationTimer.OnTimer := @OnAnimationTimer;
end;

destructor TONURSkinCustomControl.Destroy;
begin
  if FSkinManager <> nil then
    FSkinManager.UnRegisterControl(Self);

  StopAnimation; // Animasyonu durdur
  FreeAndNil(FAnimationTimer);
  inherited Destroy;
end;



procedure TONURSkinCustomControl.SetSkinManager(AValue: TONURSkinManager);
begin
  if FSkinManager = AValue then Exit;

  if FSkinManager <> nil then
    FSkinManager.UnRegisterControl(Self);

  FSkinManager := AValue;

  if FSkinManager <> nil then
  begin
    FSkinManager.FreeNotification(Self);
    FSkinManager.RegisterControl(Self);
  end;

  Invalidate;
end;

procedure TONURSkinCustomControl.SetSkinElement(AValue: string);
begin
  if FSkinElement = AValue then Exit;
  FSkinElement := AValue;
  Invalidate;
end;

procedure TONURSkinCustomControl.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (AComponent = FSkinManager) then
  begin
    if FSkinManager <> nil then
      FSkinManager.UnRegisterControl(Self);
    FSkinManager := nil;
  end;
end;

function TONURSkinCustomControl.DrawPart(PartName: string; TargetCanvas: TCanvas;
  TargetRect: TRect; Alpha: byte): boolean;
begin
  Result := False;
  // Boş
end;

function TONURSkinCustomControl.DrawPart(PartName: string;
  TargetBitmap: TBGRABitmap; TargetRect: TRect; Alpha: byte): boolean;
var
  Bmp: TBGRABitmap;
  Part: TONURSkinPart; // EKLE
begin
  Result := False;
  if (FSkinManager = nil) or (FSkinElement = '') then Exit;

  Part := FSkinManager.GetPart(FSkinElement, PartName); // EKLE
  if Part = nil then Exit; // EKLE

  Bmp := Part.CachedBitmap; // DEĞİŞTİR
  if Bmp = nil then
  begin
    Bmp := FSkinManager.GetBitmap(FSkinElement, PartName);
    if Bmp = nil then Exit;
  end;

  Draw9Slice(Bmp, TargetBitmap, TargetRect, Part.Margin, Alpha); // DEĞİŞTİR
  Result := True;
end;

procedure TONURSkinCustomControl.OnAnimationTimer(Sender: TObject);
begin
  if (FAnimation <> nil) and FAnimation.IsFinished then
  begin
    if Assigned(FAnimation.OnComplete) then
      FAnimation.OnComplete(Self);
    StopAnimation;
  end
  else
    AnimationTick(Sender);
end;

procedure TONURSkinCustomControl.AnimationTick(Sender: TObject);
begin
  // Alt sınıflar override edecek
  Invalidate;
end;

procedure TONURSkinCustomControl.StartAnimation(AType: TONURAnimationType;
  ADuration: integer; AEasing: TONURAnimationEasing);
begin
  StopAnimation;
  FAnimation := TONURAnimation.Create(AType, ADuration, AEasing);
  FAnimationTimer.Enabled := True;
end;

procedure TONURSkinCustomControl.StopAnimation;
begin
  FAnimationTimer.Enabled := False;
  if FAnimation <> nil then
    FreeAndNil(FAnimation);
end;

{ TONURAnimation }
constructor TONURAnimation.Create(AType: TONURAnimationType;
  ADuration: integer; AEasing: TONURAnimationEasing);
begin
  FAnimationType := AType;
  FDuration := ADuration;
  FEasing := AEasing;
  FStartTime := GetTickCount64;
  FTag := 0;
end;

function TONURAnimation.GetProgress: single;
var
  Elapsed: QWord;
begin
  Elapsed := GetTickCount64 - FStartTime;
  if Elapsed >= FDuration then
    Result := 1.0
  else
    Result := Elapsed / FDuration;
end;

function TONURAnimation.ApplyEasing(Progress: single): single;
begin
  case FEasing of
    oaeLinear: Result := Progress;
    oaeEaseIn: Result := Progress * Progress;
    oaeEaseOut: Result := 1 - (1 - Progress) * (1 - Progress);
    oaeEaseInOut:
    begin
      if Progress < 0.5 then
        Result := 2 * Progress * Progress
      else
        Result := 1 - 2 * (1 - Progress) * (1 - Progress);
    end;
    else
      Result := Progress;
  end;
end;

function TONURAnimation.GetEasedProgress: single;
begin
  Result := ApplyEasing(GetProgress);
end;

function TONURAnimation.IsFinished: boolean;
begin
  Result := GetProgress >= 1.0;
end;

procedure TONURAnimation.Reset;
begin
  FStartTime := GetTickCount64;
end;

end.

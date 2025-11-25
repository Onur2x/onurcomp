unit onurctrl;

{$mode objfpc}{$H+}
{$modeswitch advancedrecords}
{$R 'onur.rc' onres.res}

interface

uses
  Forms, LCLType, LCLIntf, Controls, Graphics, Classes,
  BGRABitmap, BGRABitmapTypes, BGRACanvas, BGRABlend, BGRATransform, BGRAGradientScanner, BGRAGraphics, BGRAPen, BGRAPolygon,
  LazUTF8, Zipper, Dialogs, LMessages, Contnrs, Generics.Collections, IniFiles,
  {$IFDEF WINDOWS}Windows, ShellAPI,{$ELSE}unix{$ENDIF}, Types, SysUtils;

type
  TONURButtonState = (obshover, obspressed, obsnormal);
  TONURExpandStatus = (oExpanded, oCollapsed);
  TONURButtonDirection = (obleft, obright, obup, obdown);
  TONURSwichState = (FonN, FonH, FoffN, FoffH);
  TONURKindState = (oVertical, oHorizontal);
  TONURScroll = (FDown, FUp);
  TONURCapDirection = (ocup, ocdown, ocleft, ocright);

  { TONURSkinPart }
  TONURSkinPart = class(TPersistent)
  private
    FName: string;
    FBitmap: TBGRABitmap;
    FEnabled: Boolean;
    FVisible: Boolean;
    FSourceRect: TRect;
    FTargetRect: TRect;
    procedure SetBitmap(const AValue: TBGRABitmap);
    procedure SetSourceRect(const AValue: TRect);
    procedure SetTargetRect(const AValue: TRect);
  public
    constructor Create(const AName: string = '');
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    procedure LoadFromFile(const AFileName: string);
    procedure SaveToFile(const AFileName: string);
    procedure LoadFromJSON(JSON: TJSONObject);
    procedure SaveToJSON(JSON: TJSONObject);
    procedure Draw(ACanvas: TCanvas; const ADestRect: TRect);
    procedure DrawTo(ABitmap: TBGRABitmap; const ADestRect: TRect);
  published
    property Name: string read FName write FName;
    property Bitmap: TBGRABitmap read FBitmap write SetBitmap;
    property Enabled: Boolean read FEnabled write FEnabled default True;
    property Visible: Boolean read FVisible write FVisible default True;
    property SourceRect: TRect read FSourceRect write SetSourceRect;
    property TargetRect: TRect read FTargetRect write SetTargetRect;
  end;

  { TONURSkinParts }
  TONURSkinParts = class(TObjectList<TONURSkinPart>)
  private
    function GetItemByName(const AName: string): TONURSkinPart;
  public
    function Add(const AName: string): TONURSkinPart; overload;
    property ByName[const AName: string]: TONURSkinPart read GetItemByName; default;
  end;

  { TONURSkinData }
  TONURSkinData = class(TComponent)
  private
    FSkinParts: TONURSkinParts;
    FAdi: string;
    FYazar: string;
    FSurum: string;
    FAciklama: string;
    FTarih: TDateTime;
    FFileName: string;
    FModified: Boolean;
    FOnDegisiklik: TNotifyEvent;
    procedure SetSkinParts(AValue: TONURSkinParts);
    procedure OnSkinPartsChanged(Sender: TObject);
    procedure YapilandirmadanYukle(JSON: TJSONObject);
    procedure YapilandirmayiKaydet(JSON: TJSONObject);
    procedure DegisiklikleriBildir;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure LoadFromFile(const AFileName: string);
    procedure SaveToFile(const AFileName: string);
    procedure Assign(Source: TPersistent); override;
    procedure Changed;
    procedure AddOnChangeHandler(Handler: TNotifyEvent);
    procedure RemoveOnChangeHandler(Handler: TNotifyEvent);
  published
    // Özellikler
    property DosyaAdi: string read FFileName;
    property DegisiklikVar: Boolean read FModified;
    property Adi: string read FAdi write FAdi;
    property Yazar: string read FYazar write FYazar;
    property Surum: string read FSurum write FSurum;
    property Aciklama: string read FAciklama write FAciklama;
    property Tarih: TDateTime read FTarih;
    property SkinParcalari: TONURSkinParts read FSkinParts write SetSkinParts;
    property OnDegisiklik: TNotifyEvent read FOnDegisiklik write FOnDegisiklik;
  end;

  { TONURPersistent }
  TONURPersistent = class(TPersistent)
  private
    FOwner: TPersistent;
  protected
    function GetOwner: TPersistent; override;
  public
    constructor Create(AOwner: TPersistent); virtual;
    property Owner: TPersistent read FOwner;
  end;

  { TONURCustomCrop }
  TONURCustomCrop = class(TONURPersistent)
  private
    FLeft: Integer;
    FTop: Integer;
    FRight: Integer;
    FBottom: Integer;
    procedure SetBottom(const AValue: Integer);
    procedure SetLeft(const AValue: Integer);
    procedure SetRight(const AValue: Integer);
    procedure SetTop(const AValue: Integer);
  public
    constructor Create(AOwner: TPersistent); override;
    procedure Assign(Source: TPersistent); override;
    function ToRect: TRect;
  published
    property Left: Integer read FLeft write SetLeft default 0;
    property Top: Integer read FTop write SetTop default 0;
    property Right: Integer read FRight write SetRight default 0;
    property Bottom: Integer read FBottom write SetBottom default 0;
  end;

  { TONURCustomControl }
  TONURCustomControl = class(TCustomControl)
  private
    FSkinData: TONURSkinData;
    FOnSkinChange: TNotifyEvent;
    procedure SetSkinData(AValue: TONURSkinData);
    procedure OnSkinChanged(Sender: TObject);
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure DoOnResize; override;
    procedure Paint; override;
    procedure Loaded; override;
    procedure UpdateSkin; virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property SkinData: TONURSkinData read FSkinData write SetSkinData;
    property OnSkinChange: TNotifyEvent read FOnSkinChange write FOnSkinChange;
  end;

  // ... (existing types and declarations remain the same)

implementation

uses
  BGRABlend, BGRATransform, BGRAGradientScanner, BGRAGraphics, BGRAPen, BGRAPolygon;

{ TONURSkinPart }

constructor TONURSkinPart.Create(const AName: string);
begin
  inherited Create;
  FName := AName;
  FBitmap := TBGRABitmap.Create;
  FEnabled := True;
  FVisible := True;
  FSourceRect := Rect(0, 0, 0, 0);
  FTargetRect := Rect(0, 0, 0, 0);
end;

destructor TONURSkinPart.Destroy;
begin
  FBitmap.Free;
  inherited Destroy;
end;

procedure TONURSkinPart.Assign(Source: TPersistent);
begin
  if Source is TONURSkinPart then
  begin
    FName := TONURSkinPart(Source).Name;
    FEnabled := TONURSkinPart(Source).Enabled;
    FVisible := TONURSkinPart(Source).Visible;
    FBitmap.Assign(TONURSkinPart(Source).Bitmap);
    FSourceRect := TONURSkinPart(Source).SourceRect;
    FTargetRect := TONURSkinPart(Source).TargetRect;
  end
  else
    inherited Assign(Source);
end;

procedure TONURSkinPart.LoadFromFile(const AFileName: string);
begin
  if FileExists(AFileName) then
    FBitmap.LoadFromFile(AFileName);
end;

procedure TONURSkinPart.SaveToFile(const AFileName: string);
begin
  if not FBitmap.Empty then
    FBitmap.SaveToFile(AFileName);
end;

procedure TONURSkinPart.LoadFromJSON(JSON: TJSONObject);
begin
  if not Assigned(JSON) then Exit;
  
  FName := JSON.Get('name', FName);
  FEnabled := JSON.Get('enabled', FEnabled);
  FVisible := JSON.Get('visible', FVisible);
  
  // Load source rectangle
  if JSON.Find('source') is TJSONObject then
  begin
    with TJSONObject(JSON.Find('source')) do
    begin
      FSourceRect.Left := Get('left', FSourceRect.Left);
      FSourceRect.Top := Get('top', FSourceRect.Top);
      FSourceRect.Right := Get('right', FSourceRect.Right);
      FSourceRect.Bottom := Get('bottom', FSourceRect.Bottom);
    end;
  end;
  
  // Load target rectangle
  if JSON.Find('target') is TJSONObject then
  begin
    with TJSONObject(JSON.Find('target')) do
    begin
      FTargetRect.Left := Get('left', FTargetRect.Left);
      FTargetRect.Top := Get('top', FTargetRect.Top);
      FTargetRect.Right := Get('right', FTargetRect.Right);
      FTargetRect.Bottom := Get('bottom', FTargetRect.Bottom);
    end;
  end;
end;

procedure TONURSkinPart.SaveToJSON(JSON: TJSONObject);
var
  SourceObj, TargetObj: TJSONObject;
begin
  if not Assigned(JSON) then Exit;
  
  JSON.Add('name', FName);
  JSON.Add('enabled', FEnabled);
  JSON.Add('visible', FVisible);
  
  // Save source rectangle
  SourceObj := TJSONObject.Create;
  SourceObj.Add('left', FSourceRect.Left);
  SourceObj.Add('top', FSourceRect.Top);
  SourceObj.Add('right', FSourceRect.Right);
  SourceObj.Add('bottom', FSourceRect.Bottom);
  JSON.Add('source', SourceObj);
  
  // Save target rectangle
  TargetObj := TJSONObject.Create;
  TargetObj.Add('left', FTargetRect.Left);
  TargetObj.Add('top', FTargetRect.Top);
  TargetObj.Add('right', FTargetRect.Right);
  TargetObj.Add('bottom', FTargetRect.Bottom);
  JSON.Add('target', TargetObj);
end;

procedure TONURSkinPart.Draw(ACanvas: TCanvas; const ADestRect: TRect);
var
  DestRect: TRect;
begin
  if not FVisible or FBitmap.Empty then Exit;
  
  if not IsRectEmpty(FTargetRect) then
    DestRect := FTargetRect
  else
    DestRect := ADestRect;
    
  if not IsRectEmpty(FSourceRect) then
    FBitmap.DrawPart(FSourceRect, ACanvas, DestRect, True)
  else
    FBitmap.Draw(ACanvas, DestRect, True);
end;

procedure TONURSkinPart.DrawTo(ABitmap: TBGRABitmap; const ADestRect: TRect);
var
  DestRect: TRect;
begin
  if not FVisible or FBitmap.Empty then Exit;
  
  if not IsRectEmpty(FTargetRect) then
    DestRect := FTargetRect
  else
    DestRect := ADestRect;
    
  if not IsRectEmpty(FSourceRect) then
    ABitmap.PutImagePart(DestRect.Left, DestRect.Top, FBitmap, FSourceRect, dmDrawWithTransparency)
  else
    ABitmap.PutImage(DestRect.Left, DestRect.Top, FBitmap, dmDrawWithTransparency);
end;

procedure TONURSkinPart.SetBitmap(const AValue: TBGRABitmap);
begin
  if FBitmap = AValue then Exit;
  FBitmap.Assign(AValue);
end;

procedure TONURSkinPart.SetSourceRect(const AValue: TRect);
begin
  if (FSourceRect.Left = AValue.Left) and
     (FSourceRect.Top = AValue.Top) and
     (FSourceRect.Right = AValue.Right) and
     (FSourceRect.Bottom = AValue.Bottom) then Exit;
  FSourceRect := AValue;
end;

procedure TONURSkinPart.SetTargetRect(const AValue: TRect);
begin
  if (FTargetRect.Left = AValue.Left) and
     (FTargetRect.Top = AValue.Top) and
     (FTargetRect.Right = AValue.Right) and
     (FTargetRect.Bottom = AValue.Bottom) then Exit;
  FTargetRect := AValue;
end;

{ TONURSkinParts }

{ TONURSkinParts }

constructor TONURSkinParts.Create(AOwnsObjects: Boolean = True);
begin
  inherited Create(AOwnsObjects);
end;

function TONURSkinParts.GetItemByName(const AName: string): TONURSkinPart;
var
  idx: Integer;
begin
  idx := IndexOf(AName);
  if idx >= 0 then
    Result := Items[idx]
  else
    Result := nil;
end;

function TONURSkinParts.Add(const AName: string): TONURSkinPart;
begin
  if Contains(AName) then
    raise Exception.CreateFmt('"%s" isimli skin parçası zaten mevcut!', [AName]);
    
  Result := TONURSkinPart.Create(AName);
  inherited Add(Result);
  NotifyChange;
end;

function TONURSkinParts.AddOrSet(const AName: string): TONURSkinPart;
var
  idx: Integer;
begin
  idx := IndexOf(AName);
  if idx >= 0 then
    Result := Items[idx]
  else
  begin
    Result := TONURSkinPart.Create(AName);
    inherited Add(Result);
    NotifyChange;
  end;
end;

function TONURSkinParts.Extract(Item: TONURSkinPart): TONURSkinPart;
begin
  Result := inherited Extract(Item);
  if Assigned(Result) then
    NotifyChange;
end;

function TONURSkinParts.Remove(const AName: string): Integer;
begin
  Result := IndexOf(AName);
  if Result >= 0 then
  begin
    Delete(Result);
    NotifyChange;
  end;
end;

function TONURSkinParts.IndexOf(const AName: string): Integer;
var
  I: Integer;
begin
  Result := -1;
  for I := 0 to Count - 1 do
    if SameText(Items[I].Name, AName) then
      Exit(I);
end;

function TONURSkinParts.Contains(const AName: string): Boolean;
begin
  Result := IndexOf(AName) >= 0;
end;

procedure TONURSkinParts.LoadFromJSON(JSON: TJSONObject);
var
  I: Integer;
  Item: TONURSkinPart;
  ItemsArray: TJSONArray;
  ItemObj: TJSONObject;
begin
  if not Assigned(JSON) then Exit;
  
  Clear;
  
  if JSON.Find('items') is TJSONArray then
  begin
    ItemsArray := TJSONArray(JSON.Find('items'));
    for I := 0 to ItemsArray.Count - 1 do
    begin
      if ItemsArray[I] is TJSONObject then
      begin
        ItemObj := TJSONObject(ItemsArray[I]);
        Item := Add(ItemObj.Get('name', 'item_' + IntToStr(I)));
        Item.LoadFromJSON(ItemObj);
      end;
    end;
  end;
  
  NotifyChange;
end;

procedure TONURSkinParts.SaveToJSON(JSON: TJSONObject);
var
  I: Integer;
  ItemObj: TJSONObject;
  ItemsArray: TJSONArray;
begin
  if not Assigned(JSON) then Exit;
  
  ItemsArray := TJSONArray.Create;
  try
    for I := 0 to Count - 1 do
    begin
      ItemObj := TJSONObject.Create;
      Items[I].SaveToJSON(ItemObj);
      ItemsArray.Add(ItemObj);
    end;
    JSON.Add('items', ItemsArray);
  except
    ItemsArray.Free;
    raise;
  end;
end;

procedure TONURSkinParts.Assign(Source: TONURSkinParts);
var
  I: Integer;
  NewItem: TONURSkinPart;
begin
  if Source = Self then Exit;
  
  Clear;
  if not Assigned(Source) then Exit;
  
  for I := 0 to Source.Count - 1 do
  begin
    NewItem := Add(Source[I].Name);
    NewItem.Assign(Source[I]);
  end;
  
  NotifyChange;
end;

procedure TONURSkinParts.NotifyChange;
begin
  if Assigned(FOnChange) then
    FOnChange(Self);
end;



{ TONURSkinData }

constructor TONURSkinData.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FSkinParts := TONURSkinParts.Create(True);
  FSkinParts.OnChange := @OnSkinPartsChanged;
  FFileName := '';
  FModified := False;
  FName := 'New Skin';
  FAuthor := '';
  FVersion := '1.0';
  FDescription := '';
  FDate := Now;
end;

destructor TONURSkinData.Destroy;
begin
  FSkinParts.Free;
  inherited Destroy;
end;

procedure TONURSkinData.SetSkinParts(AValue: TONURSkinParts);
begin
  if FSkinParts = AValue then Exit;
  FSkinParts.Assign(AValue);
end;

procedure TONURSkinData.LoadFromFile(const AFileName: string);
var
  FileStream: TFileStream;
  JSONData: TJSONObject;
  FileContent: TStringList;
begin
  if not FileExists(AFileName) then
    raise Exception.CreateFmt('Dosya bulunamadı: %s', [AFileName]);

  FileContent := TStringList.Create;
  try
    FileContent.LoadFromFile(AFileName);
    
    try
      JSONData := TJSONObject(GetJSON(FileContent.Text));
      try
        FSkinParts.Clear;
        
        if JSONData.Find('skin_info') is TJSONObject then
          LoadFromConfig(TJSONObject(JSONData.Find('skin_info')));
          
        FSkinParts.LoadFromJSON(JSONData);
        
        FFileName := AFileName;
        FModified := False;
      finally
        JSONData.Free;
      end;
    except
      on E: Exception do
        raise Exception.CreateFmt('Skin dosyası okunurken hata: %s', [E.Message]);
    end;
  finally
    FileContent.Free;
  end;
  
  NotifyChanges;
end;

procedure TONURSkinData.SaveToFile(const AFileName: string);
var
  JSONData: TJSONObject;
  FileContent: TStringList;
begin
  JSONData := TJSONObject.Create;
  FileContent := TStringList.Create;
  try
    SaveToConfig(JSONData);
    FSkinParts.SaveToJSON(JSONData);
    
    FileContent.Text := JSONData.FormatJSON();
    try
      FileContent.SaveToFile(AFileName);
      FFileName := AFileName;
      FModified := False;
    except
      on E: Exception do
        raise Exception.CreateFmt('Dosya kaydedilirken hata: %s', [E.Message]);
    end;
  finally
    JSONData.Free;
    FileContent.Free;
  end;
  
  NotifyChanges;
end;

procedure TONURSkinData.LoadFromConfig(JSON: TJSONObject);
begin
  if not Assigned(JSON) then Exit;
  
  FName := JSON.Get('name', 'İsimsiz Skin');
  FAuthor := JSON.Get('author', '');
  FVersion := JSON.Get('version', '1.0');
  FDescription := JSON.Get('description', '');
  FDate := ISO8601ToDate(JSON.Get('date', ''), True);
end;

procedure TONURSkinData.SaveToConfig(JSON: TJSONObject);
var
  Config: TJSONObject;
begin
  if not Assigned(JSON) then Exit;
  
  Config := TJSONObject.Create;
  try
    Config.Add('name', FName);
    Config.Add('author', FAuthor);
    Config.Add('version', FVersion);
    Config.Add('description', FDescription);
    Config.Add('date', DateToISO8601(Now, False));
    
    JSON.Add('skin_info', Config);
  except
    Config.Free;
    raise;
  end;
end;

procedure TONURSkinData.OnSkinPartsChanged(Sender: TObject);
begin
  FModified := True;
  NotifyChanges;
end;

procedure TONURSkinData.NotifyChanges;
begin
  if Assigned(FOnChange) then
    FOnChange(Self);
end;




{ TONURPersistent }

function TONURPersistent.GetOwner: TPersistent;
begin
  Result := FOwner;
end;

constructor TONURPersistent.Create(AOwner: TPersistent);
begin
  inherited Create;
  FOwner := AOwner;
end;

{ TONURCustomCrop }

constructor TONURCustomCrop.Create(AOwner: TPersistent);
begin
  inherited Create(AOwner);
  FLeft := 0;
  FTop := 0;
  FRight := 0;
  FBottom := 0;
end;

procedure TONURCustomCrop.Assign(Source: TPersistent);
begin
  if Source is TONURCustomCrop then
  begin
    FLeft := TONURCustomCrop(Source).Left;
    FTop := TONURCustomCrop(Source).Top;
    FRight := TONURCustomCrop(Source).Right;
    FBottom := TONURCustomCrop(Source).Bottom;
  end
  else
    inherited Assign(Source);
end;

function TONURCustomCrop.ToRect: TRect;
begin
  Result := Rect(FLeft, FTop, FRight, FBottom);
end;

procedure TONURCustomCrop.SetBottom(const AValue: Integer);
begin
  if FBottom <> AValue then
  begin
    FBottom := AValue;
    if Assigned(Owner) and (Owner is TComponent) then
      TComponent(Owner).Invalidate;
  end;
end;

procedure TONURCustomCrop.SetLeft(const AValue: Integer);
begin
  if FLeft <> AValue then
  begin
    FLeft := AValue;
    if Assigned(Owner) and (Owner is TComponent) then
      TComponent(Owner).Invalidate;
  end;
end;

procedure TONURCustomCrop.SetRight(const AValue: Integer);
begin
  if FRight <> AValue then
  begin
    FRight := AValue;
    if Assigned(Owner) and (Owner is TComponent) then
      TComponent(Owner).Invalidate;
  end;
end;

procedure TONURCustomCrop.SetTop(const AValue: Integer);
begin
  if FTop <> AValue then
  begin
    FTop := AValue;
    if Assigned(Owner) and (Owner is TComponent) then
      TComponent(Owner).Invalidate;
  end;
end;

{ TONURCustomControl }

constructor TONURCustomControl.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := ControlStyle + [csAcceptsControls, csParentBackground];
  FSkinData := nil;
  FOnSkinChange := nil;
  DoubleBuffered := True;
end;

destructor TONURCustomControl.Destroy;
begin
  if FSkinData <> nil then
    FSkinData.RemoveFreeNotification(Self);
  inherited Destroy;
end;

procedure TONURCustomControl.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (AComponent = FSkinData) then
    FSkinData := nil;
end;

procedure TONURCustomControl.DoOnResize;
begin
  inherited DoOnResize;
  Invalidate;
end;

procedure TONURCustomControl.Paint;
begin
  inherited Paint;
  if csDesigning in ComponentState then
  begin
    Canvas.Pen.Style := psDash;
    Canvas.Brush.Style := bsClear;
    Canvas.Rectangle(ClientRect);
  end;
end;

procedure TONURCustomControl.Loaded;
begin
  inherited Loaded;
  if FSkinData <> nil then
    FSkinData.FreeNotification(Self);
  UpdateSkin;
end;

procedure TONURCustomControl.UpdateSkin;
begin
  if Assigned(FOnSkinChange) then
    FOnSkinChange(Self);
  Invalidate;
end;

procedure TONURCustomControl.SetSkinData(AValue: TONURSkinData);
begin
  if FSkinData <> AValue then
  begin
    if FSkinData <> nil then
    begin
      FSkinData.RemoveFreeNotification(Self);
      FSkinData.RemoveOnChangeHandler(@OnSkinChanged);
    end;
    
    FSkinData := AValue;
    
    if FSkinData <> nil then
    begin
      FSkinData.FreeNotification(Self);
      FSkinData.AddOnChangeHandler(@OnSkinChanged);
    end;
    
    UpdateSkin;
  end;
end;

procedure TONURCustomControl.OnSkinChanged(Sender: TObject);
begin
  UpdateSkin;
end;


end.

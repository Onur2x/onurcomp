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

unit sppngimagelist;

interface

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


uses
  Windows, Classes, SysUtils, Controls, Graphics, CommCtrl, ImgList, Messages,
  spPngImage
  {$IFDEF VER200},PngImage {$ENDIF};

type
  TspPngImageList = class;

  TspPngImageItem = class(TCollectionItem)
   private
    FPngImage: TspPngImage;
    FName: string;
    procedure SetPngImage(const Value: TspPngImage);
  protected
    procedure AssignTo(Dest: TPersistent); override;
    function GetDisplayName: string; override;
  public
    constructor Create(Collection: TCollection); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
  published
    property Name: string read FName write FName;
    property PngImage: TspPngImage read FPngImage write SetPngImage;
  end;

  TspPngImageItems = class(TCollection)
  private
    function GetItem(Index: Integer): TspPngImageItem;
    procedure SetItem(Index: Integer; Value:  TspPngImageItem);
  protected
    function GetOwner: TPersistent; override;
  public
    FPngImageList: TspPngImageList;
    constructor Create(APNGImageList: TspPngImageList);
    property Items[Index: Integer]:  TspPngImageItem read GetItem write SetItem; default;
  end;

  TspPngImageList = class(TCustomImageList)
  private
    FPngImages: TspPngImageItems;
    function GetPngWidth: Integer;
    function GetPngHeight: Integer;
    procedure SetPngWidth(Value: Integer);
    procedure SetPngHeight(Value: Integer);
    procedure SetPngImages(Value: TspPngImageItems);
  protected
    procedure DoDraw(Index: Integer; Canvas: TCanvas; X, Y: Integer; Style: Cardinal; Enabled: Boolean = True); override;
    procedure InsertBitMap(Index: Integer);
    procedure DeleteBitMap(Index: Integer);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property PngImages: TspPngImageItems read FPngImages write SetPngImages;
    property PngWidth: Integer read GetPngWidth write SetPngWidth;
    property PngHeight: Integer read GetPngHeight write SetPngHeight;
  end;

   TspPngImageStorage = class;

   TspPngStorageImageItem = class(TCollectionItem)
   private
    FPngImage: TspPngImage;
    FName: string;
    procedure SetPngImage(const Value: TspPngImage);
    function GetWidth: Integer;
    function GetHeight: Integer;
  protected
    procedure AssignTo(Dest: TPersistent); override;
    function GetDisplayName: string; override;
  public
    constructor Create(Collection: TCollection); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
  published
    property Name: string read FName write FName;
    property PngImage: TspPngImage read FPngImage write SetPngImage;
    property PngWidth: Integer read GetWidth;
    property PngHeight: Integer read  GetHeight;
  end;

  TspPngStorageImageItems = class(TCollection)
  private
    function GetItem(Index: Integer): TspPngStorageImageItem;
    procedure SetItem(Index: Integer; Value:  TspPngStorageImageItem);
  protected
    function GetOwner: TPersistent; override;
  public
    FPngImageList: TspPngImageStorage;
    constructor Create(APNGImageList: TspPngImageStorage);
    property Items[Index: Integer]:  TspPngStorageImageItem read GetItem write SetItem; default;
  end;

  TspPngImageStorage = class(TComponent)
  private
    FPngImages: TspPngStorageImageItems;
    procedure SetPngImages(Value: TspPngStorageImageItems);
  public
    procedure Draw(Index: Integer; Canvas: TCanvas; X, Y: Integer; Enabled: Boolean = True);
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property PngImages: TspPngStorageImageItems read FPngImages write SetPngImages;
  end;

  TspPngImageView = class(TGraphicControl)
  private
    FDoubleBuffered: Boolean;
    FReflectionImage: Pointer;
    FReflectionEffect: Boolean; 
    FOnMouseEnter, FOnMouseLeave: TNotifyEvent;
    FAutoSize: Boolean;
    FPngImageList: TspPngImageList;
    FPngImageStorage: TspPngImageStorage;
    FImageIndex: Integer;
    FCenter: Boolean;
    procedure SetDoubleBuffered(Value: Boolean);
    procedure SetAutoSize(Value: Boolean);
    procedure SetImageIndex(Value: Integer);
    procedure SetCenter(Value: Boolean);
    procedure SetReflectionEffect(Value: Boolean);
    procedure CreateReflection;
    procedure DestroyReflection;
  protected
    procedure AdjustBounds;
    procedure Loaded; override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure Paint; override;
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
    procedure CMMouseEnter(var Message: TMessage); message CM_MOUSEENTER;
    procedure CMEnabledChanged(var Message: TMessage); message CM_ENABLEDCHANGED;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property DoubleBuffered: Boolean
      read FDoubleBuffered write SetDoubleBuffered;
    property ReflectionEffect: Boolean
      read FReflectionEffect write SetReflectionEffect;
    property AutoSize: Boolean read FAutoSize write SetAutoSize default True;
    property PngImageList: TspPngImageList
      read FPngImageList write FPngImageList;
    property PngImageStorage: TspPngImageStorage
      read FPngImageStorage write FPngImageStorage;
    property ImageIndex: Integer read FImageIndex write SetImageIndex;
    property Align;
    property Anchors;
    property Center: Boolean read FCenter write SetCenter default False;
    property Constraints;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property PopupMenu;
    property ShowHint;
    property Visible;
    property OnClick;
    property OnContextPopup;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnStartDock;
    property OnStartDrag;
    property OnMouseEnter: TNotifyEvent read FOnMouseEnter write FOnMouseEnter;
    property OnMouseLeave: TNotifyEvent read FOnMouseLeave write FOnMouseLeave;
  end;

implementation
  Uses spEffBmp, spUtils;

procedure TspPngImageItem.AssignTo(Dest: TPersistent);
begin
  inherited AssignTo(Dest);
  if (Dest is TspPngImageItem)
  then
    TspPngImageItem(Dest).PngImage := PngImage;
end;

constructor TspPngImageItem.Create(Collection: TCollection);
begin
  inherited Create(Collection);
  FPngImage := TspPngImage.Create;
  FName := Format('PngImage%d', [Index]);
  TspPngImageItems(Self.Collection).FPngImageList.InsertBitmap(Index);
end;

destructor TspPngImageItem.Destroy;
begin
  FPngImage.Free;
  if TspPngImageItems(Self.Collection).FPngImageList.Count > Index
  then
    TspPngImageItems(Self.Collection).FPngImageList.DeleteBitmap(Index);
  inherited Destroy;
end;

procedure TspPngImageItem.Assign(Source: TPersistent);
begin
  if Source is TspPngImageItem
  then
    begin
      PngImage.Assign(TspPngImageItem(Source).PngImage);
      Name := TspPngImageItem(Source).Name;
   end
  else
    inherited Assign(Source);
end;

function TspPngImageItem.GetDisplayName: string;
begin
  if Length(FName) = 0
  then Result := inherited GetDisplayName
  else Result := FName;
end;

procedure TspPngImageItem.SetPngImage(const Value: TspPngImage);
begin
  FPngImage.Assign(Value);
  Changed(True);
end;

constructor TspPngImageItems.Create;
begin
  inherited Create(TspPngImageItem);
  FPngImageList := APngImageList;
end;


function TspPngImageItems.GetOwner: TPersistent;
begin
  Result := FPngImageList;
end;

function TspPngImageItems.GetItem(Index: Integer): TspPngImageItem;
begin
  Result := TspPngImageItem(inherited GetItem(Index));
end;

procedure TspPngImageItems.SetItem;
begin
  inherited SetItem(Index, Value);
end;

constructor TspPngImageList.Create(AOwner: TComponent);
begin
  inherited;
  FPngImages := TspPngImageItems.Create(Self);
end;

destructor TspPngImageList.Destroy;
begin
  FPngImages.Free;
  FPngImages := nil;
  inherited;
end;

function TspPngImageList.GetPngWidth: Integer;
begin
  Result := Width;
end;

function TspPngImageList.GetPngHeight: Integer;
begin
  Result := Height;
end;

procedure TspPngImageList.SetPngWidth(Value: Integer);
begin
  if Width <> Value
  then
    begin
      Width := Value;
      if not (csLoading in ComponentState)
      then
        FPngImages.Clear;
    end;
end;

procedure TspPngImageList.SetPngHeight(Value: Integer);
begin
  if Height <> Value
  then
    begin
      Height := Value;
      if not (csLoading in ComponentState)
      then
      FPngImages.Clear;
    end;
end;


procedure TspPngImageList.SetPngImages(Value: TspPngImageItems);
begin
  FPngImages.Assign(Value);
end;

procedure TspPngImageList.DoDraw(Index: Integer; Canvas: TCanvas; X, Y: Integer; Style: Cardinal; Enabled: Boolean);

procedure MakeImageBlended(Image: TspPngImage; Amount: Byte = 127);

  procedure ForceAlphachannel(BitTransparency: Boolean; TransparentColor: TColor);
  var
     Assigner: TBitmap;
     Temp: TspPngImage;
     X, Y: Integer;
     {$IFNDEF VER200}
     Line: sppngimage.PByteArray;
     {$ELSE}
     Line: PByteArray;
     {$ENDIF}
     Current: TColor;
  begin
  Temp := TspPngImage.Create;
  try
    Assigner := TBitmap.Create;
    try
      Assigner.Width := Image.Width;
      Assigner.Height := Image.Height;
      Temp.Assign(Assigner);
    finally
      Assigner.Free;
     end;
    Temp.CreateAlpha;
    for Y := 0 to Image.Height - 1
    do begin
       Line := Temp.AlphaScanline[Y];
       for X := 0 to Image.Width - 1
       do begin
          Current := Image.Pixels[X, Y];
          Temp.Pixels[X, Y] := Current;
          if BitTransparency and (Current = TransparentColor)
          then Line^[X] := 0
          else Line^[X] := Amount;
          end;
       end;
    Image.Assign(Temp);
  finally
    Temp.Free;
   end;
  end;

var
   X, Y: Integer;
   {$IFNDEF VER200}
   Line: sppngimage.PByteArray;
   {$ELSE}
   Line: PByteArray;
   {$ENDIF}
   Forced: Boolean;
   TransparentColor: TColor;
   BitTransparency: Boolean;
begin
  {$IFNDEF VER200}
  BitTransparency := Image.TransparencyMode = bsptmBit;
  {$ELSE}
  BitTransparency := Image.TransparencyMode = ptmBit;
  {$ENDIF}
  TransparentColor := Image.TransparentColor;
  if not (Image.Header.ColorType in [COLOR_RGBALPHA, COLOR_GRAYSCALEALPHA])
  then
    begin
      Forced := Image.Header.ColorType in [COLOR_GRAYSCALE, COLOR_PALETTE];
      if Forced
      then
        ForceAlphachannel(BitTransparency, TransparentColor)
      else
        Image.CreateAlpha;
    end
  else
   Forced := False;

  if not Forced and (Image.Header.ColorType in [COLOR_RGBALPHA, COLOR_GRAYSCALEALPHA])
  then
     for Y := 0 to Image.Height - 1 do
     begin
       Line := Image.AlphaScanline[Y];
       for X := 0 to Image.Width - 1 do
         if BitTransparency and (Image.Pixels[X, Y] = TransparentColor)
         then
           Line^[X] := 0
         else
           Line^[X] := Round(Line^[X] / 256 * (Amount + 1));
     end;
end;

procedure DrawPNG(Png: TspPngImage; Canvas: TCanvas; const Rect: TRect; AEnabled: Boolean);
var
  PngCopy: TspPngImage;
begin
  if not AEnabled
  then
   begin
     PngCopy := TspPngImage.Create;
     try
       PngCopy.Assign(Png);
       MakeImageBlended(PngCopy);
       PngCopy.Draw(Canvas, Rect);
     finally
       PngCopy.Free;
      end;
    end
  else
    Png.Draw(Canvas, Rect);
end;


var
  PaintRect: TRect;
  Png: TspPngImageItem;
begin
  PaintRect := Rect(X, Y, X + Width, Y + Height);
  Png := TspPngImageItem(FPngImages.Items[Index]);
  if Png <> nil
  then
    DrawPNG(Png.PngImage, Canvas, PaintRect, Enabled);
end;

procedure TspPngImageList.InsertBitMap(Index: Integer);
var
  B: TBitMap;
begin
  B := TBitMap.Create;
  B.Monochrome := True;
  B.Width := Width;
  B.height := Height;
  Insert(Index, B, nil);
  B.Free;
end;

procedure TspPngImageList.DeleteBitMap(Index: Integer);
begin
  Delete(Index);
end;

constructor TspPngImageView.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := ControlStyle - [csOpaque] + [csReplicatable];
  FDoubleBuffered := False;
  FReflectionImage := nil;
  FReflectionEffect := False;
  FPngImageList := nil;
  FPngImageStorage := nil;
  FAutoSize := True;
  FImageIndex := -1;
  FCenter := False;
  Width := 50;
  Height := 50;
end;

destructor TspPngImageView.Destroy;
begin
  if FReflectionImage <> nil then DestroyReflection;
  inherited;
end;

procedure TspPngImageView.SetDoubleBuffered(Value: Boolean);
begin
  FDoubleBuffered := Value;
  if FDoubleBuffered
  then ControlStyle := ControlStyle + [csOpaque]
  else ControlStyle := ControlStyle - [csOpaque];
end;

procedure TspPngImageView.CMEnabledChanged(var Message: TMessage);
begin
  if FReflectionEffect then CreateReflection;
  inherited;
end;

procedure TspPngImageView.CreateReflection;
begin
  DestroyReflection;
  if (FPngImageStorage <> nil) and (FPngImageStorage.PngImages.Count > 0) and
     (FImageIndex >= 0) and
     (FImageIndex < FPngImageStorage.PngImages.Count)
  then
    begin
      TspBitMap(FReflectionImage) := TspBitMap.Create;
      MakeCopyFromPng(TspBitMap(FReflectionImage),
        FPngImageStorage.PngImages[FImageIndex].FPngImage);
      if Enabled
      then
        TspBitMap(FReflectionImage).Reflection
      else
        TspBitMap(FReflectionImage).Reflection2;
    end
  else
  if (FPngImageList <> nil) and
     (FPngImageList.Count > 0) and
     (FImageIndex >= 0) and
     (FImageIndex < FPngImageList.Count) and
     (FPngImageList.Width > 0) and
     (FPngImageList.Height > 0)
  then
    begin
      TspBitMap(FReflectionImage) := TspBitMap.Create;
      MakeCopyFromPng(TspBitMap(FReflectionImage),
        FPngImageList.PngImages[FImageIndex].FPngImage);
      if Enabled
      then
        TspBitMap(FReflectionImage).Reflection
      else
        TspBitMap(FReflectionImage).Reflection2;
    end;
end;

procedure TspPngImageView.DestroyReflection;
begin
  if FReflectionImage <> nil
  then
    begin
      TspBitMap(FReflectionImage).Free;
      FReflectionImage := nil;
    end;
end;

procedure TspPngImageView.CMMouseEnter;
begin
  inherited;
  if (csDesigning in ComponentState) then Exit;
  if Enabled
  then
    if Assigned(FOnMouseEnter) then FOnMouseEnter(Self);
end;

procedure TspPngImageView.SetReflectionEffect;
begin
  if FReflectionEffect <> Value
  then
    begin
      FReflectionEffect := Value;
      if FReflectionEffect then CreateReflection else DestroyReflection;
      AdjustBounds;
      RePaint;
    end;
end;

procedure TspPngImageView.CMMouseLeave;
begin
  inherited;
  if (csDesigning in ComponentState) then Exit;
  if Enabled
  then
    if Assigned(FOnMouseLeave) then FOnMouseLeave(Self);
end;

procedure TspPngImageView.Paint;
var
  H, X, Y: Integer;
  C: TCanvas;
  Buffer: TBitMap;
begin
  if FDoubleBuffered
  then
    begin
      Buffer := TBitMap.Create;
      Buffer.Width := Width;
      Buffer.Height := Height;
      GetParentImage(Self, Buffer.Canvas);
      C := Buffer.Canvas;
    end
  else
    C := Canvas;

  if (FPngImageStorage <> nil) and (FPngImageStorage.PngImages.Count > 0) and
     (FImageIndex >= 0) and
     (FImageIndex < FPngImageStorage.PngImages.Count)
  then
    begin
      if FCenter
      then
        begin
          H := FPngImageStorage.PngImages[FImageIndex].PngHeight;
          if FReflectionImage <> nil then H := H + H div 2;
          Y := Height div 2 - H div 2;
          X := Width div 2 - FPngImageStorage.PngImages[FImageIndex].PngWidth div 2;
          FPngImageStorage.Draw(FImageIndex, C, X, Y, Enabled);
          if FReflectionImage <> nil
          then
            TspBitMap(FReflectionImage).Draw(C,
              X, Y + FPngImageStorage.PngImages[FImageIndex].PngHeight);
        end
      else
        begin
          FPngImageStorage.Draw(FImageIndex, C, 0, 0, Enabled);
          if FReflectionImage <> nil
          then
            TspBitMap(FReflectionImage).Draw(C,
              0, FPngImageStorage.PngImages[FImageIndex].PngHeight);
        end;
    end
  else
  if (FPngImageList <> nil) and
     (FPngImageList.Count > 0) and
     (FImageIndex >= 0) and
     (FImageIndex < FPngImageList.Count) and
     (FPngImageList.Width > 0) and
     (FPngImageList.Height > 0)
  then
    begin
      if FCenter
      then
        begin
          H := FPngImageList.Height;
          if FReflectionImage <> nil then H := H + H div 2;
          Y := Height div 2 - H div 2;
          X := Width div 2 - FPngImageList.Width div 2;
          FPngImageList.Draw(C,  X, Y, FImageIndex, Enabled);
          if FReflectionImage <> nil
          then
            TspBitMap(FReflectionImage).Draw(C,
              X, Y + FPngImageList.Height);
        end
      else
        begin
          FPngImageList.Draw(C, 0, 0, FImageIndex, Enabled);
          if FReflectionImage <> nil
          then
            TspBitMap(FReflectionImage).Draw(C,
              0, FPngImageList.Height);
        end;
    end;

  if csDesigning in ComponentState
  then
    with C do
    begin
      Pen.Style := psDash;
      Brush.Style := bsClear;
      Rectangle(0, 0, Width, Height);
    end;

  if FDoubleBuffered
  then
    begin
      Canvas.Draw(0, 0, Buffer);
      Buffer.Free;
    end;
end;

procedure TspPngImageView.Loaded;
begin
  inherited Loaded;
  if FReflectionEffect then CreateReflection;
  AdjustBounds;
end;

procedure TspPngImageView.AdjustBounds;
begin
  if FAutoSize and (FPngImageStorage <> nil) and
     (FPngImageStorage.PngImages.Count > 0) and
     (FImageIndex >= 0) and
     (FImageIndex < FPngImageStorage.PngImages.Count)
  then
    begin
      Width := FPngImageStorage.PngImages[FImageIndex].PngWidth;
      if FReflectionEffect
      then
        Height := FPngImageStorage.PngImages[FImageIndex].PngHeight  +
          FPngImageStorage.PngImages[FImageIndex].PngHeight div 2 + 5
      else
        Height := FPngImageStorage.PngImages[FImageIndex].PngHeight;
    end
  else
  if FAutoSize and (FPngImageList <> nil)
  then
    begin
      Width := FPngImageList.Width;
      if FReflectionEffect
      then
        Height := FPngImageList.Height  + FPngImageList.Height div 2 + 5
      else
        Height := FPngImageList.Height;
    end;
end;

procedure TspPngImageView.SetAutoSize(Value: Boolean);
begin
  if FAutoSize <> Value then
  begin
    FAutoSize := Value;
    AdjustBounds;
  end;
end;

procedure TspPngImageView.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (AComponent = FPngImageList) then
    FPngImageList := nil;
  if (Operation = opRemove) and (AComponent = FPngImageStorage) then
    FPngImageStorage := nil;
end;

procedure TspPngImageView.SetImageIndex(Value: Integer);
begin
  if Value >= -1
  then
    FImageIndex := Value;
  if FPngImageStorage <> nil
  then
    begin
      if FReflectionEffect then CreateReflection;
      if FAutoSize then AdjustBounds;
      RePaint;
    end
  else
  if FPngImageList <> nil
  then
    begin
      if FReflectionEffect then CreateReflection;
      if FAutoSize then AdjustBounds;
      RePaint;
    end;
end;

procedure TspPngImageView.SetCenter;
begin
  if FCenter <> Value then
  begin
    FCenter := Value;
    RePaint;
  end;
end;


// TspPngImageStorage

procedure TspPngStorageImageItem.AssignTo(Dest: TPersistent);
begin
  inherited AssignTo(Dest);
  if (Dest is TspPngStorageImageItem)
  then
    TspPngStorageImageItem(Dest).PngImage := PngImage;
end;

constructor TspPngStorageImageItem.Create(Collection: TCollection);
begin
  inherited Create(Collection);
  FPngImage := TspPngImage.Create;
  FName := Format('PngImage%d', [Index]);
end;

destructor TspPngStorageImageItem.Destroy;
begin
  FPngImage.Free;
  inherited Destroy;
end;

function TspPngStorageImageItem.GetWidth: Integer;
begin
  Result := FPngImage.Width;
end;

function TspPngStorageImageItem.GetHeight: Integer;
begin
  Result := FPngImage.Height;
end;


procedure TspPngStorageImageItem.Assign(Source: TPersistent);
begin
  if Source is TspPngStorageImageItem
  then
    begin
      PngImage.Assign(TspPngStorageImageItem(Source).PngImage);
      Name := TspPngStorageImageItem(Source).Name;
   end
  else
    inherited Assign(Source);
end;

function TspPngStorageImageItem.GetDisplayName: string;
begin
  if Length(FName) = 0
  then Result := inherited GetDisplayName
  else Result := FName;
end;

procedure TspPngStorageImageItem.SetPngImage(const Value: TspPngImage);
begin
  FPngImage.Assign(Value);
  Changed(True);
end;

constructor TspPngStorageImageItems.Create;
begin
  inherited Create(TspPngStorageImageItem);
  FPngImageList := APngImageList;
end;

function TspPngStorageImageItems.GetOwner: TPersistent;
begin
  Result := FPngImageList;
end;

function TspPngStorageImageItems.GetItem(Index: Integer): TspPngStorageImageItem;
begin
  Result := TspPngStorageImageItem(inherited GetItem(Index));
end;

procedure TspPngStorageImageItems.SetItem;
begin
  inherited SetItem(Index, Value);
end;

constructor TspPngImageStorage.Create(AOwner: TComponent);
begin
  inherited;
  FPngImages := TspPngStorageImageItems.Create(Self);
end;

destructor TspPngImageStorage.Destroy;
begin
  FPngImages.Free;
  FPngImages := nil;
  inherited;
end;

procedure TspPngImageStorage.SetPngImages(Value: TspPngStorageImageItems);
begin
  FPngImages.Assign(Value);
end;

procedure TspPngImageStorage.Draw(Index: Integer; Canvas: TCanvas; X, Y: Integer; Enabled: Boolean);

procedure MakeImageBlended(Image: TspPngImage; Amount: Byte = 127);

  procedure ForceAlphachannel(BitTransparency: Boolean; TransparentColor: TColor);
  var
     Assigner: TBitmap;
     Temp: TspPngImage;
     X, Y: Integer;
     {$IFNDEF VER200}
     Line: sppngimage.PByteArray;
     {$ELSE}
     Line: PByteArray;
     {$ENDIF}
     Current: TColor;
  begin
  Temp := TspPngImage.Create;
  try
    Assigner := TBitmap.Create;
    try
      Assigner.Width := Image.Width;
      Assigner.Height := Image.Height;
      Temp.Assign(Assigner);
    finally
      Assigner.Free;
     end;
    Temp.CreateAlpha;
    for Y := 0 to Image.Height - 1
    do begin
       Line := Temp.AlphaScanline[Y];
       for X := 0 to Image.Width - 1
       do begin
          Current := Image.Pixels[X, Y];
          Temp.Pixels[X, Y] := Current;
          if BitTransparency and (Current = TransparentColor)
          then Line^[X] := 0
          else Line^[X] := Amount;
          end;
       end;
    Image.Assign(Temp);
  finally
    Temp.Free;
   end;
  end;

var
   X, Y: Integer;
   {$IFNDEF VER200}
   Line: sppngimage.PByteArray;
   {$ELSE}
   Line: PByteArray;
   {$ENDIF}
   Forced: Boolean;
   TransparentColor: TColor;
   BitTransparency: Boolean;
begin
  {$IFNDEF VER200}
  BitTransparency := Image.TransparencyMode = bsptmBit;
  {$ELSE}
  BitTransparency := Image.TransparencyMode = ptmBit;
  {$ENDIF}
  TransparentColor := Image.TransparentColor;
  if not (Image.Header.ColorType in [COLOR_RGBALPHA, COLOR_GRAYSCALEALPHA])
  then
    begin
      Forced := Image.Header.ColorType in [COLOR_GRAYSCALE, COLOR_PALETTE];
      if Forced
      then
        ForceAlphachannel(BitTransparency, TransparentColor)
      else
        Image.CreateAlpha;
    end
  else
   Forced := False;

  if not Forced and (Image.Header.ColorType in [COLOR_RGBALPHA, COLOR_GRAYSCALEALPHA])
  then
     for Y := 0 to Image.Height - 1 do
     begin
       Line := Image.AlphaScanline[Y];
       for X := 0 to Image.Width - 1 do
         if BitTransparency and (Image.Pixels[X, Y] = TransparentColor)
         then
           Line^[X] := 0
         else
           Line^[X] := Round(Line^[X] / 256 * (Amount + 1));
     end;
end;

procedure DrawPNG(Png: TspPngImage; Canvas: TCanvas; const Rect: TRect; AEnabled: Boolean);
var
  PngCopy: TspPngImage;
begin
  if not AEnabled
  then
   begin
     PngCopy := TspPngImage.Create;
     try
       PngCopy.Assign(Png);
       MakeImageBlended(PngCopy);
       PngCopy.Draw(Canvas, Rect);
     finally
       PngCopy.Free;
      end;
    end
  else
    Png.Draw(Canvas, Rect);
end;


var
  PaintRect: TRect;
  Png: TspPngImageItem;
begin
  PaintRect := Rect(X, Y,
    X + FPngImages.Items[Index].PngWidth,
    Y + FPngImages.Items[Index].PngHeight);
  Png := TspPngImageItem(FPngImages.Items[Index]);
  if Png <> nil
  then
    DrawPNG(Png.PngImage, Canvas, PaintRect, Enabled);
end;

end.

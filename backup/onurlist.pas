unit onurlist;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Controls, Graphics, LCLType, LCLIntf, LMessages, Forms,
  BGRABitmap, BGRABitmapTypes, onurskin, onurslider;

type
  TONURListBox = class(TONURSkinCustomControl)
  private
    FItems: TStringList;
    FItemIndex: integer;
    FItemHeight: integer;
    FTopIndex: integer;
    FScrollBar: TONURScrollBar;
    FOnChange: TNotifyEvent;

    // Skin parts
    FBackground: TONURSkinPart;
    FItemNormal: TONURSkinPart;
    FItemHover: TONURSkinPart;
    FItemSelected: TONURSkinPart;

    procedure SetItems(Value: TStringList);
    procedure SetItemIndex(Value: integer);
    procedure SetItemHeight(Value: integer);
    procedure UpdateScrollBar(Sender: TObject);
    function GetSelected: string;
    function GetVisibleItemCount: integer;
    function GetItemRect(Index: integer): TRect;
    function ItemAtPos(Pos: TPoint): integer;

  protected
    procedure Paint; override;
    procedure Resize; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: integer); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Clear;
    function AddItem(const S: string): integer;
    procedure DeleteItem(Index: integer);

  published
    property Align;
    property Anchors;
    property Items: TStringList read FItems write SetItems;
    property ItemIndex: integer read FItemIndex write SetItemIndex default -1;
    property ItemHeight: integer read FItemHeight write SetItemHeight default 24;
    property Selected: string read GetSelected;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
    property OnClick;
    property OnDblClick;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
  end;

implementation

{ TONURListBox }

constructor TONURListBox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := ControlStyle + [csOpaque, csClickEvents, csCaptureMouse];

  FItems := TStringList.Create;
  FItemIndex := -1;
  FItemHeight := 24;
  FTopIndex := 0;

  // Kaydırma çubuğu
  FScrollBar := TONURScrollBar.Create(Self);
  FScrollBar.Parent := Self;
  FScrollBar.Orientation := orVertical;
  FScrollBar.Align := alRight;
  FScrollBar.Width := 17;
  FScrollBar.OnChange := @UpdateScrollBar;

  // Varsayılan boyut
  Width := 150;
  Height := 100;

  SkinElement := 'Listbox';
  // Skin parçaları
  FBackground := TONURSkinPart.Create('Background');
  FItemNormal := TONURSkinPart.Create('ItemNormal');
  FItemHover := TONURSkinPart.Create('ItemHover');
  FItemSelected := TONURSkinPart.Create('ItemSelected');
end;

destructor TONURListBox.Destroy;
begin
  FItems.Free;
  inherited Destroy;
end;

procedure TONURListBox.SetItems(Value: TStringList);
begin
  FItems.Assign(Value);
  UpdateScrollBar(self);
  Invalidate;
end;

procedure TONURListBox.SetItemIndex(Value: integer);
begin
  if (Value < -1) or (Value >= FItems.Count) then
    Value := -1;

  if FItemIndex <> Value then
  begin
    FItemIndex := Value;
    if Assigned(FOnChange) then
      FOnChange(Self);
    Invalidate;
  end;
end;

procedure TONURListBox.SetItemHeight(Value: integer);
begin
  if Value < 1 then Value := 1;
  if FItemHeight <> Value then
  begin
    FItemHeight := Value;
    UpdateScrollBar(self);
    Invalidate;
  end;
end;

procedure TONURListBox.UpdateScrollBar(Sender: TObject);
var
  VisibleCount, TotalHeight: integer;
begin
  if not HandleAllocated then Exit;

  VisibleCount := ClientHeight div FItemHeight;
  TotalHeight := FItems.Count * FItemHeight;

  FScrollBar.Visible := (FItems.Count > VisibleCount);
  if FScrollBar.Visible then
  begin
    FScrollBar.PageSize := VisibleCount;
    FScrollBar.Max := FItems.Count - 1;
    FScrollBar.LargeChange := VisibleCount;
    FScrollBar.Position := FTopIndex;
  end;
end;

function TONURListBox.GetSelected: string;
begin
  if (FItemIndex >= 0) and (FItemIndex < FItems.Count) then
    Result := FItems[FItemIndex]
  else
    Result := '';
end;

function TONURListBox.GetVisibleItemCount: integer;
begin
  Result := ClientHeight div FItemHeight;
  if (ClientHeight mod FItemHeight) > 0 then
    Inc(Result);
end;

function TONURListBox.GetItemRect(Index: integer): TRect;
begin
  if FScrollBar.Visible then

    Result := Rect(0, (Index - FTopIndex) * FItemHeight, ClientWidth -
      FScrollBar.Width, (Index - FTopIndex + 1) * FItemHeight)
  else
    Result := Rect(0, (Index - FTopIndex) * FItemHeight, ClientWidth,
      (Index - FTopIndex + 1) * FItemHeight);

end;

function TONURListBox.ItemAtPos(Pos: TPoint): integer;
begin
  Result := FTopIndex + (Pos.Y div FItemHeight);
  if (Result < 0) or (Result >= FItems.Count) then
    Result := -1;
end;

procedure TONURListBox.Paint;
var
  I, Y, VisibleCount: integer;
  R: TRect;
begin
  inherited Paint;

  // Arka planı çiz
  if Assigned(SkinManager) and Assigned(FBackground) then
  begin
    // Skin'den arka plan çizimi
    // DrawPart(FBackground, ClientRect);
  end
  else
  begin
    // Varsayılan arka plan
    Canvas.Brush.Color := clWindow;
    Canvas.FillRect(ClientRect);
  end;

  // Görünür öğe sayısını hesapla
  VisibleCount := GetVisibleItemCount;

  // Öğeleri çiz
  for I := 0 to VisibleCount - 1 do
  begin
    if (I + FTopIndex) >= FItems.Count then Break;

    Y := I * FItemHeight;
    if FScrollBar.Visible then
      R := Rect(0, Y, ClientWidth - FScrollBar.Width, Y + FItemHeight)
    else
      R := Rect(0, Y, ClientWidth, Y + FItemHeight);

    // Öğe durumuna göre çizim
    if (I + FTopIndex) = FItemIndex then
    begin
      // Seçili öğe
      if Assigned(FItemSelected) then
      begin
        // DrawPart(FItemSelected, R);
      end
      else
      begin
        Canvas.Brush.Color := clHighlight;
        Canvas.Font.Color := clHighlightText;
        Canvas.FillRect(R);
      end;
    end
    else if (ItemAtPos(Point(0, Y)) = I + FTopIndex) and (FItemHover <> nil) then
    begin
      // Üzerine gelinen öğe
      // DrawPart(FItemHover, R);
    end
    else if Assigned(FItemNormal) then
    begin
      // Normal öğe
      // DrawPart(FItemNormal, R);
    end;

    // Metni çiz
    Canvas.TextOut(R.Left + 2, Y + (FItemHeight - Canvas.TextHeight('Wg')) div
      2, FItems[I + FTopIndex]);
  end;
end;

procedure TONURListBox.Resize;
begin
  inherited Resize;
  UpdateScrollBar(self);
  Invalidate;
end;

procedure TONURListBox.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: integer);
var
  Index: integer;
begin
  inherited;
  if Button = mbLeft then
  begin
    Index := ItemAtPos(Point(X, Y));
    if (Index >= 0) and (Index < FItems.Count) then
      ItemIndex := Index;
  end;
end;

procedure TONURListBox.MouseMove(Shift: TShiftState; X, Y: integer);
begin
  inherited;
  // Fare takibi için gerekirse burada işlemler yapılabilir
end;

procedure TONURListBox.Clear;
begin
  FItems.Clear;
  FItemIndex := -1;
  FTopIndex := 0;
  UpdateScrollBar(self);
  Invalidate;
end;

function TONURListBox.AddItem(const S: string): integer;
begin
  Result := FItems.Add(S);
  UpdateScrollBar(self);
  Invalidate;
end;

procedure TONURListBox.DeleteItem(Index: integer);
begin
  if (Index >= 0) and (Index < FItems.Count) then
  begin
    FItems.Delete(Index);
    if FItemIndex >= FItems.Count then
      FItemIndex := FItems.Count - 1;
    UpdateScrollBar(self);
    Invalidate;
  end;
end;

end.

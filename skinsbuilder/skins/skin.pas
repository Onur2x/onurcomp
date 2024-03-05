unit skin;

interface
uses windows,sysutils,Classes,Forms,ExtCtrls,skinini,controls,graphics;
procedure LoadObjectFromStrings(resimler: TList; SkinObject:TControl;
  kontroladi: string; Data: TgenelIni);

implementation
uses clipbrd;
function GetImage(Images: TList; Name: string): Tbitmap;
var
  i: integer;
begin
  for i := 0 to Images.Count-1 do
    begin
      Result := Images[i];
      Exit;
    end;
  Result := nil;
end;
function GetToken(var S: string): string;
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

function ExtractImage(SourceImage: Tbitmap;s:string):Tbitmap;
var
   SrcRect,DstRect: TRect;
   BitMap:Tbitmap;
   sol,ust,sag,alt:integer;
begin
sol:=StrToInt(s);
ust:=StrToInt(s);
sag:=StrToInt(s);
alt:=StrToInt(s);

    try
    BitMap:=TBitmap.Create;
 DstRect := Rect(sol,ust,sag,alt);
 SrcRect := Rect(0,0,sag-sol,alt-ust);
 BitMap.Height:=alt-ust;
 BitMap.Width:=sag-sol;
 BitMap.TransparentColor:=BitMap.Canvas.Pixels[0, Bitmap.Height - 1];
 bitmap.Canvas.CopyRect(srcRect,SourceImage.canvas,dstRect);
 Clipboard.Assign(BitMap);
bitmap.free;
except end;
Result.Assign(Clipboard);

end;

procedure LoadObjectFromStrings(resimler: TList; SkinObject:TControl;
  kontroladi: string; Data: TgenelIni);
var
  S, Word: string;
  Image: TBitmap;
begin
  with SkinObject do
  begin
  name:=kontroladi;
FindComponent(Name);
{
    S := Data.ReadString(ObjectName, 'Align', '');
    if S <> '' then Align := ExtractAlign(S);

    S := Data.ReadString(ObjectName, 'Transparency', '');
    if S <> '' then Transparency := StrToInt(S);

    S := Data.ReadString(ObjectName, 'TileStyle', '');
    if S <> '' then TileStyle := ExtractTileStyle(S);

    S := Data.ReadString(ObjectName, 'Kind', '');
    if S <> '' then Kind := ExtractKind(S);

    S := Data.ReadString(kontroladi, 'Visible', '');
    if S <> '' then  Visible := ExtractVisible(S);

    S := Data.ReadString(kontroladi, 'Color', '');
    if S <> '' then Color := ExtractColor(S);

    S := Data.ReadString(kontroladi, 'FontName', '');
    if S <> '' then FontName := S;
    S := Data.ReadString(kontroladi, 'FontSize', '');
    if S <> '' then FontSize := StrToInt(S);
    S := Data.ReadString(kontroladi, 'FontStyle', '');
    if S <> '' then FontStyle := ExtractFontStyle(S);

    S := Data.ReadString(kontroladi, 'TextColor', '');
    if S <> '' then TextColor := ExtractColor(S);
    S := Data.ReadString(kontroladi, 'DisabledTextColor', '');
    if S <> '' then DisabledTextColor := ExtractColor(S);
    S := Data.ReadString(kontroladi, 'TextAlign', '');;
    if S <> '' then TextAlign := ExtractTextAlign(S);
                       }
    { Extract image }
    S := Data.ReadString(kontroladi, 'Resim', '');
    if S <> '' then
    begin
      Image := GetImage(resimler, GetToken(S));
      if Image <> nil then
      begin
        if image <> nil then
        //  Image.FreeImage;
        Image := ExtractImage(Image, GetToken(S));
//        Image.Name := TempImage.Name;
        end;
      end;
    end;
    { Extract origin and size }
//    S := Data.ReadString(kontroladi, 'Left', '');
//    if S <> '' then Left := StrToInt(S);
//    FAlignLeft := FLeft;
//    S := Data.ReadString(kontroladi, 'Top', '');
//    if S <> '' then FTop := StrToInt(S);
//    FAlignTop := FTop;
//    S := Data.ReadString(kontroladi, 'Width', '');
//    if S <> '' then FWidth := StrToInt(S);
//    S := Data.ReadString(kontroladi, 'Height', '');
//    if S <> '' then FHeight := StrToInt(S);
    { Extract events }
{    S := Data.ReadString(kontroladi, 'HoverEvent', '');
    ExtractEvent(HoverEvent, S);
    S := Data.ReadString(kontroladi, 'LeaveEvent', '');
    ExtractEvent(LeaveEvent, S);
    S := Data.ReadString(kontroladi, 'ClickEvent', '');
    ExtractEvent(ClickEvent, S);
    S := Data.ReadString(kontroladi, 'RightClickEvent', '');
    ExtractEvent(RightClickEvent, S);
    S := Data.ReadString(kontroladi, 'DoubleClickEvent', '');
    ExtractEvent(DoubleClickEvent, S);
    S := Data.ReadString(kontroladi, 'UnClickEvent', '');
    ExtractEvent(UnClickEvent, S);
    S := Data.ReadString(kontroladi, 'SetFocusEvent', '');
    ExtractEvent(SetFocusEvent, S);
    S := Data.ReadString(kontroladi, 'KillFocusEvent', '');
    ExtractEvent(KillFocusEvent, S);}
    { Extract mask }
{    S := Data.ReadString(kontroladi, 'MaskColor', '');
    if S <> '' then
    begin
      MaskColor := ExtractColor(S);
      MaskType := smColor;
    end;
 {   S := Data.ReadString(kontroladi, 'MaskImage', '');
    if S <> '' then
    begin
      TempImage := GetImage(Images, GetToken(S));
      if TempImage <> nil then
      begin
        if MaskImage <> nil then
          MaskImage.FreeBmp;
        MaskImage := ExtractImage(TempImage, S);
        MaskImage.Name := TempImage.Name;
      end;
      MaskType := smImage;
    end;
    { Extract children }
{    S := Data.ReadString(kontroladi, 'Child', '');
    while S <> '' do
    begin
      Word := GetToken(S);
      Obj := TscSkinObject.Create;
      LoadObjectFromStrings(Images, Obj, Word, Data);
      AddChild(Obj);
    end;
  end; }
end;
end.

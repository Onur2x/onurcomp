unit sikinkodu;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, resim, bilesenutil, bilesenim;

const

  sGeneralSection              = 'General';
  sImagesSection               = 'Images';
  sSoundsSection               = 'Sounds';

  sFormSection                 = 'Form';
  sPopupMenuSection            = 'PopupMenu';
  sButtonSection               = 'Button';
  sProgressBarSection          = 'ProgressBar';
  sPanelSection                = 'Panel';
  sCheckBoxSection             = 'CheckBox';
  sRadioButtonSection          = 'RadioButton';
  sPageControl                 = 'PageControl';

 Sign = 'OnAmp Skin Dosyasý';
 Suyari='Lütfen Bu Dosyada Hiç Bir Deðiþiklik Uygulamayýn Aksi Halde Skin Dosyasýný Çalýþtýramazsýnýz';

type

{ TscSkinSource }

  TscSkinSource = class(TComponent)
  private
    { Private declarations }
    FIsLoad: boolean;
    FSkinName: string;
    FAuthorURL: string;
    FSkinVersion: string;
    FAuthor: string;
    FAuthorEMail: string;
    Fuyari:string;
    { Objects and images }
    FObjects: TList;
    FImages: TList;
    { Link to SkinEngine }
    FSkinEngine: TComponent;

    FSizeable: boolean;
    { Objects }
    function GetForm: TscSkinObject;
    function GetCaption: TscSkinObject;
    function GetBottom: TscSkinObject;
    function GetLeft: TscSkinObject;
    function GetRight: TscSkinObject;
    function GetTop: TscSkinObject;
    function GetClient: TscSkinObject;
    function Getustpanel: TscSkinObject;
    function Getortapanel: TscSkinObject;
    function Getaltpanel: TscSkinObject;
    function Getekobant1: TscSkinObject;
    function Getekobant2: TscSkinObject;
    function Getekobant3: TscSkinObject;
    function Getekobant4: TscSkinObject;
    function Getekobant5: TscSkinObject;
    function Getekobant6: TscSkinObject;
    function Getekobant7: TscSkinObject;
    function Getekobant8: TscSkinObject;
    function Getekobant9: TscSkinObject;
    function Getekobant10: TscSkinObject;
    function Getsarkibar: TscSkinObject;
    function Getsesayar: TscSkinObject;
    function Getekolayzirbutonu: TscSkinObject;
    function Geteklebutonu: TscSkinObject;
    function Getemizlebutonu: TscSkinObject;
    function Getekogoster: TscSkinObject;
    function Getkarisik: TscSkinObject;
    function Getdevamli: TscSkinObject;
    function Getsarkigoster: TscSkinObject;
    function GetMenuBar: TscSkinObject;
    function GetMenuBarItem: TscSkinObject;
    function GetPopupMenu: TscSkinPopupMenu;
    function GetTitle: TscSkinObject;
    function GetButton: TscSkinObject;
    function GetProgressBar: TscSkinObject;
    function GetPanel: TscSkinObject;
    function GetCheckBox: TscSkinObject;
    function GetRadioButton: TscSkinObject;
    function GetPageControl: TscSkinObject;
    function Getcalbut: TscSkinObject;
    function Getduraklat: TscSkinObject;
    function Getdurdur: TscSkinObject;
    function Getileri: TscSkinObject;
    function Getgeri: TscSkinObject;
  protected
    { Protected declarations }
    procedure SetSkinEngine(const Value: TComponent);
    procedure UpdateSkinEngine;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    { I/O methods}
    procedure LoadFromFolder(Path: string); dynamic;
    procedure LoadFromFile(FileName: string); dynamic;
    procedure LoadFromStream(Stream: TStream); dynamic;
    procedure SaveToFolder(Path: string); dynamic;
    procedure SaveToFile(FileName: string); dynamic;
    procedure SaveToStream(Stream: TStream); dynamic;
    { Assign and copy methods }
    procedure Assign(Source: TPersistent); override;
    function CreateCopy: TscSkinSource;
    { Objects actions }
    procedure AddObject(Value: TscSkinObject);
    function GetObject(Kind: TscKind): TscSkinObject;
    { Public property }
    property Objects: TList read FObjects;
    property Images: TList read FImages;
   { General properties }
    property SkinName: string read FSkinName write FSkinName;
    property SkinVersion: string read FSkinVersion;
    property Author: string read FAuthor write FAuthor;
    property AuthorEMail: string read FAuthorEMail write FAuthorEMail;
    property AuthorURL: string read FAuthorURL write FAuthorURL;
    property Sizeable: boolean read FSizeable write FSizeable;
    property Uyari: string read Fuyari write Fuyari;
    { Necessary objects }
    property Form: TscSkinObject read GetForm;
    { In form }
    property Caption: TscSkinObject read GetCaption;
    property Title: TscSkinObject read GetTitle;
    property Top: TscSkinObject read GetTop;
    property Left: TscSkinObject read GetLeft;
    property Right: TscSkinObject read GetRight;
    property Bottom: TscSkinObject read GetBottom;
    property Client: TscSkinObject read GetClient;
    { MenuBar }
    property MenuBar: TscSkinObject read GetMenuBar;
    property MenuBarItem: TscSkinObject read GetMenuBarItem;
    { PopupMenu }
    property PopupMenu: TscSkinPopupMenu read GetPopupMenu;
    { Button }
    property Button: TscSkinObject read GetButton;
    property IleriButonu: TscSkinObject read Getileri;
    property geri: TscSkinObject read Getgeri;
    property cal: TscSkinObject read Getcalbut;
    property durdur: TscSkinObject read Getdurdur;
    property duraklat: TscSkinObject read Getduraklat;
    property ortapanel: TscSkinObject read Getortapanel;
    property ustpanel: TscSkinObject read Getustpanel;
    property altpanel: TscSkinObject read Getaltpanel;
    property ekogoster: TscSkinObject read Getekogoster;
    property sarkigoster: TscSkinObject read Getsarkigoster;
    property karisik: TscSkinObject read Getkarisik;
    property devamli: TscSkinObject read Getdevamli;
    property sesayar: TscSkinObject read Getsesayar;
    property ekobant1: TscSkinObject read Getekobant1;
    property ekobant2: TscSkinObject read Getekobant2;
    property ekobant3: TscSkinObject read Getekobant3;
    property ekobant4: TscSkinObject read Getekobant4;
    property ekobant5: TscSkinObject read Getekobant5;
    property ekobant6: TscSkinObject read Getekobant6;
    property ekobant7: TscSkinObject read Getekobant7;
    property ekobant8: TscSkinObject read Getekobant8;
    property ekobant9: TscSkinObject read Getekobant9;
    property ekolayzirbut: TscSkinObject read Getekolayzirbutonu;
    property ekle: TscSkinObject read Geteklebutonu;
    property temizle: TscSkinObject read Getemizlebutonu;


    { ProgressBar }
    property ProgressBar: TscSkinObject read GetProgressBar;
    { PageControl }
    property PageControl: TscSkinObject read GetPageControl;
    { Panel }
    property Panel: TscSkinObject read GetPanel;
    { CheckBox }
    property CheckBox: TscSkinObject read GetCheckBox;
    { RadioButton }
    property RadioButton: TscSkinObject read GetRadioButton;
    { Global settings }
    property isLoad: boolean read FIsLoad write FIsLoad;
    { Link to SkinEngine}
    property SkinEngine: TComponent read FSkinEngine write SetSkinEngine;
  published
    { Published declarations }
  end;

implementation {===============================================================}

uses FileCtrl, SkinIniFiles,skinana, Sikinkaydi;

{ TscSkinSource ===============================================================}

constructor TscSkinSource.Create(AOwner: TComponent);
begin
  inherited;
  FSizeable := true;
  FSkinName := 'OnAmp Skin';
  FSkinVersion := '0,1';
  FAuthor := 'By Onur ERÇELEN';
  FAuthorEMail := 'karamaske3@hotmail.com';
  FAuthorURL := 'http://onurnet.tr.cx';
  FObjects := TList.Create;
  FImages := TList.Create;
end;

destructor TscSkinSource.Destroy;
var
  i: integer;
begin


  for i := 0 to FImages.Count-1 do
    TksBmp(FImages[i]).FreeBmp;
  FImages.Free;

  for i := 0 to FObjects.Count-1 do
    TscSkinObject(FObjects[i]).Free;
  FObjects.Free;
  inherited;
end;

procedure TscSkinSource.Assign(Source: TPersistent);
var
  i: integer;
  SO: TscSkinObject;
begin
  if Source is TscSkinSource then
  begin
    { Clear self }


    for i := 0 to FImages.Count-1 do
      TksBmp(FImages[i]).FreeBmp;
    FImages.Clear;

    for i := 0 to FObjects.Count-1 do
      TscSkinObject(FObjects[i]).Free;
    FObjects.Clear;
    { Add child }
    for i := 0 to (Source as TscSkinSource).FObjects.Count-1 do
    begin
      SO := TscSkinObject.Create;
      SO.Assign(TscSkinObject((Source as TscSkinSource).FObjects[i]));
      AddObject(SO);
    end;
    { Copy sounds }

    { Copy images }
    for i := 0 to (Source as TscSkinSource).FImages.Count-1 do
      FImages.Add(TksBmp((Source as TscSkinSource).FImages[i]).GetCopy);
    { Other properties }
    FSkinName :=  (Source as TscSkinSource).SkinName;
    FSkinVersion := (Source as TscSkinSource).SkinVersion ;
    FAuthor := (Source as TscSkinSource).Author;
    FAuthorEMail := (Source as TscSkinSource).AuthorEmail;
    FAuthorURL := (Source as TscSkinSource).AuthorURL;
    FSizeable := (Source as TscSkinSource).Sizeable;
    FisLoad := (Source as TscSkinSource).FisLoad;
  end
  else
    inherited;
end;

function TscSkinSource.CreateCopy: TscSkinSource;
begin
  Result := TscSkinSource.Create(Owner);
  Result.Assign(Self);
end;

{ I\O methods }

procedure TscSkinSource.LoadFromFolder(Path: string);
var
  SkinObject: TscSkinObject;
  SkinImage: TksBmp;

  SkinFile: TscCustomIniFile;
  Str: TStrings;
  SR: TSearchRec;
  i: integer;
  S: string;
begin
  { Load from folder }
  if csDesigning in ComponentState then Exit;
  if Path = '' then Exit;
  if not DirectoryExists(Path) then Exit;

  if FindFirst(Path+'*.ksp', $FF, SR) = 0 then
  begin
    SkinFile := TscMemIniFile.Create(Path+SR.Name);
    Str := TStringList.Create;
    try
      { Loading general data }
      FSkinName := SkinFile.ReadString(sGeneralSection, 'SkinName', '');
      FSkinVersion := SkinFile.ReadString(sGeneralSection, 'SkinVersion', '');
      FAuthor := SkinFile.ReadString(sGeneralSection, 'Author', '');
      FAuthorEMail := SkinFile.ReadString(sGeneralSection, 'AuthorEmail', '');
      FAuthorURL := SkinFile.ReadString(sGeneralSection, 'AuthorURL', '');
      S := SkinFile.ReadString(sGeneralSection, 'Sizeable', 'true');
      if LowerCase(S) = 'true' then
        FSizeable := true
      else
        FSizeable := false;


      { Load skin images }
      SkinFile.ReadSectionValues(sImagesSection, Str);
      for i := 0 to Str.Count-1 do
      begin
        SkinImage := TksBmp.CreateFromFile(Path+Str.Values[Str.Names[i]]);
        SkinImage.Name := Str.Names[i];
        FImages.Add(SkinImage);
      end;
      { Loading skin objects }
      { Load Form }
      if SkinFile.SectionExists(sFormSection) then
      begin
        SkinObject := TscSkinObject.Create;
        LoadObjectFromStrings(FImages, SkinObject, sFormSection, SkinFile);
        AddObject(SkinObject);
      end;
      { Load MenuItem }
      if SkinFile.SectionExists(sPopupMenuSection) then
      begin
        SkinObject := TscSkinObject.Create;
        LoadObjectFromStrings(FImages, SkinObject, sPopupMenuSection, SkinFile);
        AddObject(SkinObject);
      end;
      { Load Button }
      if SkinFile.SectionExists(sButtonSection) then
      begin
        SkinObject := TscSkinObject.Create;
        LoadObjectFromStrings(FImages, SkinObject, sButtonSection, SkinFile);
        AddObject(SkinObject);
      end;
      { Load ProgressBar }
      if SkinFile.SectionExists(sProgressBarSection) then
      begin
        SkinObject := TscSkinObject.Create;
        LoadObjectFromStrings(FImages, SkinObject, sProgressBarSection, SkinFile);
        AddObject(SkinObject);
      end;
      { Load Panel }
      if SkinFile.SectionExists(sPanelSection) then
      begin
        SkinObject := TscSkinObject.Create;
        LoadObjectFromStrings(FImages, SkinObject, sPanelSection, SkinFile);
        AddObject(SkinObject);
      end;
      { Load CheckBox }
      if SkinFile.SectionExists(sCheckBoxSection) then
      begin
        SkinObject := TscSkinObject.Create;
        LoadObjectFromStrings(FImages, SkinObject, sCheckBoxSection, SkinFile);
        AddObject(SkinObject);
      end;
      { Load RadioButton }
      if SkinFile.SectionExists(sRadioButtonSection) then
      begin
        SkinObject := TscSkinObject.Create;
        LoadObjectFromStrings(FImages, SkinObject, sRadioButtonSection, SkinFile);
        AddObject(SkinObject);
      end;
      { Load PageControl }
      if SkinFile.SectionExists(sPageControl) then
      begin
        SkinObject := TscSkinObject.Create;
        LoadObjectFromStrings(FImages, SkinObject, sPageControl, SkinFile);
        AddObject(SkinObject);
      end;
    finally
      Str.Free;
      SkinFile.Free;
    end;
    { Finish loading SkinSource }
    FIsLoad := true;
    UpdateSkinEngine;
  end;
  FindClose(SR);
end;

procedure TscSkinSource.SaveToFolder(Path: string);
var
  SkinObject: TscSkinObject;
  SkinImage: TksBmp;
  SkinFile: TscCustomIniFile;
  i: integer;
begin
  { Save to file }
  if csDesigning in ComponentState then Exit;
  if Path = '' then Exit;
  if not DirectoryExists(Path) then
    CreateDir(Path);

  SkinFile := TscMemIniFile.Create(Path+'config.kse');
  try
    { Saving general data }
    SkinFile.WriteString(sGeneralSection, 'SkinName', FSkinName);
    SkinFile.WriteString(sGeneralSection, 'SkinVersion', FSkinVersion);
    SkinFile.WriteString(sGeneralSection, 'Author', FAuthor);
    SkinFile.WriteString(sGeneralSection, 'AuthorEmail', FAuthorEMail);
    SkinFile.WriteString(sGeneralSection, 'AuthorURL', FAuthorURL);
    if FSizeable then
      SkinFile.WriteString(sGeneralSection, 'Sizeable', 'true')
    else
      SkinFile.WriteString(sGeneralSection, 'Sizeable', 'false');
    { Save skin sounds }
    { Save skin images }
    for i := 0 to FImages.Count-1 do
    begin
      TksBmp(FImages[i]).SaveToFile(Path+TksBmp(FImages[i]).Name+'.bmp');
      SkinFile.WriteString(sImagesSection, TksBmp(FImages[i]).Name,
        TksBmp(FImages[i]).Name+'.bmp');
    end;
    { Saving skin objects }
    for i := 0 to FObjects.Count-1 do
      SaveObjectToStrings(TscSkinObject(FObjects[i]), SkinFile);
    SkinFile.UpdateFile;
  finally
    SkinFile.Free;
  end;
end;

procedure TscSkinSource.LoadFromFile(FileName: string);
var
  PackFile: TStream;
begin
  if FileName = '' then Exit;
  PackFile := TFileStream.Create(FileName, fmOpenRead);
  try
    LoadFromStream(PackFile);
  finally
    PackFile.Free;
  end;
end;

procedure TscSkinSource.SaveToFile(FileName: string);
var
  PackFile: TStream;
begin
  if FileName = '' then Exit;

  PackFile := TFileStream.Create(FileName, fmCreate);
  try
    SaveToStream(PackFile);
  finally
    PackFile.Free;
  end;
  end;

procedure TscSkinSource.LoadFromStream(Stream: TStream);
var
  SkinObject: TscSkinObject;
  SkinImage: TksBmp;
  SkinFile: TscStringsIniFile;
  Str: TStrings;
  SR: TSearchRec;
  i: integer;
  S: String;
begin
  { Read sign }
  S := ReadString(Stream);
  if S = Sign then
  begin
    SkinFile := TscStringsIniFile.Create;
    Str := TStringList.Create;
    try
      SkinFile.LoadFromStream(Stream);
      { Loading general data }
      FSkinName := SkinFile.ReadString(sGeneralSection, 'SkinName', '');
      FSkinVersion := SkinFile.ReadString(sGeneralSection, 'SkinVersion', '');
      FAuthor := SkinFile.ReadString(sGeneralSection, 'Author', '');
      FAuthorEMail := SkinFile.ReadString(sGeneralSection, 'AuthorEmail', '');
      FAuthorURL := SkinFile.ReadString(sGeneralSection, 'AuthorURL', '');
      S := SkinFile.ReadString(sGeneralSection, 'Sizeable', 'true');
      if LowerCase(S) = 'true' then
        FSizeable := true
      else
        FSizeable := false;
      { Load skin sounds }
      SkinFile.ReadSectionValues(sSoundsSection, Str);
      { Load skin images }
      SkinFile.ReadSectionValues(sImagesSection, Str);
      for i := 0 to Str.Count-1 do
      begin
        SkinImage := TksBmp.CreateFromStream(Stream);
        SkinImage.Name := Str.Names[i];
        FImages.Add(SkinImage);
      end;
      { Loading skin objects }
      { Load Form }
      if SkinFile.SectionExists(sFormSection) then
      begin
        SkinObject := TscSkinObject.Create;
        LoadObjectFromStrings(FImages, SkinObject, sFormSection, SkinFile);
        AddObject(SkinObject);
      end;
      { Load MenuItem }
      if SkinFile.SectionExists(sPopupMenuSection) then
      begin
        SkinObject := TscSkinObject.Create;
        LoadObjectFromStrings(FImages, SkinObject, sPopupMenuSection, SkinFile);
        AddObject(SkinObject);
      end;
      { Load Button }
      if SkinFile.SectionExists(sButtonSection) then
      begin
        SkinObject := TscSkinObject.Create;
        LoadObjectFromStrings(FImages, SkinObject, sButtonSection, SkinFile);
        AddObject(SkinObject);
      end;
      { Load ProgressBar }
      if SkinFile.SectionExists(sProgressBarSection) then
      begin
        SkinObject := TscSkinObject.Create;
        LoadObjectFromStrings(FImages, SkinObject, sProgressBarSection, SkinFile);
        AddObject(SkinObject);
      end;
      { Load Panel }
      if SkinFile.SectionExists(sPanelSection) then
      begin
        SkinObject := TscSkinObject.Create;
        LoadObjectFromStrings(FImages, SkinObject, sPanelSection, SkinFile);
        AddObject(SkinObject);
      end;
      { Load CheckBox }
      if SkinFile.SectionExists(sCheckBoxSection) then
      begin
        SkinObject := TscSkinObject.Create;
        LoadObjectFromStrings(FImages, SkinObject, sCheckBoxSection, SkinFile);
        AddObject(SkinObject);
      end;
      { Load RadioButton }
      if SkinFile.SectionExists(sRadioButtonSection) then
      begin
        SkinObject := TscSkinObject.Create;
        LoadObjectFromStrings(FImages, SkinObject, sRadioButtonSection, SkinFile);
        AddObject(SkinObject);
      end;
      { Load PageControl }
      if SkinFile.SectionExists(sPageControl) then
      begin
        SkinObject := TscSkinObject.Create;
        LoadObjectFromStrings(FImages, SkinObject, sPageControl, SkinFile);
        AddObject(SkinObject);
      end;
    finally
      Str.Free;
      SkinFile.Free;
    end;
  end;
  { Finish loading SkinSource }
  FIsLoad := true;
  UpdateSkinEngine;
end;

procedure TscSkinSource.SaveToStream(Stream: TStream);
var
  SkinObject: TscSkinObject;
  SkinImage: TksBmp;
  SkinFile: TscStringsIniFile;
  Str: TStrings;
  i: integer;
begin
  { Save to file }
  if csDesigning in ComponentState then Exit;

  { Save sign }
  WriteString(Stream, Sign);
  WriteString(Stream, Uyari);
  SkinFile := TscStringsIniFile.Create;
  try
    { Saving general data }
    SkinFile.WriteString(sGeneralSection, 'SkinName', FSkinName);
    SkinFile.WriteString(sGeneralSection, 'SkinVersion', FSkinVersion);
    SkinFile.WriteString(sGeneralSection, 'Author', FAuthor);
    SkinFile.WriteString(sGeneralSection, 'AuthorEmail', FAuthorEMail);
    SkinFile.WriteString(sGeneralSection, 'AuthorURL', FAuthorURL);
    if FSizeable then
      SkinFile.WriteString(sGeneralSection, 'Sizeable', 'true')
    else
      SkinFile.WriteString(sGeneralSection, 'Sizeable', 'false');
    { Save skin sounds  to config }
    { Save skin images to config }
    for i := 0 to FImages.Count-1 do
    begin
      { Save bitmap to config }
      SkinFile.WriteString(sImagesSection, TksBmp(FImages[i]).Name,
        TksBmp(FImages[i]).Name+'.bmp');
    end;
    { Saving skin objects }
    for i := 0 to FObjects.Count-1 do
      SaveObjectToStrings(TscSkinObject(FObjects[i]), SkinFile);
    { Save to package }
    SkinFile.SaveToStream(Stream);
    { Save skin sounds  }
    { Save skin images  }
    for i := 0 to FImages.Count-1 do
    begin
      { Save bitmap to pack }
      TksBmp(FImages[i]).SaveToStream(Stream);
    end;
  finally
    SkinFile.Free;
  end;
end;

{ SkinEngine methods }

procedure TscSkinSource.SetSkinEngine(const Value: TComponent);
var
  i: integer;
begin
  FSkinEngine := Value;
  for i := 0 to FObjects.Count-1 do
    TscSkinObject(FObjects[i]).Engine := FSkinEngine;
end;

procedure TscSkinSource.UpdateSkinEngine;
var
  i: integer;
begin
  FisLoad := true;
  if FSkinEngine <> nil then
    (FSkinEngine as TscSkinEngine).UpdateSkinSource;
  for i := 0 to FObjects.Count-1 do
  begin
    TscSkinObject(FObjects[i]).Source := Self;
    TscSkinObject(FObjects[i]).Engine := FSkinEngine;
  end;
end;

{ Objects methods }

procedure TscSkinSource.AddObject(Value: TscSkinObject);
begin
  if Value = nil then Exit;
  FObjects.Add(Value);
  Value.Source := Self;
  Value.Engine := FSkinEngine;
end;

function TscSkinSource.GetObject(Kind: TscKind): TscSkinObject;
var
  i: integer;
begin
  Result := nil;
  if FObjects.Count = 0 then exit;
  for i := 0 to FObjects.Count-1 do
  begin
    if TscSkinObject(FObjects[i]).Kind = Kind then
    begin
      Result := FObjects[i];
      Break;
    end;
  end;
end;

{ Get form object }

function TscSkinSource.GetForm: TscSkinObject;
begin
  Result := GetObject(skForm);
end;



function TscSkinSource.Getustpanel: TscSkinObject;
begin
  Result := GetObject(skUstPanel);
end;
function TscSkinSource.Getortapanel: TscSkinObject;
begin
  Result := GetObject(skOrtaPanel);
end;
function TscSkinSource.Getaltpanel: TscSkinObject;
begin
  Result := GetObject(skaltPanel);
end;
function TscSkinSource.Getekobant1: TscSkinObject;
begin
  Result := GetObject(skekobant1);
end;
function TscSkinSource.Getekobant2: TscSkinObject;
begin
  Result := GetObject(skekobant2);
end;
function TscSkinSource.Getekobant3: TscSkinObject;
begin
  Result := GetObject(skekobant3);
end;
function TscSkinSource.Getekobant4: TscSkinObject;
begin
  Result := GetObject(skekobant4);
end;
function TscSkinSource.Getekobant5: TscSkinObject;
begin
  Result := GetObject(skekobant5);
end;
function TscSkinSource.Getekobant6: TscSkinObject;
begin
  Result := GetObject(skekobant6);
end;
function TscSkinSource.Getekobant7: TscSkinObject;
begin
  Result := GetObject(skekobant7);
end;
function TscSkinSource.Getekobant8: TscSkinObject;
begin
  Result := GetObject(skekobant8);
end;
function TscSkinSource.Getekobant9: TscSkinObject;
begin
  Result := GetObject(skekobant9);
end;
function TscSkinSource.Getekobant10: TscSkinObject;
begin
  Result := GetObject(skekobant10);
end;
function TscSkinSource.Getsarkibar: TscSkinObject;
begin
  Result := GetObject(sksarkibar);
end;
function TscSkinSource.Getsesayar: TscSkinObject;
begin
  Result := GetObject(sksesayar);
end;
function TscSkinSource.Getekolayzirbutonu: TscSkinObject;
begin
  Result := GetObject(skekolayzirbutonu);
end;
function TscSkinSource.Geteklebutonu: TscSkinObject;
begin
  Result := GetObject(skeklebutonu);
end;

function TscSkinSource.Getemizlebutonu: TscSkinObject;
begin
  Result := GetObject(sktemizlebutonu);
end;
function TscSkinSource.Getkarisik: TscSkinObject;
begin
  Result := GetObject(skkaisik);
end;
function TscSkinSource.Getdevamli: TscSkinObject;
begin
  Result := GetObject(skdevamli);
end;
function TscSkinSource.Getekogoster: TscSkinObject;
begin
  Result := GetObject(skekogoster);
end;
function TscSkinSource.Getsarkigoster: TscSkinObject;
begin
  Result := GetObject(sksarkigoster);
end;

function TscSkinSource.Getcalbut: TscSkinObject;
begin
  Result := GetObject(skcalbutonu);
end;

function TscSkinSource.Getileri: TscSkinObject;
begin
  Result := GetObject(skileributonu);
end;
function TscSkinSource.Getgeri: TscSkinObject;
begin
  Result := GetObject(skgeributonu);
end;
function TscSkinSource.Getduraklat: TscSkinObject;
begin
  Result := GetObject(skileributonu);
end;
function TscSkinSource.Getdurdur: TscSkinObject;
begin
  Result := GetObject(skdurdurbutonu);
end;
function TscSkinSource.GetCaption: TscSkinObject;
begin
  Result := Form.FindObjectByKind(skCaption);
end;

function TscSkinSource.GetTitle: TscSkinObject;
begin
  Result := Form.FindObjectByKind(skTitle);
end;

function TscSkinSource.GetMenuBar: TscSkinObject;
begin
  Result := Form.FindObjectByKind(skMenuBar);
end;

function TscSkinSource.GetBottom: TscSkinObject;
begin
  Result := Form.FindObjectByKind(skBottom);
end;

function TscSkinSource.GetLeft: TscSkinObject;
begin
  Result := Form.FindObjectByKind(skLeft);
end;

function TscSkinSource.GetRight: TscSkinObject;
begin
  Result := Form.FindObjectByKind(skRight);
end;

function TscSkinSource.GetTop: TscSkinObject;
begin
  Result := Form.FindObjectByKind(skTop);
end;

function TscSkinSource.GetClient: TscSkinObject;
begin
  Result := Form.FindObjectByKind(skClient);
end;

function TscSkinSource.GetMenuBarItem: TscSkinObject;
begin
  Result := Form.FindObjectByKind(skMenuBarItem);
end;

{ Get popupmenu objects }

function TscSkinSource.GetPopupMenu: TscSkinPopupMenu;
begin
  Result := TscSkinPopupMenu(GetObject(skPopupMenu));
end;

{ Get button objects }

function TscSkinSource.GetButton: TscSkinObject;
begin
  Result := TscSkinObject(GetObject(skButton));
end;

{ Get progressbar objects }

function TscSkinSource.GetProgressBar: TscSkinObject;
begin
  Result := TscSkinObject(GetObject(skProgressBar));
end;

{ Get panel objects }

function TscSkinSource.GetPanel: TscSkinObject;
begin
  Result := TscSkinObject(GetObject(skPanel));
end;

{ Get checkbox objects }

function TscSkinSource.GetCheckBox: TscSkinObject;
begin
  Result := TscSkinObject(GetObject(skCheckBox));
end;

{ Get radiobutton objects }

function TscSkinSource.GetRadioButton: TscSkinObject;
begin
  Result := TscSkinObject(GetObject(skRadioButton));
end;

{ Get radiobutton objects }

function TscSkinSource.GetPageControl: TscSkinObject;
begin
  Result := TscSkinObject(GetObject(skPageControl));
end;

end.



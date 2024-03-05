
{*******************************************************************}
{                                                                   }
{       SkinEngine                                                  }
{       Version 1                                                   }
{                                                                   }
{       Copyright (c) 1998-2003 Evgeny Kryukov                      }
{       ALL RIGHTS RESERVED                                         }
{                                                                   }
{   The entire contents of this file is protected by                }
{   International Copyright Laws. Unauthorized reproduction,        }
{   reverse-engineering, and distribution of all or any portion of  }
{   the code contained in this file is strictly prohibited and may  }
{   result in severe civil and criminal penalties and will be       }
{   prosecuted to the maximum extent possible under the law.        }
{                                                                   }
{   RESTRICTIONS                                                    }
{                                                                   }
{   THE SOURCE CODE CONTAINED WITHIN THIS FILE AND ALL RELATED      }
{   FILES OR ANY PORTION OF ITS CONTENTS SHALL AT NO TIME BE        }
{   COPIED, TRANSFERRED, SOLD, DISTRIBUTED, OR OTHERWISE MADE       }
{   AVAILABLE TO OTHER INDIVIDUALS WITHOUT KS DEVELOPMENT WRITTEN   }
{   CONSENT AND PERMISSION FROM KS DEVELOPMENT.                     }
{                                                                   }
{   CONSULT THE END USER LICENSE AGREEMENT FOR INFORMATION ON       }
{   ADDITIONAL RESTRICTIONS.                                        }
{                                                                   }
{   DISTRIBUTION OF THIS FILE IS NOT ALLOWED!                       }
{                                                                   }
{       Home:  http://www.ksdev.com                                 }
{       Support: support@ksdev.com                                  }
{       Questions: faq@ksdev.com                                    }
{                                                                   }
{*******************************************************************}
{
 $Id: SkinSource.pas,v 1.1.1.1 2003/03/21 12:12:44 evgeny Exp $                                                            
}

unit SkinSource;

{$I KSSKIN.INC}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, KSDevBmp, SkinConst, SkinTypes, SkinObjects, SkinSound;

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

  Sign = 'SkinEngine package';

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
    { Objects and images }
    FObjects: TList;
    FImages: TList;
    { Link to SkinEngine }
    FSkinEngine: TComponent;
    FSounds: TList;
    FSizeable: boolean;
    { Objects }
    function GetForm: TscSkinObject;
    function GetCaption: TscSkinObject;
    function GetBottom: TscSkinObject;
    function GetLeft: TscSkinObject;
    function GetRight: TscSkinObject;
    function GetTop: TscSkinObject;
    function GetClient: TscSkinObject;

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
    property Sounds: TList read FSounds;
    { General properties }
    property SkinName: string read FSkinName write FSkinName;
    property SkinVersion: string read FSkinVersion;
    property Author: string read FAuthor write FAuthor;
    property AuthorEMail: string read FAuthorEMail write FAuthorEMail;
    property AuthorURL: string read FAuthorURL write FAuthorURL;
    property Sizeable: boolean read FSizeable write FSizeable;
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

uses FileCtrl, SkinEngine, SkinIniFiles, SkinObjectStore;

{ TscSkinSource ===============================================================}

constructor TscSkinSource.Create(AOwner: TComponent);
begin
  inherited;
  FSizeable := true;
  FSkinName := 'KS Skin';
  FSkinVersion := '1.5';
  FAuthor := 'KS Development';
  FAuthorEMail := 'skin@ksdev.com';
  FAuthorURL := 'http://www.ksdev.com';
  
  FObjects := TList.Create;
  FImages := TList.Create;
  FSounds := TList.Create;
end;

destructor TscSkinSource.Destroy;
var
  i: integer;
begin
  for i := 0 to FSounds.Count-1 do
    TscSound(FSounds[i]).FreeSound;
  FSounds.Free;

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
    for i := 0 to FSounds.Count-1 do
      TscSound(FSounds[i]).FreeSound;
    FSounds.Clear;

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
    for i := 0 to (Source as TscSkinSource).FSounds.Count-1 do
    begin
      FSounds.Add(TscSound((Source as TscSkinSource).FSounds[i]).GetCopy);
    end;
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
  SkinSound: TscSound;
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

  if FindFirst(Path+'*.kse', $FF, SR) = 0 then
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
      { Load skin sounds }
      SkinFile.ReadSectionValues(sSoundsSection, Str);
      for i := 0 to Str.Count-1 do
      begin
        SkinSound := TscWave.Create;
        SkinSound.LoadFromFile(Path+Str.Values[Str.Names[i]]);
        SkinSound.Name := Str.Names[i];
        FSounds.Add(SkinSound);
      end;
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
    for i := 0 to FSounds.Count-1 do
    begin
      TscSound(FSounds[i]).SaveToFile(Path+TscSound(FSounds[i]).Name+'.wav');
      SkinFile.WriteString(sSoundsSection, TscSound(FSounds[i]).Name,
        TscSound(FSounds[i]).Name+'.wav');
    end;
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
  SkinSound: TscSound;
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
      for i := 0 to Str.Count-1 do
      begin
        SkinSound := TscWave.Create;
        SkinSound.LoadFromStream(Stream);
        SkinSound.Name := Str.Names[i];
        FSounds.Add(SkinSound);
      end;
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
    for i := 0 to FSounds.Count-1 do
    begin
      { Save sound to config }
      SkinFile.WriteString(sSoundsSection, TscSound(FSounds[i]).Name,
        TscSound(FSounds[i]).Name+'.wav');
    end;
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
    for i := 0 to FSounds.Count-1 do
    begin
      { Save sound to pack }
      TscSound(FSounds[i]).SaveToStream(Stream);
    end;
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



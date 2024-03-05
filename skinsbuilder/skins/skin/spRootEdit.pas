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

unit spRootEdit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, spSkinShellCtrls,
  {$IFNDEF  VER130} DesignEditors, DesignIntf {$ELSE} DsgnIntf {$ENDIF};


type
  TspRootPathEditDlg = class(TForm)
    Button1: TButton;
    Button2: TButton;
    rbUseFolder: TRadioButton;
    GroupBox1: TGroupBox;
    cbFolderType: TComboBox;
    GroupBox2: TGroupBox;
    ePath: TEdit;
    rbUsePath: TRadioButton;
    OpenDialog1: TOpenDialog;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button2Click(Sender: TObject);
    procedure rbUseFolderClick(Sender: TObject);
    procedure rbUsePathClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    procedure UpdateState;
  public
  end;

  TspRootProperty = class(TStringProperty)
  public
    procedure Edit; override;
    function GetAttributes: TPropertyAttributes; override;
  end;

  TspRootEditor = class(TComponentEditor)
  public
    procedure ExecuteVerb(Index: Integer); override;
    function GetVerb(Index: Integer): String; override;
    function GetVerbCount: Integer; override;
  end;

implementation

{$R *.dfm}

uses TypInfo;

resourcestring
  SPickRootPath = 'Please select a root path';
  SEditRoot = 'E&dit Root';

const
  NTFolders = [rfCommonDesktopDirectory, rfCommonPrograms, rfCommonStartMenu,
               rfCommonStartup];

function PathIsCSIDL(Value: string): Boolean;
begin
  Result := GetEnumValue(TypeInfo(TspRootFolder), Value) >= 0;
end;

function RootPathEditor(Value : string): string;
begin
  Result := Value;
  with TspRootPathEditDlg.Create(Application) do
  try
    rbUseFolder.Checked := PathIsCSIDL(Result);
    rbUsePath.Checked := not rbUseFolder.Checked;
    if not PathIsCSIDL(Result) then
    begin
      cbFolderType.ItemIndex := 0;
      ePath.Text := Result;
    end
    else
      cbFolderType.ItemIndex := cbFolderType.Items.IndexOf(Result);

    UpdateState;
    ShowModal;
    if ModalResult = mrOK then
    begin
      if rbUsePath.Checked then
        Result := ePath.Text
      else
        Result := cbFolderType.Items[cbFolderType.ItemIndex];
    end;
  finally
    Free;
  end;
end;

procedure TspRootProperty.Edit;
begin
  SetStrValue(RootPathEditor(GetStrValue));
end;

function TspRootProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [paDialog];
end;

procedure TspRootPathEditDlg.FormCreate(Sender: TObject);
var
  FT: TspRootFolder;
begin
  for FT := Low(TspRootFolder) to High(TspRootFolder) do
    if not ((Win32Platform = VER_PLATFORM_WIN32_WINDOWS) and (FT in NTFolders)) then
      cbFolderType.Items.Add(GetEnumName(TypeInfo(TspRootFolder), Ord(FT)));
  cbFolderType.ItemIndex := 0;
end;

procedure TspRootPathEditDlg.UpdateState;
begin
  cbFolderType.Enabled := rbUseFolder.Checked;
  ePath.Enabled := not rbUseFolder.Checked;
end;

procedure TspRootPathEditDlg.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TspRootPathEditDlg.Button2Click(Sender: TObject);
begin
  ModalResult := mrCancel;
  Close;
end;

procedure TspRootPathEditDlg.rbUseFolderClick(Sender: TObject);
begin
  rbUsePath.Checked := not rbUseFolder.Checked;
  UpdateState;
end;

procedure TspRootPathEditDlg.rbUsePathClick(Sender: TObject);
begin
  rbUseFolder.Checked := not rbUsePath.Checked;
  UpdateState;
end;

procedure TspRootPathEditDlg.Button1Click(Sender: TObject);
begin
  ModalResult := mrOK;
end;


{ TspRootEditor }

procedure TspRootEditor.ExecuteVerb(Index: Integer);

  procedure EditRoot;
  const
    SRoot = 'root';
  var
    Path : string;
  begin
    Path := RootPathEditor(GetPropValue(Component, SRoot, True));
    SetPropValue(Component, SRoot, Path);
    Designer.Modified;
  end;

begin

  case Index of
  0 : EditRoot;
  end;
end;

function TspRootEditor.GetVerb(Index: Integer): String;
begin
  case Index of
  0 : Result := SEditRoot;
  end;
end;

function TspRootEditor.GetVerbCount: Integer;
begin
  Result := 1;
end;

end.

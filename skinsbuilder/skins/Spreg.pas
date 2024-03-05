{*******************************************************************}
{                                                                   }
{       Almediadev Visual Component Library                         }
{       DynamicSkinForm                                             }
{       Version 5.86                                                }
{                                                                   }
{       Copyright (c) 2000-2004 Almediadev                          }
{       ALL RIGHTS RESERVED                                         }
{                                                                   }
{       Home:  http://www.almdev.com                                }
{       Support: support@almdev.com                                 }
{                                                                   }
{*******************************************************************}

unit spreg;

{$P+,S-,W-,R-}
{$WARNINGS OFF}
{$HINTS OFF}

interface

uses Classes, Menus, Dialogs, Forms, Controls,
    {$IFDEF  VER140} DesignEditors, DesignIntf
    {$ELSE} {$IFDEF  VER150} DesignEditors, DesignIntf {$ELSE} DsgnIntf {$ENDIF} {$ENDIF};

type
  TspSkinStatusBarEditor = class(TDefaultEditor)
  public
    procedure ExecuteVerb(Index: Integer); override;
    function GetVerb(Index: Integer): string; override;
    function GetVerbCount: Integer; override;
  end;

  TspSkinToolBarEditor = class(TDefaultEditor)
  public
    procedure ExecuteVerb(Index: Integer); override;
    function GetVerb(Index: Integer): string; override;
    function GetVerbCount: Integer; override;
  end;

  TspSkinPageControlEditor = class(TDefaultEditor)
  public
    procedure ExecuteVerb(Index: Integer); override;
    function GetVerb(Index: Integer): string; override;
    function GetVerbCount: Integer; override;
  end;

procedure Register;

implementation

uses
  SPUtils, SPEffBMP, DynamicSkinForm, SkinData, SkinCtrls, SkinHint, SkinGrids,
  SkinTabs, SysUtils, SkinBoxCtrls, SkinMenus, spTrayIcon, spMessages,
  spSkinZip, spSkinUnZip, spFileCtrl, spSkinShellCtrls, spNBPagesEditor,
  spCalendar, spColorCtrls, spDialogs, spRootEdit;

  { TFilenameProperty }
type
  TspFilenameProperty = class(TStringProperty)
  public
    procedure Edit; override;
    function GetAttributes: TPropertyAttributes; override;
  end;

  TspSkinDataNameProperty = class(TStringProperty)
  public
    function GetAttributes: TPropertyAttributes; override;
    procedure GetValueList(List: TStrings); virtual;
    procedure GetValues(Proc: TGetStrProc); override;
  end;

  TspButtonSkinDataNameProperty = class(TspSkinDataNameProperty)
  public
    procedure GetValueList(List: TStrings); override;
  end;

  TspEditSkinDataNameProperty = class(TspSkinDataNameProperty)
  public
    procedure GetValueList(List: TStrings); override;
  end;

  TspSpinEditSkinDataNameProperty = class(TspSkinDataNameProperty)
  public
    procedure GetValueList(List: TStrings); override;
  end;

  TspGaugeSkinDataNameProperty = class(TspSkinDataNameProperty)
  public
    procedure GetValueList(List: TStrings); override;
  end;

  TspMenuButtonSkinDataNameProperty = class(TspSkinDataNameProperty)
  public
    procedure GetValueList(List: TStrings); override;
  end;

  TspPanelSkinDataNameProperty = class(TspSkinDataNameProperty)
  public
    procedure GetValueList(List: TStrings); override;
  end;

  TspListBoxSkinDataNameProperty = class(TspSkinDataNameProperty)
  public
    procedure GetValueList(List: TStrings); override;
  end;

  TspCheckListBoxSkinDataNameProperty = class(TspSkinDataNameProperty)
  public
    procedure GetValueList(List: TStrings); override;
  end;

  TspComboBoxSkinDataNameProperty = class(TspSkinDataNameProperty)
  public
    procedure GetValueList(List: TStrings); override;
  end;


  TspSplitterSkinDataNameProperty = class(TspSkinDataNameProperty)
  public
    procedure GetValueList(List: TStrings); override;
  end;

  procedure TspSkinDataNameProperty.GetValueList(List: TStrings);
  begin
  end;

  procedure TspSkinDataNameProperty.GetValues(Proc: TGetStrProc);
  var
    I: Integer;
    Values: TStringList;
  begin
    Values := TStringList.Create;
    try
      GetValueList(Values);
      for I := 0 to Values.Count - 1 do Proc(Values[I]);
    finally
      Values.Free;
    end;
  end;

  function TspSkinDataNameProperty.GetAttributes: TPropertyAttributes;
  begin
    Result := [paValueList, paMultiSelect];
  end;

  procedure TspEditSkinDataNameProperty.GetValueList(List: TStrings);
  begin
    List.Add('edit');
    List.Add('buttonedit');
    List.Add('statusedit');
    List.Add('statusbuttonedit');
    List.Add('tooledit');
    List.Add('toolbuttonedit');
  end;

  procedure TspSpinEditSkinDataNameProperty.GetValueList(List: TStrings);
  begin
    List.Add('spinedit');
    List.Add('statusspinedit');
    List.Add('toolspinedit');
  end;

  procedure TspButtonSkinDataNameProperty.GetValueList(List: TStrings);
  begin
    List.Add('button');
    List.Add('resizebutton');
    List.Add('toolbutton');
    List.Add('bigtoolbutton');
  end;

  procedure TspGaugeSkinDataNameProperty.GetValueList(List: TStrings);
  begin
    List.Add('gauge');
    List.Add('vgauge');
    List.Add('statusgauge');
  end;

  procedure TspMenuButtonSkinDataNameProperty.GetValueList(List: TStrings);
  begin
    List.Add('toolmenubutton');
    List.Add('bigtoolmenubutton');
    List.Add('toolmenutrackbutton');
    List.Add('bigtoolmenutrackbutton');
  end;

  procedure TspPanelSkinDataNameProperty.GetValueList(List: TStrings);
  begin
    List.Add('panel');
    List.Add('toolpanel');
    List.Add('bigtoolpanel');
    List.Add('statusbar');
    List.Add('groupbox');
  end;

  procedure TspListBoxSkinDataNameProperty.GetValueList(List: TStrings);
  begin
    List.Add('listbox');
    List.Add('captionlistbox');
  end;

  procedure TspCheckListBoxSkinDataNameProperty.GetValueList(List: TStrings);
  begin
    List.Add('checklistbox');
    List.Add('captionchecklistbox');
  end;

  procedure TspComboBoxSkinDataNameProperty.GetValueList(List: TStrings);
  begin
    List.Add('combobox');
    List.Add('captioncombobox');
    List.Add('statuscombobox');
    List.Add('toolcombobox');
  end;

  procedure TspSplitterSkinDataNameProperty.GetValueList(List: TStrings);
  begin
    List.Add('vsplitter');
    List.Add('hsplitter');
  end;

  procedure TspFilenameProperty.Edit;
  var
    FileOpen: TOpenDialog;
  begin
    FileOpen := TOpenDialog.Create(Application);
    try
      FileOpen.Filename := '';
      FileOpen.InitialDir := ExtractFilePath(FileOpen.Filename);
      FileOpen.Filter := '*.*|*.*';
      FileOpen.Options := FileOpen.Options + [ofHideReadOnly];
      if FileOpen.Execute then SetValue(FileOpen.Filename);
    finally
      FileOpen.Free;
    end;
  end;

  function TspFilenameProperty.GetAttributes: TPropertyAttributes;
  begin
    Result := [paDialog , paRevertable];
  end;

type
  TspSetPagesProperty = class(TPropertyEditor)
  public
    procedure Edit; override;
    function GetAttributes: TPropertyAttributes; override;
    function GetValue: string; override;
    procedure SetValue(const Value: string); override;
   end;

procedure TspSetPagesProperty.Edit;
var
  NB: TspSkinNoteBook;
begin
  try
    NB := TspSkinNoteBook(GetComponent(0));
    spNBPagesEditor.Execute(NB);
  finally
  end;
end;

function TspSetPagesProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [paDialog];
end;

function TspSetPagesProperty.GetValue: string;
begin
  Result := '(Pages)';
end;      

procedure TspSetPagesProperty.SetValue(const Value: string);
begin
  if Value = '' then SetOrdValue(0);
end;


{ Registration }

resourcestring
  sNEW_PAGE = 'New page';
  sDEL_PAGE = 'Delete page';

  sNEW_STATUSPANEL = 'New panel';
  sNEW_STATUSGAUGE = 'New gauge';
  sNEW_STATUSEDIT = 'New edit';
  sNEW_STATUSBUTTONEDIT = 'New edit with button';
  sNEW_STATUSCOMBOBOX = 'New combobox';
  sNEW_STATUSSPINEDIT = 'New spinedit';

  sNEW_TOOLBUTTON = 'New button';
  sNEW_TOOLMENUBUTTON = 'New button with tracking menu';
  sNEW_TOOLMENUTRACKBUTTON = 'New button with chevron and tracking menu';
  sNEW_TOOLSEPARATOR = 'New separator';
  sNEW_TOOLCOMBOBOX = 'New combobox';
  sNEW_TOOLEDIT = 'New edit';
  sNEW_TOOLBUTTONEDIT = 'New edit with button';
  sNEW_TOOLSPINEDIT = 'New spinedit';

procedure Register;
begin
  RegisterComponents('Skin Pack',  [TspDynamicSkinForm,
    TspSkinData, TspCompressedStoredSkin, TspResourceStrData, 
    TspSkinMainMenuBar,
    TspSkinMDITabsBar,
    TspSkinPopupMenu, TspSkinMainMenu, TspTrayIcon,
    TspSkinPanel, TspSkinGroupBox, TspSkinExPanel, TspSkinScrollPanel,
    TspSkinRadioGroup, TspSkinCheckGroup,
    TspSkinButton, TspSkinMenuButton,
    TspSkinSpeedButton, TspSkinMenuSpeedButton,
    TspSkinCheckRadioBox,
    TspSkinGauge, TspSkinTrackBar, TspSkinLabel, TspSkinStdLabel, TspSkinBitLabel,
    TspSkinFrameRegulator,
    TspSkinFrameGauge,
    TspSkinXFormButton,
    TspSkinHint, TspSkinDrawGrid, TspSkinStringGrid,
    TspSkinPageControl, TspSkinTabControl,
    TspSkinListBox, TspSkinComboBox, TspSkinEdit, TspSkinMaskEdit,
    TspSkinPasswordEdit, TspSkinNumericEdit,
    TspSkinMemo, TspSkinMemo2,
    TspSkinScrollBar, TspSkinSpinEdit, TspSkinCheckListBox, TspSkinCheckComboBox,
    TspSkinAnimate, TspSkinSwitch, TspSkinUpDown,
    TspSkinControlBar, TspSkinToolBar, TspSkinStatusBar,
    TspSkinSplitter,
    TspSkinScrollBox, TspSkinColorComboBox, TspSkinFontComboBox,
    TspSkinFontSizeComboBox,
    TspSkinListView, TspSkinTreeView, TspSkinStatusPanel,
    TspSkinRichEdit, TspSkinDateEdit, TspSkinTimeEdit,
    TspSkinMessage, TspSkinZip, TspSkinUnZip, TspSkinTextLabel,
    TspSkinFileListView, TspSkinDirTreeView, TspSkinShellDriveComboBox,
    TspSkinShellComboBox,
    TspSkinDriveComboBox, TspSkinFilterComboBox,
    TspSkinDirectoryListBox, TspSkinFileListBox,
    TspSkinDirectoryEdit, TspSkinFileEdit, TspSkinSaveFileEdit,
    TspSkinHeaderControl, TspSkinTrackEdit, TspSkinSlider,
    TspSkinLinkLabel, TspSkinLinkImage, TspSkinButtonLabel, TspSkinBevel,
    TspSkinButtonsBar, TspSkinNoteBook, TspSkinMonthCalendar,
    TspSkinColorGrid]);

 RegisterComponents('Skin Pack Dialogs', [ TspSkinSelectDirectoryDialog,
    TspOpenSkinDialog, TspSelectSkinDialog, TspSelectSkinsFromFoldersDialog, 
    TspSkinOpenDialog, TspSkinSaveDialog,
    TspSkinOpenPictureDialog, TspSkinSavePictureDialog, TspSkinFontDialog,
    TspSkinInputDialog, TspSkinPasswordDialog, TspSkinConfirmDialog,
    TspSkinProgressDialog, TspSkinTextDialog,
    TspSkinColorDialog, TspSkinSelectValueDialog]);

  RegisterClass(TspSkinTabSheet);

  RegisterPropertyEditor(TypeInfo(string), TspCompressedStoredSkin, 'FileName', TspFilenameProperty);
  RegisterPropertyEditor(TypeInfo(string), TspCompressedStoredSkin, 'CompressedFileName', TspFilenameProperty);
  RegisterPropertyEditor(TypeInfo(string), TspSkinListView, 'HeaderSkinDataName', TspButtonSkinDataNameProperty);
  RegisterPropertyEditor(TypeInfo(string), TspSkinOpenDialog, 'LVHeaderSkinDataName', TspButtonSkinDataNameProperty);
  RegisterPropertyEditor(TypeInfo(string), TspSkinSaveDialog, 'LVHeaderSkinDataName', TspButtonSkinDataNameProperty);
  RegisterPropertyEditor(TypeInfo(string), TspSkinOpenPictureDialog, 'LVHeaderSkinDataName', TspButtonSkinDataNameProperty);
  RegisterPropertyEditor(TypeInfo(string), TspSkinSavePictureDialog, 'LVHeaderSkinDataName', TspButtonSkinDataNameProperty);
  RegisterPropertyEditor(TypeInfo(string), TspSkinButton, 'SkinDataName', TspButtonSkinDataNameProperty);
  RegisterPropertyEditor(TypeInfo(string), TspSkinEdit, 'SkinDataName', TspEditSkinDataNameProperty);
  RegisterPropertyEditor(TypeInfo(string), TspSkinSpinEdit, 'SkinDataName', TspSpinEditSkinDataNameProperty);
  RegisterPropertyEditor(TypeInfo(string), TspSkinButtonsBar, 'SectionButtonSkinDataName', TspButtonSkinDataNameProperty);
  RegisterPropertyEditor(TypeInfo(string), TspSkinHeaderControl, 'SkinDataName', TspButtonSkinDataNameProperty);
  RegisterPropertyEditor(TypeInfo(string), TspSkinGauge, 'SkinDataName', TspGaugeSkinDataNameProperty);
  RegisterPropertyEditor(TypeInfo(string), TspSkinMenuButton, 'SkinDataName', TspMenuButtonSkinDataNameProperty);
  RegisterPropertyEditor(TypeInfo(string), TspSkinSpeedButton, 'SkinDataName', TspButtonSkinDataNameProperty);
  RegisterPropertyEditor(TypeInfo(string), TspSkinMenuSpeedButton, 'SkinDataName', TspMenuButtonSkinDataNameProperty);
  RegisterPropertyEditor(TypeInfo(string), TspSkinPanel, 'SkinDataName', TspPanelSkinDataNameProperty);
  RegisterPropertyEditor(TypeInfo(string), TspSkinListBox, 'SkinDataName', TspListBoxSkinDataNameProperty);
  RegisterPropertyEditor(TypeInfo(string), TspSkinCheckListBox, 'SkinDataName', TspCheckListBoxSkinDataNameProperty);
  RegisterPropertyEditor(TypeInfo(string), TspSkinSplitter, 'SkinDataName', TspSplitterSkinDataNameProperty);
  RegisterPropertyEditor(TypeInfo(string), TspSkinComboBox, 'SkinDataName', TspComboBoxSkinDataNameProperty);
  RegisterPropertyEditor(TypeInfo(TStrings),  TspSkinNoteBook, 'Pages', TspSetPagesProperty);
  RegisterComponentEditor(TspSkinPageControl, TspSkinPageControlEditor);
  RegisterComponentEditor(TspSkinTabSheet, TspSkinPageControlEditor);
  RegisterComponentEditor(TspSkinStatusBar, TspSkinStatusBarEditor);
  RegisterComponentEditor(TspSkinToolBar, TspSkinToolBarEditor);
  //
  RegisterPropertyEditor(TypeInfo(TRoot), TspSkinDirTreeView, 'Root', TspRootProperty);
  RegisterPropertyEditor(TypeInfo(TRoot), TspSkinFileListView, 'Root', TspRootProperty);
  RegisterPropertyEditor(TypeInfo(TRoot), TspSkinShellComboBox, 'Root', TspRootProperty);
  RegisterComponentEditor(TspSkinDirTreeView, TspRootEditor);
  RegisterComponentEditor(TspSkinFileListView, TspRootEditor);
  RegisterComponentEditor(TspSkinShellComboBox, TspRootEditor);
  //
end;

function TspSkinPageControlEditor.GetVerb(Index: Integer): string;
begin
  case Index of
    0:  result := sNEW_PAGE;
    1:  result := sDEL_PAGE;
  end;
end;


procedure TspSkinPageControlEditor.ExecuteVerb(Index: Integer);
var
  NewPage: TspSkinCustomTabSheet;
  PControl : TspSkinPageControl;
begin
  if Component is TspSkinPageControl then
    PControl := TspSkinPageControl(Component)
  else PControl := TspSkinPageControl(TspSkinTabSheet(Component).PageControl);
  case Index of
    0:  begin
          NewPage := TspSkinTabSheet.Create(Designer.GetRoot);
          with NewPage do
          begin
            Parent := PControl;
            PageControl := PControl;
            Name := Designer.UniqueName(ClassName);
            Caption := Name;
          end;
        end;
    1:  begin
          with PControl do
          begin
            NewPage := TspSkinCustomTabSheet(ActivePage);
            NewPage.PageControl := nil;
            NewPage.Free;
          end;
        end;
  end;
  if Designer <> nil then Designer.Modified;
end;

function TspSkinPageControlEditor.GetVerbCount: Integer;
begin
  Result := 2;
end;

procedure TspSkinStatusBarEditor.ExecuteVerb(Index: Integer);
var
  NewPanel: TspSkinStatusPanel;
  NewGauge: TspSkinGauge;
  NewEdit: TspSkinEdit;
  NewSpinEdit: TspSkinSpinEdit;
  NewComboBox: TspSkinComboBox;
  PControl : TspSkinStatusBar;
begin
  if Component is TspSkinStatusBar
  then
    PControl := TspSkinStatusBar(Component)
  else
    Exit;
  case Index of
    0:  begin
          NewPanel := TspSkinStatusPanel.Create(Designer.GetRoot);
          with NewPanel do
          begin
            Left := PControl.Width;
            Parent := PControl;
            Align := alLeft;
            Name := Designer.UniqueName(ClassName);
            SkinData := PControl.SkinData;
            Designer.SelectComponent(NewPanel);
          end;
        end;
    1:  begin
          NewGauge := TspSkinGauge.Create(Designer.GetRoot);
          with NewGauge do
          begin
            Left := PControl.Width;
            SkinDataName := 'statusgauge';
            Parent := PControl;
            Align := alLeft;
            Name := Designer.UniqueName(ClassName);
            SkinData := PControl.SkinData;
            Designer.SelectComponent(NewGauge);
          end;
        end;
    2:
       begin
         NewEdit := TspSkinEdit.Create(Designer.GetRoot);
          with NewEdit do
          begin
            Left := PControl.Width;
            SkinDataName := 'statusedit';
            Parent := PControl;
            Align := alLeft;
            Name := Designer.UniqueName(ClassName);
            SkinData := PControl.SkinData;
            Designer.SelectComponent(NewEdit);
          end;
       end;
    3:
       begin
         NewEdit := TspSkinEdit.Create(Designer.GetRoot);
         with NewEdit do
         begin
           ButtonMode := True;
           Left := PControl.Width;
           SkinDataName := 'statusbuttonedit';
           Parent := PControl;
           Align := alLeft;
           Name := Designer.UniqueName(ClassName);
           SkinData := PControl.SkinData;
           Designer.SelectComponent(NewEdit);
         end;
       end;
    4:
       begin
         NewSpinEdit := TspSkinSpinEdit.Create(Designer.GetRoot);
         with NewSpinEdit do
         begin
           Left := PControl.Width;
           SkinDataName := 'statusspinedit';
           Parent := PControl;
           Align := alLeft;
           Name := Designer.UniqueName(ClassName);
           SkinData := PControl.SkinData;
           Designer.SelectComponent(NewEdit);
         end;
       end;
     5:
       begin
         NewComboBox := TspSkinComboBox.Create(Designer.GetRoot);
         with NewComboBox do
         begin
           Left := PControl.Width;
           SkinDataName := 'statuscombobox';
           Parent := PControl;
           Align := alLeft;
           Name := Designer.UniqueName(ClassName);
           SkinData := PControl.SkinData;
           Designer.SelectComponent(NewEdit);
         end;
       end;
  end;
  if Designer <> nil then Designer.Modified;
end;

function TspSkinStatusBarEditor.GetVerbCount: Integer;
begin
  Result := 6;
end;

function TspSkinStatusBarEditor.GetVerb(Index: Integer): string;
begin
  case Index of
    0: Result := sNEW_STATUSPANEL;
    1: Result := sNEW_STATUSGAUGE;
    2: Result := sNEW_STATUSEDIT;
    3: Result := sNEW_STATUSBUTTONEDIT;
    4: Result := sNEW_STATUSSPINEDIT;
    5: Result := sNEW_STATUSCOMBOBOX;
  end;
end;

procedure TspSkinToolBarEditor.ExecuteVerb(Index: Integer);
var
  NewSpeedButton: TspSkinSpeedButton;
  NewMenuSpeedButton: TspSkinMenuSpeedButton;
  NewBevel: TspSkinBevel;
  NewEdit: TspSkinEdit;
  NewSpinEdit: TspSkinSpinEdit;
  NewComboBox: TspSkinComboBox;
  PControl : TspSkinToolBar;
begin
  if Component is TspSkinToolBar
  then
    PControl := TspSkinToolBar(Component)
  else
    Exit;
  case Index of
    0:  begin
          NewSpeedButton := TspSkinSpeedButton.Create(Designer.GetRoot);
          with NewSpeedButton do
          begin
            Flat := PControl.Flat;
            SkinData := PControl.SkinData;
            Left := PControl.Width;
            Parent := PControl;
            Align := alLeft;
            Name := Designer.UniqueName(ClassName);
            if PControl.SkinDataName = 'bigtoolpanel'
            then
              SkinDataName := 'bigtoolbutton'
            else
              SkinDataName := 'toolbutton';
            Designer.SelectComponent(NewSpeedButton);
          end;
        end;
    1:  begin
          NewMenuSpeedButton := TspSkinMenuSpeedButton.Create(Designer.GetRoot);
          with NewMenuSpeedButton do
          begin
            Flat := PControl.Flat;
            SkinData := PControl.SkinData;
            Left := PControl.Width;
            Parent := PControl;
            Align := alLeft;
            Name := Designer.UniqueName(ClassName);
            if PControl.SkinDataName = 'bigtoolpanel'
            then
              SkinDataName := 'bigtoolmenubutton'
            else
              SkinDataName := 'toolmenubutton';
            Designer.SelectComponent(NewMenuSpeedButton);
          end;
        end;
    2:  begin
          NewMenuSpeedButton := TspSkinMenuSpeedButton.Create(Designer.GetRoot);
          with NewMenuSpeedButton do
          begin
            Flat := PControl.Flat;
            SkinData := PControl.SkinData;
            Left := PControl.Width;
            TrackButtonMode := True;
            Parent := PControl;
            Align := alLeft;
            Name := Designer.UniqueName(ClassName);
            if PControl.SkinDataName = 'bigtoolpanel'
            then
              SkinDataName := 'bigtoolmenutrackbutton'
            else
              SkinDataName := 'toolmenutrackbutton';
            Designer.SelectComponent(NewMenuSpeedButton);
          end;
        end;
    3: begin
          NewBevel := TspSkinBevel.Create(Designer.GetRoot);
          with NewBevel do
          begin
            SkinData := PControl.SkinData;
            Left := PControl.Width;
            Width := 25;
            DividerMode := True;
            Parent := PControl;
            Align := alLeft;
            Name := Designer.UniqueName(ClassName);
            Designer.SelectComponent(NewBevel);
          end;
        end;
    4:
       begin
         NewEdit := TspSkinEdit.Create(Designer.GetRoot);
          with NewEdit do
          begin
            Left := PControl.Width;
            SkinDataName := 'tooledit';
            Parent := PControl;
            Align := alLeft;
            Name := Designer.UniqueName(ClassName);
            SkinData := PControl.SkinData;
            Designer.SelectComponent(NewEdit);
          end;
       end;
    5:
       begin
         NewEdit := TspSkinEdit.Create(Designer.GetRoot);
         with NewEdit do
         begin
           ButtonMode := True;
           Left := PControl.Width;
           SkinDataName := 'toolbuttonedit';
           Parent := PControl;
           Align := alLeft;
           Name := Designer.UniqueName(ClassName);
           SkinData := PControl.SkinData;
           Designer.SelectComponent(NewEdit);
         end;
       end;
    6:
       begin
         NewSpinEdit := TspSkinSpinEdit.Create(Designer.GetRoot);
         with NewSpinEdit do
         begin
           Left := PControl.Width;
           SkinDataName := 'toolspinedit';
           Parent := PControl;
           Align := alLeft;
           Name := Designer.UniqueName(ClassName);
           SkinData := PControl.SkinData;
           Designer.SelectComponent(NewEdit);
         end;
       end;
    7:
       begin
         NewComboBox := TspSkinComboBox.Create(Designer.GetRoot);
         with NewComboBox do
         begin
           Left := PControl.Width;
           SkinDataName := 'toolcombobox';
           Parent := PControl;
           Align := alLeft;
           Name := Designer.UniqueName(ClassName);
           SkinData := PControl.SkinData;
           Designer.SelectComponent(NewEdit);
         end;
       end;
  end;
  if Designer <> nil then Designer.Modified;
end;

function TspSkinToolBarEditor.GetVerbCount: Integer;
begin
  Result := 8;
end;

function TspSkinToolBarEditor.GetVerb(Index: Integer): string;
begin
  case Index of
    0: Result := sNEW_TOOLBUTTON;
    1: Result := sNEW_TOOLMENUBUTTON;
    2: Result := sNEW_TOOLMENUTRACKBUTTON;
    3: Result := sNEW_TOOLSEPARATOR;
    4: Result := sNEW_TOOLEDIT;
    5: Result := sNEW_TOOLBUTTONEDIT;
    6: Result := sNEW_TOOLSPINEDIT;
    7: Result := sNEW_TOOLCOMBOBOX;
  end;
end;

end.

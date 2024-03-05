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

unit spreg;

{$P+,S-,W-,R-}
{$WARNINGS OFF}
{$HINTS OFF}

interface

uses Classes, Menus, Dialogs, Forms, Controls, TypInfo,
    {$IFNDEF VER130} DesignEditors, DesignIntf {$ELSE} DsgnIntf {$ENDIF};

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
  spUtils, spEffBmp, DynamicSkinForm, SkinData, SkinCtrls, SkinExCtrls, SkinHint, SkinGrids,
  SkinTabs, SysUtils, SkinBoxCtrls, SkinMenus, spTrayIcon, spMessages,
  spSkinZip, spSkinUnZip, spFileCtrl, spSkinShellCtrls, spNBPagesEditor,
  spCalendar, spColorCtrls, spDialogs, spRootEdit, SkinPrinter,
  spCategoryButtons, spButtonGroup, spPngImageList, spPngImage, spPngImageEditor,
  spDBGrids, spDBCtrls, DB;


type

  TspDynamicSkinFormEditor = class(TComponentEditor)
    function GetVerb(Index: Integer): string; override;
    function GetVerbCount: integer; override;
    procedure ExecuteVerb(Index: Integer); override;
  end;

  TspPNGPropertyEditor = class(TStringProperty)
  public
    procedure Edit; override;
    function GetAttributes: TPropertyAttributes; override;
    function GetValue: String; override;
 end;

  TspFilenameProperty = class(TStringProperty)
  public
    procedure Edit; override;
    function GetAttributes: TPropertyAttributes; override;
  end;

  TspDBStringProperty = class(TStringProperty)
  public
    function GetAttributes: TPropertyAttributes; override;
    procedure GetValueList(List: TStrings); virtual;
    procedure GetValues(Proc: TGetStrProc); override;
  end;

  TspSkinDataNameProperty = class(TStringProperty)
  public
    function GetAttributes: TPropertyAttributes; override;
    procedure GetValueList(List: TStrings); virtual;
    procedure GetValues(Proc: TGetStrProc); override;
  end;

  TspToolBarSkinDataNameProperty = class(TspSkinDataNameProperty)
  public
    procedure GetValueList(List: TStrings); override;
  end;

  TspButtonSkinDataNameProperty = class(TspSkinDataNameProperty)
  public
    procedure GetValueList(List: TStrings); override;
  end;

  TspButtonExSkinDataNameProperty = class(TspSkinDataNameProperty)
  public
    procedure GetValueList(List: TStrings); override;
  end;


  TspCategoryButtonSkinDataNameProperty = class(TspSkinDataNameProperty)
  public
    procedure GetValueList(List: TStrings); override;
  end;


  TspCategorySkinDataNameProperty = class(TspSkinDataNameProperty)
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

  TspCalendarSkinDataNameProperty = class(TspSkinDataNameProperty)
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

  TspOfficeListBoxSkinDataNameProperty = class(TspSkinDataNameProperty)
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


  procedure TspPNGPropertyEditor.Edit;
  begin
    if PropCount <> 1 then Exit;
    ExecutePngEditor(TspPngImageItem(GetComponent(0)).PngImage);
    Designer.Modified;
  end;

  function TspPNGPropertyEditor.GetAttributes: TPropertyAttributes;
  begin
    Result := inherited GetAttributes + [paDialog, paReadOnly];
  end;

  function TspPNGPropertyEditor.GetValue: String;
  var
    P: TspPngImage;
  begin
    P := TspPngImageItem(GetComponent(0)).PngImage;
    if not P.Empty
    then
      Result := 'PNG image'
    else
      Result := '(none)';
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
  end;

  procedure TspSpinEditSkinDataNameProperty.GetValueList(List: TStrings);
  begin
    List.Add('spinedit');
    List.Add('statusspinedit');
  end;

  procedure TspButtonExSkinDataNameProperty.GetValueList(List: TStrings);
  begin
    List.Add('resizebutton');
    List.Add('resizetoolbutton');
  end;


  procedure TspButtonSkinDataNameProperty.GetValueList(List: TStrings);
  begin
    List.Add('button');
    List.Add('resizebutton');
    List.Add('toolbutton');
    List.Add('bigtoolbutton');
    List.Add('resizetoolbutton');
  end;

  procedure TspCategoryButtonSkinDataNameProperty.GetValueList(List: TStrings);
  begin
    List.Add('button');
    List.Add('resizebutton');
    List.Add('toolbutton');
    List.Add('bigtoolbutton');
    List.Add('resizetoolbutton');
  end;

  procedure TspCategorySkinDataNameProperty.GetValueList(List: TStrings);
  begin
    List.Add('resizetoolpanel');
    List.Add('panel');
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
    List.Add('resizebutton');
    List.Add('resizetoolbutton');
  end;

  procedure TspToolBarSkinDataNameProperty.GetValueList(List: TStrings);
  begin
    List.Add('toolpanel');
    List.Add('bigtoolpanel');
    List.Add('resizetoolpanel');
    List.Add('panel');
  end;

  procedure TspPanelSkinDataNameProperty.GetValueList(List: TStrings);
  begin
    List.Add('panel');
    List.Add('resizetoolpanel');
    List.Add('toolpanel');
    List.Add('bigtoolpanel');
    List.Add('statusbar');
    List.Add('groupbox');
  end;


  procedure TspOfficeListBoxSkinDataNameProperty.GetValueList(List: TStrings);
  begin
    List.Add('listbox');
    List.Add('resizetoolpanel');
    List.Add('panel');
    List.Add('memo');
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

  procedure TspCalendarSkinDataNameProperty.GetValueList(List: TStrings);
  begin
    List.Add('panel');
    List.Add('groupbox');
    List.Add('resizetoolpanel');
  end;

  procedure TspComboBoxSkinDataNameProperty.GetValueList(List: TStrings);
  begin
    List.Add('combobox');
    List.Add('captioncombobox');
    List.Add('statuscombobox');
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


  function TspDBStringProperty.GetAttributes: TPropertyAttributes;
  begin
    Result := [paValueList, paSortList, paMultiSelect];
  end;

  procedure TspDBStringProperty.GetValueList(List: TStrings);
  begin
  end;

  procedure TspDBStringProperty.GetValues(Proc: TGetStrProc);
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

type
  TspColumnDataFieldProperty = class(TspDBStringProperty)
    procedure GetValueList(List: TStrings); override;
  end;

procedure TspColumnDataFieldProperty.GetValueList(List: TStrings);
var
  Grid: TspSkinCustomDBGrid;
  DataSource: TDataSource;
begin
  Grid := (GetComponent(0) as TspColumn).Grid;
  if (Grid = nil) then Exit;
  DataSource := Grid.DataSource;
  if (DataSource <> nil) and (DataSource.DataSet <> nil) then
    DataSource.DataSet.GetFieldNames(List);
end;

type
  TspSkinDBLookUpListBoxFieldProperty = class(TspDBStringProperty)
    procedure GetValueList(List: TStrings); override;
  end;

procedure TspSkinDBLookUpListBoxFieldProperty.GetValueList(List: TStrings);
var
  DataSource: TDataSource;
  LookUpControl: TspDBLookUpControl;
begin
  DataSource := (GetComponent(0) as TspSkinDBLookUpListBox).ListSource;
  if (DataSource <> nil) and (DataSource.DataSet <> nil) then
    DataSource.DataSet.GetFieldNames(List);
end;

type
  TspSkinDBLookUpComboBoxFieldProperty = class(TspDBStringProperty)
    procedure GetValueList(List: TStrings); override;
  end;

procedure TspSkinDBLookUpComboBoxFieldProperty.GetValueList(List: TStrings);
var
  DataSource: TDataSource;
  LookUpControl: TspDBLookUpControl;
begin
  DataSource := (GetComponent(0) as TspSkinDBLookUpComboBox).ListSource;
  if (DataSource <> nil) and (DataSource.DataSet <> nil) then
    DataSource.DataSet.GetFieldNames(List);
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


procedure SPS_ComSetSkinData(TCom: TComponent; spSkinData:TspSkinData);
var
  j, iPropCount: Integer;
  p: ppropinfo;
  plList,pl2: TPropList;
  strProp: String;
  ts: TSTrings;
  k, pc2, l: Integer;
  p2: ppropinfo;
  obj:TObject;
begin        
  if not Assigned(spSkinData) then Exit;
  if not Assigned(TCom) then Exit;
  iPropCount := GetPropList(TCom.classinfo, [tkString, tkLString, tkWString,tkClass], @plList);
  for j := 0 to iPropCount - 1 do
  begin
    p := GetPropInfo(TCom.classinfo, plList[j].name);
    if p = nil then  continue;
    if SameText(p.PropType^.Name, 'TspSkinData')
    then
      begin
        obj := GetObjectProp(TCom, p);
        if obj = nil
        then
          begin
            SetObjectProp(TCom, p, spSkinData);
          end;
        SetStrProp(tcom, p, strProp);
      end;
  end;
end;                          

procedure SPS_FormSetSkinData(WinControl: TWinControl; spSkinData:TspSkinData);
var
  i: Integer;
begin
  if not Assigned(spSkinData) then Exit;
  if not Assigned(WinControl) then Exit;
  for i := 0 to WinControl.componentcount - 1 do
  begin
    SPS_ComSetSkinData(WinControl.Components[i], spSkinData);
  end;
end;

procedure TspDynamicSkinFormEditor.ExecuteVerb(Index: Integer);
begin
  case Index of
    0:
      begin
        if  TspDynamicSkinForm(Component).SkinData <> nil
        then
          begin
            SPS_FormSetSkinData(TWinControl(TspDynamicSkinForm(Component).owner as Controls.TWinControl),
              TspDynamicSkinForm(Component).SkinData);
          end;
      end;
  else
    inherited;
  end;
end;

function TspDynamicSkinFormEditor.GetVerb(Index: Integer): string;
begin
  case Index of
    0: Result := '&Apply SkinData to All Controls';
  end;
end;

function TspDynamicSkinFormEditor.GetVerbCount: integer;
begin
  Result := 1;
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
  sNEW_TOOLNUMERICEDIT = 'New numeric edit';
  sNEW_TOOLFONTCOMBOBOX = 'New font combobox';
  sNEW_TOOLFONTSIZECOMBOBOX = 'New font size combobox';

  sNEW_TOOLMENUCOLORBUTTON = 'New color button';
  sNEW_TOOLMENUCOLORTRACKBUTTON = 'New color button with chevron';

  sNEW_TOOLDIVIDER = 'New divider with alpha channel';


procedure RewritePublishedProperty(ComponentClass: TClass; const PropertyName: string);
var
   LPropInfo: PPropInfo;
begin
  LPropInfo := GetPropInfo(ComponentClass, PropertyName);
  if LPropInfo <> nil
  then
    RegisterPropertyEditor(LPropInfo^.PropType^, ComponentClass, PropertyName, TspPNGPropertyEditor);
end;


procedure Register;
begin
  RegisterComponents('Skin Pack',  [TspDynamicSkinForm, TspSkinFrame, 

    TspSkinData, TspCompressedStoredSkin, TspCompressedSkinList, 
    TspResourceStrData,
    TspSkinMainMenuBar, TspSkinMDITabsBar, TspSkinPopupMenu,
    TspSkinImagesMenu,
    TspSkinMainMenu, TspTrayIcon, TspSkinHint, TspSkinZip, TspSkinUnZip,

    TspSkinScrollBar,

    TspSkinCheckRadioBox, TspSkinButton, TspSkinMenuButton,
    TspSkinSpeedButton, TspSkinMenuSpeedButton, TspSkinColorButton, 
    TspSkinXFormButton,
    TspSkinUpDown,

    TspSkinStdLabel, TspSkinLabel, TspSkinBitLabel, TspSkinTextLabel,
    TspSkinLinkLabel, TspSkinWaveLabel, TspSkinShadowLabel,
    TspSkinLinkImage, TspSkinButtonLabel, TspSkinBevel,
    TspSkinSplitter, TspSkinSplitterEx,

    TspSkinListBox, TspSkinComboBox, TspSkinMRUComboBox, TspSkinComboBoxEx,
    TspSkinColorComboBox, TspSkinColorListBox,
    TspSkinFontComboBox, TspSkinFontListBox,
    TspSkinFontSizeComboBox,

    TspSkinEdit, TspSkinMaskEdit,
    TspSkinPasswordEdit, TspSkinNumericEdit, TspSkinMonthCalendar,
    TspSkinDateEdit, TspSkinTimeEdit,
    TspSkinTrackEdit, TspSkinURLEdit,
    TspSkinMemo, TspSkinMemo2, TspSkinRichEdit,
    TspSkinSpinEdit, TspSkinCheckListBox, TspSkinCheckComboBox,

    TspSkinPanel, TspSkinGroupBox, TspSkinExPanel, TspSkinScrollPanel,
    TspSkinPaintPanel,
    TspSkinRadioGroup, TspSkinCheckGroup,
    TspSkinControlBar, TspSkinCoolBar,
    TspSkinToolBar, TspSkinStatusBar, TspSkinStatusPanel,
    TspSkinButtonsBar, TspSkinNoteBook, TspSkinScrollBox, TspSkinHeaderControl,
    TspSkinPageControl, TspSkinTabControl,
    TspSkinListView, TspSkinTreeView, TspSkinDrawGrid, TspSkinStringGrid,

    TspSkinTrackBar, TspSkinSlider, TspSkinGauge, TspSkinAnimateGauge, 
    TspSkinFrameRegulator, TspSkinFrameGauge,
    TspSkinAnimate, TspSkinSwitch,

    TspSkinFileListView, TspSkinDirTreeView, TspSkinShellDriveComboBox,
    TspSkinShellComboBox,
    TspSkinDriveComboBox, TspSkinFilterComboBox,
    TspSkinDirectoryListBox, TspSkinFileListBox,
    TspSkinDirectoryEdit, TspSkinFileEdit, TspSkinSaveFileEdit,
    TspSkinColorGrid, TspSkinCategoryButtons, TspSkinButtonGroup,
    TspPngImageList, TspPngImageStorage, TspPngImageView]);

  RegisterComponents('SkinPack DB VCL',
    [TspSkinDBGrid, TspSkinDBText,
     TspSkinDBEdit, TspSkinDBMemo, TspSkinDBMemo2,
     TspSkinDBCheckRadioBox, TspSkinDBListBox, TspSkinDBComboBox,
     TspSkinDBNavigator, TspSkinDBImage, TspSkinDBRadioGroup,
     TspSkinDBSpinEdit, TspSkinDBRichEdit,
     TspSkinDBLookUpListBox, TspSkinDBLookUpComboBox,
     TspSkinDBDateEdit, TspSkinDBTimeEdit,
     TspSkinDBPasswordEdit, TspSkinDBNumericEdit]);

  RegisterComponents('Skin Pack Dialogs', [TspSkinMessage, TspSkinSelectDirectoryDialog,
    TspOpenSkinDialog, TspSelectSkinDialog, TspSelectSkinsFromFoldersDialog,
    TspSkinOpenDialog, TspSkinSaveDialog,
    TspSkinOpenPictureDialog, TspSkinSavePictureDialog, TspSkinFontDialog,
    TspSkinInputDialog, TspSkinPasswordDialog, TspSkinConfirmDialog,
    TspSkinProgressDialog, TspSkinTextDialog,
    TspSkinColorDialog, TspSkinSelectValueDialog,
    TspSkinPrintDialog, TspSkinPrinterSetupDialog, TspSkinSmallPrintDialog,
    TspSkinPageSetupDialog,
    TspSkinFindDialog, TspSkinReplaceDialog,
    TspSkinOpenPreviewDialog, TspSkinSavePreviewDialog,
    TspSkinOpenSoundDialog, TspSkinSaveSoundDialog]);


  RegisterClass(TspSkinTabSheet);


  RegisterComponents('Skin Pack Graphics',
    [TspSkinGradientStyleButton, TspSkinBrushStyleButton,
     TspSkinPenStyleButton, TspSkinPenWidthButton,
     TspSkinBrushColorButton, TspSkinTextColorButton,
     TspSkinShadowStyleButton]);

  RegisterComponents('Skin Pack Additionals',
   [TspSkinButtonEx, TspSkinOfficeListBox, TspSkinOfficeComboBox,
    TspSkinHorzListBox,     
   TspSkinLinkBar, TspSkinVistaGlowLabel, TspSkinToolBarEx, TspSkinMenuEx, TspSkinDivider,
   TspSkinGridView]);

  RegisterPropertyEditor(TypeInfo(string), TspColumn, 'FieldName', TspColumnDataFieldProperty);
  RegisterPropertyEditor(TypeInfo(string), TspSkinDBLookUpListBox, 'KeyField', TspSkinDBLookUpListBoxFieldProperty);
  RegisterPropertyEditor(TypeInfo(string), TspSkinDBLookUpListBox, 'ListField', TspSkinDBLookUpListBoxFieldProperty);
  RegisterPropertyEditor(TypeInfo(string), TspSkinDBLookUpComboBox, 'KeyField', TspSkinDBLookUpComboBoxFieldProperty);
  RegisterPropertyEditor(TypeInfo(string), TspSkinDBLookUpComboBox, 'ListField', TspSkinDBLookUpComboBoxFieldProperty);
  //
  RegisterPropertyEditor(TypeInfo(string), TspCompressedStoredSkin, 'FileName', TspFilenameProperty);
  RegisterPropertyEditor(TypeInfo(string), TspSkinListItem, 'FileName', TspFilenameProperty);
  RegisterPropertyEditor(TypeInfo(string), TspSkinListItem, 'CompressedFileName', TspFilenameProperty);
  RegisterPropertyEditor(TypeInfo(string), TspCompressedStoredSkin, 'CompressedFileName', TspFilenameProperty);
  RegisterPropertyEditor(TypeInfo(string), TspSkinListView, 'HeaderSkinDataName', TspButtonSkinDataNameProperty);
  RegisterPropertyEditor(TypeInfo(string), TspSkinOpenDialog, 'LVHeaderSkinDataName', TspButtonSkinDataNameProperty);
  RegisterPropertyEditor(TypeInfo(string), TspSkinSaveDialog, 'LVHeaderSkinDataName', TspButtonSkinDataNameProperty);
  RegisterPropertyEditor(TypeInfo(string), TspSkinOpenPictureDialog, 'LVHeaderSkinDataName', TspButtonSkinDataNameProperty);
  RegisterPropertyEditor(TypeInfo(string), TspSkinSavePictureDialog, 'LVHeaderSkinDataName', TspButtonSkinDataNameProperty);
  RegisterPropertyEditor(TypeInfo(string), TspSkinButton, 'SkinDataName', TspButtonSkinDataNameProperty);
  RegisterPropertyEditor(TypeInfo(string), TspSkinButtonEx, 'SkinDataName', TspButtonExSkinDataNameProperty);
  RegisterPropertyEditor(TypeInfo(string), TspSkinPageControl, 'ButtonTabSkinDataName', TspButtonExSkinDataNameProperty);
  RegisterPropertyEditor(TypeInfo(string), TspSkinCategoryButtons, 'ButtonsSkinDataName', TspCategoryButtonSkinDataNameProperty);
  RegisterPropertyEditor(TypeInfo(string), TspSkinCategoryButtons, 'CategorySkinDataName', TspCategorySkinDataNameProperty);
  RegisterPropertyEditor(TypeInfo(string), TspSkinButtonGroup, 'ButtonsSkinDataName', TspCategoryButtonSkinDataNameProperty);
  RegisterPropertyEditor(TypeInfo(string), TspSkinEdit, 'SkinDataName', TspEditSkinDataNameProperty);
  RegisterPropertyEditor(TypeInfo(string), TspSkinSpinEdit, 'SkinDataName', TspSpinEditSkinDataNameProperty);
  RegisterPropertyEditor(TypeInfo(string), TspSkinButtonsBar, 'SectionButtonSkinDataName', TspButtonSkinDataNameProperty);
  RegisterPropertyEditor(TypeInfo(string), TspSkinHeaderControl, 'SkinDataName', TspButtonSkinDataNameProperty);
  RegisterPropertyEditor(TypeInfo(string), TspSkinGauge, 'SkinDataName', TspGaugeSkinDataNameProperty);
  RegisterPropertyEditor(TypeInfo(string), TspSkinMenuButton, 'SkinDataName', TspMenuButtonSkinDataNameProperty);
  RegisterPropertyEditor(TypeInfo(string), TspSkinSpeedButton, 'SkinDataName', TspButtonSkinDataNameProperty);
  RegisterPropertyEditor(TypeInfo(string), TspSkinMenuSpeedButton, 'SkinDataName', TspMenuButtonSkinDataNameProperty);
  RegisterPropertyEditor(TypeInfo(string), TspSkinPanel, 'SkinDataName', TspPanelSkinDataNameProperty);
  RegisterPropertyEditor(TypeInfo(string), TspSkinToolBar, 'SkinDataName', TspToolBarSkinDataNameProperty);
  RegisterPropertyEditor(TypeInfo(string), TspSkinListBox, 'SkinDataName', TspListBoxSkinDataNameProperty);
  RegisterPropertyEditor(TypeInfo(string), TspSkinOfficeListBox, 'SkinDataName', TspOfficeListBoxSkinDataNameProperty);
  RegisterPropertyEditor(TypeInfo(string), TspSkinGridView, 'SkinDataName', TspOfficeListBoxSkinDataNameProperty);
  RegisterPropertyEditor(TypeInfo(string), TspSkinHorzListBox, 'SkinDataName', TspOfficeListBoxSkinDataNameProperty);
  RegisterPropertyEditor(TypeInfo(string), TspSkinLinkBar, 'SkinDataName', TspOfficeListBoxSkinDataNameProperty);
  RegisterPropertyEditor(TypeInfo(string), TspSkinOfficeComboBox, 'ListBoxSkinDataName', TspOfficeListBoxSkinDataNameProperty);
  RegisterPropertyEditor(TypeInfo(string), TspSkinCheckListBox, 'SkinDataName', TspCheckListBoxSkinDataNameProperty);
  RegisterPropertyEditor(TypeInfo(string), TspSkinSplitter, 'SkinDataName', TspSplitterSkinDataNameProperty);
  RegisterPropertyEditor(TypeInfo(string), TspSkinSplitterEx, 'SkinDataName', TspSplitterSkinDataNameProperty);
  RegisterPropertyEditor(TypeInfo(string), TspSkinComboBox, 'SkinDataName', TspComboBoxSkinDataNameProperty);
  RegisterPropertyEditor(TypeInfo(TStrings),  TspSkinNoteBook, 'Pages', TspSetPagesProperty);

  RegisterPropertyEditor(TypeInfo(string), TspSkinMonthCalendar, 'SkinDataName', TspCalendarSkinDataNameProperty);
  RegisterPropertyEditor(TypeInfo(string), TspSkinDateEdit, 'CalendarSkinDataName', TspCalendarSkinDataNameProperty);

  RegisterComponentEditor(TspDynamicSkinForm, TspDynamicSkinFormEditor);
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
  RewritePublishedProperty(TspPngImageItem, 'PngImage');
  RewritePublishedProperty(TspPngStorageImageItem, 'PngImage');
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
  NewNumericEdit: TspSkinNumericEdit;
  NewFontComboBox: TspSkinFontComboBox;
  NewFontSizeComboBox: TspSkinFontSizeComboBox;
  NewColorButton: TspSkinColorButton;
  NewDivider: TspSkinDivider;
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
            if (PControl.SkinDataName = 'resizetoolpanel')
            then
              SkinDataName := 'resizetoolbutton'
            else
            if PControl.SkinDataName = 'panel'
            then
              SkinDataName := 'resizebutton'
            else
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
            if (PControl.SkinDataName = 'resizetoolpanel')
            then
              SkinDataName := 'resizetoolbutton'
            else
            if PControl.SkinDataName = 'panel'
            then
              SkinDataName := 'resizebutton'
            else
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
            if (PControl.SkinDataName = 'resizetoolpanel')
            then
              SkinDataName := 'resizetoolbutton'
            else
            if PControl.SkinDataName = 'panel'
            then
              SkinDataName := 'resizebutton'
            else
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
            SkinDataName := 'edit';
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
           SkinDataName := 'buttonedit';
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
           SkinDataName := 'spinedit';
           Parent := PControl;
           Align := alLeft;
           Name := Designer.UniqueName(ClassName);
           SkinData := PControl.SkinData;
           Designer.SelectComponent(NewSpinEdit);
         end;
       end;
    7:
       begin
         NewComboBox := TspSkinComboBox.Create(Designer.GetRoot);
         with NewComboBox do
         begin
           Left := PControl.Width;
           SkinDataName := 'combobox';
           Parent := PControl;
           Align := alLeft;
           Name := Designer.UniqueName(ClassName);
           SkinData := PControl.SkinData;
           Designer.SelectComponent(NewComboBox);
         end;
       end;
    8: begin
         NewNumericEdit := TspSkinNumericEdit.Create(Designer.GetRoot);
         with NewNumericEdit do
         begin
           Left := PControl.Width;
           SkinDataName := 'buttonedit';
           Parent := PControl;
           Align := alLeft;
           Name := Designer.UniqueName(ClassName);
           SkinData := PControl.SkinData;
           Designer.SelectComponent(NewNumericEdit);
         end;
       end;
    9:
       begin
         NewFontComboBox := TspSkinFontComboBox.Create(Designer.GetRoot);
         with NewFontComboBox do
         begin
           Left := PControl.Width;
           SkinDataName := 'combobox';
           Parent := PControl;
           Align := alLeft;
           Name := Designer.UniqueName(ClassName);
           SkinData := PControl.SkinData;
           Designer.SelectComponent(NewFontComboBox);
         end;
       end;
    10:
       begin
         NewFontSizeComboBox := TspSkinFontSizeComboBox.Create(Designer.GetRoot);
         with NewFontSizeComboBox do
         begin
           Left := PControl.Width;
           SkinDataName := 'combobox';
           Parent := PControl;
           Align := alLeft;
           Name := Designer.UniqueName(ClassName);
           SkinData := PControl.SkinData;
           Designer.SelectComponent(NewFontSizeComboBox);
         end;
       end;
      11:  begin
          NewColorButton := TspSkinColorButton.Create(Designer.GetRoot);
          with NewColorButton do
          begin
            Flat := PControl.Flat;
            SkinData := PControl.SkinData;
            Left := PControl.Width;
            Parent := PControl;
            Align := alLeft;
            Name := Designer.UniqueName(ClassName);
            if (PControl.SkinDataName = 'resizetoolpanel')
            then
              SkinDataName := 'resizetoolbutton'
            else
            if PControl.SkinDataName = 'panel'
            then
              SkinDataName := 'resizebutton'
            else
            if PControl.SkinDataName = 'bigtoolpanel'
            then
              SkinDataName := 'bigtoolmenubutton'
            else
              SkinDataName := 'toolmenubutton';
            Designer.SelectComponent(NewMenuSpeedButton);
          end;
        end;
    12: begin
          NewColorButton := TspSkinColorButton.Create(Designer.GetRoot);
          with NewColorButton do
          begin
            Flat := PControl.Flat;
            SkinData := PControl.SkinData;
            Left := PControl.Width;
            TrackButtonMode := True;
            Parent := PControl;
            Align := alLeft;
            Name := Designer.UniqueName(ClassName);
            if (PControl.SkinDataName = 'resizetoolpanel')
            then
              SkinDataName := 'resizetoolbutton'
            else
            if PControl.SkinDataName = 'panel'
            then
              SkinDataName := 'resizebutton'
            else
            if PControl.SkinDataName = 'bigtoolpanel'
            then
              SkinDataName := 'bigtoolmenutrackbutton'
            else
              SkinDataName := 'toolmenutrackbutton';
            Designer.SelectComponent(NewMenuSpeedButton);
          end;
        end;

     13: begin
          NewDivider := TspSkinDivider.Create(Designer.GetRoot);
          with NewDivider do
          begin
            SkinData := PControl.SkinData;
            Left := PControl.Width;
            Width := 15;
            Parent := PControl;
            Align := alLeft;
            Name := Designer.UniqueName(ClassName);
            Designer.SelectComponent(NewDivider);
          end;
        end;
  end;
  if Designer <> nil then Designer.Modified;
end;

function TspSkinToolBarEditor.GetVerbCount: Integer;
begin
  Result := 14;
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
    8: Result := sNEW_TOOLNUMERICEDIT;
    9: Result := sNEW_TOOLFONTCOMBOBOX;
    10: Result := sNew_TOOLFONTSIZECOMBOBOX;
    11: Result := sNEW_TOOLMENUCOLORBUTTON;
    12: Result := sNEW_TOOLMENUCOLORTRACKBUTTON;
    13: Result := sNEW_TOOLDIVIDER;
  end;
end;

end.

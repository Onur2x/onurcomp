unit sRegisterIt;
{$I sDefs.inc}

interface

uses
  Classes, sScrollBar,
  {$IFNDEF ALITE}
    sCustomComboBox, sCurrencyEdit, sSpinEdit, sMemo, sRadioButton, sComboEdit,
    sPageControl, sCustomMenuManager, sCurrEdit, sToolEdit, sMonthCalendar,
    sHintManager, sBevel, sGroupBox, sStatusBar, sGauge, sTrackBar, sCalculator,
    sCustomMaskEdit, sCustomListBox, sEditorsManager, sComboBoxes, sSplitter,
    sControlsManager, sEdit, sCustomLabel, sSkinManager, sSkinProvider, sTabControl,
    sCheckBox, sStyleUtil, sPanel, sCustomButton, sScrollBox, sImageList, sCheckListBox,
    sAlphaListBox, sTreeView, sListView;
  {$ELSE}
    sEdit, sCustomLabel, sSkinManager, sSkinProvider,
    sCheckBox, sStyleUtil, sPanel, sCustomButton;
  {$ENDIF}

procedure Register;

implementation

uses Registry, Windows, sUtils, SysUtils;

procedure Register;
begin

{$IFNDEF ALITE}

  RegisterComponents('AlphaControls', [
    TsEdit, TsCheckBox, TsPanel, TsButton
    ,TsBitBtn, TsMemo, TsComboEdit, TsCurrencyEdit, TsMaskEdit, TsListBox, TsDateEdit,
    TsGauge, TsTrackBar, TsRadioButton, TsPageControl, TsStatusBar, TsDirectoryEdit,
    TsContainer, TsSpeedButton, TsColorSelect, TsCalcEdit, TsFileNameEdit, TsSplitter, 
    TsToolBar, TsSpinEdit, TsBevel, TsGroupBox, TsComboBox, TsLabel, TsColorBox, 
    TsDragBar, TsWebLabel, TsMonthCalendar, TsScrollBar, TsScrollBox, TsComboBoxEx,
    TsTabControl, TsCheckListBox, TsTreeView, TsListView{, TsAlphaListBox}]);

  RegisterComponents('AlphaTools', [
    TsMenuManager, TsHintManager, TsSkinProvider, TsSkinManager,
    TsCalculator, TsEditorsManager, TsControlsManager{, TsImageList in progress}]);

  RegisterNoIcon([TsTabSheet]);
  RegisterClasses([TsTabSheet]);

{$ELSE}

  RegisterComponents('AlphaLite', [
    TsSkinManager, TsSkinProvider, TsEdit, TsCheckBox, TsPanel, TsButton,
    TsScrollBar, TsLabel, TsWebLabel]);

{$ENDIF}

end;

end.

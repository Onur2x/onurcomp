unit TFlatRegister;

interface

procedure Register;

implementation  

uses
  Classes,
  TFlatButtonUnit, TFlatSpeedButtonUnit, TFlatEditUnit, TFlatMemoUnit,
  TFlatRadioButtonUnit, TFlatCheckBoxUnit, TFlatProgressBarUnit, TFlatHintUnit,
  TFlatTabControlUnit, TFlatListBoxUnit, TFlatComboBoxUnit, TFlatAnimWndUnit,
  TFlatSoundUnit, TFlatGaugeUnit, TFlatSplitterUnit, TFlatAnimationUnit;

procedure Register;
begin
  RegisterComponents ('FlatStyle', [TFlatButton, TFlatSpeedButton, TFlatCheckBox,
    TFlatRadioButton, TFlatEdit, TFlatMemo, TFlatProgressBar, TFlatTabControl,
    TFlatListBox, TFlatComboBox, TFlatHint, TFlatAnimWnd, TFlatSound,
    TFlatGauge, TFlatSplitter, TFlatAnimation]);
end;

end.

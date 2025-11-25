unit testee;

{$mode objfpc}{$H+}

interface

uses
  Classes, onurpanel, onurslider, SysUtils, Forms, Controls, Graphics, Dialogs,
  ExtCtrls, StdCtrls, onurskin, onurbutton;

type
  TForm1 = class(TForm)
    Button1: TButton;
    ONURBadgeButton1: TONURBadgeButton;
    ONURButton1: TONURButton;
    ONURCard1: TONURCard;
    ONURCheckBox1: TONURCheckBox;
    ONURCollapsiblePanel1: TONURCollapsiblePanel;
    ONURFloatingButton1: TONURFloatingButton;
    ONURGaugeBar1: TONURGaugeBar;
    ONURGroupBox1: TONURGroupBox;
    ONURIconButton1: TONURIconButton;
    ONURKnob1: TONURKnob;
    ONURLoadingBar1: TONURLoadingBar;
    ONURMeterBar1: TONURMeterBar;
    ONURPanel1: TONURPanel;
    ONURProgressBar1: TONURProgressBar;
    ONURRadioButton1: TONURRadioButton;
    ONURRangeBar1: TONURRangeBar;
    ONURRippleButton1: TONURRippleButton;
    ONURScrollBar1: TONURScrollBar;
    ONURSegmentedButton1: TONURSegmentedButton;
    ONURSkinManager1: TONURSkinManager;
    ONURSliderBar1: TONURSliderBar;
    ONURSplitButton1: TONURSplitButton;
    ONURSwitchBar1: TONURSwitchBar;
    ONURSystemButton1: TONURSystemButton;
    ONURTimeBar1: TONURTimeBar;
    ONURToggleButton1: TONURToggleButton;
    ONURTrackBar1: TONURTrackBar;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private

  public
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
begin
  // Form ayarları
  Width := 800;
  Height := 600;
  Position := poScreenCenter;
  Caption := 'ONUR Skin Sistemi Demo';

end;



procedure TForm1.Button1Click(Sender: TObject);
begin
  ONURSkinManager1.LoadSkinFromFile('test.osk');
end;

end.

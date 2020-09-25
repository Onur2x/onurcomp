unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, onurbutton;

type

  { TForm1 }

  TForm1 = class(TForm)
    ONButton1: TONButton;
    OnCheckBox1: TOnCheckBox;
    ONCOMBOBOX1: TONCOMBOBOX;
    ONCropButton1: TONCropButton;
    ONCropButton2: TONCropButton;
    ONCURREDIT1: TONCURREDIT;
    ONDATEEDIT1: TONDATEEDIT;
    ONEDIT1: TONEDIT;
    OnGroupBox1: TOnGroupBox;
    ONImg1: TONImg;
    ONMEMO1: TONMEMO;
    ONPANEL1: TONPANEL;
    ONPANEL2: TONPANEL;
    ONProgressBar1: TONProgressBar;
    OnRadioButton1: TOnRadioButton;
    OnSwich1: TOnSwich;
    procedure ONCropButton2Click(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.ONCropButton2Click(Sender: TObject);
begin
  close;
end;

end.


unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, onurbutton;

type

  { TForm1 }

  TForm1 = class(TForm)
    OnCheckbox1: TOnCheckbox;
    OnCheckbox2: TOnCheckbox;
    ONCollapExpandPanel1: TONCollapExpandPanel;
    ONcombobox1: TONcombobox;
    ONCropButton1: TONCropButton;
    ONCropButton2: TONCropButton;
    onEdit1: TonEdit;
    onEdit2: TonEdit;
    ONGraphicPanel1: TONGraphicPanel;
    ONGraphicsButton1: TONGraphicsButton;
    ONHeaderPanel1: TONHeaderPanel;
    ONImg1: TONImg;
    ONImg2: TONImg;
    oNListBox1: ToNListBox;
    ONMemo1: TONMemo;
    ONPanel1: TONPanel;
    ONProgressBar1: TONProgressBar;
    ONProgressBar2: TONProgressBar;
    OnRadioButton1: TOnRadioButton;
    OnRadioButton2: TOnRadioButton;
    oNScrollBar1: ToNScrollBar;
    oNScrollBar2: ToNScrollBar;
    OnSpinEdit1: TOnSpinEdit;
    OnSpinEdit2: TOnSpinEdit;
    OnSwich1: TOnSwich;
    OnSwich2: TOnSwich;
    ONTrackBar1: TONTrackBar;
    ONTrackBar2: TONTrackBar;
    procedure FormCreate(Sender: TObject);
    procedure ONCropButton1Click(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.ONCropButton1Click(Sender: TObject);
begin
//  ONImg2.Picture.LoadFromFile('C:\lazarus2_2\onlinepackagemanager\packages\ONUR\panel_e.png');
//  ONImg2.Readskinsfile('C:\lazarus2_2\onlinepackagemanager\packages\ONUR\panel_skins.ini');
//  ONImg2.ReadskinsComp(ONCropButton2);
//  ONImg2.Saveskinsfile('C:\lazarus2_2\onlinepackagemanager\packages\ONUR\panel_skins22.ini');
//
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  Strm: TResourceStream;
begin
  // for onimg2
    Strm := TResourceStream.Create(HInstance, 'PANEL_E',MAKEINTRESOURCE(10));// RT_RCDATA);
    Strm.Position := 0;
    try
      ONImg2.Picture.LoadFromStream(Strm);
    finally
      Strm.Free;
    end;


   Strm := TResourceStream.Create(HInstance, 'PANEL_skins', MAKEINTRESOURCE(10));//RT_RCDATA);
    Strm.Position := 0;
    try
      ONImg2.ReadskinsStream(Strm);
    finally
      Strm.Free;
    end;

 //  ONImg2.Readskins(self);

end;

end.


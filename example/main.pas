unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, onurpage,
  onurpanel, onurbutton, onurctrl, onurlist, onurbar, onuredit, butonu;

type

  { TForm1 }

  TForm1 = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    OnCheckbox1: TOnCheckbox;
    ONCollapExpandPanel1: TONCollapExpandPanel;
    Oncolumlist1: TOncolumlist;
    ONcombobox1: TONcombobox;
    ONCropButton1: TONCropButton;
    ONCropButton2: TONCropButton;
    onEdit1: TonEdit;
    onEdit2: TonEdit;
    onEdit3: TonEdit;
    onEdit4: TonEdit;
    onEdit5: TonEdit;
    ONGraphicPanel1: TONGraphicPanel;
    ONGraphicsButton1: TONGraphicsButton;
    ONGraphicsButton2: TONGraphicsButton;
    ONGraphicsButton3: TONGraphicsButton;
    ONGraphicsButton4: TONGraphicsButton;
    ONGraphicsButton5: TONGraphicsButton;
    ONHeaderPanel1: TONHeaderPanel;
    ONHeaderPanel2: TONHeaderPanel;
    ONImg1: TONImg;
    ONKnob1: TONKnob;
    ONKnob2: TONKnob;
    ONlabel1: TONlabel;
    ONLed1: TONLed;
    oNListBox1: ToNListBox;
    ONMemo1: TONMemo;
    ONNormalLabel1: TONNormalLabel;
    ONPage1: TONPage;
    ONPage2: TONPage;
    ONPage3: TONPage;
    ONPage4: TONPage;
    ONPage5: TONPage;
    ONPage6: TONPage;
    ONPageControl1: TONPageControl;
    ONPanel1: TONPanel;
    ONProgressBar1: TONProgressBar;
    ONProgressBar2: TONProgressBar;
    OnRadioButton1: TOnRadioButton;
    oNScrollBar1: ToNScrollBar;
    oNScrollBar2: ToNScrollBar;
    OnSpinEdit1: TOnSpinEdit;
    OnSwich1: TOnSwich;
    OnSwich2: TOnSwich;
    ONTrackBar1: TONTrackBar;
    ONTrackBar2: TONTrackBar;
    OpenDialog1: TOpenDialog;
    procedure ONCropButton1Click(Sender: TObject);
    procedure ONGraphicsButton1Click(Sender: TObject);
    procedure ONGraphicsButton3Click(Sender: TObject);
    procedure ONGraphicsButton4Click(Sender: TObject);
    procedure ONGraphicsButton5Click(Sender: TObject);
    procedure ONHeaderPanel1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ONlabel1Click(Sender: TObject);
    procedure oNScrollBar1Change(Sender: TObject);
    procedure oNScrollBar2Change(Sender: TObject);
    procedure OnSwich1Change(Sender: TObject);
    procedure OnSwich2Change(Sender: TObject);
    procedure ONTrackBar1Change(Sender: TObject);
    procedure ONTrackBar2Change(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;

implementation
uses windows;
{$R *.lfm}

{ TForm1 }

procedure TForm1.ONGraphicsButton1Click(Sender: TObject);
begin
 close;
end;

procedure TForm1.ONCropButton1Click(Sender: TObject);
begin
  if opendialog1.execute then
  onimg1.Loadskin(opendialog1.filename,false);
end;

procedure TForm1.ONGraphicsButton3Click(Sender: TObject);
var
  a, i,p: Integer;
begin
 p:=Oncolumlist1.Items.Count;
 if Length(onEdit3.Text)>0 then
 for a:=0 to 3 do
  for i:=p to p++strtoint(onEdit3.Text) do
  Oncolumlist1.Cells[a,i]:='col '+inttostr(a)+'  row '+inttostr(i);
end;

procedure TForm1.ONGraphicsButton4Click(Sender: TObject);
var
  a, i,p: Integer;
begin
 p:=oNListBox1.Items.Count;
  if Length(onEdit2.Text)>0 then
  for i:=p to p+strtoint(onEdit2.Text) do
  oNListBox1.Items.Add('items '+inttostr(i));
end;

procedure TForm1.ONGraphicsButton5Click(Sender: TObject);
begin
 ONNormalLabel1.Animateinterval:=strtoint(ONEdit4.Text);
  ONlabel1.Interval:=ONNormalLabel1.Animateinterval;
  ONlabel1.ScrollBy:=strtoint(ONEdit5.Text);
  ONNormalLabel1.Scroll:=strtoint(ONEdit5.Text);
end;

procedure TForm1.ONHeaderPanel1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
   ReleaseCapture;
  SendMessage(self.Handle, WM_SYSCOMMAND, $F012, 0);
end;

procedure TForm1.ONlabel1Click(Sender: TObject);
begin
  ONlabel1.Active:= not ONlabel1.Active;
  ONNormalLabel1.Animate:=ONlabel1.Active;
end;

procedure TForm1.oNScrollBar1Change(Sender: TObject);
begin
  ONProgressBar1.Position:=oNScrollBar1.Position;
end;

procedure TForm1.oNScrollBar2Change(Sender: TObject);
begin
    ONProgressBar2.Position:=oNScrollBar2.Position;
end;

procedure TForm1.ONTrackBar1Change(Sender: TObject);
begin
  ONProgressBar1.Position:=ONTrackBar1.Position;
end;

procedure TForm1.ONTrackBar2Change(Sender: TObject);
begin
  ONProgressBar2.Position:=ONTrackBar2.Position;
end;

procedure TForm1.OnSwich1Change(Sender: TObject);
begin
  ONLed1.LedOn:=OnSwich1.Checked;
end;

procedure TForm1.OnSwich2Change(Sender: TObject);
begin
   Oncolumlist1.Headervisible:= OnSwich2.Checked;//not Oncolumlist1.Headervisible;
end;

end.


unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  onurctrl, onurlist, onurpanel, onurbutton, onurbar, onuredit, onurpage,windows;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Edit2: TonEdit;
    Label1: TLabel;
    Label2: TLabel;
    OnCheckbox1: TOnCheckbox;
    ONCollapExpandPanel1: TONCollapExpandPanel;
    Oncolumlist1: TOncolumlist;
    ONcombobox1: TONcombobox;
    ONCropButton1: TONCropButton;
    ONCropButton2: TONCropButton;
    Edit1: TonEdit;
    onEdit2: TonEdit;
    ONGraphicPanel1: TONGraphicPanel;
    ONGraphicsButton1: TONGraphicsButton;
    ONGraphicsButton2: TONGraphicsButton;
    ONGraphicsButton3: TONGraphicsButton;
    ONHeaderPanel1: TONHeaderPanel;
    ONHeaderPanel2: TONHeaderPanel;
    ONImg1: TONImg;
    ONKnob1: TONKnob;
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
    OnSpinEdit2: TOnSpinEdit;
    OnSwich1: TOnSwich;
    OnSwich2: TOnSwich;
    ONTrackBar1: TONTrackBar;
    ONTrackBar2: TONTrackBar;
    OpenDialog1: TOpenDialog;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ONCropButton2Click(Sender: TObject);
    procedure ONGraphicsButton1Click(Sender: TObject);
    procedure ONGraphicsButton2Click(Sender: TObject);
    procedure ONHeaderPanel2MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ONlabel1Click(Sender: TObject);
    procedure oNScrollBar1Change(Sender: TObject);
    procedure oNScrollBar2Change(Sender: TObject);
    procedure OnSwich1Change(Sender: TObject);
    procedure ONTrackBar1Change(Sender: TObject);
    procedure ONTrackBar2Change(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
var
  a, i: Integer;
begin
  for i:=0 to 250 do
   begin
   for a:=0 to 35 do
    begin
    Oncolumlist1.Cells[a,i]:='col '+inttostr(a)+'  row '+inttostr(i);
    Oncolumlist1.Columns[a].Caption:='COL '+inttostr(a);
    end;
   oNListBox1.Items.Add('row '+inttostr(i));
   ONcombobox1.Items.Add('row '+inttostr(i));

   end;
ONNormalLabel1.OnClick:=@ONlabel1Click;
end;

procedure TForm1.ONCropButton2Click(Sender: TObject);
begin
  close;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  ONPanel1.Crop:=not ONPanel1.Crop;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  Oncolumlist1.Headervisible:= not Oncolumlist1.Headervisible;
end;

procedure TForm1.ONGraphicsButton1Click(Sender: TObject);
begin
  if opendialog1.execute then
  onimg1.Loadskin(opendialog1.filename,false);
end;

procedure TForm1.ONGraphicsButton2Click(Sender: TObject);
begin
    ONNormalLabel1.Animateinterval:=strtoint(Edit1.Text);
  ONlabel1.Interval:=ONNormalLabel1.Animateinterval;
  ONlabel1.ScrollBy:=strtoint(Edit2.Text);
  ONNormalLabel1.Scroll:=strtoint(Edit2.Text);
end;

procedure TForm1.ONHeaderPanel2MouseDown(Sender: TObject; Button: TMouseButton;
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
  ONProgressBar2.Position:=oNScrollBar1.Position;

end;

procedure TForm1.oNScrollBar2Change(Sender: TObject);
begin
  ONProgressBar1.Position:=oNScrollBar2.Position;
  ONProgressBar2.Position:=oNScrollBar2.Position;
end;

procedure TForm1.OnSwich1Change(Sender: TObject);
begin
  ONLed1.LedOn:=OnSwich1.Checked;
end;

procedure TForm1.ONTrackBar1Change(Sender: TObject);
begin
   ONProgressBar1.Position:=ONTrackBar1.Position;
  ONProgressBar2.Position:=ONTrackBar1.Position;
end;

procedure TForm1.ONTrackBar2Change(Sender: TObject);
begin
   ONProgressBar1.Position:=ONTrackBar2.Position;
  ONProgressBar2.Position:=ONTrackBar2.Position;
end;

end.


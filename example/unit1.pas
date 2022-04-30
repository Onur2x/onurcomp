unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ColorBox, StdCtrls,
   onurbutton, BGRABitmap;

type

  { TForm1 }

  TForm1 = class(TForm)
    ColorBox1: TColorBox;
    ComboBox1: TComboBox;
    label1: tlabel;
    OnCheckbox1: TOnCheckbox;
    ONCollapExpandPanel1: TONCollapExpandPanel;
    ONcombobox1: TONcombobox;
    ONCropButton1: TONCropButton;
    oncropbutton2: toncropbutton;
    oncropbutton3: toncropbutton;
    onEdit1: TonEdit;
    ONGraphicPanel1: TONGraphicPanel;
    ONGraphicsButton1: TONGraphicsButton;
    ONHeaderPanel1: TONHeaderPanel;
    ONImg1: TONImg;
    oNListBox1: ToNListBox;
    ONMemo1: TONMemo;
    ONPanel1: TONPanel;
    ONProgressBar1: TONProgressBar;
    ONProgressBar2: TONProgressBar;
    OnRadioButton1: TOnRadioButton;
    oNScrollBar1: ToNScrollBar;
    OnSpinEdit1: TOnSpinEdit;
    OnSwich1: TOnSwich;
    ONTrackBar1: TONTrackBar;
    ONTrackBar2: TONTrackBar;
    opendialog1: topendialog;
    procedure ColorBox1Change(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure oncropbutton1click(sender: tobject);
    procedure oncropbutton2click(sender: tobject);
    procedure oncropbutton3click(sender: tobject);
    procedure ONGraphicsButton1Click(Sender: TObject);
    procedure oNScrollBar1Change(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;

implementation
 uses BGRABitmapTypes;
{$R *.lfm}

{ TForm1 }

procedure TForm1.ONGraphicsButton1Click(Sender: TObject);
begin
  if opendialog1.Execute then
    ONImg1.Loadskin(opendialog1.FileName,'',false);
 //ONImg1.Loadskin('D:\MAILLER\Onur_YEDEK\lazarus\components\paketler\ONUR\skins.zip','',False);
 {a:=Tbgrabitmap.Create();
  a.SetSize(ONImg1.Fimage.Width,ONImg1.Fimage.Height);
  a.Fill(BGRA(10,20,30,60),dmDrawWithTransparency);

  ONImg1.Fimage.PutImage(0,0,a,dmDrawWithTransparency,100);
 // ONGraphicsButton1.Skindata:=ONImg1;
 // ONPanel1.Skindata:=ONImg1;
 FreeAndNil(a);
 }
end;

procedure TForm1.oNScrollBar1Change(Sender: TObject);
begin
  ONTrackBar1.Position:=oNScrollBar1.Position;
  ONTrackBar2.Position:=oNScrollBar1.Position;
  ONProgressBar1.Position:=oNScrollBar1.Position;
  ONProgressBar2.Position:=oNScrollBar1.Position;

end;

procedure TForm1.ColorBox1Change(Sender: TObject);
begin
 onimg1.Opacity:=88;
 ONImg1.mcolor:=ColorToString(ColorBox1.Selected);
end;

procedure TForm1.ComboBox1Change(Sender: TObject);
begin
  ONImg1.Blend:=ComboBox1.items[ComboBox1.ItemIndex];
end;

procedure tform1.oncropbutton1click(sender: tobject);
begin
  ONImg1.saveskin('D:\MAILLER\Onur_YEDEK\lazarus\components\paketler\ONUR\skinstest.zip','');
end;

procedure tform1.oncropbutton2click(sender: tobject);
begin
  close;
end;

procedure tform1.oncropbutton3click(sender: tobject);
begin
  ONMemo1.Lines.Add(ONImg1.Skinname);
  ONMemo1.Lines.Add(ONImg1.version);
  ONMemo1.Lines.Add(ONImg1.author);
  ONMemo1.Lines.Add(ONImg1.email);
  ONMemo1.Lines.Add(ONImg1.homepage);
  ONMemo1.Lines.Add(ONImg1.comment);
  ONMemo1.Lines.Add(ONImg1.screenshot);
end;

end.


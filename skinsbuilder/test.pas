unit test;

{$mode ObjFPC}{$H+}

interface

uses
  Classes,StdCtrls,SysUtils,Forms,Controls,Graphics,Dialogs,onurlist,onurpanel,
  onuredit,onurbutton,onurpage,onurbar,onurctrl;

type

  { Ttestfrm }

  Ttestfrm = class(TForm)
    ONURCheckbox1: TONURCheckbox;
    ONURCollapExpandPanel1: TONURCollapExpandPanel;
    ONURColumList1: TONURColumList;
    ONURComboBox1: TONURComboBox;
    ONURContentSlider1: TONURContentSlider;
    ONURCropButton1: TONURCropButton;
    ONUREdit1: TONUREdit;
    ONURGraphicPanel1: TONURGraphicPanel;
    ONURGraphicsButton1: TONURGraphicsButton;
    ONURHeaderPanel1: TONURHeaderPanel;
    ONURImg1:TONURImg;
    ONURKnob1: TONURKnob;
    ONURlabel1: TONURlabel;
    ONURLed1: TONURLed;
    ONURListBox1: TONURListBox;
    ONURMemo1: TONURMemo;
    ONURNavButton1: TONURNavButton;
    ONURNavButton2: TONURNavButton;
    ONURNavButton3: TONURNavButton;
    ONURNavButton4: TONURNavButton;
    ONURNavMenuButton1: TONURNavMenuButton;
    ONURNormalLabel1: TONURNormalLabel;
    ONURPage1: TONURPage;
    ONURPage2: TONURPage;
    ONURPageControl1: TONURPageControl;
    ONURPanel1: TONURPanel;
    ONURProgressBar1: TONURProgressBar;
    ONURProgressBar2: TONURProgressBar;
    ONURRadioButton1: TONURRadioButton;
    ONURScrollBar1: TONURScrollBar;
    ONURScrollBar2: TONURScrollBar;
    ONURSpinEdit1: TONURSpinEdit;
    ONURStringGrid1: TONURStringGrid;
    ONURSwich1: TONURSwich;
    ONURsystemButton1: TONURsystemButton;
    ONURsystemButton2: TONURsystemButton;
    ONURsystemButton3: TONURsystemButton;
    ONURTrackBar1: TONURTrackBar;
    ONURTrackBar2: TONURTrackBar;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private

  public

  end;

var
  testfrm: Ttestfrm;

implementation
 uses unit1;
{$R *.lfm}

 { Ttestfrm }

procedure Ttestfrm.FormCreate(Sender: TObject);


begin
 {  for i:=0 to self.ComponentCount-1 do
    begin
     if (Components[i] is TONURCustomControl)  then
      TONURCustomControl(Components[i]).Skindata:=skinsbuildier.ONImg1
     else
     if (Components[i] is TONURGraphicControl) then
      TONURGraphicControl(Components[i]).Skindata:=skinsbuildier.ONImg1;
    end;

  }

    ONURImg1.Loadskin(skinsbuildier.ONImg1.SkinFilename);



 //  ONimg1.Loadskin(skinsbuildier.ONImg1.SkinFilename);
end;

procedure Ttestfrm.FormShow(Sender: TObject);
var
  i,P: byte;
begin

 {
  for i:=0 to self.ComponentCount-1 do
  begin
     if (Components[i] is TONURCustomControl)  then
      TONURCustomControl(Components[i]).Skindata:=skinsbuildier.ONImg1
     else
     if (Components[i] is TONURGraphicControl) then
      TONURGraphicControl(Components[i]).Skindata:=skinsbuildier.ONImg1;
  end;   }

    for i:=0 to 50 do
   begin
    ONURListBox1.items.add(' TEST   ITEM  '+inttostr(i));
    ONURComboBox1.items.add(' TEST   ITEM  '+inttostr(i));
 //   ONURMemo1.Lines.add(' TEST   ITEM  '+inttostr(i));
    ONURContentSlider1.Items.Add(' TEST   ITEM  '+inttostr(i));

   end;

   for i:=0 to 10 do
   begin
     for P:=0 to 50 do
     begin
       ONURStringGrid1.Cells[i,p]:='TEST COL '+inttostr(i)+' ITEM '+inttostr(p);
       ONURColumList1.Cells[i,p]:='TEST COL '+inttostr(i)+' ITEM '+inttostr(p);
     end;
   end;

end;

end.


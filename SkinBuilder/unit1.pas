unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Windows, Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, ExtDlgs, BGRAVirtualScreen, onurctrl,onurbutton,onurbar,onuredit,onurpanel,onurlist, BGRABitmap,
  BGRABitmapTypes, ColorBox, ComCtrls, Spin, inifiles;

type

  // ToInspectorExpande = (oleft, oright, otop, obottom, otopleft, otopright, obottomleft, obottomright, onormal, ohover, opress, odisable);
  //  ToInspectorExpanded = set of ToInspectorExpande;

  { Tskinsbuildier }

  Tskinsbuildier = class(TForm)
    Button1: TButton;
    ColorBox1: TColorBox;
    ColorBox2: TColorBox;
    colorbox3: tcolorbox;
    Edit1: TEdit;
    edit10: tedit;
    edit11: tedit;
    Edit2: TEdit;
    Edit4: TEdit;
    Edit3: TEdit;
    Edit5: TEdit;
    edit6: tedit;
    edit7: tedit;
    edit8: tedit;
    edit9: tedit;
    ImageList1: TImageList;
    label10: tlabel;
    label11: tlabel;
    label12: tlabel;
    label13: tlabel;
    label14: tlabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    Label22: TLabel;
    label23: tlabel;
    Label6: TLabel;
    label7: tlabel;
    label8: tlabel;
    label9: tlabel;
    mainpicture: tbgravirtualscreen;
    odf: TOpenDialog;
    oncheckbox1: toncheckbox;
    oncollapexpandpanel1: toncollapexpandpanel;
    Oncolumlist1: Toncolumlist;
    ONlabel1: TONlabel;
    ONLed1: TONLed;
    ONProgressBar1: TONProgressBar;
    ONProgressBar2: TONProgressBar;
    onradiobutton1: tonradiobutton;
    onscrollbar2: tonscrollbar;
    OnSpinEdit1: TOnSpinEdit;
    onswich1: tonswich;
    ontrackbar1: tontrackbar;
    ontrackbar2: tontrackbar;
    Panel5: TPanel;
    Panel6: TPanel;
    Panel7: TPanel;
    panel8: tpanel;
    RadioGroup1: TRadioGroup;
    ScrollBox1: TScrollBox;
    sdf: TSaveDialog;
    spinedit1: tspinedit;
    toolbutton10: ttoolbutton;
    ToolButton5: TToolButton;
    ToolButton6: TToolButton;
    ToolButton7: TToolButton;
    toolbutton8: ttoolbutton;
    zoomx: tbgravirtualscreen;
    ComboBox1: TComboBox;
    label1: tlabel;
    label2: tlabel;
    label3: tlabel;
    label4: tlabel;
    label5: tlabel;
    ONcombobox1: TONcombobox;
    oncropbutton1: toncropbutton;
    onEdit1: TonEdit;
    ONGraphicPanel1: TONGraphicPanel;
    ongraphicsbutton1: tongraphicsbutton;
    onheaderpanel1: tonheaderpanel;
    ONImg1: TONImg;
    oNListBox1: ToNListBox;
    ONMemo1: TONMemo;
    ONPanel1: TONPanel;
    oNScrollBar1: ToNScrollBar;
    opd: topenpicturedialog;
    Panel1: TPanel;
    Panel2: TPanel;
    panel3: tpanel;
    panel4: tpanel;
    toolbar1: ttoolbar;
    toolbutton1: ttoolbutton;
    toolbutton2: ttoolbutton;
    toolbutton3: ttoolbutton;
    toolbutton4: ttoolbutton;
    trackbar1: ttrackbar;
    procedure Button1Click(Sender: TObject);
    procedure combobox1change(Sender: TObject);
    procedure Edit1KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure Edit3KeyPress(Sender: TObject; var Key: char);
    procedure Edit5Change(Sender: TObject);
    procedure edit6change(sender: tobject);
    procedure formclose(Sender: TObject; var closeaction: tcloseaction);
    procedure formcreate(Sender: TObject);
    procedure mainpicturemousedown(Sender: TObject; button: tmousebutton;
      shift: tshiftstate; x, y: integer);
    procedure mainpicturemousemove(Sender: TObject; shift: tshiftstate;
      x, y: integer);
    procedure mainpicturemouseup(Sender: TObject; button: tmousebutton;
      shift: tshiftstate; x, y: integer);
    procedure mainpictureredraw(Sender: TObject; bitmap: tbgrabitmap);
    procedure ONlabel1Click(Sender: TObject);
    procedure RadioGroup1Click(Sender: TObject);
    procedure toolbar1mousedown(sender: tobject; button: tmousebutton;
      shift: tshiftstate; x, y: integer);

    procedure toolbutton1click(Sender: TObject);
    procedure ToolButton4Click(Sender: TObject);
    procedure ToolButton5Click(Sender: TObject);
    procedure toolbutton8click(sender: tobject);
    procedure trackbar1change(Sender: TObject);
    procedure zoomxredraw(Sender: TObject; bitmap: tbgrabitmap);
  private
    procedure readdata(Ab: TONCustomCrop);
//    procedure readskin;
    procedure updatefrm;
    procedure updateocustomcontrolu(aworkbook: tcontrol);
    procedure writedata(Ab: TONCustomCrop);
//    procedure writeskin;
    procedure zoomtimertimer;
  public
    gg: Tcontrol;
    oncrop: TONCustomCrop;
  end;




var
  skinsbuildier: Tskinsbuildier;
  aktif,changeskininfo: boolean;
  rectlange: Trect;
  temp, mainimg, cropimg: TBGRABitmap;
  curPos: TPoint;
  skn: TIniFile;

implementation

{$R *.lfm}

{ Tskinsbuildier }


procedure cropparse(Crp: TONCustomCrop; val: string);
var
  myst: TStringList;
begin
  if val.Length>0 then
  begin
    myst := TStringlist.Create;
    try
      myst.Delimiter:=',';
      myst.DelimitedText:=val;
      Crp.LEFT      := StrToIntDef(myst.Strings[0],2);
      Crp.TOP       := StrToIntDef(myst.Strings[1],2);
      Crp.RIGHT     := StrToIntDef(myst.Strings[2],4);
      Crp.BOTTOM    := StrToIntDef(myst.Strings[3],4);
      Crp.Fontcolor := StringToColorDef(myst.Strings[4],clNone);
    finally
      myst.free;
    end;
  end;
end;


procedure Tskinsbuildier.readdata(Ab: TONCustomCrop);
begin
  skn := Tinifile.Create(GetTempDir+'skins.ini');//Extractfilepath(application.ExeName) + 'temp.ini');
//  ShowMessage('ok '+ab.cropname+'  '+Edit5.text+'   '+IntToStr(ab.Left));
  try
    cropparse(ab,skn.ReadString(Edit5.text,ab.cropname,'0,0,0,0,clblack'));

  {  ab.fsLEFT := StrToInt(trim(skn.ReadString(edit5.Text, ab.cropname + '.LEFT', '0')));
    ab.fsTOP := StrToInt(trim(skn.ReadString(edit5.Text, ab.cropname + '.TOP', '0')));
    ab.fsBOTTOM := StrToInt(trim(skn.ReadString(edit5.Text, ab.cropname + '.BOTTOM', '0')));
    ab.fsRIGHT := StrToInt(trim(skn.ReadString(edit5.Text, ab.cropname + '.RIGHT', '0')));
    ab.Fontcolor := StringToColor(skn.ReadString(edit5.Text,
    ab.cropname + '.FONTCOLOR', 'clBlack')); }
  finally
    FreeAndNil(skn);
  end;
 // gg.Invalidate;
 // ShowMessage('ok '+ab.cropname+'  '+IntToStr(ab.Left));
  edit1.Text := IntToStr(ab.Left);
  edit2.Text := IntToStr(ab.Right);
  Edit3.Text := IntToStr(ab.Top);
  Edit4.Text := IntToStr(ab.Bottom);
  ColorBox2.Selected := ab.Fontcolor;

  rectlange.left := ab.Left;
  rectlange.Right := ab.Right;
  rectlange.top := ab.top;
  rectlange.bottom := ab.bottom;
  mainpicture.RedrawBitmap;


 { if (ab.cropname = 'ONNORMAL') or (ab.cropname = 'ONHOVER') or
    (ab.cropname = 'ONPRESSED') or (ab.cropname = 'ONDISABLE') then
  begin
    ColorBox2.Visible := True;
    ColorBox2.Selected := ab.Fontcolor;
  end
  else
    ColorBox2.Visible := False; }
end;

procedure Tskinsbuildier.Edit3KeyPress(Sender: TObject; var Key: char);
begin
  if (key in ['0'..'9']) then
  begin
    if Edit1.Text = '' then Edit1.Text :='0';

    if Edit2.Text = '' then Edit2.text :='0';

    if Edit3.Text = '' then Edit3.text :='0';

    if Edit4.Text = '' then Edit4.text :='0';

     rectlange:=rect(StrToInt(Edit1.Text),StrToInt(Edit3.Text),StrToInt(Edit2.Text),StrToInt(Edit4.Text));
    mainpicture.RedrawBitmap;
  end;
end;

procedure Tskinsbuildier.Edit1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
//  if (key in ['0'..'9']) then
//  begin
   { if Edit1.Text = '' then Edit1.Text :='0';

    if Edit2.Text = '' then Edit2.text :='0';

    if Edit3.Text = '' then Edit3.text :='0';

    if Edit4.Text = '' then Edit4.text :='0';

     rectlange:=rect(StrToInt(Edit1.Text),StrToInt(Edit3.Text),StrToInt(Edit2.Text),StrToInt(Edit4.Text));
    mainpicture.RedrawBitmap; }
end;

function croptostring(Crp: TONCustomCrop):string;
begin
   Result:='';
  if Crp<>nil then
    Result:=inttostr(Crp.LEFT)+','+inttostr(Crp.TOP)+','+inttostr(Crp.RIGHT)+','+inttostr(Crp.BOTTOM)+','+ColorToString(Crp.Fontcolor);
end;

procedure Tskinsbuildier.writedata(Ab: TONCustomCrop);
begin
  if Edit1.Text <> '' then ab.Left := StrToInt(edit1.Text)
  else
    ab.left := 0;

  if Edit2.Text <> '' then ab.Right := StrToInt(edit2.Text)
  else
    ab.Right := 0;

  if Edit3.Text <> '' then ab.top := StrToInt(Edit3.Text)
  else
    ab.Top := 0;

  if Edit4.Text <> '' then ab.bottom := StrToInt(Edit4.Text)
  else
    ab.Bottom := 0;

  ab.Fontcolor := ColorBox2.Selected;

  skn := Tinifile.Create(GetTempDir+'skins.ini'); //Extractfilepath(application.ExeName) + 'temp.ini');
  try
    skn.WriteString(edit5.Text,ab.cropname,croptostring(Ab));//  ab.cropname + '.LEFT', IntToStr(ab.fsLeft));
   { skn.WriteString(edit5.Text, ab.cropname + '.RIGHT', IntToStr(ab.fsRight));
    skn.WriteString(edit5.Text, ab.cropname + '.TOP', IntToStr(ab.fsTop));
    skn.WriteString(edit5.Text, ab.cropname + '.BOTTOM', IntToStr(ab.fsBottom));
    skn.WriteString(edit5.Text, ab.cropname + '.FONTCOLOR', ColortoString(ab.Fontcolor));}
  finally
    FreeAndNil(skn);
  end;

end;


procedure Tskinsbuildier.combobox1change(Sender: TObject);
//var
//  i:integer;
begin
  //gg.Visible:=False;
  gg := nil;
  ONGraphicsButton1.Visible := False;
  ONCropButton1.Visible := False;
  ONPanel1.Visible := False;
  onheaderpanel1.Visible := False;
  onEdit1.Visible := False;
  OnSpinEdit1.Visible := False;
  ONcombobox1.Visible := False;
  oNListBox1.Visible := False;
  ONMemo1.Visible := False;
  oNScrollBar1.Visible:=false;
  oNScrollBar2.Visible:=false;
  onswich1.Visible:=false;
  oncheckbox1.Visible:=false;
  onradiobutton1.Visible:=false;
  onprogressbar1.Visible:=false;
  onprogressbar2.Visible:=false;
  ontrackbar1.Visible:=false;
  ontrackbar2.Visible:=false;
  ONCollapExpandPanel1.Visible:=False;
  Oncolumlist1.Visible:=false;
  ONlabel1.Visible:=false;
  ONLed1.Visible:=false;

  Panel7.Visible := False;

  RadioGroup1.Items.Clear;
  case ComboBox1.ItemIndex of
    0:
    begin
     // gg := TControl(ONImg1);
      edit5.Text := 'form';
      RadioGroup1.items.add('TOPLEFT');
      RadioGroup1.items.add('TOPRIGHT');
      RadioGroup1.items.add('TOP');
      RadioGroup1.items.add('BOTTOMLEFT');
      RadioGroup1.items.add('BOTTOMRIGHT');
      RadioGroup1.items.add('BOTTOM');
      RadioGroup1.items.add('LEFT');
      RadioGroup1.items.add('RIGHT');
      RadioGroup1.items.add('CENTER');
    end;


     1:
    begin
      gg := ONGraphicsButton1;
      edit5.Text := ONGraphicsButton1.Skinname;
      RadioGroup1.items.add('NORMAL');
      RadioGroup1.items.add('NORMALLEFT');
      RadioGroup1.items.add('NORMALRIGHT');
      RadioGroup1.items.add('NORMALTOP');
      RadioGroup1.items.add('NORMALBOTTOM');

      RadioGroup1.items.add('ENTER');
      RadioGroup1.items.add('ENTERLEFT');
      RadioGroup1.items.add('ENTERRIGHT');
      RadioGroup1.items.add('ENTERTOP');
      RadioGroup1.items.add('ENTERBOTTOM');


      RadioGroup1.items.add('PRESSED');
      RadioGroup1.items.add('PRESSEDLEFT');
      RadioGroup1.items.add('PRESSEDRIGHT');
      RadioGroup1.items.add('PRESSEDTOP');
      RadioGroup1.items.add('PRESSEDBOTTOM');

      RadioGroup1.items.add('DISABLE');
      RadioGroup1.items.add('DISABLELEFT');
      RadioGroup1.items.add('DISABLERIGHT');
      RadioGroup1.items.add('DISABLETOP');
      RadioGroup1.items.add('DISABLEBOTTOM');
    end;

    2:
    begin
      gg := ONCropButton1;
      edit5.Text := oncropbutton1.Skinname;
      RadioGroup1.items.add('NORMAL');
      RadioGroup1.items.add('NORMALLEFT');
      RadioGroup1.items.add('NORMALRIGHT');
      RadioGroup1.items.add('NORMALTOP');
      RadioGroup1.items.add('NORMALBOTTOM');

      RadioGroup1.items.add('ENTER');
      RadioGroup1.items.add('ENTERLEFT');
      RadioGroup1.items.add('ENTERRIGHT');
      RadioGroup1.items.add('ENTERTOP');
      RadioGroup1.items.add('ENTERBOTTOM');


      RadioGroup1.items.add('PRESSED');
      RadioGroup1.items.add('PRESSEDLEFT');
      RadioGroup1.items.add('PRESSEDRIGHT');
      RadioGroup1.items.add('PRESSEDTOP');
      RadioGroup1.items.add('PRESSEDBOTTOM');

      RadioGroup1.items.add('DISABLE');
      RadioGroup1.items.add('DISABLELEFT');
      RadioGroup1.items.add('DISABLERIGHT');
      RadioGroup1.items.add('DISABLETOP');
      RadioGroup1.items.add('DISABLEBOTTOM');
    end;

    3:
    begin
      gg := ONPanel1;
      edit5.Text := ONPanel1.Skinname;
      RadioGroup1.items.add('TOPLEFT');
      RadioGroup1.items.add('TOPRIGHT');
      RadioGroup1.items.add('TOP');
      RadioGroup1.items.add('BOTTOMLEFT');
      RadioGroup1.items.add('BOTTOMRIGHT');
      RadioGroup1.items.add('BOTTOM');
      RadioGroup1.items.add('LEFT');
      RadioGroup1.items.add('RIGHT');
      RadioGroup1.items.add('CENTER');
    end;
    4:
    begin
      gg := onheaderpanel1;
      edit5.Text := onheaderpanel1.Skinname;
      RadioGroup1.items.add('TOPLEFT');
      RadioGroup1.items.add('TOPRIGHT');
      RadioGroup1.items.add('TOP');
      RadioGroup1.items.add('BOTTOMLEFT');
      RadioGroup1.items.add('BOTTOMRIGHT');
      RadioGroup1.items.add('BOTTOM');
      RadioGroup1.items.add('LEFT');
      RadioGroup1.items.add('RIGHT');
      RadioGroup1.items.add('CENTER');
    end;
    5:
    begin
      gg := onEdit1;
      edit5.Text := onEdit1.Skinname;
      RadioGroup1.items.add('TOPLEFT');
      RadioGroup1.items.add('TOPRIGHT');
      RadioGroup1.items.add('TOP');
      RadioGroup1.items.add('BOTTOMLEFT');
      RadioGroup1.items.add('BOTTOMRIGHT');
      RadioGroup1.items.add('BOTTOM');
      RadioGroup1.items.add('LEFT');
      RadioGroup1.items.add('RIGHT');
      RadioGroup1.items.add('CENTER');
    end;
    6:
    begin
      gg := OnSpinEdit1;
      edit5.Text := OnSpinEdit1.Skinname;
      RadioGroup1.items.add('TOPLEFT');
      RadioGroup1.items.add('TOPRIGHT');
      RadioGroup1.items.add('TOP');
      RadioGroup1.items.add('BOTTOMLEFT');
      RadioGroup1.items.add('BOTTOMRIGHT');
      RadioGroup1.items.add('BOTTOM');
      RadioGroup1.items.add('LEFT');
      RadioGroup1.items.add('RIGHT');
      RadioGroup1.items.add('CENTER');
      RadioGroup1.items.add('UPBUTONNORMAL');
      RadioGroup1.items.add('UPBUTONHOVER');
      RadioGroup1.items.add('UPBUTONPRESSED');
      RadioGroup1.items.add('UPBUTONDISABLE');
      RadioGroup1.items.add('DOWNBUTONNORMAL');
      RadioGroup1.items.add('DOWNBUTONHOVER');
      RadioGroup1.items.add('DOWNBUTONPRESSED');
      RadioGroup1.items.add('DOWNBUTONDISABLE');
    end;
    7:
    begin
      gg := ONcombobox1;
      edit5.Text := ONcombobox1.Skinname;
      RadioGroup1.items.add('TOPLEFT');
      RadioGroup1.items.add('TOPRIGHT');
      RadioGroup1.items.add('TOP');
      RadioGroup1.items.add('BOTTOMLEFT');
      RadioGroup1.items.add('BOTTOMRIGHT');
      RadioGroup1.items.add('BOTTOM');
      RadioGroup1.items.add('LEFT');
      RadioGroup1.items.add('RIGHT');
      RadioGroup1.items.add('CENTER');
      RadioGroup1.items.add('BUTONNORMAL');
      RadioGroup1.items.add('BUTONHOVER');
      RadioGroup1.items.add('BUTONPRESSED');
      RadioGroup1.items.add('BUTONDISABLE');
    end;
    8:
    begin
      gg := oNListBox1;
      edit5.Text := oNListBox1.Skinname;
      RadioGroup1.items.add('TOPLEFT');
      RadioGroup1.items.add('TOPRIGHT');
      RadioGroup1.items.add('TOP');
      RadioGroup1.items.add('BOTTOMLEFT');
      RadioGroup1.items.add('BOTTOMRIGHT');
      RadioGroup1.items.add('BOTTOM');
      RadioGroup1.items.add('LEFT');
      RadioGroup1.items.add('RIGHT');
      RadioGroup1.items.add('CENTER');
      RadioGroup1.items.add('ACTIVEITEM');
      RadioGroup1.items.add('ITEM');

    end;
    9:
    begin
      gg := onswich1;
      edit5.Text := onswich1.Skinname;
      RadioGroup1.items.add('OPEN');
      RadioGroup1.items.add('OPENHOVER');
      RadioGroup1.items.add('CLOSE');
      RadioGroup1.items.add('CLOSEHOVER');
      RadioGroup1.items.add('DISABLE');
    end;
    10:
    begin
      gg := oNScrollBar1;
      edit5.Text := oNScrollBar1.Skinname;
      RadioGroup1.items.add('LEFT');
      RadioGroup1.items.add('RIGHT');
      RadioGroup1.items.add('NORMAL');
      RadioGroup1.items.add('BAR');
      RadioGroup1.items.add('LEFTBUTONNORMAL');
      RadioGroup1.items.add('LEFTBUTONHOVER');
      RadioGroup1.items.add('LEFTBUTONPRESSED');
      RadioGroup1.items.add('LEFTBUTONDISABLE');
      RadioGroup1.items.add('RIGHTBUTONNORMAL');
      RadioGroup1.items.add('RIGHTBUTONHOVER');
      RadioGroup1.items.add('RIGHTBUTONPRESSED');
      RadioGroup1.items.add('RIGHTBUTONDISABLE');

      RadioGroup1.items.add('CENTERBUTONNORMAL');
      RadioGroup1.items.add('CENTERBUTONNHOVER');
      RadioGroup1.items.add('CENTERBUTONPRESS');
      RadioGroup1.items.add('CENTERBUTONDISABLE');
    end;

    11:
    begin
      gg := oNScrollBar2;
      edit5.Text := oNScrollBar2.Skinname;
      RadioGroup1.items.add('TOP');
      RadioGroup1.items.add('BOTTOM');
      RadioGroup1.items.add('NORMAL');
      RadioGroup1.items.add('BAR');
      RadioGroup1.items.add('UPBUTONNORMAL');
      RadioGroup1.items.add('UPBUTONHOVER');
      RadioGroup1.items.add('UPBUTONPRESSED');
      RadioGroup1.items.add('UPBUTONDISABLE');
      RadioGroup1.items.add('DOWNBUTONNORMAL');
      RadioGroup1.items.add('DOWNBUTONHOVER');
      RadioGroup1.items.add('DOWNBUTONPRESSED');
      RadioGroup1.items.add('DOWNBUTONDISABLE');
      RadioGroup1.items.add('CENTERBUTONNORMAL');
      RadioGroup1.items.add('CENTERBUTONNHOVER');
      RadioGroup1.items.add('CENTERBUTONPRESS');
      RadioGroup1.items.add('CENTERBUTONDISABLE');
    end;

    12:
    begin
      gg := ONMemo1;
      edit5.Text := ONMemo1.Skinname;
      RadioGroup1.items.add('TOPLEFT');
      RadioGroup1.items.add('TOPRIGHT');
      RadioGroup1.items.add('TOP');
      RadioGroup1.items.add('BOTTOMLEFT');
      RadioGroup1.items.add('BOTTOMRIGHT');
      RadioGroup1.items.add('BOTTOM');
      RadioGroup1.items.add('LEFT');
      RadioGroup1.items.add('RIGHT');
      RadioGroup1.items.add('CENTER');
    end;

    13:
    begin
      gg := oncheckbox1;
      edit5.Text := oncheckbox1.Skinname;
      RadioGroup1.items.add('NORMAL');
      RadioGroup1.items.add('NORMALHOVER');
      RadioGroup1.items.add('PRESSED');
      RadioGroup1.items.add('CHECK');
      RadioGroup1.items.add('CHECKHOVER');
      RadioGroup1.items.add('DISABLE');
    end;

    14:
    begin
      gg := onradiobutton1;
      edit5.Text := onradiobutton1.Skinname;
      RadioGroup1.items.add('NORMAL');
      RadioGroup1.items.add('NORMALHOVER');
      RadioGroup1.items.add('PRESSED');
      RadioGroup1.items.add('CHECK');
      RadioGroup1.items.add('CHECKHOVER');
      RadioGroup1.items.add('DISABLE');
    end;

    15:
    begin
      gg := onprogressbar1;
      edit5.Text := onprogressbar1.Skinname;
      RadioGroup1.items.add('ONLEFT');
      RadioGroup1.items.add('ONRIGHT');
      RadioGroup1.items.add('ONTOP');
      RadioGroup1.items.add('ONBOTTOM');
      RadioGroup1.items.add('ONCENTER');
      RadioGroup1.items.add('ONBAR');
    end;

    16:
    begin
      gg := onprogressbar2;
      edit5.Text := onprogressbar2.Skinname;
      RadioGroup1.items.add('ONLEFT');
      RadioGroup1.items.add('ONRIGHT');
      RadioGroup1.items.add('ONTOP');
      RadioGroup1.items.add('ONBOTTOM');
      RadioGroup1.items.add('ONCENTER');
      RadioGroup1.items.add('ONBAR');
    end;

    17:
    begin
      gg := ontrackbar1;
      edit5.Text := ontrackbar1.Skinname;
      RadioGroup1.items.add('LEFT_TOP');
      RadioGroup1.items.add('RIGHT_BOTTOM');
      RadioGroup1.items.add('CENTER');
      RadioGroup1.items.add('TRACKBUTONNORMAL');
      RadioGroup1.items.add('TRACKBUTONHOVER');
      RadioGroup1.items.add('TRACKBUTONPRESSED');
      RadioGroup1.items.add('TRACKBUTONDISABLE');
    end;

    18:
    begin
      gg := ontrackbar2;
      edit5.Text := ontrackbar2.Skinname;
      RadioGroup1.items.add('LEFT_TOP');
      RadioGroup1.items.add('RIGHT_BOTTOM');
      RadioGroup1.items.add('CENTER');
      RadioGroup1.items.add('TRACKBUTONNORMAL');
      RadioGroup1.items.add('TRACKBUTONHOVER');
      RadioGroup1.items.add('TRACKBUTONPRESSED');
      RadioGroup1.items.add('TRACKBUTONDISABLE');
    end;

    19:
    begin
      gg := ONCollapExpandPanel1;
      edit5.Text := ONCollapExpandPanel1.Skinname;
      RadioGroup1.items.add('TOPLEFT');
      RadioGroup1.items.add('TOPRIGHT');
      RadioGroup1.items.add('TOP');
      RadioGroup1.items.add('BOTTOMLEFT');
      RadioGroup1.items.add('BOTTOMRIGHT');
      RadioGroup1.items.add('BOTTOM');
      RadioGroup1.items.add('LEFT');
      RadioGroup1.items.add('RIGHT');
      RadioGroup1.items.add('CENTER');
      RadioGroup1.items.add('BUTONNORMAL');
      RadioGroup1.items.add('BUTONHOVER');
      RadioGroup1.items.add('BUTONPRESSED');
      RadioGroup1.items.add('BUTONDISABLE');
      RadioGroup1.items.add('COLLAPSENORMAL');
      RadioGroup1.items.add('COLLAPSEPRESSED');
      RadioGroup1.items.add('COLLAPSEHOVER');
      RadioGroup1.items.add('COLLAPSEDISABLE');
      RadioGroup1.items.add('CAPTIONAREA');
    end;
     20:
    begin
      gg := Oncolumlist1;
      edit5.Text := Oncolumlist1.Skinname;
      RadioGroup1.items.add('TOPLEFT');
      RadioGroup1.items.add('TOPRIGHT');
      RadioGroup1.items.add('TOP');
      RadioGroup1.items.add('BOTTOMLEFT');
      RadioGroup1.items.add('BOTTOMRIGHT');
      RadioGroup1.items.add('BOTTOM');
      RadioGroup1.items.add('LEFT');
      RadioGroup1.items.add('RIGHT');
      RadioGroup1.items.add('CENTER');
      RadioGroup1.items.add('ACTIVEITEM');
      RadioGroup1.items.add('ITEM');
      RadioGroup1.items.add('HEADER');
    end;
   21:
    begin
      gg := ONlabel1;
      edit5.Text := ONlabel1.Skinname;
      RadioGroup1.items.add('ONCLIENT');
    end;
    22:
    begin
      gg := ONled1;
      edit5.Text := ONled1.Skinname;
      RadioGroup1.items.add('LEDONNORMAL');
      RadioGroup1.items.add('LEDONHOVER');
      RadioGroup1.items.add('LEDOFFNORMAL');
      RadioGroup1.items.add('LEDOFFHOVER');
      RadioGroup1.items.add('DISABLE');
    end;

  end;

  if Assigned(gg) then
  GG.Visible := True;
  //edit5.Text:=gg.Name;
end;




procedure Tskinsbuildier.Edit5Change(Sender: TObject);
begin
  if ComboBox1.ItemIndex>0 then // for form itemindex... 0 =form
  if gg is TONCustomControl then
    TONCustomControl(gg).Skinname := edit5.Text
  else
    TONGraphicControl(gg).Skinname := edit5.Text;

end;

procedure Tskinsbuildier.edit6change(sender: tobject);
begin
  if changeskininfo=true then
  begin
    ONImg1.Skinname:=edit11.Text;
    ONImg1.author:=edit6.Text;
    ONImg1.email:=edit7.Text;
    ONImg1.homepage:=edit8.Text;
    ONImg1.comment:=edit9.Text;
    ONImg1.version:=edit10.Text;
    ONImg1.MColor:=colortostring(colorbox3.Selected);
    ONImg1.Opacity:=spinedit1.Value;
  end;

end;

procedure Tskinsbuildier.Button1Click(Sender: TObject);
begin
  if (RadioGroup1.ItemIndex > -1) and (Assigned(oncrop)) then
  begin
    writedata(oncrop);
    if ComboBox1.ItemIndex>0 then  // for form itemindex... 0 =form
    gg.Invalidate;

  end;

end;

procedure Tskinsbuildier.RadioGroup1Click(Sender: TObject);
begin
  if RadioGroup1.ItemIndex > -1 then
  begin
    panel7.Visible := True;
   if ComboBox1.ItemIndex>0 then  // for form itemindex... 0 =form
    updateocustomcontrolu(gg)
   else
    updatefrm;
  end
  else
  begin
    panel7.Visible := False;
    oncrop := nil;
  end;
end;

procedure Tskinsbuildier.toolbar1mousedown(sender: tobject; button: tmousebutton;
  shift: tshiftstate; x, y: integer);
begin
  ReleaseCapture;
  SendMessage(self.Handle, WM_SYSCOMMAND, $F012, 0);
end;


procedure Tskinsbuildier.formclose(Sender: TObject; var closeaction: tcloseaction);
begin
//  writeskin;
  FreeAndNil(mainimg);
  FreeAndNil(temp);
  FreeAndNil(cropimg);

end;

procedure Tskinsbuildier.formcreate(Sender: TObject);
var
  i,a:byte;
begin
  //FExpanded := [oleft, oright, otop, obottom, otopleft, otopright, obottomleft, obottomright, onormal, ohover, opress, odisable];
  aktif := False;
  mainimg := TBGRABitmap.Create(mainpicture.Width, mainpicture.Height);
  temp := TBGRABitmap.Create(mainpicture.Width, mainpicture.Height);
  cropimg := TBGRABitmap.Create(100, 100);
  mainimg.Assign(ONImg1.Fimage);
  mainpicture.RedrawBitmap;
  for i:=0 to 2 do
   for a:=0 to 200 do
    begin
     Oncolumlist1.Items.Add;
     Oncolumlist1.Items[a].Cells[i]:='TEST '+i.ToString+'  '+a.ToString;
   end;
end;


procedure Tskinsbuildier.toolbutton1click(Sender: TObject);
begin
  if opd.Execute then
  begin
    //image1.Picture.LoadFromFile(opd.FileName);
    mainimg.LoadFromFile(opd.FileName);
    ONImg1.Picture.LoadFromFile(opd.FileName);
    mainpicture.RedrawBitmap;
  end;
end;

procedure Tskinsbuildier.ToolButton4Click(Sender: TObject);
begin
  if odf.Execute then
  begin
    ONImg1.Loadskin(odf.FileName,false);
    changeskininfo:=false;
    Edit11.Text:=ONImg1.Skinname;
    edit6.Text:=ONImg1.author;
    edit7.Text:=ONImg1.email;
    edit8.Text:=ONImg1.homepage;
    edit9.Text:=ONImg1.comment;
    edit10.Text:=ONImg1.version;
    colorbox3.Selected:=StringToColor(ONImg1.MColor);
    spinedit1.Value:=ONImg1.Opacity;
    changeskininfo:=true;
    mainimg.Assign(ONImg1.Fimage);
    mainpicture.RedrawBitmap;
    Repaint;
  end;
end;

procedure Tskinsbuildier.ToolButton5Click(Sender: TObject);
begin
  if sdf.Execute then
  begin
  //  ONImg1.Readskinsfile(Extractfilepath(application.ExeName) + 'temp.ini');
    ONImg1.saveskin(sdf.FileName);
  end;
end;

procedure Tskinsbuildier.toolbutton8click(sender: tobject);
begin
  Close;
end;


procedure Tskinsbuildier.Updatefrm;
begin
  case RadioGroup1.ItemIndex of
      0: oncrop := ONImg1.FTOPLEFT;
      1: oncrop := ONImg1.FTOPRIGHT;
      2: oncrop := ONImg1.FTOP;
      3: oncrop := ONImg1.FBOTTOMLEFT;
      4: oncrop := ONImg1.FBOTTOMRIGHT;
      5: oncrop := ONImg1.FBOTTOM;
      6: oncrop := ONImg1.FLEFT;
      7: oncrop := ONImg1.FRIGHT;
      8: oncrop := ONImg1.FCENTER;
    end;
  readdata(oncrop);
end;
procedure Tskinsbuildier.UpdateOcustomControlu(AWorkbook: TControl);
begin
  if AWorkbook = nil then Exit;

  if AWorkbook is TONPANEL then
  begin
    case RadioGroup1.ItemIndex of
      0: oncrop := ONPanel1.ONTOPLEFT;
      1: oncrop := ONPanel1.ONTOPRIGHT;
      2: oncrop := ONPanel1.ONTOP;
      3: oncrop := ONPanel1.ONBOTTOMLEFT;
      4: oncrop := ONPanel1.ONBOTTOMRIGHT;
      5: oncrop := ONPanel1.ONBOTTOM;
      6: oncrop := ONPanel1.ONLEFT;
      7: oncrop := ONPanel1.ONRIGHT;
      8: oncrop := ONPanel1.ONCENTER;
    end;
  end;

  if AWorkbook is TONHeaderPanel then
  begin
    case RadioGroup1.ItemIndex of
      0: oncrop := ONHeaderPanel1.ONTOPLEFT;
      1: oncrop := ONHeaderPanel1.ONTOPRIGHT;
      2: oncrop := ONHeaderPanel1.ONTOP;
      3: oncrop := ONHeaderPanel1.ONBOTTOMLEFT;
      4: oncrop := ONHeaderPanel1.ONBOTTOMRIGHT;
      5: oncrop := ONHeaderPanel1.ONBOTTOM;
      6: oncrop := ONHeaderPanel1.ONLEFT;
      7: oncrop := ONHeaderPanel1.ONRIGHT;
      8: oncrop := ONHeaderPanel1.ONCENTER;
    end;
  end;

  if AWorkbook is TONGraphicsButton then
  begin
    case RadioGroup1.ItemIndex of
      0: oncrop := ONGraphicsButton1.ONNORMAL;
      1: oncrop := ONGraphicsButton1.ONNORMALLEFT;
      2: oncrop := ONGraphicsButton1.ONNORMALRIGHT;
      3: oncrop := ONGraphicsButton1.ONNORMALTOP;
      4: oncrop := ONGraphicsButton1.ONNORMALBOTTOM;

      5: oncrop := ONGraphicsButton1.ONHOVER;
      6: oncrop := ONGraphicsButton1.ONHOVERLEFT;
      7: oncrop := ONGraphicsButton1.ONHOVERRIGHT;
      8: oncrop := ONGraphicsButton1.ONHOVERTOP;
      9: oncrop := ONGraphicsButton1.ONHOVERBOTTOM;


      10: oncrop := ONGraphicsButton1.ONPRESSED;
      11: oncrop := ONGraphicsButton1.ONPRESSEDLEFT;
      12: oncrop := ONGraphicsButton1.ONPRESSEDRIGHT;
      13: oncrop := ONGraphicsButton1.ONPRESSEDTOP;
      14: oncrop := ONGraphicsButton1.ONPRESSEDBOTTOM;

      15: oncrop := ONGraphicsButton1.ONDISABLE;
      16: oncrop := ONGraphicsButton1.ONDISABLELEFT;
      17: oncrop := ONGraphicsButton1.ONDISABLERIGHT;
      18: oncrop := ONGraphicsButton1.ONDISABLETOP;
      19: oncrop := ONGraphicsButton1.ONDISABLEBOTTOM;


    end;
  end;

  if AWorkbook is TONCropButton then
  begin
    case RadioGroup1.ItemIndex of
      0: oncrop := ONCropButton1.ONNORMAL;
      1: oncrop := ONCropButton1.ONNORMALLEFT;
      2: oncrop := ONCropButton1.ONNORMALRIGHT;
      3: oncrop := ONCropButton1.ONNORMALTOP;
      4: oncrop := ONCropButton1.ONNORMALBOTTOM;

      5: oncrop := ONCropButton1.ONHOVER;
      6: oncrop := ONCropButton1.ONHOVERLEFT;
      7: oncrop := ONCropButton1.ONHOVERRIGHT;
      8: oncrop := ONCropButton1.ONHOVERTOP;
      9: oncrop := ONCropButton1.ONHOVERBOTTOM;


      10: oncrop := ONCropButton1.ONPRESSED;
      11: oncrop := ONCropButton1.ONPRESSEDLEFT;
      12: oncrop := ONCropButton1.ONPRESSEDRIGHT;
      13: oncrop := ONCropButton1.ONPRESSEDTOP;
      14: oncrop := ONCropButton1.ONPRESSEDBOTTOM;

      15: oncrop := ONCropButton1.ONDISABLE;
      16: oncrop := ONCropButton1.ONDISABLELEFT;
      17: oncrop := ONCropButton1.ONDISABLERIGHT;
      18: oncrop := ONCropButton1.ONDISABLETOP;
      19: oncrop := ONCropButton1.ONDISABLEBOTTOM;

    end;
  end;

  if AWorkbook is TonEdit then
  begin
    case RadioGroup1.ItemIndex of
      0: oncrop := onEdit1.ONTOPLEFT;
      1: oncrop := onEdit1.ONTOPRIGHT;
      2: oncrop := onEdit1.ONTOP;
      3: oncrop := onEdit1.ONBOTTOMLEFT;
      4: oncrop := onEdit1.ONBOTTOMRIGHT;
      5: oncrop := onEdit1.ONBOTTOM;
      6: oncrop := onEdit1.ONLEFT;
      7: oncrop := onEdit1.ONRIGHT;
      8: oncrop := onEdit1.ONCENTER;
    end;
  end;

  if AWorkbook is TONMemo then
  begin
    case RadioGroup1.ItemIndex of
      0: oncrop := ONMemo1.ONTOPLEFT;
      1: oncrop := ONMemo1.ONTOPRIGHT;
      2: oncrop := ONMemo1.ONTOP;
      3: oncrop := ONMemo1.ONBOTTOMLEFT;
      4: oncrop := ONMemo1.ONBOTTOMRIGHT;
      5: oncrop := ONMemo1.ONBOTTOM;
      6: oncrop := ONMemo1.ONLEFT;
      7: oncrop := ONMemo1.ONRIGHT;
      8: oncrop := ONMemo1.ONCENTER;
    end;
  end;

  if AWorkbook is TOnSpinEdit then
  begin
    case RadioGroup1.ItemIndex of
      0: oncrop := OnSpinEdit1.ONTOPLEFT;
      1: oncrop := OnSpinEdit1.ONTOPRIGHT;
      2: oncrop := OnSpinEdit1.ONTOP;
      3: oncrop := OnSpinEdit1.ONBOTTOMLEFT;
      4: oncrop := OnSpinEdit1.ONBOTTOMRIGHT;
      5: oncrop := OnSpinEdit1.ONBOTTOM;
      6: oncrop := OnSpinEdit1.ONLEFT;
      7: oncrop := OnSpinEdit1.ONRIGHT;
      8: oncrop := OnSpinEdit1.ONCENTER;
      9: oncrop := OnSpinEdit1.ONUPBUTONNORMAL;
      10: oncrop := OnSpinEdit1.ONUPBUTONHOVER;
      11: oncrop := OnSpinEdit1.ONUPBUTONPRESS;
      12: oncrop := OnSpinEdit1.ONUPBUTONDISABLE;
      13: oncrop := OnSpinEdit1.ONDOWNBUTONNORMAL;
      14: oncrop := OnSpinEdit1.ONDOWNBUTONHOVER;
      15: oncrop := OnSpinEdit1.ONDOWNBUTONPRESS;
      16: oncrop := OnSpinEdit1.ONDOWNBUTONDISABLE;
    end;
  end;

  if AWorkbook is TONcombobox then
  begin
    case RadioGroup1.ItemIndex of
      0: oncrop := ONcombobox1.ONTOPLEFT;
      1: oncrop := ONcombobox1.ONTOPRIGHT;
      2: oncrop := ONcombobox1.ONTOP;
      3: oncrop := ONcombobox1.ONBOTTOMLEFT;
      4: oncrop := ONcombobox1.ONBOTTOMRIGHT;
      5: oncrop := ONcombobox1.ONBOTTOM;
      6: oncrop := ONcombobox1.ONLEFT;
      7: oncrop := ONcombobox1.ONRIGHT;
      8: oncrop := ONcombobox1.ONCENTER;
      9: oncrop := ONcombobox1.ONBUTONNORMAL;
      10: oncrop := ONcombobox1.ONBUTONHOVER;
      11: oncrop := ONcombobox1.ONBUTONPRESS;
      12: oncrop := ONcombobox1.ONBUTONDISABLE;
    end;
  end;

  if AWorkbook is ToNListBox then
  begin
    case RadioGroup1.ItemIndex of
      0: oncrop := oNListBox1.ONTOPLEFT;
      1: oncrop := oNListBox1.ONTOPRIGHT;
      2: oncrop := oNListBox1.ONTOP;
      3: oncrop := oNListBox1.ONBOTTOMLEFT;
      4: oncrop := oNListBox1.ONBOTTOMRIGHT;
      5: oncrop := oNListBox1.ONBOTTOM;
      6: oncrop := oNListBox1.ONLEFT;
      7: oncrop := oNListBox1.ONRIGHT;
      8: oncrop := oNListBox1.ONCENTER;
      9: oncrop := oNListBox1.ONACTIVEITEM;
     10: oncrop := oNListBox1.ONITEM;

    end;
  end;

  if AWorkbook is TOncolumlist then
  begin
    case RadioGroup1.ItemIndex of
      0: oncrop := Oncolumlist1.ONTOPLEFT;
      1: oncrop := Oncolumlist1.ONTOPRIGHT;
      2: oncrop := Oncolumlist1.ONTOP;
      3: oncrop := Oncolumlist1.ONBOTTOMLEFT;
      4: oncrop := Oncolumlist1.ONBOTTOMRIGHT;
      5: oncrop := Oncolumlist1.ONBOTTOM;
      6: oncrop := Oncolumlist1.ONLEFT;
      7: oncrop := Oncolumlist1.ONRIGHT;
      8: oncrop := Oncolumlist1.ONCENTER;
      9: oncrop := Oncolumlist1.ONACTIVEITEM;
     10: oncrop := Oncolumlist1.ONITEM;
     11: oncrop := Oncolumlist1.ONHEADER;
    end;
  end;

  if AWorkbook = ToNScrollBar(oNScrollBar1) then
  begin
    case RadioGroup1.ItemIndex of
      0: oncrop := oNScrollBar1.ONTOP;
      1: oncrop := oNScrollBar1.ONBOTTOM;
      2: oncrop := oNScrollBar1.ONNORMAL;
      3: oncrop := oNScrollBar1.ONBAR;
      4: oncrop := oNScrollBar1.ONLEFTBUTNORMAL;
      5: oncrop := oNScrollBar1.ONLEFTBUTONHOVER;
      6: oncrop := oNScrollBar1.ONLEFTBUTPRESS;
      7: oncrop := oNScrollBar1.ONLEFTBUTDISABLE;
      8: oncrop := oNScrollBar1.ONRIGHTBUTNORMAL;
      9: oncrop := oNScrollBar1.ONRIGHTBUTONHOVER;
      10: oncrop := oNScrollBar1.ONRIGHTBUTPRESS;
      11: oncrop := oNScrollBar1.ONRIGHTBUTDISABLE;
      12: oncrop := oNScrollBar1.ONCENTERBUTNORMAL;
      13: oncrop := oNScrollBar1.ONCENTERBUTONHOVER;
      14: oncrop := oNScrollBar1.ONCENTERBUTPRESS;
      15: oncrop := oNScrollBar1.ONCENTERBUTDISABLE;
    end;
  end;

  if AWorkbook = ToNScrollBar(oNScrollBar2) then
  begin
    case RadioGroup1.ItemIndex of
      0: oncrop := oNScrollBar2.ONTOP;
      1: oncrop := oNScrollBar2.ONBOTTOM;
      2: oncrop := oNScrollBar2.ONNORMAL;
      3: oncrop := oNScrollBar2.ONBAR;
      4: oncrop := oNScrollBar2.ONLEFTBUTNORMAL;
      5: oncrop := oNScrollBar2.ONLEFTBUTONHOVER;
      6: oncrop := oNScrollBar2.ONLEFTBUTPRESS;
      7: oncrop := oNScrollBar2.ONLEFTBUTDISABLE;
      8: oncrop := oNScrollBar2.ONRIGHTBUTNORMAL;
      9: oncrop := oNScrollBar2.ONRIGHTBUTONHOVER;
      10: oncrop := oNScrollBar2.ONRIGHTBUTPRESS;
      11: oncrop := oNScrollBar2.ONRIGHTBUTDISABLE;
      12: oncrop := oNScrollBar2.ONCENTERBUTNORMAL;
      13: oncrop := oNScrollBar2.ONCENTERBUTONHOVER;
      14: oncrop := oNScrollBar2.ONCENTERBUTPRESS;
      15: oncrop := oNScrollBar2.ONCENTERBUTDISABLE;
    end;
  end;


  if AWorkbook is TOnSwich then
  begin
    case RadioGroup1.ItemIndex of
      0: oncrop := onswich1.ONOPEN;
      1: oncrop := onswich1.ONOPENHOVER;
      2: oncrop := onswich1.ONCLOSE;
      3: oncrop := onswich1.ONCLOSEHOVER;
      4: oncrop := onswich1.ONDISABLE;
    end;
  end;

  if AWorkbook is TOnCheckbox then
  begin
    case RadioGroup1.ItemIndex of
      0: oncrop := OnCheckbox1.ONNORMAL;
      1: oncrop := OnCheckbox1.ONNORMALHOVER;
      2: oncrop := OnCheckbox1.ONNORMALDOWN;
      3: oncrop := OnCheckbox1.ONCHECKED;
      4: oncrop := OnCheckbox1.ONCHECKEDHOVER;
      5: oncrop := OnCheckbox1.ONDISABLE;
    end;
  end;

  if AWorkbook is TOnRadioButton then
  begin
    case RadioGroup1.ItemIndex of
      0: oncrop := OnRadioButton1.ONNORMAL;
      1: oncrop := OnRadioButton1.ONNORMALHOVER;
      2: oncrop := OnRadioButton1.ONNORMALDOWN;
      3: oncrop := OnRadioButton1.ONCHECKED;
      4: oncrop := OnRadioButton1.ONCHECKEDHOVER;
      5: oncrop := OnRadioButton1.ONDISABLE;
    end;
  end;


  if AWorkbook = TONProgressBar(ONProgressBar1) then
  begin
    case RadioGroup1.ItemIndex of
      0: oncrop := ONProgressBar1.ONLEFT_TOP;
      1: oncrop := ONProgressBar1.ONRIGHT_BOTTOM;
      2: oncrop := ONProgressBar1.ONTOP;
      3: oncrop := ONProgressBar1.ONBOTTOM;
      4: oncrop := ONProgressBar1.ONCENTER;
      5: oncrop := ONProgressBar1.ONBAR;
    end;
  end;

  if AWorkbook = TONProgressBar(ONProgressBar2) then
  begin
    case RadioGroup1.ItemIndex of
      0: oncrop := ONProgressBar2.ONLEFT_TOP;
      1: oncrop := ONProgressBar2.ONRIGHT_BOTTOM;
      2: oncrop := ONProgressBar1.ONTOP;
      3: oncrop := ONProgressBar1.ONBOTTOM;
      4: oncrop := ONProgressBar1.ONCENTER;
      5: oncrop := ONProgressBar1.ONBAR;
    end;
  end;


  if AWorkbook = TONTrackBar(ontrackbar1) then
  begin
    case RadioGroup1.ItemIndex of
      0: oncrop := ontrackbar1.ONLEFT;
      1: oncrop := ontrackbar1.ONRIGHT;
      2: oncrop := ontrackbar1.ONCENTER;
      3: oncrop := ontrackbar1.ONBUTONNORMAL;
      4: oncrop := ontrackbar1.ONBUTONHOVER;
      5: oncrop := ontrackbar1.ONBUTONPRESS;
      6: oncrop := ontrackbar1.ONBUTONDISABLE;
    end;
  end;

   if AWorkbook = TONTrackBar(ontrackbar2) then
   begin
      case RadioGroup1.ItemIndex of
        0: oncrop := ontrackbar2.ONLEFT;
        1: oncrop := ontrackbar2.ONRIGHT;
        2: oncrop := ontrackbar2.ONCENTER;
        3: oncrop := ontrackbar2.ONBUTONNORMAL;
        4: oncrop := ontrackbar2.ONBUTONHOVER;
        5: oncrop := ontrackbar2.ONBUTONPRESS;
        6: oncrop := ontrackbar2.ONBUTONDISABLE;
      end;
   end;

   if AWorkbook is TONCollapExpandPanel then
  begin
    case RadioGroup1.ItemIndex of
      0: oncrop := ONCollapExpandPanel1.ONTOPLEFT;
      1: oncrop := ONCollapExpandPanel1.ONTOPRIGHT;
      2: oncrop := ONCollapExpandPanel1.ONTOP;
      3: oncrop := ONCollapExpandPanel1.ONBOTTOMLEFT;
      4: oncrop := ONCollapExpandPanel1.ONBOTTOMRIGHT;
      5: oncrop := ONCollapExpandPanel1.ONBOTTOM;
      6: oncrop := ONCollapExpandPanel1.ONLEFT;
      7: oncrop := ONCollapExpandPanel1.ONRIGHT;
      8: oncrop := ONCollapExpandPanel1.ONCENTER;
      9: oncrop := ONCollapExpandPanel1.ONNORMAL;
      10: oncrop := ONCollapExpandPanel1.ONHOVER;
      11: oncrop := ONCollapExpandPanel1.ONPRESSED;
      12: oncrop := ONCollapExpandPanel1.ONDISABLE;
      13: oncrop := ONCollapExpandPanel1.ONEXNORMAL;
      14: oncrop := ONCollapExpandPanel1.ONEXPRESSED;
      15: oncrop := ONCollapExpandPanel1.ONEXHOVER;
      16: oncrop := ONCollapExpandPanel1.ONEXDISABLE;
      17: oncrop := ONCollapExpandPanel1.ONCAPTION;

    end;
  end;

  if AWorkbook is TONlabel then
  begin
    case RadioGroup1.ItemIndex of
      0: oncrop := ONlabel1.ONCLIENT;
    end;
  end;

  if AWorkbook is TONLed then
  begin
    case RadioGroup1.ItemIndex of
      0: oncrop := ONLed1.ONLEDONNORMAL;
      1: oncrop := ONLed1.ONLEDONHOVER;
      2: oncrop := ONLed1.ONLEDOFFNORMAL;
      3: oncrop := ONLed1.ONLEDOFFHOVER;
      4: oncrop := ONLed1.ONDISABLED;

    end;
  end;


  readdata(oncrop);
 // ShowMessage(oncrop.cropname);
end;


procedure Tskinsbuildier.zoomTimerTimer;
var
  srcRect, fmrRect: TRect;
  oo: integer;
  img: TBGRACustomBitmap;
 begin
    fmrRect := Rect(mainpicture.Left, mainpicture.Top, mainpicture.Left +  mainpicture.Width, mainpicture.Top + mainpicture.Height);

    if PtInRect(fmrRect, curPos) then
    begin
      oo := trackbar1.Position;
      srcRect := Rect(curPos.x - oo, curPos.y - oo, curPos.x + oo, curPos.y + oo);

      cropimg.SetSize(zoomx.Width, zoomx.Height);

      img := temp.GetPart(srcRect);
      if img <> nil then
      begin
        img.ResampleFilter := rfBestQuality;
        BGRAReplace(cropimg, img.Resample(zoomx.Width, zoomx.Height, rmSimpleStretch));
      end;
      FreeAndNil(img);
      zoomx.RedrawBitmap;
    end;

end;

procedure Tskinsbuildier.trackbar1change(Sender: TObject);
begin
  zoomTimerTimer;
end;


procedure Tskinsbuildier.mainpictureredraw(Sender: TObject; bitmap: tbgrabitmap);
begin
  temp.SetSize(0,0);
  temp.SetSize(mainimg.Width,mainimg.Height);
  temp.PutImage(0, 0, mainimg, dmSet);
  temp.Canvas.Brush.Style := bsClear;
  temp.Canvas.Pen.Style := psDash;
  temp.Canvas.Pen.Color := clRed;
  temp.Canvas.Pen.Width := 1;
  temp.Canvas.Rectangle(rectlange);
  bitmap.PutImage(0, 0, temp, dmLinearBlend, 255);
end;

procedure Tskinsbuildier.ONlabel1Click(Sender: TObject);
begin
  ONlabel1.Active:=NOT ONlabel1.Active;
end;

procedure Tskinsbuildier.zoomxredraw(Sender: TObject; bitmap: tbgrabitmap);
var
  Xshift, Yshift: integer;
  c: TBGRAPixel;
begin
  Xshift := (zoomx.Width) div 2;
  Yshift := (zoomx.Height) div 2;
  c := ColorToBGRA(ColorToRGB(ColorBox1.Selected));


  cropimg.JoinStyle := pjsBevel;
  cropimg.LineCap := pecSquare;
  cropimg.PenStyle := psSolid;//psdot;
  cropimg.DrawPolyLineAntialias(
    [PointF(Xshift, Yshift - 20), PointF(Xshift, Yshift + 20), PointF(Xshift, Yshift),
    PointF(Xshift - 20, Yshift), PointF(Xshift + 20, Yshift)], c, 2);

  bitmap.PutImage(0, 0, cropimg, dmLinearBlend{dmDrawWithTransparency}, 255);
end;

procedure Tskinsbuildier.mainpicturemousedown(Sender: TObject; button: tmousebutton;
  shift: tshiftstate; x, y: integer);
begin
  if (button = mbleft) then
  begin
    rectlange.left := x;
    rectlange.Top := y;
    aktif := True;
  end;
end;

procedure Tskinsbuildier.mainpicturemousemove(Sender: TObject; shift: tshiftstate;
  x, y: integer);
begin
  curPos := Point(x, y);
  label6.Caption := 'X= '+IntToStr(x) + ' --  Y=' + IntToStr(y);

  if (aktif) then
  begin
    rectlange.Right := x;
    rectlange.Bottom := y;
    mainpicture.RedrawBitmap;
  end;

  zoomTimerTimer;
end;

procedure Tskinsbuildier.mainpicturemouseup(Sender: TObject; button: tmousebutton;
  shift: tshiftstate; x, y: integer);
begin
  aktif := False;
  rectlange.Right := x;
  rectlange.Bottom := y;
  mainpicture.RedrawBitmap;
{  Label12.Caption := IntToStr(rectlange.Left);
  Label13.Caption := IntToStr(rectlange.Right);
  Label14.Caption := IntToStr(rectlange.top);
  Label15.Caption := IntToStr(rectlange.bottom);
  }
  edit1.Text := IntToStr(rectlange.Left);
  edit2.Text := IntToStr(rectlange.Right);
  edit3.Text := IntToStr(rectlange.top);
  edit4.Text := IntToStr(rectlange.bottom);
  //if list.Row>0 then
  //UpdateOcustomControlu(gg, rectlange);
end;



end.

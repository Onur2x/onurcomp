unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Windows, Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, ExtDlgs, BGRAVirtualScreen, onurbutton, BGRABitmap,
  BGRABitmapTypes, ColorBox, ComCtrls, inifiles;

type

  // ToInspectorExpande = (oleft, oright, otop, obottom, otopleft, otopright, obottomleft, obottomright, onormal, ohover, opress, odisable);
  //  ToInspectorExpanded = set of ToInspectorExpande;

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    ColorBox1: TColorBox;
    ColorBox2: TColorBox;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit4: TEdit;
    Edit3: TEdit;
    Edit5: TEdit;
    ImageList1: TImageList;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    Label22: TLabel;
    Label23: TLabel;
    Label6: TLabel;
    mainpicture: tbgravirtualscreen;
    odf: TOpenDialog;
    main: tonimg;
    oncheckbox1: toncheckbox;
    oncollapexpandpanel1: toncollapexpandpanel;
    onprogressbar1: tonprogressbar;
    onprogressbar2: tonprogressbar;
    onradiobutton1: tonradiobutton;
    onscrollbar2: tonscrollbar;
    OnSpinEdit1: TOnSpinEdit;
    onswich1: tonswich;
    ontrackbar1: tontrackbar;
    ontrackbar2: tontrackbar;
    Panel5: TPanel;
    Panel6: TPanel;
    Panel7: TPanel;
    RadioGroup1: TRadioGroup;
    sdf: TSaveDialog;
    ToolButton5: TToolButton;
    ToolButton6: TToolButton;
    ToolButton7: TToolButton;
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
    procedure Edit3KeyPress(Sender: TObject; var Key: char);
    procedure Edit5Change(Sender: TObject);
    procedure formclose(Sender: TObject; var closeaction: tcloseaction);
    procedure formcreate(Sender: TObject);
    procedure mainpicturemousedown(Sender: TObject; button: tmousebutton;
      shift: tshiftstate; x, y: integer);
    procedure mainpicturemousemove(Sender: TObject; shift: tshiftstate;
      x, y: integer);
    procedure mainpicturemouseup(Sender: TObject; button: tmousebutton;
      shift: tshiftstate; x, y: integer);
    procedure mainpictureredraw(Sender: TObject; bitmap: tbgrabitmap);
    procedure RadioGroup1Click(Sender: TObject);

    procedure toolbutton1click(Sender: TObject);
    procedure ToolButton4Click(Sender: TObject);
    procedure ToolButton5Click(Sender: TObject);
    procedure trackbar1change(Sender: TObject);
    procedure zoomxredraw(Sender: TObject; bitmap: tbgrabitmap);
  private
    procedure readdata(Ab: TONCustomCrop);
    procedure readskin;
    procedure updateocustomcontrolu(aworkbook: tcontrol);
    procedure writedata(Ab: TONCustomCrop);
    procedure writeskin;
    procedure zoomtimertimer;
  public
    gg: Tcontrol;
    oncrop: TONCustomCrop;
  end;




var
  Form1: TForm1;
  aktif: boolean;
  rectlange: Trect;
  temp, mainimg, cropimg: TBGRABitmap;
  curPos: TPoint;
  skn: TIniFile;

implementation

{$R *.lfm}

{ TForm1 }


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
      Crp.fsLEFT    := StrToIntDef(myst.Strings[0],2);
      Crp.fsTOP     := StrToInt(myst.Strings[1]);
      Crp.fsBOTTOM  := StrToInt(myst.Strings[2]);
      Crp.fsRIGHT   := StrToInt(myst.Strings[3]);
      Crp.Fontcolor := StringToColorDef(myst.Strings[4],clNone);
    finally
      myst.free;
    end;
  end;
end;

procedure TForm1.readdata(Ab: TONCustomCrop);
begin

  skn := Tinifile.Create(GetTempDir+'skins.ini');//Extractfilepath(application.ExeName) + 'temp.ini');
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

  edit1.Text := IntToStr(ab.fsLeft);
  edit2.Text := IntToStr(ab.fsRight);
  Edit3.Text := IntToStr(ab.fstop);
  Edit4.Text := IntToStr(ab.fsbottom);
  ColorBox2.Selected := ab.Fontcolor;

  rectlange.left := ab.fsLeft;
  rectlange.Right := ab.fsRight;
  rectlange.top := ab.fstop;
  rectlange.bottom := ab.fsbottom;
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

procedure TForm1.Edit3KeyPress(Sender: TObject; var Key: char);
begin
  if (key in ['0'..'9']) then
  begin
    if Edit1.Text <> '' then  rectlange.left := StrToInt(Edit1.Text)
    else
      rectlange.Left := 0;
    if Edit2.Text <> '' then  rectlange.Right := StrToInt(Edit2.Text)
    else
      rectlange.Right := 0;
    if Edit3.Text <> '' then  rectlange.top := StrToInt(Edit3.Text)
    else
      rectlange.top := 0;
    if Edit4.Text <> '' then  rectlange.bottom := StrToInt(Edit4.Text)
    else
      rectlange.Bottom := 0;
    mainpicture.RedrawBitmap;
  end;
end;


function croptostring(Crp: TONCustomCrop):string;
begin
   Result:='';
  if Crp<>nil then
    Result:=inttostr(Crp.fsLEFT)+','+inttostr(Crp.fsTOP)+','+inttostr(Crp.fsBOTTOM)+','+inttostr(Crp.fsRIGHT)+','+ColorToString(Crp.Fontcolor);
end;

procedure TForm1.writedata(Ab: TONCustomCrop);
begin
  if Edit1.Text <> '' then ab.fsLeft := StrToInt(edit1.Text)
  else
    ab.fsleft := 0;
  if Edit2.Text <> '' then ab.fsRight := StrToInt(edit2.Text)
  else
    ab.fsRight := 0;
  if Edit3.Text <> '' then ab.fstop := StrToInt(Edit3.Text)
  else
    ab.fsTop := 0;
  if Edit4.Text <> '' then ab.fsbottom := StrToInt(Edit4.Text)
  else
    ab.fsBottom := 0;
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


procedure tform1.combobox1change(Sender: TObject);
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
  Panel7.Visible := False;

  RadioGroup1.Items.Clear;
  case ComboBox1.ItemIndex of
    0:
    begin
      gg := ONGraphicsButton1;
      edit5.Text := ONGraphicsButton1.Skinname;
      RadioGroup1.items.add('NORMAL');
      RadioGroup1.items.add('HOVER');
      RadioGroup1.items.add('PRESSED');
      RadioGroup1.items.add('DISABLE');
    end;

    1:
    begin
      gg := ONCropButton1;
      edit5.Text := oncropbutton1.Skinname;
      RadioGroup1.items.add('NORMAL');
      RadioGroup1.items.add('HOVER');
      RadioGroup1.items.add('PRESSED');
      RadioGroup1.items.add('DISABLE');
    end;
    2:
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
    3:
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
    4:
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
    5:
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
    6:
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
    7:
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
    end;
    8:
    begin
      gg := onswich1;
      edit5.Text := onswich1.Skinname;
      RadioGroup1.items.add('OPEN');
      RadioGroup1.items.add('OPENHOVER');
      RadioGroup1.items.add('CLOSE');
      RadioGroup1.items.add('CLOSEHOVER');
      RadioGroup1.items.add('DISABLE');
    end;
    9:
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

    10:
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

    11:
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

    12:
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

    13:
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

    14:
    begin
      gg := onprogressbar1;
      edit5.Text := onprogressbar1.Skinname;
      RadioGroup1.items.add('ONLEFT_TOP');
      RadioGroup1.items.add('ONRIGHT_BOTTOM');
      RadioGroup1.items.add('ONCENTER');
      RadioGroup1.items.add('ONBAR');
    end;

    15:
    begin
      gg := onprogressbar2;
      edit5.Text := onprogressbar2.Skinname;
      RadioGroup1.items.add('ONLEFT_TOP');
      RadioGroup1.items.add('ONRIGHT_BOTTOM');
      RadioGroup1.items.add('ONCENTER');
      RadioGroup1.items.add('ONBAR');
    end;

    16:
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

    17:
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

    18:
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
    end;




  end;

  if Assigned(gg) then
  GG.Visible := True;
  //edit5.Text:=gg.Name;
end;


procedure TForm1.Edit5Change(Sender: TObject);
begin
  if gg is TONCustomControl then
    TONCustomControl(gg).Skinname := edit5.Text
  else
    TONGraphicControl(gg).Skinname := edit5.Text;

end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  if (RadioGroup1.ItemIndex > -1) and (Assigned(oncrop)) then
  begin
    writedata(oncrop);
    gg.Invalidate;

  end;

end;

procedure TForm1.RadioGroup1Click(Sender: TObject);
begin
  if RadioGroup1.ItemIndex > -1 then
  begin
    panel7.Visible := True;
    updateocustomcontrolu(gg);
  end
  else
  begin
    panel7.Visible := False;
    oncrop := nil;
  end;
end;



procedure TForm1.readskin;
var
  a: TStringList;
  i, k, l: integer;
begin
  a := TStringList.Create;
  skn := Tinifile.Create(GetTempDir+'skins.ini');//Extractfilepath(application.ExeName) + 'temp.ini');
  try
    skn.ReadSection('Compnames', a);

    if a.Count > -1 then
    begin
      for i := 0 to a.Count - 1 do
      begin
        if skn.ReadString('Compnames', IntToStr(i), '') <> '' then
        begin
          for k := 0 to self.ComponentCount - 1 do
          begin
            //   :=timetable.ReadString(dosya, 'sure'+inttostr(i),'');
          end;
        end;
      end;
    end;

  finally
    FreeAndNil(a);
    FreeAndNil(skn);
  end;
end;

procedure TForm1.writeskin;
var
  a: TStringList;
begin
  a := TStringList.Create;
  skn := Tinifile.Create(Extractfilepath(application.ExeName) + 'temp.ini');
  try
    skn.ReadSection('Compnames', a);
  finally
    FreeAndNil(a);
    FreeAndNil(skn);
  end;
end;

procedure tform1.formclose(Sender: TObject; var closeaction: tcloseaction);
begin
  writeskin;
  FreeAndNil(mainimg);
  FreeAndNil(temp);
  FreeAndNil(cropimg);

end;

procedure tform1.formcreate(Sender: TObject);
begin
  //FExpanded := [oleft, oright, otop, obottom, otopleft, otopright, obottomleft, obottomright, onormal, ohover, opress, odisable];
  aktif := False;
  mainimg := TBGRABitmap.Create(mainpicture.Width, mainpicture.Height);
  temp := TBGRABitmap.Create(mainpicture.Width, mainpicture.Height);
  cropimg := TBGRABitmap.Create(100, 100);
  mainimg.Assign(ONImg1.Fimage);
  mainpicture.RedrawBitmap;
  readskin;

end;



procedure tform1.toolbutton1click(Sender: TObject);
begin
  if opd.Execute then
  begin
    //image1.Picture.LoadFromFile(opd.FileName);
    mainimg.LoadFromFile(opd.FileName);
    ONImg1.Picture.LoadFromFile(opd.FileName);
    mainpicture.RedrawBitmap;
  end;
end;

procedure TForm1.ToolButton4Click(Sender: TObject);
begin

  if odf.Execute then
  begin
    ONImg1.Loadskin(odf.FileName,'',false);
    mainimg.Assign(ONImg1.Fimage);
    mainpicture.RedrawBitmap;
  end;
end;

procedure TForm1.ToolButton5Click(Sender: TObject);
begin
  if sdf.Execute then
  begin
  //  ONImg1.Readskinsfile(Extractfilepath(application.ExeName) + 'temp.ini');
    ONImg1.saveskin(sdf.FileName,'');
  end;
end;




procedure TForm1.UpdateOcustomControlu(AWorkbook: TControl);
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
      1: oncrop := ONGraphicsButton1.ONHOVER;
      2: oncrop := ONGraphicsButton1.ONPRESSED;
      3: oncrop := ONGraphicsButton1.ONDISABLE;
    end;
  end;

  if AWorkbook is TONCropButton then
  begin
    case RadioGroup1.ItemIndex of
      0: oncrop := ONCropButton1.ONNORMAL;
      1: oncrop := ONCropButton1.ONHOVER;
      2: oncrop := ONCropButton1.ONPRESSED;
      3: oncrop := ONCropButton1.ONDISABLE;
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
      2: oncrop := ONProgressBar1.ONCENTER;
      3: oncrop := ONProgressBar1.ONBAR;
    end;
  end;

  if AWorkbook = TONProgressBar(ONProgressBar2) then
  begin
    case RadioGroup1.ItemIndex of
      0: oncrop := ONProgressBar2.ONLEFT_TOP;
      1: oncrop := ONProgressBar2.ONRIGHT_BOTTOM;
      2: oncrop := ONProgressBar2.ONCENTER;
      3: oncrop := ONProgressBar2.ONBAR;
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
    end;
  end;

  readdata(oncrop);
end;




procedure TForm1.zoomTimerTimer;
var
  srcRect, fmrRect: TRect;
  oo: integer;
  img: TBGRACustomBitmap;
 begin
    fmrRect := Rect(mainpicture.Left, mainpicture.Top, mainpicture.Left +
      mainpicture.Width, mainpicture.Top + mainpicture.Height);

    if PtInRect(fmrRect, curPos) then
    begin
      //      destRect:=Rect(0,0,zoomx.Width,zoomx.Height);
      oo := trackbar1.Position;
      srcRect := Rect(curPos.x - oo, curPos.y - oo, curPos.x + oo, curPos.y + oo);


      cropimg.SetSize(zoomx.Width, zoomx.Height);
      //  cropimg.ResampleFilter:= rfBestQuality;
 //     BGRAReplace(cropimg, temp.GetPart(srcRect).Resample(zoomx.Width,
 //       zoomx.Height, rmFineResample));



      img := temp.GetPart(srcRect);
      if img <> nil then
      begin
       // Target.Fresim.ResampleFilter := rfBestQuality;
        img.ResampleFilter := rfBestQuality;
        BGRAReplace(cropimg, img.Resample(zoomx.Width, zoomx.Height, rmSimpleStretch));
      end;
      FreeAndNil(img);



      //      DrawPartstrechRegion(srcRect,temp,zoomx.Width,zoomx.Height,destRect,false);
      zoomx.RedrawBitmap;
    end;

end;

procedure tform1.trackbar1change(Sender: TObject);
begin
  zoomTimerTimer;
end;


procedure tform1.mainpictureredraw(Sender: TObject; bitmap: tbgrabitmap);
begin
  temp.PutImage(0, 0, mainimg, dmSet);
  temp.Canvas.Brush.Style := bsClear;
  temp.Canvas.Pen.Style := psDash;
  temp.Canvas.Pen.Color := clRed;
  temp.Canvas.Pen.Width := 1;
  // temp.Canvas.Pen.Style := psSolid;
  // temp.Canvas.Pen.Mode := pmNotXor;
  temp.Canvas.Rectangle(rectlange);

  bitmap.PutImage(0, 0, temp, dmDrawWithTransparency, 255);

end;




procedure tform1.zoomxredraw(Sender: TObject; bitmap: tbgrabitmap);
var
  Xshift, Yshift: integer;
  c: TBGRAPixel;
begin
  Xshift := (zoomx.Width) div 2;
  Yshift := (zoomx.Height) div 2;
  c := ColorToBGRA(ColorToRGB(ColorBox1.Selected));


  cropimg.JoinStyle := pjsBevel;
  cropimg.LineCap := pecSquare;
  cropimg.PenStyle := psdot;//psSolid;
  cropimg.DrawPolyLineAntialias(
    [PointF(Xshift, Yshift - 20), PointF(Xshift, Yshift + 20), PointF(Xshift, Yshift),
    PointF(Xshift - 20, Yshift), PointF(Xshift + 20, Yshift)], c, 2);

  bitmap.PutImage(0, 0, cropimg, dmDrawWithTransparency, 255);
end;

procedure tform1.mainpicturemousedown(Sender: TObject; button: tmousebutton;
  shift: tshiftstate; x, y: integer);
begin
  if (button = mbleft) then
  begin
    rectlange.left := x;
    rectlange.Top := y;
    aktif := True;
  end;
end;

procedure tform1.mainpicturemousemove(Sender: TObject; shift: tshiftstate;
  x, y: integer);
begin
  curPos := Point(x, y);
  label6.Caption := 'X= '+IntToStr(x) + ' --  Y=' + IntToStr(y);

  if (aktif) then
  begin
    //rectlange:=Rect(xx,x,yy,y);
    rectlange.Right := x;
    rectlange.Bottom := y;
    mainpicture.RedrawBitmap;
  end;


  zoomTimerTimer;
end;

procedure tform1.mainpicturemouseup(Sender: TObject; button: tmousebutton;
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

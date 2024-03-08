unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Windows, Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, ExtDlgs, BGRAVirtualScreen, onurctrl, onurbutton, onurbar,
  onuredit, onurpanel, onurlist, onurpage, BGRABitmap,
  BGRABitmapTypes, ColorBox, ComCtrls, Spin, ValEdit, inifiles, Types, Grids;

type

  // ToInspectorExpande = (oleft, oright, otop, obottom, otopleft, otopright, obottomleft, obottomright, onormal, ohover, opress, odisable);
  //  ToInspectorExpanded = set of ToInspectorExpande;

  { Tskinsbuildier }

  Tskinsbuildier = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    PropEdit: TValueListEditor;
    ONURContentSlider1: TONURContentSlider;
    ONURStringGrid1: TONURStringGrid;
    Panel1: TPanel;
    traybut: TONURsystemButton;
    ColorBox1: TColorBox;
    ColorBox2: TColorBox;
    colorbox3: tcolorbox;
    ImageList1: TImageList;
    Label15: TLabel;
    Label16: TLabel;
    Label24: TLabel;
    Label25: TLabel;
    Label6: TLabel;
    mainpicture: tbgravirtualscreen;
    odf: TOpenDialog;
    oncheckbox1: TONURcheckbox;
    ONColExpPanel1: TONURcollapexpandpanel;
    Oncolumlist1: TONURColumList;
    closebut: TONURsystemButton;
    infoedit: TValueListEditor;
    ONKnob1: TONURKnob;
    ONlabel1: TONURlabel;
    ONLed1: TONURLed;
    ONPage1: TONURPage;
    ONPage2: TONURPage;
    ONPageControl1: TONURPageControl;
    ONProgressBar1: TONURProgressBar;
    ONProgressBar2: TONURProgressBar;
    onradiobutton1: TONURradiobutton;
    onscrollbar2: TONURscrollbar;
    OnSpinEdit1: TONURSpinEdit;
    onswich1: TONURswich;
    ontrackbar1: TONURtrackbar;
    ontrackbar2: TONURtrackbar;
    Panel5: TPanel;
    Panel8: TPanel;
    Panel9: TPanel;
    ScrollBox1: TScrollBox;
    sdf: TSaveDialog;
    SpinEdit1: TSpinEdit;
    maxbut: TONURsystemButton;
    TreeView1: TTreeView;
    zoomx: tbgravirtualscreen;
    label1: tlabel;
    label2: tlabel;
    label3: tlabel;
    label4: tlabel;
    label5: tlabel;
    ONcombobox1: TONURComboBox;
    oncropbutton1: TONURcropbutton;
    onEdit1: TONUREdit;
    ONGraphicPanel1: TONURGraphicPanel;
    ongraphicsbutton1: TONURgraphicsbutton;
    onheaderpanel1: TONURheaderpanel;
    ONImg1: TONURImg;
    oNListBox1: TONURListBox;
    ONMemo1: TONURMemo;
    ONPanel1: TONURPanel;
    oNScrollBar1: TONURScrollBar;
    opd: topenpicturedialog;
    Panel2: TPanel;
    panel3: tpanel;
    panel4: tpanel;
    trackbar1: ttrackbar;
    procedure Button2Click(Sender: TObject);
    procedure ColorBox2Select(Sender: TObject);
    procedure ColorBox3Select(Sender: TObject);
    procedure formclose(Sender: TObject; var closeaction: tcloseaction);
    procedure formcreate(Sender: TObject);
    procedure PropEditSelectCell(Sender: TObject; aCol, aRow: Integer;
      var CanSelect: Boolean);
    procedure infoeditSelectCell(Sender: TObject; aCol, aRow: integer;
      var CanSelect: boolean);
    procedure infoeditStringsChange(Sender: TObject);
    procedure infoeditTopLeftChanged(Sender: TObject);
    procedure mainpicturemousedown(Sender: TObject; button: tmousebutton;
      shift: tshiftstate; x, y: integer);
    procedure mainpicturemousemove(Sender: TObject; shift: tshiftstate;
      x, y: integer);
    procedure mainpicturemouseup(Sender: TObject; button: tmousebutton;
      shift: tshiftstate; x, y: integer);
    procedure mainpictureredraw(Sender: TObject; bitmap: tbgrabitmap);
    procedure ONGraphicsButton2Click(Sender: TObject);
    procedure ONGraphicsButton3Click(Sender: TObject);
    procedure ONGraphicsButton4Click(Sender: TObject);
    procedure ONGraphicsButton5Click(Sender: TObject);
    procedure ONHeaderPanel2MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: integer);
    procedure ONlabel1Click(Sender: TObject);
    procedure ONLed1Click(Sender: TObject);
    procedure PropEditKeyPress(Sender: TObject; var Key: char);
    procedure PropEditStringsChange(Sender: TObject);
    procedure PropEditTopLeftChanged(Sender: TObject);

    procedure SpinEdit1Change(Sender: TObject);
    procedure SpinEdit1Exit(Sender: TObject);
    procedure trackbar1change(Sender: TObject);
    procedure TreeView1Change(Sender: TObject; Node: TTreeNode);
    procedure zoomxredraw(Sender: TObject; bitmap: tbgrabitmap);
  private

    procedure readdata(Ab: TONURCustomCrop);
    //    procedure readskin;
    procedure updatefrm;
    //   procedure updateocustomcontrolu(aworkbook: tcontrol);
    procedure writedata(Ab: TONURCUSTOMCROP);
    //    procedure writeskin;
    procedure zoomtimertimer;
  public
    objlist: TList;
    gg: Tcontrol;
    oncrop: TONURCUSTOMCROP;

  end;




var
  skinsbuildier: Tskinsbuildier;
  aktif, changeskininfo: boolean;
  rectlange: Trect;
  temp, mainimg, cropimg: TBGRABitmap;
  curPos: TPoint;
  skn: TIniFile;
  fselect : integer; // for propedit selected row
  notwriting:boolean; // for propedit save
implementation

uses Variants;

{$R *.lfm}

{ Tskinsbuildier }


procedure cropparse(Crp: TONURCUSTOMCROP; val: string);
var
  myst: TStringList;
begin
  if val.Length > 0 then
  begin
    myst := TStringList.Create;
    try
      myst.Delimiter     := ',';
      myst.DelimitedText := val;
      Crp.LEFT           := StrToIntDef(myst.Strings[0], 2);
      Crp.TOP            := StrToIntDef(myst.Strings[1], 2);
      Crp.RIGHT          := StrToIntDef(myst.Strings[2], 4);
      Crp.BOTTOM         := StrToIntDef(myst.Strings[3], 4);
      Crp.Fontcolor      := StringToColorDef(myst.Strings[4], clNone);
    finally
      myst.Free;
    end;
  end;
end;


procedure Tskinsbuildier.readdata(Ab: TONURCUSTOMCROP);
begin
  skn := Tinifile.Create(GetTempDir + 'skins.ini');
  try
    cropparse(ab, skn.ReadString(PropEdit.Cells[1, 1], ab.cropname, '0,0,0,0,clblack'));
  finally
    FreeAndNil(skn);
  end;

  PropEdit.Cells[1, 2] := IntToStr(ab.Left);
  PropEdit.Cells[1, 3] := IntToStr(ab.top);
  PropEdit.Cells[1, 4] := IntToStr(ab.Right);
  PropEdit.Cells[1, 5] := IntToStr(ab.Bottom);
  ColorBox2.Selected   := ab.Fontcolor;
  rectlange.left       := ab.Left;
  rectlange.Right      := ab.Right;
  rectlange.top        := ab.top;
  rectlange.bottom     := ab.bottom;
  mainpicture.RedrawBitmap;

end;

function croptostring(Crp: TONURCUSTOMCROP): string;
begin
  Result := '';
  if Crp <> nil then
    Result := IntToStr(Crp.LEFT) + ',' + IntToStr(Crp.TOP) + ',' +
      IntToStr(Crp.RIGHT) + ',' + IntToStr(Crp.BOTTOM) + ',' +
      ColorToString(Crp.Fontcolor);
end;

procedure Tskinsbuildier.writedata(Ab: TONURCUSTOMCROP);
begin
  if PropEdit.Cells[1, 2] <> '' then ab.Left := StrToInt(PropEdit.Cells[1, 2])
  else
    ab.left := 0;

  if PropEdit.Cells[1, 4] <> '' then ab.Right := StrToInt(PropEdit.Cells[1, 4])
  else
    ab.Right := 0;

  if PropEdit.Cells[1, 3] <> '' then ab.top := StrToInt(PropEdit.Cells[1, 3])
  else
    ab.Top := 0;

  if PropEdit.Cells[1, 5] <> '' then ab.bottom := StrToInt(PropEdit.Cells[1, 5])
  else
    ab.Bottom := 0;

  if PropEdit.Cells[1, 6] <> '' then
    ab.Fontcolor := StringToColor(PropEdit.Cells[1, 6])
  else
    ab.Fontcolor := clBlack;




  skn := Tinifile.Create(GetTempDir + 'skins.ini');
  //Extractfilepath(application.ExeName) + 'temp.ini');
  try
    skn.WriteString(PropEdit.Cells[1, 1], ab.cropname, croptostring(Ab));
  finally
    FreeAndNil(skn);
  end;
end;

procedure Tskinsbuildier.Button2Click(Sender: TObject);
begin
  if (Assigned(oncrop)) then
  begin
    writedata(oncrop);
    if GG <> nil then  // for form itemindex... 0 =form
      gg.Invalidate;
  end;
end;

procedure Tskinsbuildier.SpinEdit1Change(Sender: TObject);
begin
  infoedit.Cells[infoedit.Selection.Left, infoedit.Selection.Top] :=
    IntToStr(SpinEdit1.Value);
end;

procedure Tskinsbuildier.SpinEdit1Exit(Sender: TObject);
begin
  SpinEdit1.Visible := False;
end;

procedure Tskinsbuildier.ColorBox3Select(Sender: TObject);
begin
    infoedit.Cells[infoedit.Selection.Left, infoedit.Selection.Top] :=
    ColorToString(colorbox3.Selected);
//  Button2Click(self);
  colorbox3.Visible := False;
end;

procedure Tskinsbuildier.ColorBox2Select(Sender: TObject);
begin
   PropEdit.Cells[PropEdit.Selection.Left, PropEdit.Selection.Top] :=
    ColorToString(colorbox2.Selected);
//  Button2Click(self);
// colorbox2.Visible := False;
end;

procedure Tskinsbuildier.infoeditSelectCell(Sender: TObject;
  aCol, aRow: integer; var CanSelect: boolean);
var
  crect: TRect;
begin
  if (ACol = 1) and (aRow = 7) then
  begin
    SpinEdit1.Visible := False;
    crect := infoedit.CellRect(ACol, ARow);
    colorbox3.Top := infoedit.Top + crect.Top;
    colorbox3.Left := infoedit.Left + crect.Left;
    colorbox3.Width := crect.Right - crect.Left;
    colorbox3.ItemIndex := colorbox3.Items.IndexOf(infoedit.Cells[ACol, ARow]);
    colorbox3.Visible := True;
  end
  else
  if (ACol = 1) and (aRow = 8) then
  begin
    colorbox3.Visible := False;
    crect := infoedit.CellRect(ACol, ARow);
    SpinEdit1.Top := infoedit.Top + crect.Top;
    SpinEdit1.Left := infoedit.Left + crect.Left;
    SpinEdit1.Width := crect.Right - crect.Left;
    //SpinEdit1.Value := strtoint(infoedit.Cells[ACol,ARow]);
    SpinEdit1.Visible := True;
    infoedit.ItemProps['OPACITY'].ReadOnly := True;
  end
  else
  begin
    colorbox3.Visible := False;
    SpinEdit1.Visible := False;
  end;
end;

procedure Tskinsbuildier.infoeditStringsChange(Sender: TObject);
var
  a: integer;
begin

  if changeskininfo = True then
  begin
    ONImg1.Skinname  := infoedit.Cells[1, 1];
    ONImg1.author    := infoedit.Cells[1, 2];
    ONImg1.email     := infoedit.Cells[1, 3];
    ONImg1.homepage  := infoedit.Cells[1, 4];
    ONImg1.comment   := infoedit.Cells[1, 5];
    ONImg1.version   := infoedit.Cells[1, 6];
    ONImg1.MColor    := infoedit.Cells[1, 7];
    if (Length(infoedit.Cells[1, 8]) > 0) then
      ONImg1.Opacity := StrToInt(infoedit.Cells[1, 8]);

  end;
end;

procedure Tskinsbuildier.infoeditTopLeftChanged(Sender: TObject);
begin
  colorbox3.Visible := False;
  SpinEdit1.Visible := False;
end;



procedure Tskinsbuildier.PropEditSelectCell(Sender: TObject; aCol,
  aRow: Integer; var CanSelect: Boolean);
var
  crect: TRect;
begin
  if (ACol = 1) and (aRow = 6) then
  begin
   // Numberedit.Visible := False;
    crect := PropEdit.CellRect(ACol, ARow);
    colorbox2.Top := PropEdit.Top + crect.Top;
    colorbox2.Left := PropEdit.Left + crect.Left;
    colorbox2.Width := crect.Right - crect.Left;
    colorbox2.ItemIndex := colorbox2.Items.IndexOf(PropEdit.Cells[ACol, ARow]);
    colorbox2.Visible := True;
  end
  else
  {if (acol = 1) and ((aRow <> 1) and (aRow <> 6)) then
  begin
    colorbox2.Visible := False;
    crect := PropEdit.CellRect(ACol, ARow);
    Numberedit.Top := PropEdit.Top + crect.Top;
    Numberedit.Left := PropEdit.Left + crect.Left;
    Numberedit.Width := crect.Right - crect.Left;
    Numberedit.Text := PropEdit.Cells[ACol,ARow];
    Numberedit.Visible := True;
  end
  else }
  begin
    colorbox2.Visible := False;
  //  Numberedit.Visible := False;
  end;
  fselect:=arow;
end;

procedure Tskinsbuildier.PropEditKeyPress(Sender: TObject; var Key: char);
begin
 // if not (Key in [#8, '0'..'9']) then Key := #0;
  if fselect<> 1 then
  if not(Key IN ['0'..'9', #8, #9, #13, #27, #127]) then key:= #0;
end;

procedure Tskinsbuildier.PropEditStringsChange(Sender: TObject);
begin
  if (Assigned(oncrop)) and (notwriting=false) then
  begin
    writedata(oncrop);
    if GG <> nil then  // for form itemindex... 0 =form
      gg.Invalidate;
  end;
end;

procedure Tskinsbuildier.PropEditTopLeftChanged(Sender: TObject);
begin
  ColorBox2.Visible:=False;
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
  i, a: byte;
  rootNode, subnode: TTreeNode;

begin
  //FExpanded := [oleft, oright, otop, obottom, otopleft, otopright, obottomleft, obottomright, onormal, ohover, opress, odisable];
//  ONImg1.formactive(false);//
//  onimg1.Loadskin(ExtractFileDir(Application.ExeName)+'\darkskins.osf',false);
  aktif   := False;
  mainimg := TBGRABitmap.Create(mainpicture.Width, mainpicture.Height);
  temp    := TBGRABitmap.Create(mainpicture.Width, mainpicture.Height);
  cropimg := TBGRABitmap.Create(100, 100);
  mainimg.Assign(ONImg1.Fimage);
  mainpicture.RedrawBitmap;


  rootNode := TreeView1.Items.Add(nil, 'FORM');
  subnode := TreeView1.Items.AddChild(rootNode,'TOPLEFT');
  subnode := TreeView1.Items.AddChild(rootNode,'TOP');
  subnode := TreeView1.Items.AddChild(rootNode,'TOPRIGHT');
  subnode := TreeView1.Items.AddChild(rootNode,'BOTTOMLEFT');
  subnode := TreeView1.Items.AddChild(rootNode,'BOTTOM');
  subnode := TreeView1.Items.AddChild(rootNode,'BOTTOMRIGHT');
  subnode := TreeView1.Items.AddChild(rootNode,'LEFT');
  subnode := TreeView1.Items.AddChild(rootNode,'RIGHT');
  subnode := TreeView1.Items.AddChild(rootNode,'CENTER');


  rootNode := TreeView1.Items.Add(nil, 'CLOSE BUTTON');
  for i := 0 to closebut.Customcroplist.Count - 1 do
    subnode := TreeView1.Items.AddChild(rootNode,
      TONURCUSTOMCROP(closebut.Customcroplist[i]).cropname);

  rootNode := TreeView1.Items.Add(nil, 'MAX BUTTON');
  for i := 0 to maxbut.Customcroplist.Count - 1 do
    subnode := TreeView1.Items.AddChild(rootNode,
      TONURCUSTOMCROP(maxbut.Customcroplist[i]).cropname);

  rootNode := TreeView1.Items.Add(nil, 'TRAY BUTTON');
  for i := 0 to traybut.Customcroplist.Count - 1 do
    subnode := TreeView1.Items.AddChild(rootNode,
      TONURCUSTOMCROP(traybut.Customcroplist[i]).cropname);


  rootNode := TreeView1.Items.Add(nil, 'GRAPHIC BUTTON');
  for i := 0 to ongraphicsbutton1.Customcroplist.Count - 1 do
    subnode := TreeView1.Items.AddChild(rootNode,
      TONURCUSTOMCROP(ongraphicsbutton1.Customcroplist[i]).cropname);

  rootNode := TreeView1.Items.Add(nil, 'CROP BUTTON');
  for i := 0 to oncropbutton1.Customcroplist.Count - 1 do
    subnode := TreeView1.Items.AddChild(rootNode,
      TONURCUSTOMCROP(oncropbutton1.Customcroplist[i]).cropname);

  rootNode := TreeView1.Items.Add(nil, 'RADIO BUTTON');
  for i := 0 to onradiobutton1.Customcroplist.Count - 1 do
    subnode := TreeView1.Items.AddChild(rootNode,
      TONURCUSTOMCROP(onradiobutton1.Customcroplist[i]).cropname);

  rootNode := TreeView1.Items.Add(nil, 'CHECKBOX');
  for i := 0 to oncheckbox1.Customcroplist.Count - 1 do
    subnode := TreeView1.Items.AddChild(rootNode,
      TONURCUSTOMCROP(oncheckbox1.Customcroplist[i]).cropname);

  rootNode := TreeView1.Items.Add(nil, 'SWICH');
  for i := 0 to onswich1.Customcroplist.Count - 1 do
    subnode := TreeView1.Items.AddChild(rootNode,
      TONURCUSTOMCROP(onswich1.Customcroplist[i]).cropname);

  rootNode := TreeView1.Items.Add(nil, 'LED');
  for i := 0 to ONLed1.Customcroplist.Count - 1 do
    subnode := TreeView1.Items.AddChild(rootNode,
      TONURCUSTOMCROP(ONLed1.Customcroplist[i]).cropname);

  rootNode := TreeView1.Items.Add(nil, 'LABEL');
  for i := 0 to ONlabel1.Customcroplist.Count - 1 do
    subnode := TreeView1.Items.AddChild(rootNode,
      TONURCUSTOMCROP(ONlabel1.Customcroplist[i]).cropname);

  rootNode := TreeView1.Items.Add(nil, 'TRACKBAR_HORIZONTAL');
  for i := 0 to ontrackbar1.Customcroplist.Count - 1 do
    subnode := TreeView1.Items.AddChild(rootNode,
      TONURCUSTOMCROP(ontrackbar1.Customcroplist[i]).cropname);

  rootNode := TreeView1.Items.Add(nil, 'TRACKBAR_VERTICAL');
  for i := 0 to ontrackbar2.Customcroplist.Count - 1 do
    subnode := TreeView1.Items.AddChild(rootNode,
      TONURCUSTOMCROP(ontrackbar2.Customcroplist[i]).cropname);

  rootNode := TreeView1.Items.Add(nil, 'PROGRESSBAR_HORIZONTAL');
  for i := 0 to ONProgressBar1.Customcroplist.Count - 1 do
    subnode := TreeView1.Items.AddChild(rootNode,
      TONURCUSTOMCROP(ONProgressBar1.Customcroplist[i]).cropname);

  rootNode := TreeView1.Items.Add(nil, 'PROGRESSBAR_VERTICAL');
  for i := 0 to ONProgressBar2.Customcroplist.Count - 1 do
    subnode := TreeView1.Items.AddChild(rootNode,
      TONURCUSTOMCROP(ONProgressBar2.Customcroplist[i]).cropname);

  rootNode := TreeView1.Items.Add(nil, 'SCROLLBAR_HORIZONTAL');
  for i := 0 to oNScrollBar1.Customcroplist.Count - 1 do
    subnode := TreeView1.Items.AddChild(rootNode,
      TONURCUSTOMCROP(oNScrollBar1.Customcroplist[i]).cropname);

  rootNode := TreeView1.Items.Add(nil, 'SCROLLBAR_VERTICAL');
  for i := 0 to oNScrollBar2.Customcroplist.Count - 1 do
    subnode := TreeView1.Items.AddChild(rootNode,
      TONURCUSTOMCROP(oNScrollBar2.Customcroplist[i]).cropname);

  rootNode := TreeView1.Items.Add(nil, 'KNOB');
  for i := 0 to ONKnob1.Customcroplist.Count - 1 do
    subnode := TreeView1.Items.AddChild(rootNode,
      TONURCUSTOMCROP(ONKnob1.Customcroplist[i]).cropname);

  rootNode := TreeView1.Items.Add(nil, 'PANEL');
  for i := 0 to ONPanel1.Customcroplist.Count - 1 do
    subnode := TreeView1.Items.AddChild(rootNode,
      TONURCUSTOMCROP(ONPanel1.Customcroplist[i]).cropname);

  rootNode := TreeView1.Items.Add(nil, 'GRAPHICSPANEL');
  for i := 0 to ONGraphicPanel1.Customcroplist.Count - 1 do
    subnode := TreeView1.Items.AddChild(rootNode,
      TONURCUSTOMCROP(ONGraphicPanel1.Customcroplist[i]).cropname);

  rootNode := TreeView1.Items.Add(nil, 'HEADERPANEL');
  for i := 0 to onheaderpanel1.Customcroplist.Count - 1 do
    subnode := TreeView1.Items.AddChild(rootNode,
      TONURCUSTOMCROP(onheaderpanel1.Customcroplist[i]).cropname);

  rootNode := TreeView1.Items.Add(nil, 'COLLAPSEDPANEL');
  for i := 0 to ONColExpPanel1.Customcroplist.Count - 1 do
    subnode := TreeView1.Items.AddChild(rootNode,
      TONURCUSTOMCROP(ONColExpPanel1.Customcroplist[i]).cropname);

  rootNode := TreeView1.Items.Add(nil, 'CONTENT SLIDER');
  for i := 0 to ONURContentSlider1.Customcroplist.Count - 1 do
    subnode := TreeView1.Items.AddChild(rootNode,
      TONURCUSTOMCROP(ONURContentSlider1.Customcroplist[i]).cropname);





  rootNode := TreeView1.Items.Add(nil, 'STRINGGRID');
  for i := 0 to ONURStringGrid1.Customcroplist.Count - 1 do
    subnode := TreeView1.Items.AddChild(rootNode,
      TONURCUSTOMCROP(ONURStringGrid1.Customcroplist[i]).cropname);


  rootNode := TreeView1.Items.Add(nil, 'LISTBOX');
  for i := 0 to oNListBox1.Customcroplist.Count - 1 do
    subnode := TreeView1.Items.AddChild(rootNode,
      TONURCUSTOMCROP(oNListBox1.Customcroplist[i]).cropname);

  rootNode := TreeView1.Items.Add(nil, 'COLUMNLIST');
  for i := 0 to Oncolumlist1.Customcroplist.Count - 1 do
    subnode := TreeView1.Items.AddChild(rootNode,
      TONURCUSTOMCROP(Oncolumlist1.Customcroplist[i]).cropname);

  rootNode := TreeView1.Items.Add(nil, 'COMBOBOX');
  for i := 0 to ONcombobox1.Customcroplist.Count - 1 do
    subnode := TreeView1.Items.AddChild(rootNode,
      TONURCUSTOMCROP(ONcombobox1.Customcroplist[i]).cropname);

  rootNode := TreeView1.Items.Add(nil, 'EDIT');
  for i := 0 to onEdit1.Customcroplist.Count - 1 do
    subnode := TreeView1.Items.AddChild(rootNode,
      TONURCUSTOMCROP(onEdit1.Customcroplist[i]).cropname);

  rootNode := TreeView1.Items.Add(nil, 'MEMO');
  for i := 0 to ONMemo1.Customcroplist.Count - 1 do
    subnode := TreeView1.Items.AddChild(rootNode,
      TONURCUSTOMCROP(ONMemo1.Customcroplist[i]).cropname);

  rootNode := TreeView1.Items.Add(nil, 'SPINEDIT');
  for i := 0 to OnSpinEdit1.Customcroplist.Count - 1 do
    subnode := TreeView1.Items.AddChild(rootNode,
      TONURCUSTOMCROP(OnSpinEdit1.Customcroplist[i]).cropname);

  rootNode := TreeView1.Items.Add(nil, 'PAGECONTROL');
  for i := 0 to ONPageControl1.Customcroplist.Count - 1 do
    subnode := TreeView1.Items.AddChild(rootNode,
      TONURCUSTOMCROP(ONPageControl1.Customcroplist[i]).cropname);

  rootNode := TreeView1.Items.Add(nil, 'PAGECONTROL BUTTONAREA');
  for i := 0 to ONPageControl1.btnarea.Customcroplist.Count - 1 do
    subnode := TreeView1.Items.AddChild(rootNode,
      TONURCUSTOMCROP(ONPageControl1.btnarea.Customcroplist[i]).cropname);

  rootNode := TreeView1.Items.Add(nil, 'PAGE');
  for i := 0 to ONPageControl1.Pages[1].Customcroplist.Count - 1 do
    subnode := TreeView1.Items.AddChild(rootNode,
      TONURCUSTOMCROP(ONPageControl1.Pages[1].Customcroplist[i]).cropname);

  rootNode := TreeView1.Items.Add(nil, 'PAGE BUTTON');
  for i := 0 to ONPageControl1.Pages[1].Fbutton.Customcroplist.Count - 1 do
    subnode := TreeView1.Items.AddChild(rootNode,
      TONURCUSTOMCROP(ONPageControl1.Pages[1].Fbutton.Customcroplist[i]).cropname);



  objlist := TList.Create;
  objlist.Add(skinsbuildier);
  objlist.Add(closebut);
  objlist.Add(maxbut);
  objlist.Add(traybut);

  objlist.add(ongraphicsbutton1);
  objlist.add(oncropbutton1);
  objlist.add(onradiobutton1);
  objlist.add(oncheckbox1);
  objlist.add(onswich1);
  objlist.add(ONLed1);
  objlist.add(ONlabel1);
  objlist.add(ontrackbar1);
  objlist.add(ontrackbar2);
  objlist.add(ONProgressBar1);
  objlist.add(ONProgressBar2);
  objlist.add(oNScrollBar1);
  objlist.add(oNScrollBar2);
  objlist.add(ONKnob1);

  objlist.add(ONPanel1);
  objlist.add(ONGraphicPanel1);
  objlist.add(onheaderpanel1);
  objlist.add(ONColExpPanel1);
  objlist.add(ONURContentSlider1);

  objlist.add(ONURStringGrid1);

  objlist.add(oNListBox1);
  objlist.add(Oncolumlist1);

  objlist.add(ONcombobox1);
  objlist.add(onEdit1);
  objlist.add(ONMemo1);
  objlist.add(OnSpinEdit1);

  objlist.add(ONPageControl1);
  objlist.add(ONPageControl1.btnarea);
  objlist.add(ONPageControl1.Pages[1]);
  objlist.add(ONPageControl1.Pages[1].Fbutton);



  for i := 0 to 4 do
    for a := 0 to 200 do
    begin
    //  Oncolumlist1.Items.Add;
      Oncolumlist1.Cells[i,a]:='TEST '+inttostr(i)+' -X- '+inttostr(a);//Items[a].Cells[i] := 'TEST ' + i.ToString + ' X ' + a.ToString;
      ONURStringGrid1.Cells[i,a]:='TEST '+inttostr(i)+' -X- '+inttostr(a);
    end;



end;






procedure Tskinsbuildier.Updatefrm;
begin
 { case RadioGroup1.ItemIndex of
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
  }
end;




procedure Tskinsbuildier.zoomTimerTimer;
var
  srcRect, fmrRect: TRect;
  oo: integer;
  img: TBGRACustomBitmap;
begin
  fmrRect := Rect(mainpicture.Left, mainpicture.Top, mainpicture.Left +
    mainpicture.Width, mainpicture.Top + mainpicture.Height);

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

end;      //434 443 t 6 228     c 422 426 12 215  b 420 422 9 215   t 426 429 15 217

procedure Tskinsbuildier.trackbar1change(Sender: TObject);
begin
  zoomTimerTimer;
end;


procedure Tskinsbuildier.TreeView1Change(Sender: TObject; Node: TTreeNode);
var
  s: string;
  i:integer;
begin

  if TreeView1.Selected.Level = 0 then
  begin
    gg := nil;
    PropEdit.Clear;
    for i:=0 to ComponentCount-1 do
    begin
     if (Components[i] is TONURCustomControl) or (Components[i] is TONURGraphicControl) then
     Tcontrol(Components[i]).visible:=false;
    end;

    gg := Tcontrol(objlist[TreeView1.Selected.Index]);
    gg.Visible := True;
   { ONGraphicsButton1.Visible := False;
    ONCropButton1.Visible := False;
    ONPanel1.Visible := False;
    onheaderpanel1.Visible := False;
    onEdit1.Visible := False;
    OnSpinEdit1.Visible := False;
    ONcombobox1.Visible := False;
    oNListBox1.Visible := False;
    ONMemo1.Visible := False;
    oNScrollBar1.Visible := False;
    oNScrollBar2.Visible := False;
    onswich1.Visible := False;
    oncheckbox1.Visible := False;
    onradiobutton1.Visible := False;
    onprogressbar1.Visible := False;
    onprogressbar2.Visible := False;
    ontrackbar1.Visible := False;
    ontrackbar2.Visible := False;
    ONColExpPanel1.Visible := False;
    Oncolumlist1.Visible := False;
    ONlabel1.Visible := False;
    ONLed1.Visible := False;
    ONPageControl1.Visible := False;
    ONKnob1.Visible := False;
    maxbut.Visible:=false;
    traybut.Visible:=false;
    closebut.Visible:=false;
    ONURStringGrid1.Visible:=false;
    ONURContentSlider1.Visible:=false; }

  end
  else
  begin
    if gg <> nil then
    begin
      s := '';
      if  gg is TForm then
      begin
       oncrop := TONURCUSTOMCROP(ONImg1.Customcroplist[TreeView1.Selected.Index]);
        s := 'form';
      end
      else
      begin
        if gg is TONURGraphicControl then
        begin
          oncrop := TONURCUSTOMCROP(TONURGraphicControl(
            gg).Customcroplist[TreeView1.Selected.Index]);
          s := TONURGraphicControl(gg).Skinname;
        end
        else
        if gg is TONURCustomControl then
        begin
          oncrop := TONURCUSTOMCROP(TONURCustomControl(gg).Customcroplist[TreeView1.Selected.Index]);
          s := TONURCustomControl(gg).Skinname;
        end;
      end;

      notwriting:=true;
      PropEdit.Keys[1] := 'SKINNAME';
      // PropEdit.Keys[2]:='NAME';
      PropEdit.Keys[2] := 'LEFT';
      PropEdit.Keys[3] := 'TOP';
      PropEdit.Keys[4] := 'RIGHT';
      PropEdit.Keys[5] := 'BOTTOM';
      PropEdit.Keys[6] := 'FONTCOLOR';
      PropEdit.Cells[1, 1] := s;
      PropEdit.Cells[1, 2] := IntToStr(oncrop.Left);
      PropEdit.Cells[1, 3] := IntToStr(oncrop.top);
      PropEdit.Cells[1, 4] := IntToStr(oncrop.Right);
      PropEdit.Cells[1, 5] := IntToStr(oncrop.Bottom);

   { with PropEdit.ItemProps['FONTCOLOR'] do
    begin
      PickList.Clear;
      KeyDesc := 'Select Color';
      EditStyle := esPickList;
      ReadOnly := True;
      PickList.Assign(ColorBox2.Items);
    end;  }
      PropEdit.Cells[1, 6] := ColorToString(oncrop.Fontcolor);
      rectlange.left := oncrop.Left;
      rectlange.Right := oncrop.Right;
      rectlange.top := oncrop.top;
      rectlange.bottom := oncrop.bottom;
      mainpicture.RedrawBitmap;
      notwriting:=false;
    end;
  end;
end;

procedure Tskinsbuildier.mainpictureredraw(Sender: TObject; bitmap: tbgrabitmap);
begin
  temp.SetSize(0, 0);
  temp.SetSize(mainimg.Width, mainimg.Height);
  temp.PutImage(0, 0, mainimg, dmSet);
  temp.Canvas.Brush.Style := bsClear;
  temp.Canvas.Pen.Style := psDash;
  temp.Canvas.Pen.Color := clRed;
  temp.Canvas.Pen.Width := 1;
  temp.Canvas.Rectangle(rectlange);
  bitmap.PutImage(0, 0, temp, dmLinearBlend, 200);
end;



procedure Tskinsbuildier.ONGraphicsButton2Click(Sender: TObject);
begin
  if opd.Execute then
  begin
    //image1.Picture.LoadFromFile(opd.FileName);
    mainimg.LoadFromFile(opd.FileName);
    ONImg1.Picture.LoadFromFile(opd.FileName);
    mainpicture.RedrawBitmap;
  end;
end;

procedure Tskinsbuildier.ONGraphicsButton3Click(Sender: TObject);
begin
  if odf.Execute then
  begin
    ONImg1.Loadskin(odf.FileName, False);
    changeskininfo := False;
    infoedit.Cells[1, 1] := ONImg1.Skinname;
    infoedit.Cells[1, 2] := ONImg1.author;
    infoedit.Cells[1, 3] := ONImg1.email;
    infoedit.Cells[1, 4] := ONImg1.homepage;
    infoedit.Cells[1, 5] := ONImg1.comment;
    infoedit.Cells[1, 6] := ONImg1.version;
    infoedit.Cells[1, 7] := ONImg1.MColor;
    infoedit.Cells[1, 8] := IntToStr(ONImg1.Opacity);
    changeskininfo := True;
    mainimg.Assign(ONImg1.Fimage);
    mainpicture.RedrawBitmap;
    Repaint;
  end;
end;

procedure Tskinsbuildier.ONGraphicsButton4Click(Sender: TObject);
begin
  if sdf.Execute then
  begin
    //  ONImg1.Readskinsfile(Extractfilepath(application.ExeName) + 'temp.ini');
    ONImg1.saveskin(sdf.FileName);
  end;
end;

procedure Tskinsbuildier.ONGraphicsButton5Click(Sender: TObject);
begin
  Close;
end;

procedure Tskinsbuildier.ONHeaderPanel2MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: integer);
begin
  ReleaseCapture;
  SendMessage(self.Handle, WM_SYSCOMMAND, $F012, 0);
end;

procedure Tskinsbuildier.ONlabel1Click(Sender: TObject);
begin
  ONlabel1.Active := not ONlabel1.Active;
end;

procedure Tskinsbuildier.ONLed1Click(Sender: TObject);
begin
  onled1.LedOn := not onled1.LedOn;
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
    [PointF(Xshift, Yshift - 20), PointF(Xshift, Yshift + 20),
    PointF(Xshift, Yshift), PointF(Xshift - 20, Yshift),
    PointF(Xshift + 20, Yshift)], c, 2);

  bitmap.PutImage(0, 0, cropimg, dmLinearBlend{dmDrawWithTransparency}, 255);
end;

procedure Tskinsbuildier.mainpicturemousedown(Sender: TObject;
  button: tmousebutton; shift: tshiftstate; x, y: integer);
begin
  if (button = mbleft) then
  begin
    rectlange.left := x;
    rectlange.Top := y;
    aktif := True;
  end;
end;

procedure Tskinsbuildier.mainpicturemousemove(Sender: TObject;
  shift: tshiftstate; x, y: integer);
begin
  curPos := Point(x, y);
  label6.Caption := 'X= ' + IntToStr(x) + ' --  Y=' + IntToStr(y);

  if (aktif) then
  begin
    rectlange.Right := x;
    rectlange.Bottom := y;
    mainpicture.RedrawBitmap;
  end;

  zoomTimerTimer;
end;

procedure Tskinsbuildier.mainpicturemouseup(Sender: TObject;
  button: tmousebutton; shift: tshiftstate; x, y: integer);
begin
  aktif := False;
  rectlange.Right := x;
  rectlange.Bottom := y;
  mainpicture.RedrawBitmap;
  PropEdit.Cells[1, 2] := IntToStr(rectlange.Left);
  PropEdit.Cells[1, 3] := IntToStr(rectlange.top);
  PropEdit.Cells[1, 4] := IntToStr(rectlange.Right);
  PropEdit.Cells[1, 5] := IntToStr(rectlange.bottom);

  //if list.Row>0 then
  //UpdateOcustomControlu(gg, rectlange);
end;



end.

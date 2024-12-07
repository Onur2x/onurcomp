unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Windows,Classes,SysUtils,Forms,Controls,Graphics,
  Dialogs,ExtCtrls,StdCtrls,ExtDlgs,onurctrl,onurbutton,
  onurbar,onuredit,onurpanel,onurlist,onurpage,onurmenu,BGRABitmap,BGRABitmapTypes,
  ColorBox,ComCtrls,Spin,ValEdit,inifiles,Types,Grids;

type

  TOnurScreen = class(TGraphicControl)
  private
   fbitmap   : TBGRABitmap;
   FOnChange : TNotifyEvent;
  public
   constructor Create(Aowner: TComponent); override;
   destructor Destroy; override;
   procedure paint; override;
   procedure PutImage(x,y:integer;a:Tbgrabitmap);
   procedure MouseDown(Button:TMouseButton;Shift:TShiftState;X,Y:Integer);override;
   procedure MouseMove(Shift:TShiftState;X,Y:Integer);override;
   procedure MouseUp(Button:TMouseButton;Shift:TShiftState;X,Y:Integer);override;
   property  Bitmap:TBGRABitmap read fbitmap;
  published
   property Onchange: TNotifyEvent read FOnChange write FOnChange;
  end;

  TOnurZoomScreen = class(TGraphicControl)
  private
   fbitmap   : TBGRABitmap;
   FOnChange : TNotifyEvent;
  public
   constructor Create(Aowner: TComponent); override;
   destructor Destroy; override;
   procedure paint; override;
   procedure PutImage(x,y:integer;a:Tbgrabitmap);
   procedure MouseDown(Button:TMouseButton;Shift:TShiftState;X,Y:Integer);override;
   procedure MouseMove(Shift:TShiftState;X,Y:Integer);override;
   procedure MouseUp(Button:TMouseButton;Shift:TShiftState;X,Y:Integer);override;
  published
   property Onchange: TNotifyEvent read FOnChange write FOnChange;
  end;
  { Tskinsbuildier }

  Tskinsbuildier = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6:TButton;
    Button7:TButton;
    OnurCheckListBox1:TOnurCheckListBox;
    ONURMainMenu1:TONURMainMenu;
    ONURNavButton1: TONURNavButton;
    ONURNavButton2: TONURNavButton;
    ONURNavMenuButton1: TONURNavMenuButton;
    ONURPopupMenu1:TONURPopupMenu;
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
    procedure Button6Click(Sender:TObject);
    procedure Button7Click(Sender:TObject);
    procedure ColorBox2Select(Sender: TObject);
    procedure ColorBox3Select(Sender: TObject);
    procedure formclose(Sender: TObject; var closeaction: tcloseaction);
    procedure formcreate(Sender: TObject);
    procedure FormShow(Sender:TObject);
    procedure ONProgressBar1MouseDown(Sender:TObject;Button:TMouseButton;Shift:
      TShiftState;X,Y:Integer);
    procedure ONProgressBar1MouseMove(Sender:TObject;Shift:TShiftState;X,Y:
      Integer);
    procedure ONProgressBar1MouseUp(Sender:TObject;Button:TMouseButton;Shift:
      TShiftState;X,Y:Integer);
    procedure PropEditSelectCell(Sender: TObject; aCol, aRow: Integer;
      var CanSelect: Boolean);
    procedure infoeditSelectCell(Sender: TObject; aCol, aRow: integer;
      var CanSelect: boolean);
    procedure infoeditStringsChange(Sender: TObject);
    procedure infoeditTopLeftChanged(Sender: TObject);
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
    procedure TreeView1Click(Sender:TObject);
  private
    procedure readdata(Ab: TONURCustomCrop);
    procedure writedata(Ab: TONURCUSTOMCROP);
    procedure zoomtimertimer;
  public
    objlist: TList;
    gg: Tcontrol;
    oncrop: TONURCUSTOMCROP;

  end;




var
  skinsbuildier: Tskinsbuildier;
  aktif, changeskininfo,
  progressok : boolean;
  rectlange: Trect;
  mainimg, cropimg: TBGRABitmap;
  curPos: TPoint;
  skn: TIniFile;
  fselect : integer; // for propedit selected row
  notwriting:boolean; // for propedit save

  mainscren:TOnurScreen;
  zoomx:TOnurZoomScreen;


implementation

uses Variants,test,math;//,lazutf8;

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
      Crp.Croprect.LEFT           := StrToIntDef(myst.Strings[0], 2);
      Crp.Croprect.TOP            := StrToIntDef(myst.Strings[1], 2);
      Crp.Croprect.RIGHT          := StrToIntDef(myst.Strings[2], 4);
      Crp.Croprect.BOTTOM         := StrToIntDef(myst.Strings[3], 4);
    //  Crp.Croprect       := Rect(StrToIntDef(myst.Strings[0], 2),StrToIntDef(myst.Strings[1], 4),StrToIntDef(myst.Strings[2], 4),StrToIntDef(myst.Strings[3], 4));

      if Crp.Croprect.IsEmpty then
      Crp.Croprect       := Rect(0,0,1,1);

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


  PropEdit.Cells[1, 2] := IntToStr(ab.Croprect.Left);
  PropEdit.Cells[1, 3] := IntToStr(ab.Croprect.top);
  PropEdit.Cells[1, 4] := IntToStr(ab.Croprect.Right);
  PropEdit.Cells[1, 5] := IntToStr(ab.Croprect.Bottom);
  ColorBox2.Selected   := ab.Fontcolor;
  rectlange.left       := ab.Croprect.Left;
  rectlange.Right      := ab.Croprect.Right;
  rectlange.top        := ab.Croprect.top;
  rectlange.bottom     := ab.Croprect.bottom; //mainpicture.DiscardBitmap;
  mainscren.PutImage(0,0,mainimg);
end;

function croptostring(Crp: TONURCUSTOMCROP): string;
begin
  Result := '';
  if Crp <> nil then
 {   Result := IntToStr(Crp.LEFT) + ',' + IntToStr(Crp.TOP) + ',' +
      IntToStr(Crp.RIGHT) + ',' + IntToStr(Crp.BOTTOM) + ',' +
      ColorToString(Crp.Fontcolor); }

   Result := IntToStr(Crp.Croprect.LEFT) + ',' + IntToStr(Crp.Croprect.TOP) + ',' +
      IntToStr(Crp.Croprect.RIGHT) + ',' + IntToStr(Crp.Croprect.BOTTOM) + ',' +
      ColorToString(Crp.Fontcolor);
end;

procedure Tskinsbuildier.writedata(Ab: TONURCUSTOMCROP);
begin
  if PropEdit.Cells[1, 2] <> '' then ab.Croprect.Left   := StrToInt(PropEdit.Cells[1, 2])
  else
    ab.Croprect.left := 0;

  if PropEdit.Cells[1, 4] <> '' then ab.Croprect.Right  := StrToInt(PropEdit.Cells[1, 4])
  else
    ab.Croprect.Right := 0;

  if PropEdit.Cells[1, 3] <> '' then ab.Croprect.top    := StrToInt(PropEdit.Cells[1, 3])
  else
    ab.Croprect.Top := 0;

  if PropEdit.Cells[1, 5] <> '' then ab.Croprect.bottom := StrToInt(PropEdit.Cells[1, 5])
  else
    ab.Croprect.Bottom := 0;

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






procedure Tskinsbuildier.Button6Click(Sender:TObject);
begin
testfrm :=Ttestfrm.Create(self);
//  testfrm.Parent:=Formpanel;
  testfrm.ShowModal;
end;

procedure Tskinsbuildier.Button7Click(Sender:TObject);
var
  i:Integer;
begin
for i:=0 to 350 do
oNListBox1.items.add('ITEMS '+inttostr(i));
end;

procedure Tskinsbuildier.SpinEdit1Change(Sender: TObject);
begin
//  infoedit.Cells[infoedit.Selection.Left, infoedit.Selection.Top] :=  IntToStr(SpinEdit1.Value);
infoedit.Cells[1,8]:=IntToStr(SpinEdit1.Value);
end;

procedure Tskinsbuildier.SpinEdit1Exit(Sender: TObject);
begin
  SpinEdit1.Visible := False;
end;

procedure Tskinsbuildier.ColorBox3Select(Sender: TObject);
begin
//    infoedit.Cells[infoedit.Selection.Left, infoedit.Selection.Top] :=
 //   ColorToString(colorbox3.Selected);
//  Button2Click(self);
 // colorbox3.Visible := False;

   //   infoedit.Cells[infoedit.Selection.Left, infoedit.Selection.Top] :=
//    ColorToString(colorbox3.Selected);
//  Button2Click(self);
  infoedit.Cells[1,7]:= ColorToString(colorbox3.Selected);
  colorbox3.Visible := False;
end;

procedure Tskinsbuildier.ColorBox2Select(Sender: TObject);
begin
   PropEdit.Cells[1,6]:=  ColorToString(colorbox2.Selected);
  // PropEdit.Cells[PropEdit.Selection.Left, PropEdit.Selection.Top] := ColorToString(colorbox2.Selected);
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
    if Length(infoedit.Cells[1,8])>0 then
    SpinEdit1.Value := strtoint(infoedit.Cells[1,8]);
    SpinEdit1.Visible := True;
    //infoedit.ItemProps['OPACITY'].ReadOnly := True;
    //infoedit.ItemProps[8].ReadOnly:=true;
    //SpinEdit1.Value := strtoint(infoedit.Cells[ACol,ARow]);
  end
  else
  begin
    colorbox3.Visible := False;
    SpinEdit1.Visible := False;
  end;
end;

procedure Tskinsbuildier.infoeditStringsChange(Sender: TObject);
//var
//  a: integer;
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
  FreeAndNil(zoomx);
  FreeAndNil(mainscren);

  //  writeskin;
  FreeAndNil(mainimg);
//  FreeAndNil(tempimg);
  FreeAndNil(cropimg);

end;

procedure Tskinsbuildier.formcreate(Sender: TObject);
begin
  ONImg1.formactive(false);
  aktif            := False;
  mainimg          := TBGRABitmap.Create(1920, 1080);
  cropimg          := TBGRABitmap.Create(10, 10);

  mainscren        := TOnurScreen.Create(self);
  mainscren.Parent := ScrollBox1;
  mainscren.Left   := 0;
  mainscren.Top    := 0;
  mainscren.Width  := 1920;
  mainscren.Height := 1080;
  mainscren.Cursor := crCross;

  zoomx            := TOnurZoomScreen.create(self);
  zoomx.parent     := Panel3;
  zoomx.Width      := 250;
  zoomx.Height     := 250;
  zoomx.Align      := alBottom;


end;

procedure Tskinsbuildier.FormShow(Sender:TObject);
var
  i, a: byte;
  rootNode, subnode: TTreeNode;
begin



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

  rootNode := TreeView1.Items.Add(nil, 'CHECKLISTBOX');
  for i := 0 to OnurCheckListBox1.Customcroplist.Count - 1 do
    subnode := TreeView1.Items.AddChild(rootNode,
      TONURCUSTOMCROP(OnurCheckListBox1.Customcroplist[i]).cropname);


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
  begin
    for i := 0 to ONPageControl1.Customcroplist.Count - 1 do
      subnode := TreeView1.Items.AddChild(rootNode,
        TONURCUSTOMCROP(ONPageControl1.Customcroplist[i]).cropname);

  {  rootNode := TreeView1.Items.Add(nil, 'PAGECONTROL BUTTONAREA');
    for i := 0 to ONPageControl1.btnarea.Customcroplist.Count - 1 do
      subnode := TreeView1.Items.AddChild(rootNode,
        TONURCUSTOMCROP(ONPageControl1.btnarea.Customcroplist[i]).cropname);

    rootNode := TreeView1.Items.Add(nil, 'PAGE');
    for i := 0 to ONPageControl1.Pages[0].Customcroplist.Count - 1 do
      subnode := TreeView1.Items.AddChild(rootNode,
        TONURCUSTOMCROP(ONPageControl1.Pages[1].Customcroplist[i]).cropname);

    rootNode := TreeView1.Items.Add(nil, 'PAGE BUTTON');
    for i := 0 to ONPageControl1.Pages[0].Fbutton.Customcroplist.Count - 1 do
      subnode := TreeView1.Items.AddChild(rootNode,
        TONURCUSTOMCROP(ONPageControl1.Pages[1].Fbutton.Customcroplist[i]).cropname);
  }
  end;
  rootNode := TreeView1.Items.Add(nil, 'NAV MENU');
  for i := 0 to ONURNavMenuButton1.Customcroplist.Count - 1 do
     subnode := TreeView1.Items.AddChild(rootNode,
      TONURCUSTOMCROP(ONURNavMenuButton1.Customcroplist[i]).cropname);

  rootNode := TreeView1.Items.Add(nil, 'POPUP MENU');
  for i := 0 to ONURPopupMenu1.Customcroplist.Count - 1 do
     subnode := TreeView1.Items.AddChild(rootNode,
      TONURCUSTOMCROP(ONURPopupMenu1.Customcroplist[i]).cropname);

  rootNode := TreeView1.Items.Add(nil, 'MAİN MENU');
  for i := 0 to ONURMainMenu1.Customcroplist.Count - 1 do
     subnode := TreeView1.Items.AddChild(rootNode,
      TONURCUSTOMCROP(ONURMainMenu1.Customcroplist[i]).cropname);
{ rootNode := TreeView1.Items.Add(nil, 'NAV BUTTON');
  for i := 0 to ONURNavMenuButton1.Buttons[0].Customcroplist.count-1 do//ONURNavButton1.Customcroplist.Count - 1 do
    subnode := TreeView1.Items.AddChild(rootNode,
      TONURCUSTOMCROP(ONURNavMenuButton1.Buttons[0].Customcroplist[i]).cropname);
  }
  rootNode := TreeView1.Items.Add(nil, ' ');
  rootNode := TreeView1.Items.Add(nil, ' ');
  rootNode := TreeView1.Items.Add(nil, ' ');
  rootNode := TreeView1.Items.Add(nil, ' ');
  rootNode := TreeView1.Items.Add(nil, ' ');
  rootNode := TreeView1.Items.Add(nil, ' ');


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
  objlist.add(OnurCheckListBox1);

  objlist.add(ONcombobox1);
  objlist.add(onEdit1);
  objlist.add(ONMemo1);
  objlist.add(OnSpinEdit1);

  objlist.add(ONPageControl1);
//  objlist.add(ONPageControl1.btnarea);
//  objlist.add(ONPageControl1.Pages[1]);
//  objlist.add(ONPageControl1.Pages[1].Fbutton);

  objlist.add(ONURNavMenuButton1);
//  objlist.add(ONURNavMenuButton1.Buttons[0]);
  objlist.add(ONURPopupMenu1);
  objlist.add(ONURMainMenu1);






  for i := 0 to 4 do
  for a := 0 to 200 do
  begin
  //  Oncolumlist1.Items.Add;
    Oncolumlist1.Cells[i,a]:='TEST '+inttostr(i)+' -X- '+inttostr(a);//Items[a].Cells[i] := 'TEST ' + i.ToString + ' X ' + a.ToString;
    ONURStringGrid1.Cells[i,a]:='TEST '+inttostr(i)+' -X- '+inttostr(a);

  end;

  for i := 0 to 200 do
  begin
    OnListBox1.items.add('TEST '+inttostr(i));
    OnurCheckListBox1.items.add('TEST '+inttostr(i));
  end;


  ONURStringGrid1.ColWidths[0]:=150;
  ONURStringGrid1.ColWidths[1]:=50;
  ONURStringGrid1.ColWidths[2]:=100;
  ONURStringGrid1.ColWidths[3]:=250;
  mainimg.Assign(ONImg1.Fimage);
//  mainpicture.DiscardBitmap;
  mainscren.PutImage(0,0,mainimg);


  {
  for i:=0 to self.ComponentCount-1 do
  begin
     if (Components[i] is TONURCustomControl)  then
      TONURCustomControl(Components[i]).Skindata:=testfrm.ONImg1
     else
     if (Components[i] is TONURGraphicControl) then
      TONURGraphicControl(Components[i]).Skindata:=testfrm.ONImg1;
  end;
 }
end;

procedure Tskinsbuildier.ONProgressBar1MouseDown(Sender:TObject;Button:
  TMouseButton;Shift:TShiftState;X,Y:Integer);
begin
  progressok:=true;
end;

procedure Tskinsbuildier.ONProgressBar1MouseMove(Sender:TObject;Shift:
  TShiftState;X,Y:Integer);
begin
if progressok=true then
  begin
    if TONURProgressBar(sender).Kind=oHorizontal then
     TONURProgressBar(sender).Position:=abs(x-TONURProgressBar(sender).Width)
    else
     TONURProgressBar(sender).Position:=abs(y-TONURProgressBar(sender).Height);
  end;
end;

procedure Tskinsbuildier.ONProgressBar1MouseUp(Sender:TObject;Button:
  TMouseButton;Shift:TShiftState;X,Y:Integer);
begin
  progressok:=false;
end;

procedure Tskinsbuildier.trackbar1change(Sender: TObject);
begin
  zoomTimerTimer;
end;


procedure Tskinsbuildier.TreeView1Change(Sender: TObject; Node: TTreeNode);
var
  s: string;
  i:integer;
  y:TObject;
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

    if (TObject(objlist[TreeView1.Selected.Index]).ClassName<>'TONURMainMenu') and (TObject(objlist[TreeView1.Selected.Index]).ClassName<>'TONURPopupMenu') then
    begin
     gg := Tcontrol(objlist[TreeView1.Selected.Index]);
     gg.Visible := True;
    end else
    begin
    /// y:=TObject(objlist[TreeView1.Selected.Index]);
    // gg:=Tcontrol(y as TONURMainMenu);
   //  ShowMessage('OK');
    end;

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
        end else
        begin
          if gg is TONURCustomControl then
          begin
            oncrop := TONURCUSTOMCROP(TONURCustomControl(gg).Customcroplist[TreeView1.Selected.Index]);
            s := TONURCustomControl(gg).Skinname;
          end;
        end;

        if gg is TONURNavMenuButton then
        begin
          ONURNavButton1.Visible:=true;
          ONURNavButton2.Visible:=true;
        end;

        if gg is TONURPageControl then
        begin
          ONPage1.Visible:=true;
          ONPage2.Visible:=true;
        end;
      end;



      notwriting           := true;
      PropEdit.Keys[1]     := 'SKINNAME';
      // PropEdit.Keys[2]:='NAME';
      PropEdit.Keys[2]     := 'LEFT';
      PropEdit.Keys[3]     := 'TOP';
      PropEdit.Keys[4]     := 'RIGHT';
      PropEdit.Keys[5]     := 'BOTTOM';
      PropEdit.Keys[6]     := 'FONTCOLOR';
      PropEdit.Cells[1, 1] := s;


      if oncrop.Croprect.Left>0 then
      PropEdit.Cells[1, 2] := IntToStr(oncrop.Croprect.Left)
      else
      PropEdit.Cells[1, 2] := '0';

       if oncrop.Croprect.top>0 then
      PropEdit.Cells[1, 3] := IntToStr(oncrop.Croprect.top)
      else
      PropEdit.Cells[1, 3] := '0';

       if oncrop.Croprect.Right>0 then
      PropEdit.Cells[1, 4] := IntToStr(oncrop.Croprect.Right)
      else
      PropEdit.Cells[1, 4] := '0';

      if oncrop.Croprect.Bottom>0 then
      PropEdit.Cells[1, 5] := IntToStr(oncrop.Croprect.Bottom)
      else
      PropEdit.Cells[1, 5] := '0';

      if ColorToString(oncrop.Fontcolor)<>'clnone' then
      PropEdit.Cells[1, 6] := ColorToString(oncrop.Fontcolor)
      else
      PropEdit.Cells[1, 5] := 'clnone';

      rectlange := oncrop.Croprect;
      //mainpicture.DiscardBitmap;//RedrawBitmap;
      mainscren.PutImage(0,0,mainimg);
      notwriting           := false;
    end else
    begin


    end;

  end;
end;

procedure Tskinsbuildier.TreeView1Click(Sender:TObject);
begin
 TreeView1Change(sender,TreeView1.Selected);
end;




procedure Tskinsbuildier.ONGraphicsButton2Click(Sender: TObject);
begin
  if opd.Execute then
  begin
    //image1.Picture.LoadFromFile(opd.FileName);
    mainimg.LoadFromFile(opd.FileName);
    ONImg1.Picture.LoadFromFile(opd.FileName);
    mainscren.PutImage(0,0,mainimg);
  end;
end;

procedure Tskinsbuildier.ONGraphicsButton3Click(Sender: TObject);
begin
  if odf.Execute then
  begin
    rectlange.Width:=0;
    rectlange.Height:=0;

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

    mainscren.PutImage(0,0,mainimg);
  //  mainpicture.DiscardBitmap;//RedrawBitmap;
  //  Repaint;
  end;
end;

procedure Tskinsbuildier.ONGraphicsButton4Click(Sender: TObject);
begin
  if sdf.Execute then
  begin
    ONImg1.saveskin(sdf.FileName);
    aktif := False;
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



procedure Tskinsbuildier.zoomTimerTimer;
var
  srcRect: TRect;
  oo: integer;
begin
  if PtInRect(mainscren.ClientRect, curPos) then
  begin
    cropimg.SetSize(0,0);
    oo      := trackbar1.Position;
    srcRect := Rect(curPos.x - oo, curPos.y - oo, curPos.x + oo, curPos.y + oo);
    cropimg := mainscren.Bitmap.GetPart(srcRect);
    BGRAReplace(cropimg, cropimg.Resample(zoomx.clientWidth, zoomx.clientHeight, rmSimpleStretch));
    zoomx.PutImage(0,0,cropimg);
  end;
end;



constructor TOnurScreen.Create(Aowner:TComponent);
begin
  inherited Create(Aowner);
  parent             := TWinControl(Aowner);
  ControlStyle       := ControlStyle + [csClickEvents, csCaptureMouse,
    csDoubleClicks, csParentBackground];
  Width   := 1920;
  Height  := 1080;
  fbitmap := TBGRABitmap.Create(self.Width,self.Height);
end;

destructor TOnurScreen.Destroy;
begin
   FreeAndNil(fbitmap);
  inherited Destroy;
end;

procedure TOnurScreen.paint;
begin
  inherited paint;
  fBitmap.Draw(canvas,0,0,false);
end;

procedure TOnurScreen.PutImage(x,y:integer;a:Tbgrabitmap);
var
checkersSize:integer;
begin
  fBitmap.SetSize(0,0);
  fBitmap.SetSize(Width,Height);
  checkersSize :=6;
  fBitmap.DrawCheckers(rect(floor(self.Left), floor(Top),
          ceil(Width), ceil(Height)), CSSWhite, CSSSilver,
          checkersSize, checkersSize);



  fBitmap.PutImage(0, 0, a, dmLinearBlend, 255);
  if (rectlange.Width>0) and (rectlange.Height>0) then
  begin
   fbitmap.PenStyle := psDot;  //bitmap.Canvas.Rectangle(rectlange);
   fBitmap.RectangleWithin(rectlange,CSSRed,1,BGRAPixelTransparent);
  end;

  Invalidate;
end;

procedure TOnurScreen.MouseDown(Button:TMouseButton;Shift:TShiftState;X,Y:
  Integer);
begin
  inherited MouseDown(Button,Shift,X,Y);
  if (button = mbleft) then
  begin
    rectlange.left := x;
    rectlange.Top  := y;
    aktif          := True;
  end;

end;

procedure TOnurScreen.MouseMove(Shift:TShiftState;X,Y:Integer);
begin
  inherited MouseMove(Shift,X,Y);
  curPos         := Point(x, y);
  skinsbuildier.label6.Caption := 'X= ' + IntToStr(x) + ' --  Y=' + IntToStr(y);

  if (aktif) then
  begin
    rectlange.Right  := x;
    rectlange.Bottom := y;
    PutImage(0,0,mainimg);
  end;
 skinsbuildier.zoomTimerTimer;
end;

procedure TOnurScreen.MouseUp(Button:TMouseButton;Shift:TShiftState;X,Y:Integer);
begin
  inherited MouseUp(Button,Shift,X,Y);

  aktif := False;
  rectlange.Right := x;
  rectlange.Bottom := y;

  if x<rectlange.left then
   rectlange:= Rect(x,rectlange.top,rectlange.left,rectlange.bottom);

  if y<rectlange.top then
   rectlange:= Rect(rectlange.left,y,rectlange.Right,rectlange.top);

  //if changeskininfo = False Then exit;

  PutImage(0,0,mainimg);


  if (rectlange.Width>0) and (rectlange.Height>0)  then
  begin
  //  if TreeView1.Selected.Level < 0 then   exit;
    skinsbuildier.PropEdit.Cells[1, 2] := IntToStr(rectlange.Left);
    skinsbuildier.PropEdit.Cells[1, 3] := IntToStr(rectlange.top);
    skinsbuildier.PropEdit.Cells[1, 4] := IntToStr(rectlange.Right);
    skinsbuildier.PropEdit.Cells[1, 5] := IntToStr(rectlange.bottom);
  end;
  aktif := False;
end;

constructor TOnurZoomScreen.Create(Aowner:TComponent);
begin
  inherited Create(Aowner);
  parent             := TWinControl(Aowner);
  ControlStyle       := ControlStyle + [csClickEvents, csCaptureMouse,
    csDoubleClicks, csParentBackground];
  Width:=250;
  Height:=250;
  fbitmap:=TBGRABitmap.Create(self.Width,self.Height);
end;

destructor TOnurZoomScreen.Destroy;
begin
  FreeAndNil(fbitmap);
  inherited Destroy;
end;

procedure TOnurZoomScreen.paint;
begin
 inherited paint;
 fBitmap.Draw(canvas,0,0,false);
end;

procedure TOnurZoomScreen.PutImage(x,y:integer;a:Tbgrabitmap);
var
  Xshift, Yshift: integer;
  c: TBGRAPixel;
begin
 Xshift            := (Width) div 2;
 Yshift            := (Height) div 2;
 c                 := ColorToBGRA(skinsbuildier.ColorBox1.Selected);//ColorToRGB(ColorBox1.Selected));
 cropimg.PenStyle  := psSolid;//psdot;
 cropimg.DrawPolyLineAntialias(
    [PointF(Xshift, Yshift - 20), PointF(Xshift, Yshift + 20),
    PointF(Xshift, Yshift), PointF(Xshift - 20, Yshift),
    PointF(Xshift + 20, Yshift)], c, 2);

 fBitmap.SetSize(0,0);
 fBitmap.SetSize(a.Width,a.Height);
 fBitmap.PutImage(0, 0, a, dmLinearBlend, 255);
 Invalidate;
end;

procedure TOnurZoomScreen.MouseDown(Button:TMouseButton;Shift:TShiftState;X,Y:
  Integer);
begin
  inherited MouseDown(Button,Shift,X,Y);
end;

procedure TOnurZoomScreen.MouseMove(Shift:TShiftState;X,Y:Integer);
begin
  inherited MouseMove(Shift,X,Y);
end;

procedure TOnurZoomScreen.MouseUp(Button:TMouseButton;Shift:TShiftState;X,Y:
  Integer);
begin
  inherited MouseUp(Button,Shift,X,Y);
end;



end.

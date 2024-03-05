unit Main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, OI, Grids, ExtCtrls, StdCtrls,  ImgList;

const
  GutterSize = 15;
  LineColor = $00c8d0d4;

type

  { TwndMain }

  TwndMain = class(TForm)
    Tree: TTreeView;
    ScrollBox: TScrollBox;
    tc: TTabControl;
    List: TListView;
    ImageList1: TImageList;
    StatPanel: TPanel;
    Panel1: TPanel;
    Panel2: TPanel;
    RadioButton1: TRadioButton;
    Edit1: TEdit;
    Label1: TLabel;
    Button1: TButton;
    Shape1: TShape;
    ListBox1: TListBox;  
    StatusBar1: TStatusBar;
    procedure ObjectClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ListAdvancedCustomDrawItem(Sender: TCustomListView;
      Item: TListItem; State: TCustomDrawState; Stage: TCustomDrawStage;
      var DefaultDraw: Boolean);
    procedure tcChange(Sender: TObject);
    procedure TreeClick(Sender: TObject);
    procedure ListDblClick(Sender: TObject);
    procedure ListAdvancedCustomDrawSubItem(Sender: TCustomListView;
      Item: TListItem; SubItem: Integer; State: TCustomDrawState;
      Stage: TCustomDrawStage; var DefaultDraw: Boolean);
    procedure ListMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ListKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure ListSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure Panel2MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    OI: TMObjectInspector;
    procedure RefreshTree;
    procedure RefreshOI(AObject: TObject);
    function FindNode(Atext: string): TTreeNode;
    function EnumClassProps(AProp: TObject; AIndent: integer): Integer;
    function ExpandClassProps(AProp: TObject; AIndex,AIndent: integer): Integer;
  public
  end;

var
  wndMain: TwndMain;

implementation

uses
  TypInfo;

{$R *.dfm}

procedure ListView_DrawLine(Sender: TCustomListView; Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean; AIndent: Integer; LineColor: TColor);
var
  Rect: TRect;
begin
  with (Sender as TListView) do begin
    Canvas.Pen.Color:=LineColor;
    Rect:=Item.DisplayRect(drBounds);
    Rect.Left:=Rect.Left+(AIndent+1)*GutterSize;
    if (Item.Index>0) and (Items[Item.Index-1].ImageIndex=2) then
      Rect.Left:=Rect.Left-GutterSize;
    Canvas.MoveTo(Rect.Left,Rect.Top);
    Canvas.LineTo(Rect.Right,Rect.Top);
    Rect.Left:=Rect.Left-GutterSize;
    Canvas.MoveTo(Rect.Left,Rect.Bottom);
    Canvas.LineTo(Rect.Right,Rect.Bottom);
  end;
end;

procedure ListView_DrawDivider(Sender: TCustomListView; Item: TListItem; SubItem: Integer; State: TCustomDrawState; var DefaultDraw: Boolean; LineColor: TColor);
var
  Rect: TRect;
  x,i: Integer;
begin
  with (Sender as TListView) do begin
    Canvas.Pen.Color:=LineColor;
    Rect:=Item.DisplayRect(drBounds);
    x:=0;
    for i:=0 to SubItem-1 do
      x:=x+Column[i].Width;
    Rect.Left:=Rect.Left+x;
    Canvas.MoveTo(Rect.Left,Rect.Top);
    Canvas.LineTo(Rect.Left,Rect.Bottom);
    Rect.Left:=Rect.Left+Column[SubItem].Width;
    Canvas.MoveTo(Rect.Left,Rect.Top);
    Canvas.LineTo(Rect.Left,Rect.Bottom);
  end;
end;

procedure ListView_DrawGutter(Sender: TCustomListView; Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean; AIndent: Integer; BkColor: TColor; LineColor: TColor);
var
  Rect: TRect;
  c: TColor;
begin
  with (Sender as TListView) do begin
    Rect:=Item.DisplayRect(drBounds);
    Rect.Right:=Rect.Left+(AIndent+1)*GutterSize;
    c:=Canvas.Brush.Color;
    Canvas.Brush.Color:=BkColor;
    Canvas.FillRect(Rect);
    Canvas.Pen.Color:=LineColor;
    Canvas.MoveTo(Rect.Right,Rect.Top);
    Canvas.LineTo(Rect.Right,Rect.Bottom);
    Canvas.Brush.Color:=c;
  end;
end;

procedure ListView_DrawImage(Sender: TCustomListView;
                             Item: TListItem;
                             State: TCustomDrawState;
                             var DefaultDraw: Boolean;
                             ImageList: TCustomImageList;
                             ImageIndex: Integer;
                             AIndent: Integer;
                             BgColor: TColor;
                             LineColor: TColor);
var
  Rect: TRect;
  Bitmap: TBitmap;
begin
  ListView_DrawGutter(Sender,Item,State,DefaultDraw,AIndent,BgColor,LineColor);
  with (Sender as TListView) do begin
    Bitmap:=TBitmap.Create;
    try
      ImageList.GetBitmap(ImageIndex,Bitmap);
      Rect:=Item.DisplayRect(drBounds);
      Rect.Left:=Rect.Left+AIndent*GutterSize-1;
      Rect.Right:=Rect.Left+Bitmap.Width;
      Rect.Bottom:=Rect.Top+Bitmap.Height;
      Canvas.CopyMode:=cmSrcCopy;
      Canvas.StretchDraw(Rect,Bitmap);
    finally
      Bitmap.Free;
    end;
  end;
end;

procedure TwndMain.ObjectClick(Sender: TObject);
begin
  Tree.Selected:=FindNode(Format('%s: %s',[TComponent(Sender).Name,TComponent(Sender).Classname]));
  RefreshOI(Sender);
end;

procedure TwndMain.Panel2MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Button=mbLeft then begin
    ReleaseCapture;
    TPanel(Sender).Parent.Perform(WM_SYSCOMMAND,$f012,0);
  end;
  ScrollBox.Realign;
end;

function TwndMain.EnumClassProps(AProp: TObject; AIndent: integer): Integer;
var
  i: Integer;
begin
  Result:=0;
  with TMObjectInspector.Create(nil) do
    try
      Obj:=AProp;
      for i:=0 to Properties.Count-1 do
        if (SameText(Kinds[i],'8') and (tc.TabIndex=1)) or
           (not SameText(Kinds[i],'8') and (tc.TabIndex=0)) then begin
          Inc(Result);
        end;
    finally
      Free;
    end;
end;

function TwndMain.ExpandClassProps(AProp: TObject; AIndex,AIndent: integer): Integer;
var
  i: Integer;
begin
  Result:=0;
  with TMObjectInspector.Create(nil) do
    try
      Obj:=AProp;
      for i:=0 to Properties.Count-1 do
        if (SameText(Kinds[i],'8') and (tc.TabIndex=1)) or
           (not SameText(Kinds[i],'8') and (tc.TabIndex=0)) then
          with List.Items.Insert(AIndex) do begin
            Inc(Result);
            Caption:=StringOfChar(' ',AIndent*5)+Properties[i];
            if SameText(Types[i],'TColor') then
              SubItems.Add(ColorToString(StrToInt(Values[i])))
            else if SameText(Types[i],'TCursor') then
              SubItems.Add(CursorNames[Abs(StrToInt(Values[i]))])
            else
              SubItems.Add(Values[i]);
            SubItems.Add(Types[i]);
            SubItems.Add(IntToStr(AIndent));
            ImageIndex:=-1;
            if SameText(Kinds[i],'7') and (TObject(GetOrdProp(Obj,Properties[i]))<>oi.Obj) then begin
              if EnumClassProps(TObject(GetOrdProp(Obj,Properties[i])),AIndent+1)>0 then begin
                Data:=TObject(GetOrdProp(Obj,Properties[i]));
                ImageIndex:=3;
              end;
            end;
            Inc(AIndex);
          end;
    finally
      Free;
    end;
end;

function TwndMain.FindNode(Atext: string): TTreeNode;
var
  n: TTreeNode;
begin
  Result:=nil;
  n:=Tree.Items.GetFirstNode;
  while Assigned(n) do begin
    if SameText(n.Text,AText) then begin
      Result:=n;
      Break;
    end;
    n:=n.GetNext;
  end;
end;

procedure TwndMain.FormCreate(Sender: TObject);
begin
  OI:=TMObjectInspector.Create(Self);
  RefreshTree;
end;

procedure TwndMain.ListAdvancedCustomDrawItem(Sender: TCustomListView;
  Item: TListItem; State: TCustomDrawState; Stage: TCustomDrawStage;
  var DefaultDraw: Boolean);
begin
  if Item.SubItems[0]='' then
    Sender.Canvas.Font.Color:=clGray;
  if SameText(Item.Caption,'Name') then
    Sender.Canvas.Font.Style:=[fsBold];
  if (Item.ImageIndex>-1) then
    ListView_DrawImage(Sender,Item,State,DefaultDraw,List.SmallImages,Item.ImageIndex-2,StrToInt(Item.Subitems[2]),ImageList1.BkColor,LineColor)
  else
    ListView_DrawGutter(Sender,Item,State,DefaultDraw,StrToInt(Item.Subitems[2]),ImageList1.BkColor,LineColor);
  ListView_DrawLine(Sender,Item,State,DefaultDraw,StrToInt(Item.Subitems[2]),LineColor);
end;

procedure TwndMain.ListAdvancedCustomDrawSubItem(Sender: TCustomListView;
  Item: TListItem; SubItem: Integer; State: TCustomDrawState;
  Stage: TCustomDrawStage; var DefaultDraw: Boolean);
begin
  if SubItem=1 then
    Sender.Canvas.Font.Color:=clNavy;
  if SameText(Item.Caption,'Name') then
    Sender.Canvas.Font.Style:=[fsBold];
  ListView_DrawDivider(Sender,Item,SubItem,State,DefaultDraw,LineColor);
end;

procedure TwndMain.ListDblClick(Sender: TObject);
var
  i,ind: Integer;
begin
  if not Assigned(List.Selected) or (List.Selected.ImageIndex=-1) then
    Exit;
  List.Items.BeginUpdate;
  try
    i:=List.Selected.Index+1;
    ind:=StrToInt(List.Items[List.Selected.Index].SubItems[2]);
    if List.Selected.ImageIndex=2 then begin
      while StrToInt(List.Items[i].SubItems[2])>ind do
        List.Items.Delete(i);
      List.Selected.ImageIndex:=3;
    end else begin
      ExpandClassProps(TObject(List.Selected.Data),i,ind+1);
      List.Selected.ImageIndex:=2;
    end;
  finally
    List.Items.EndUpdate;
  end;
end;

procedure TwndMain.ListKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if not Assigned(List.Selected) or (List.Selected.ImageIndex=-1) then
    Exit;
  if (Shift=[]) and (Key in [vk_add,vk_subtract]) then
    ListDblClick(nil);
end;

procedure TwndMain.ListMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  n: TListItem;
  R: TRect;
  p: TPoint;
  ind: integer;
begin
  n:=List.GetItemAt(x,y);
  if not Assigned(n) or (n.ImageIndex=-1) then
    Exit;
  ind:=StrToInt(n.SubItems[2]);
  p.X:=x;
  p.Y:=y;
  R:=n.DisplayRect(drIcon);
  InflateRect(R,ind*GutterSize,0);
  if PtInRect(R,p) then
    ListDblClick(nil);
end;

procedure TwndMain.ListSelectItem(Sender: TObject; Item: TListItem;
  Selected: Boolean);
begin
  if Assigned(List.Selected) then
    StatPanel.Caption:=Format(' Type: %s',[List.Selected.SubItems[1]]);
end;

procedure TwndMain.RefreshOI(AObject: TObject);
var
  i: Integer;
begin
  if Assigned(AObject) then
    oi.Obj:=AObject;

  List.Items.BeginUpdate;
  try
    List.Items.Clear;

    for i:=0 to oi.Properties.Count-1 do
      if (SameText(oi.Kinds[i],'8') and (tc.TabIndex=1)) or
         (not SameText(oi.Kinds[i],'8') and (tc.TabIndex=0)) then
        with List.Items.Add do begin
          Caption:=oi.Properties[i];
          if SameText(oi.Types[i],'TColor') then
            SubItems.Add(ColorToString(StrToInt(oi.Values[i])))
          else if SameText(oi.Types[i],'TCursor') then
            SubItems.Add(CursorNames[Abs(StrToInt(oi.Values[i]))])
          else
            SubItems.Add(oi.Values[i]);
          SubItems.Add(oi.Types[i]);  
          SubItems.Add(IntToStr(0));
          ImageIndex:=-1;
          if SameText(oi.Kinds[i],'7') then begin
            if EnumClassProps(TObject(GetOrdProp(oi.Obj,oi.Properties[i])),1)>0 then begin
              ImageIndex:=3;
              Data:=TObject(GetOrdProp(oi.Obj,oi.Properties[i]));
            end;
          end;
        end;
  finally
    List.Items.EndUpdate;
  end;
end;


procedure TwndMain.RefreshTree;
var
  i: Integer;
  r: TTreeNode;

procedure AddComponent(AObject: TWinControl; ARoot: TTreeNode);
var
  i: Integer;
  n: TTreeNode;
begin
  for i:=0 to AObject.ControlCount-1 do begin
    n:=Tree.Items.AddChild(ARoot,Format('%s: %s',[AObject.Controls[i].Name,AObject.Controls[i].ClassName]));
    if AObject.Controls[i] is TWinControl then
      AddComponent(TWinControl(AObject.Controls[i]),n);
  end;
end;

begin
  r:=Tree.Items.AddChild(nil,Format('%s: %s',[Self.Name,Self.Classname]));
  AddComponent(Self,r);

  for i:=0 to Self.ComponentCount-1 do
    if not(Self.Components[i] is TControl) then
      Tree.Items.AddChild(r,Format('%s: %s',[Self.Components[i].Name,Self.Components[i].ClassName]));

  Tree.FullExpand;

  Tree.Selected:=r;

  RefreshOI(Self);
end;

procedure TwndMain.tcChange(Sender: TObject);
begin
  RefreshOI(nil);
end;

procedure TwndMain.TreeClick(Sender: TObject);
begin
  if not Assigned(Tree.Selected) then
    Exit;
  if Tree.Selected.Level=0 then
    RefreshOI(Self)
  else
    RefreshOI(Self.FindComponent(Copy(Tree.Selected.Text,1,Pos(':',Tree.Selected.Text)-1)));
end;

end.

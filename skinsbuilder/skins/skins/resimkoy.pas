unit resimkoy;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms
  ,resim, ExtCtrls, panelresim, StdCtrls, JimZoomImage;

type
  TForm3 = class(TForm)
    JimZoomImage1: TJimZoomImage;
    ListBox1: TListBox;
    ResimPanel1: TResimPanel;
    Button1: TButton;
    Label1: TLabel;
    Label2: TLabel;
    procedure ListBox1DblClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure ResimPanel1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form3: TForm3;
  r:Tksbmp;

implementation

uses Unit1;

{$R *.dfm}

procedure TForm3.ListBox1DblClick(Sender: TObject);
begin
ResimPanel1.Resim.LoadFromFile(ListBox1.Items[ListBox1.itemindex]);
JimZoomImage1.Picture.Bitmap:=ResimPanel1.Resim.Bitmap;
JimZoomImage1.ZoomX:=200;
JimZoomImage1.Zoomy:=200;

end;

procedure TForm3.Button1Click(Sender: TObject);
begin
if Form1.OpenPictureDialog1.Execute then
ListBox1.Items.Add(form1.OpenPictureDialog1.FileName);
//FImages.Add(form1.OpenPictureDialog1.Files)

end;

function izal(var S: string): string;
var
  i: byte;
  CopyS: string;
begin
  Result := '';
  CopyS := S;
  for i := 1 to Length(CopyS) do
  begin
    Delete(S, 1, 1);
    if CopyS[i] in [',', ' ', '(', ')', ';'] then Break;
    Result := Result + CopyS[i];
  end;
  Trim(Result);
  Trim(S);
end;
function ExtractImage(SourceImage: TksBmp; S: string): TksBmp;
var
  R: TRect;
  str: string;
begin
{ if S = '' then
  begin
    Result := SourceImage.GetCopy;
  end
  else}
  begin
    // Load rectangle
    try
      R := Rect(0, 0, SourceImage.Width, SourceImage.Height);
      str := izal(S);
      if str <> '' then R.left := StrToInt(str);
      str := izal(S);
      if str <> '' then R.top := StrToInt(str);
      str := izal(S);
      if str <> '' then R.right := StrToInt(str);
      str := izal(S);
      if str <> '' then R.bottom := StrToInt(str);

      Result := TksBmp.Create(R.right-R.left+1, R.bottom-R.top+1);
      SourceImage. CopyRect1(Result, R, 0, 0);
      Result.Rect := R;
    except
    end;
  end;
  end;
procedure TForm3.ResimPanel1MouseMove(Sender: TObject; Shift: TShiftState;
 X, Y: Integer);
 var
 o:TBitmap;
   R: TRect;
  s,str: string;
begin
o:=TBitmap.Create;
o.Canvas.Draw(x,y,ResimPanel1.Resim.Bitmap);
    try
      R := Rect(0, 0, o.Width, o.Height);
      str := izal(S);
      if str <> '' then R.left := StrToInt(str);
      str := izal(S);
      if str <> '' then R.top := StrToInt(str);
      str := izal(S);
      if str <> '' then R.right := StrToInt(str);
      str := izal(S);
      if str <> '' then R.bottom := StrToInt(str);

//      Result := TksBmp.Create(R.right-R.left+1, R.bottom-R.top+1);
      o.Canvas.CopyRect(R,o.Canvas,r);
//      o.Canvas.Rectangle(R);
    except
    end;

//label1.Caption:=inttostr(o.Handle(X,y); ResimPanel1.Left+x);
//label2.Caption:=inttostr(ResimPanel1.top-ResimPanel1.Height+x);
//JimZoomImage1.Picture.Bitmap.FreeImage;
//JimZoomImage1.Picture.Bitmap.Canvas.CopyRect(r,o.Canvas,JimZoomImage1.ClientRect);
JimZoomImage1.Picture.Bitmap.Canvas.Draw(r.Left,r.Top,o);

end;

end.
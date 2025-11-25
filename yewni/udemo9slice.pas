unit udemo9slice;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls, onur9slice, onurctrl, BGRABitmap,BGRABitmapTypes;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Panel1: TPanel;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    Skin9Slice: TONURSkin9Slice;
    Skin9SliceGraphic: TONURSkin9SliceGraphic;
    SkinImg: TONURImg;
  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

procedure TForm1.FormCreate(Sender: TObject);
begin
  // Skin image olustur
  SkinImg := TONURImg.Create(Self);
  
  // 9 slice control olustur
  Skin9Slice := TONURSkin9Slice.Create(Self);
  Skin9Slice.Parent := Self;
  Skin9Slice.Left := 50;
  Skin9Slice.Top := 150;
  Skin9Slice.Width := 200;
  Skin9Slice.Height := 100;
  Skin9Slice.Skindata := SkinImg;
  
  // 9 slice graphic control olustur
  Skin9SliceGraphic := TONURSkin9SliceGraphic.Create(Self);
  Skin9SliceGraphic.Parent := Self;
  Skin9SliceGraphic.Left := 300;
  Skin9SliceGraphic.Top := 150;
  Skin9SliceGraphic.Width := 200;
  Skin9SliceGraphic.Height := 100;
  Skin9SliceGraphic.Skindata := SkinImg;
  
  // Default crop degerlerini ayarla
  Edit1.Text := '10';
  Edit2.Text := '10';
  Edit3.Text := '10';
  Edit4.Text := '10';
  
  Caption := 'ONUR 9 Slice Scaling Demo';
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  fleft, ftop, fright, fbottom: Integer;
  SampleBitmap: TBGRABitmap;
begin
  // Crop degerlerini oku
  fleft := StrToIntDef(Edit1.Text, 10);
  ftop := StrToIntDef(Edit2.Text, 10);
  fright := StrToIntDef(Edit3.Text, 10);
  fbottom := StrToIntDef(Edit4.Text, 10);
  
  // Ornek bir bitmap olustur
  SampleBitmap := TBGRABitmap.Create(256, 256);
  try
    // Gradient background
    SampleBitmap.GradientFill(0, 0, 256, 256, BGRA(100, 150, 200), BGRA(50, 100, 150), gtLinear, 
                              PointF(0, 0), PointF(256, 256), dmSet);
    
    // Border ciz
    SampleBitmap.Rectangle(0, 0, 256, 256, BGRA(255, 255, 255), dmSet);
    SampleBitmap.Rectangle(2, 2, 254, 254, BGRA(200, 200, 200), dmSet);
    
    // Koselere farkli renkler ekle
    SampleBitmap.FillRect(0, 0, 32, 32, BGRA(255, 0, 0), dmSet); // Sol ust - kirmizi
    SampleBitmap.FillRect(224, 0, 256, 32, BGRA(0, 255, 0), dmSet); // Sag ust - yesil
    SampleBitmap.FillRect(0, 224, 32, 256, BGRA(0, 0, 255), dmSet); // Sol alt - mavi
    SampleBitmap.FillRect(224, 224, 256, 256, BGRA(255, 255, 0), dmSet); // Sag alt - sari
    
    // Skin image'e ata
    SkinImg.Fimage := SampleBitmap;
    
    // 9 slice ayarlarini yap
    Skin9Slice.NineSlice.SetCropMargins(fleft, ftop, fright, fbottom);
    Skin9Slice.SourceLeft := 0;
    Skin9Slice.SourceTop := 0;
    Skin9Slice.SourceRight := 256;
    Skin9Slice.SourceBottom := 256;
    
    Skin9SliceGraphic.NineSlice.SetCropMargins(fleft, ftop, fright, fbottom);
    Skin9SliceGraphic.SourceLeft := 0;
    Skin9SliceGraphic.SourceTop := 0;
    Skin9SliceGraphic.SourceRight := 256;
    Skin9SliceGraphic.SourceBottom := 256;
    
    // Control'leri yeniden ciz
    Skin9Slice.Invalidate;
    Skin9SliceGraphic.Invalidate;
    
    ShowMessage('9 Slice Scaling ayarlandi!' + sLineBreak +
                'Left: ' + IntToStr(fleft) + sLineBreak +
                'Top: ' + IntToStr(ftop) + sLineBreak +
                'Right: ' + IntToStr(fright) + sLineBreak +
                'Bottom: ' + IntToStr(fbottom));
                
  finally
    SampleBitmap.Free;
  end;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  // Control boyutlarini degistir
  Skin9Slice.Width := 300;
  Skin9Slice.Height := 150;
  Skin9SliceGraphic.Width := 300;
  Skin9SliceGraphic.Height := 150;
  
  ShowMessage('Control boyutlari degistirildi!' + sLineBreak +
              'Yeni Width: 300' + sLineBreak +
              'Yeni Height: 150');
end;

end.

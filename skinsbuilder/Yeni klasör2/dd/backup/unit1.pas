unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls;

type

  { TForm1 }

  TForm1 = class(TForm)
    Bevel1: TBevel;
    Image1: TImage;
    Image2: TImage;
    Label1: TLabel;
    procedure Bevel1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Bevel1MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer
      );
    procedure Bevel1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormPaint(Sender: TObject);
  private
    FMouseDownPt: TPoint;
    FDragging: Boolean;
    procedure CopyImage;

  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

uses
  LCLIntf;

{ TForm1 }

procedure TForm1.CopyImage;
var
  bmp: TBitmap;
  Rsrc, Rdest: TRect;
begin
  bmp := TBitmap.Create;
  try
    bmp.SetSize(Image2.Width, Image2.Height);
    bmp.PixelFormat := pf32Bit;
    Rdest := Rect(0, 0, bmp.Width, bmp.Height);
    Rsrc := Rect(Bevel1.Left, Bevel1.Top, Bevel1.Left+Bevel1.Width, Bevel1.Top+Bevel1.Height);
    OffsetRect(Rsrc, -Image1.Left, -Image1.Top);
    bmp.Canvas.CopyRect(Rdest, Image1.Picture.Bitmap.Canvas, Rsrc);
    Image2.Picture.Assign(bmp);
  finally
    bmp.Free;
  end;
end;

procedure TForm1.Bevel1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  FMouseDownPt := Point(X, Y);
  FDragging := true;
end;

procedure TForm1.Bevel1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  if FDragging then begin
    X := Bevel1.Left + X - FMouseDownPt.X;
    if X < Image1.Left then X := Image1.Left;
    if X > Image1.Left + Image1.Width - Bevel1.Width then
      X := Image1.Left + Image1.Width - Bevel1.Width;
    Y := Bevel1.Top + Y - FMouseDownPt.Y;
    if Y < Image1.Top then Y := Image1.Top;
    if Y > Image1.Top + Image1.Height - Bevel1.Height then
      Y := Image1.Top + Image1.Height - Bevel1.Height;
    Bevel1.Left := X;
    Bevel1.Top := Y;
//    Bevel1.SetBounds(X, Y, Bevel1.Width, Bevel1.Height);Left := X;
    CopyImage;
  end;
end;

procedure TForm1.Bevel1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  FDragging := false;
end;

procedure TForm1.FormPaint(Sender: TObject);
begin
  Canvas.GradientFill(Rect(0, 0, ClientWidth, ClientHeight), clWhite, clSilver, gdVertical);
end;

end.


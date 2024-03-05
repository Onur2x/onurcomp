unit spLoupe;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, ExtCtrls;

type
  TspLoupe = class(TGraphicControl)
  private
    { Private declarations }
    Timer: TTimer;
    X, Y: Integer;
    DC, DCPuffer, Puffer: HDC;
    FZoom: Double;
    FActive: Boolean;
    Buffer: TBitmap;
    procedure PaintLoupe(Sender: TObject);
    procedure ReSized;
    procedure SetActive(Value: Boolean);
    procedure SetZoom(Value: Double);
  protected
    { Protected declarations }
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Paint; override;    
  published
    { Published declarations }
    property Align; 
    property Active: Boolean read FActive write SetActive;
    property ZoomLevel: Double read FZoom write SetZoom;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Samples', [TspLoupe]);
end;

constructor TspLoupe.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := ControlStyle + [csOpaque];
  Timer := TTimer.Create(self);
  Timer.Interval := 100;
  Timer.Enabled := False;
  Width := 100;
  Height := 100;
  Buffer := TBitMap.Create;
  Buffer.Width := Width;
  Buffer.Height := Height;
  FZoom := 2;
  DC := CreateDC('DISPLAY', nil, nil, nil);
  DCPuffer := CreateCompatibleDC(DC);
  X := Round(Width / FZoom);
  Y := Round(Height / FZoom);
  if Puffer <> 0 then DeleteDC(Puffer);
  Puffer := CreateCompatibleBitmap(DC, X, Y);
  SelectObject(DCPuffer, Puffer);
  Active := False;
  Timer.OnTimer := PaintLoupe;
end;

destructor TspLoupe.Destroy;
begin
  Timer.Free;
  DeleteDC(Puffer);
  DeleteDC(DCPuffer);
  DeleteDC(dc);
  Buffer.free;
  inherited destroy;
end;

procedure TspLoupe.PaintLoupe(Sender: TObject);
var
  Position: TPoint;
begin
  if (csDesigning in ComponentState) then Exit;
  GetCursorPos(Position);
  BitBlt(DCPuffer, 0, 0, Width, Height, DC,
         Position.X - (X div 2), Position.Y - (Y div 2), SRCCOPY);
  StretchBlt(Buffer.Canvas.Handle, 0, 0, Width, Height,
             DCPuffer, 0, 0, X, Y, SRCCOPY);
  Repaint;
end;

procedure TspLoupe.Resized;
begin
  buffer.Width := Width;
  buffer.Height := Height;
  X := Round(Width / FZoom);
  Y := Round(Height / FZoom);
  if Puffer <> 0 then DeleteDC(Puffer);
  Puffer := CreateCompatibleBitmap(DC, X, Y);
  SelectObject(DCPuffer, Puffer);
end;

procedure TspLoupe.SetActive;
begin
  FActive := Value;
  Timer.Enabled := FActive;
end;

procedure TspLoupe.Paint;
var
  _Rect: TRect;
begin
  if (Buffer.Width <> Width) or (Buffer.Height <> Height) then ReSized;
  _Rect := GetClientRect;
  bitblt(Canvas.Handle, Canvas.ClipRect.Left, Canvas.ClipRect.Top,
  Canvas.ClipRect.Right, Canvas.ClipRect.Bottom, Buffer.Canvas.Handle,
  Canvas.ClipRect.Left, Canvas.ClipRect.Top, SRCCOPY);
end;

procedure TspLoupe.SetZoom;
begin
  if Value > 0 then FZoom := Value else FZoom := 1;
  X := Round(Width / FZoom);
  Y := Round(Height / FZoom);
  if Puffer <> 0 then DeleteDC(Puffer);
  Puffer := CreateCompatibleBitmap(DC, X, Y);
  SelectObject(DCPuffer, Puffer);
end;

end.

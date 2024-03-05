unit SkinLabel;
(*

MindBlast Software's SkinLabel

Description: This component displays a label using the Text.bmp
from a Winamp Skin.
(If you don't know Winamp, go look at www.winamp.com)
Looking for skins? Looking for MP3 players? Go to -->
-> www.winamp.com
-> www.mp3.com
-> www.dailymp3.com

Features:
* Stretch
* Scrolling

Please visit our web page www.gcs.co.za/mbs/mbs.htm
There you will find a lot more of these great components!
Contact me via e-mail: louw@gcs.co.za for any feedback, comments,
suggestions, bug reports, etc.

This component is FREEWARE!

Sorry for the lack of comments and help - but then again using the
component should not prove that difficult! 8^D

Disclaimer:
We do not except any reponsibility for using the component. You use this
component at your own and exclusive risk.

*)

interface
{$R SkinLabel.Res}
{$R SkinLabelRes.res}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, extctrls,DsgnIntF,TypInfo;

Const
 ScrollBy = 1;
 CharWidth = 5;
 CharHeight = 6;

 Row1 : String[31] = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ"@¿ ';
 Row2 : String[31] = '0123456789 .:<>-''!_+\/[]^&%,=$¿';
 Row3 : String[31] = 'ÂÖÄ?*';
 Row4 : String[31] = ''; //For later improvement

type

  TSkinLabel = class(TCustomLabel)
  private
    { Private declarations }
    FBitmap     : TBitmap;
    FPicture    : TPicture;
    FTimer      : TTimer;
    FInterval   : Cardinal;
    FActive     : Boolean;
    FStretch    : Boolean;
    FScrollBy   : Integer;
    FCurPos     : Integer;
    FWait       : Integer;
    FWaiting    : Boolean;
    FColor      : TColor;
    FCaption    : String;

    FScale      : Real;

    procedure SetColor(Value : TColor);
    Function  GetScrollBy:Integer;
    procedure SetActive(Value : Boolean);
    procedure SetStretch(Value : Boolean);
    procedure SetInterval(Value : Cardinal);
    procedure SetPicture(Value : TPicture);
    procedure FillBitMap;
    procedure Activate;
    procedure Deactivate;
    procedure UpdatePos;
    procedure DoOnTimer(Sender : TObject);

  protected
    { Protected declarations }
    procedure paint; override;

  public
    { Public declarations }
    constructor create(AOwner: TComponent);override;
    destructor destroy; override;
  published
    { Published declarations }
    property Active     : Boolean read FActive write SetActive;
    property Stretch    : Boolean read FStretch write SetStretch;
    property ScrollBy   : Integer read GetScrollBy write FScrollBy;
    property Interval   : Cardinal read FInterval write SetInterval;
    property WaitOnEnd  : Integer read FWait write FWait;
    property SkinBitmap : TPicture read FPicture write SetPicture;
    property align;
    property Color      : TColor read FColor write SetColor;
    property Caption;
    property ParentColor;
    property Visible;
    property OnClick;
    property OnDblClick;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;

  end;

procedure Register;

implementation

constructor TSkinLabel.Create(AOwner : TComponent);
Begin
  inherited Create(AOwner);
  AutoSize:=False;
  FInterval:=100;
  FPicture:=TPicture.Create;
  FPicture.Bitmap.LoadFromResourceName(HInstance,'TEXTBITMAP');

  FBitmap:=TBitmap.Create;
  with FBitmap do
   Begin
    pixelformat:=pf24bit;
    width:=10;
    height:=10;
   end;

  FTimer:=TTimer.Create(Self);
  With FTimer do
   Begin
    Enabled:=False;
    Interval:=FInterval;
    OnTimer:=DoOnTimer;
   end;
  Width:=100;
  Height:=CharHeight*2;
  FActive:=False;
  Activate;
  FStretch:=True;
  FScrollBy:=2;
  FWait:=1000;
  Color:=clBlack;
end;

destructor TSkinLabel.Destroy;
begin
 Deactivate;
 FBitmap.Free;
 FPicture.Free;
 FTimer.Free;
 inherited Destroy;
end;

Function TSkinLabel.GetScrollBy:Integer;
Begin
 Result:=ABS(FScrollBy);
End;

procedure TSkinLabel.SetPicture(Value: TPicture);
begin
  FPicture.Assign(Value);
  IF (FPicture.Bitmap.Width<>155) or (FPicture.Bitmap.Height<>18) then
   ShowMessage('Dimensions not valid. Not valid Winamp Skin Text!');
  FCaption:='';
  Invalidate;
end;


procedure TSkinLabel.SetColor(Value : TColor);
Begin
 IF Value<>FColor then
  Begin
   FColor:=Value;
   FCaption:='';
   Invalidate;
  end;
End;

procedure TSkinLabel.SetActive(Value : Boolean);
begin
 IF Value <> FActive then
  Begin
    FActive:=Value;
    IF FActive then
     Begin
       Activate;
     end
    else Deactivate;
    FWaiting:=False;
  end;
end;

procedure TSkinLabel.SetStretch(Value : Boolean);
Var
 Rec : TRect;
begin
 IF Value <> FStretch then
  Begin
    FStretch:=Value;
     Rec.Top:=0; Rec.Left:=0; Rec.Bottom:=Height; Rec.Right:=Width;
     Canvas.Brush.Color:=Color;
     Canvas.Brush.Style:=bsSolid;
     Canvas.FillRect(Rec);
     Paint;
  end;
  IF Not FStretch then FScale:=1;
end;

procedure TSkinLabel.SetInterval(Value : Cardinal);
begin
 IF Value <> FInterval then
  Begin
    FInterval:=Value;
    FTimer.Interval:=Value;
  end;
end;


procedure TSkinLabel.Activate;
begin
 FActive:=True;
 FTimer.Enabled:=True;
 FTimer.Interval:=FInterval;
 FWaiting:=False;

 FCurPos:=0;
 FScrollBy:=ABS(FScrollBy);
 FillBitMap;
end;

procedure TSkinLabel.Deactivate;
begin
  FTimer.Enabled:=False;
  FActive:=False;
  Invalidate;
end;

procedure TSkinLabel.DoOnTimer(Sender : Tobject);
Begin
 IF FWaiting then
  Begin
   FTimer.Interval:=FInterval;
   FWaiting:=False;
  end;

 UpDatePos;
 Paint;
end;

Function GetCol(Ch : Char):Word;
Var
 Place : Word;
Begin
 Ch:=UpCase(Ch);
 Place:=Pos(Ch,Row1);
 IF Place<>0 then Result:=(Place-1)*CharWidth
  else Begin
   Place:=Pos(Ch,Row2);
   IF Place<>0 then Result:=(Place-1)*CharWidth
    Else Begin
     Place:=Pos(Ch,Row3);
     IF Place<>0 then Result:=(Place-1)*CharWidth
      Else Begin
       Place:=Pos(Ch,Row4);
       IF Place<>0 then Result:=(Place-1)*CharWidth
       Else Result:=0;
      end;
    end;
  end;
end;

Function GetRow(Ch : Char):Word;
Begin
 Ch:=UpCase(Ch);
 IF Pos(Ch,Row1) <> 0 then Result:=0 else
  IF Pos(Ch,Row2) <> 0 then Result:=CharHeight else
   IF Pos(Ch,Row3) <> 0 then Result:=CharHeight*2 else
    Begin
     Result:=0;
    end;
end;


procedure TSkinLabel.FillBitmap;
Var
 Rec   : TRect;
 T     : Word;
begin

  If Self.Caption<>'' then
  FBitMap.Width:=(Length(Self.Caption)*CharWidth)
  else FBitMap.Width:=Self.Width;

  FBitmap.Height:=CharHeight;

  IF FBitMap.Width < Self.Width then
    FBitmap.Width:=Self.Width;

  Rec.Top:=0; Rec.Left:=0; Rec.Bottom:=Height; Rec.Right:=Width;
  FBitMap.Canvas.Brush.Color:=Self.Color;
  FBitMap.Canvas.Brush.Style:=bssolid;
  FBitMap.Canvas.FillRect(Rec);

  IF Self.Caption<>'' then
  For T:= 0 to Length(Caption)-1 do
  BitBlt(FBitMap.Canvas.Handle,T*CharWidth,0,CharWidth,CharHeight,FPicture.Bitmap.Canvas.Handle,GetCol(Caption[T+1]),GetRow(Caption[T+1]),SrcCopy);
end;

procedure TSkinLabel.UpDatePos;
begin
  If (Length(Self.Caption)*CharWidth)*FScale > Self.Width then
   Begin
     FCurPos:=FCurPos+FScrollBy;
     IF FCurPos <= 0 then
      Begin
        FScrollBy:=Abs(FScrollBy);
        IF FWait<>0 then
         Begin
           FWaiting:=True;
           FTimer.Interval:=FWait;
         end;
      end;

     IF (Length(Self.Caption)*CharWidth{(FBitMap.Width)}-(FCurPos)) <= (Self.Width/FScale) then
      Begin
       FScrollBy:=Abs(FScrollBy)*-1;
       IF FWait<>0 then
         Begin
           FWaiting:=True;
           FTimer.Interval:=FWait;
         end;
      end;
   end Else FCurPos:=0;

end;

procedure TSkinLabel.Paint;
Var
 Rec : TRect;
begin
 IF Caption <> FCaption then
    Begin
     FillBitmap;
     Rec.Top:=0; Rec.Left:=0; Rec.Bottom:=Height; Rec.Right:=Width;
     Canvas.Brush.Color:=Color;
     Canvas.Brush.Style:=bsSolid;
     Canvas.FillRect(Rec);
     FCurPos:=0;
     FScrollBy:=ABS(FScrollBy);
     FCaption:=Caption;
    end;
 IF not FStretch then
  Begin
    Rec:=ClientRect;
    Rec.Top:=Rec.Top+CharHeight;
    Canvas.FillRect(Rec);
   IF FActive then
     BitBlt(Canvas.Handle,0,0,Width,CharHeight,FBitmap.Canvas.Handle,FCurPos,0,srcCopy)
   else
    Begin
     Rec:=ClientRect;
     Rec.Bottom:=Rec.Bottom+CharHeight;
     Rec.Left:=rec.Left+(CharWidth*Length(Caption));
     Canvas.FillRect(Rec);
     BitBlt(Canvas.Handle,0,0,Width,CharHeight,FBitmap.Canvas.Handle,0,0,srcCopy);
    end;
  end
 Else
 Begin
   FScale:=Height/CharHeight;
    IF FActive then
      StretchBlt(Canvas.Handle,0,0,Width,Height,FBitmap.Canvas.Handle,FCurPos,0,Round(Width/FScale),CharHeight,srcCopy)
    else
      StretchBlt(Canvas.Handle,0,0,Width,Height,FBitmap.Canvas.Handle,0,0,Round(Width/FScale),CharHeight,srcCopy);
 end;
end;

procedure Register;
begin
  RegisterComponents('MBS', [TSkinLabel]);
end;

end.

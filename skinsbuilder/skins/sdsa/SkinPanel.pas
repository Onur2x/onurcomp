unit SkinPanel;

{$MODE Delphi}

//----------------------------------------------------------------
//----------------------------------------------------------------
//----------------------------------------------------------------
interface
//----------------------------------------------------------------
uses
  Forms,SysUtils, LCLIntf, LCLType, LMessages, Messages, Classes,Graphics, Controls,
  Skin,SkinChargeur,SkinType,SkinCanvasCopy;
//----------------------------------------------------------------
type
  TSkinPanel = class(TSkinCustomControl)
  private
    { Private declarations }
    deplacement:boolean;
    Xold,Yold:integer;
    Parent:TForm;
    MargeH,MargeB,MargeG,MargeD:integer;

    procedure WSize(var Message: TMessage); message WM_SIZE;
    procedure MonMouseChange(Sender: TObject;Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure MonMouseMove(Sender: TObject; Shift: TShiftState;X, Y: Integer);
  protected
    { Protected declarations }
  public
    { Public declarations }
    procedure SkinChargement(SkinParam:TSOParam);override;
    constructor Create(AOwner: TComponent); override;
    procedure SkinPaint;override;
  published
    { Published declarations }
  end;
//----------------------------------------------------------------
//----------------------------------------------------------------
//----------------------------------------------------------------
implementation
//----------------------------------------------------------------
constructor TSkinPanel.Create(AOwner: TComponent);
begin
        inherited Create(AOwner);
        typ:=SkPanel;
        Align:=alClient;
        ControlStyle := [csAcceptsControls, csCaptureMouse, csClickEvents,
                        csDoubleClicks, csReplicatable,csFixedWidth,csFixedHeight];
        Parent:=TForm(AOwner);
        Parent.BorderStyle:=bsNone;
        deplacement:=false;
        OnMouseDown:=MonMouseChange;
        OnMouseUp:=MonMouseChange;
        OnMouseMove:=MonMouseMove;
end;
//----------------------------------------------------------------
procedure TSkinPanel.SkinPaint();
begin
        CanvasSmoothCopy(SkinBitmap.Canvas,Rect(0,0,SkinBitmap.Width,SkinBitmap.Height),Canvas,Rect(0,0,Width,Height));
end;
//----------------------------------------------------------------------------
//---> debut deplacement
procedure TSkinPanel.MonMouseChange(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
        deplacement:=(ssLeft in Shift);
end;
//----------------------------------------------------------------------------
//---> deplacement en cours
procedure TSkinPanel.MonMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
var P: TPoint;
begin
        // récupère position du curseur
        GetCursorPos(P);
        if deplacement then
        begin
                //Alors on bouge la fenetre
                parent.Top:=parent.Top+P.Y-Yold;
                parent.Left:=parent.Left+P.X-Xold;
        end;

        // on sauvegarde la position souris
        Xold:=P.X;
        Yold:=P.Y;
end;
//----------------------------------------------------------------
procedure TSkinPanel.SkinChargement(SkinParam:TSOParam);
var P:TSOParamPanel;
begin
        P:=TSOParamPanel(SkinParam);
        Parent.ClientHeight:=P.hauteur;
        Parent.ClientWidth:=P.largeur;
      //  Parent.TransparentColor:=true;
      //  Parent.TransparentColorValue:=P.Couleur;
        MargeH:=P.MargeH;
        MargeB:=P.MargeB;
        MargeD:=P.MargeD;
        MargeG:=P.MargeG;
end;
//----------------------------------------------------------------
procedure TSkinPanel.WSize(var Message: TMessage);
begin
        invalidate;
        repaint;
        inherited ;
end;
//----------------------------------------------------------------
end.

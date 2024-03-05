unit SkinButton;

{$MODE Delphi}

//----------------------------------------------------------------
//----------------------------------------------------------------
//----------------------------------------------------------------
interface
//----------------------------------------------------------------
uses
  SysUtils, LCLIntf, LCLType, LMessages, Messages, Classes,Graphics, Controls,
  Skin,SkinChargeur,SkinType,SkinCanvasCopy;
//----------------------------------------------------------------
type
  TSkinButton = class(TSkinCustomControl)
  private
    { Private declarations }
    over,click:boolean;
    TransColor:TColor;
    entre,sortie:TNotifyEvent;
    procedure SetOnEntre(Value:TNotifyEvent);
    procedure SetOnSortie(Value:TNotifyEvent);
    procedure MouseEnter(var Message: TMessage); message CM_MOUSEENTER;
    procedure MouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
    procedure GestionMouseClick(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
  protected
    { Protected declarations }
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    procedure SkinChargement(SkinParam:TSOParam);override;
    procedure SetEnabled(Value:Boolean);override;
    procedure SkinPaint;override;
  published
    { Published declarations }
    property OnClick;
    property OnEntre:TNotifyEvent READ entre write SetOnEntre;
    property OnSortie:TNotifyEvent READ sortie write SetOnSortie;
    property Enabled;
  end;
//----------------------------------------------------------------
//----------------------------------------------------------------
//----------------------------------------------------------------
implementation
//----------------------------------------------------------------
constructor TSkinButton.Create(AOwner: TComponent);
begin
        inherited Create(AOwner);
        typ:=SkButton;
        click:=false;
        over:=false;
        self.OnMouseDown:=GestionMouseClick;
        self.OnMouseUp:=GestionMouseClick;
        ControlStyle := [csCaptureMouse, csClickEvents,
                        csDoubleClicks, csReplicatable,csFixedWidth,csFixedHeight];
end;
//----------------------------------------------------------------
procedure TSkinButton.SkinPaint();
var     RecBt:TRect;
        w,h:integer;
begin
        w:=SkinBitmap.Width div 4;
        h:=SkinBitmap.Height;
        if not enabled then
                RecBt:=Rect(3*w,0,4*w,h)        //gris
        else if click then
                RecBt:=Rect(2*w,0,3*w,h)        //click
        else if over then
                RecBt:=Rect(w,0,2*w,h)          //over
        else
                RecBt:=Rect(0,0,w,h);           //normal

        CanvasMaskCopy(SkinBitmap.Canvas,RecBt,Canvas,Point(0,0),TransColor);{}
end;
//----------------------------------------------------------------
procedure TSkinButton.SkinChargement(SkinParam:TSOParam);
var P:TSOParamBouton;
begin
        P:=TSOParamBouton(SkinParam);
        Height:=P.hauteur;
        Width:=P.largeur;
        Top:=P.MargeV;
        left:=P.MargeH;
        TransColor:=P.Couleur;
end;
//----------------------------------------------------------------
procedure TSkinButton.GestionMouseClick(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
        click:=(ssLeft in Shift);
        invalidate;        
        repaint;
end;
//----------------------------------------------------------------
procedure TSkinButton.MouseEnter(var Message: TMessage);
begin
        over:=true;
        invalidate;
        repaint;
        if @entre<>nil then
        entre(self);
end;
//----------------------------------------------------------------
procedure TSkinButton.MouseLeave(var Message: TMessage);
begin
        over:=false;
        invalidate;
        repaint;
        if @sortie<>nil then
        sortie(self);
end;
//----------------------------------------------------------------
procedure TSkinButton.SetEnabled(Value:Boolean);
begin
        inherited SetEnabled(Value);
        invalidate;
        repaint;
end;
//----------------------------------------------------------------
procedure TSkinButton.SetOnEntre(Value:TNotifyEvent);
begin
        Entre:=Value;
end;
//----------------------------------------------------------------
procedure TSkinButton.SetOnSortie(Value:TNotifyEvent);
begin
        Sortie:=Value;
end;
//----------------------------------------------------------------
end.

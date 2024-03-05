unit SkinCheck;
//----------------------------------------------------------------
//----------------------------------------------------------------
//----------------------------------------------------------------
interface
//----------------------------------------------------------------
uses
  SysUtils, WinTypes, WinProcs, Messages, Classes,Graphics, Controls,
  Skin,SkinChargeur,SkinType,SkinCanvasCopy;
//----------------------------------------------------------------
type PNotifyEvent = ^TNotifyEvent;
type
  TSkinCheck = class(TSkinCustomControl)
  private
    { Private declarations }
    over,click:boolean;
    TransColor:TColor;
    change,entre,sortie:TNotifyEvent;
    procedure SetClick(Value:boolean);
    procedure SetOnChange(Value:TNotifyEvent);
    procedure SetOnEntre(Value:TNotifyEvent);
    procedure SetOnSortie(Value:TNotifyEvent);
    procedure MouseEnter(var Message: TMessage); message CM_MOUSEENTER;
    procedure MouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
    procedure GestionMouseClick(Sender: TObject);
  protected
    { Protected declarations }
  public
    { Public declarations }
    procedure SkinChargement(SkinParam:TSOParam);override;
    constructor Create(AOwner: TComponent); override;
    procedure SetEnabled(Value:Boolean);override;
    procedure SkinPaint;override;
  published
    { Published declarations }
    property OnChange:TNotifyEvent READ change write SetOnChange;
    property OnEntre:TNotifyEvent READ entre write SetOnEntre;
    property OnSortie:TNotifyEvent READ sortie write SetOnSortie;
    property Enabled;
    property Etat:boolean READ click Write Setclick;
  end;
//----------------------------------------------------------------
//----------------------------------------------------------------
//----------------------------------------------------------------
implementation
//----------------------------------------------------------------
constructor TSkinCheck.Create(AOwner: TComponent);
begin
        inherited Create(AOwner);
        typ:=SkCheck;
        click:=false;
        over:=false;
        change:=nil;
        self.OnClick:=GestionMouseClick;
        ControlStyle := [csCaptureMouse, csClickEvents,
                        csDoubleClicks, csReplicatable,csFixedWidth,csFixedHeight];
end;
//----------------------------------------------------------------
procedure TSkinCheck.SkinPaint();
var     RecBt:TRect;
        w,h:integer;
begin
        w:=SkinBitmap.Width div 6;
        h:=SkinBitmap.Height;

        if click then
        begin
                if not enabled then
                        RecBt:=Rect(5*w,0,6*w,h)        //gris coché
                else if over then
                        RecBt:=Rect(4*w,0,5*w,h)        //over coché
                else
                        RecBt:=Rect(3*w,0,4*w,h);       //coché
        end
        else
        begin
                if not enabled then
                        RecBt:=Rect(2*w,0,3*w,h)        //gris
                else if over then
                        RecBt:=Rect(w,0,2*w,h)          //over
                else
                        RecBt:=Rect(0,0,w,h);           //normal
        end;

        CanvasMaskCopy(SkinBitmap.Canvas,RecBt,Canvas,Point(0,0),TransColor);
end;
//----------------------------------------------------------------
procedure TSkinCheck.SkinChargement(SkinParam:TSOParam);
var P:TSOParamCheck;
begin
        P:=TSOParamCheck(SkinParam);
        Height:=P.hauteur;
        Width:=P.largeur;
        Top:=P.MargeV;
        left:=P.MargeH;
        TransColor:=P.Couleur;

end;
//----------------------------------------------------------------
procedure TSkinCheck.GestionMouseClick(Sender: TObject);
begin
        etat:=not etat;
        if @change<>nil then
        change(Sender);
end;
//----------------------------------------------------------------
procedure TSkinCheck.MouseEnter(var Message: TMessage);
begin
        over:=true;
        repaint;
        if @entre<>nil then
        entre(self);
end;
//----------------------------------------------------------------
procedure TSkinCheck.MouseLeave(var Message: TMessage);
begin
        over:=false;
        repaint;
        if @sortie<>nil then
        sortie(self);
end;
//----------------------------------------------------------------
procedure TSkinCheck.SetClick(Value:boolean);
begin
        click:=Value;
        invalidate;
        repaint;
end;
//----------------------------------------------------------------
procedure TSkinCheck.SetEnabled(Value:Boolean);
begin
        inherited SetEnabled(Value);
        invalidate;
        repaint;
end;
//----------------------------------------------------------------
procedure TSkinCheck.SetOnChange(Value:TNotifyEvent);
begin
        Change:=Value;
end;
//----------------------------------------------------------------
procedure TSkinCheck.SetOnEntre(Value:TNotifyEvent);
begin
        Entre:=Value;
end;
//----------------------------------------------------------------
procedure TSkinCheck.SetOnSortie(Value:TNotifyEvent);
begin
        Sortie:=Value;
end;
//----------------------------------------------------------------
end.

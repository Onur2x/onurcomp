unit SkinLabel;
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
  TSkinLabel = class(TSkinCustomControl)
  private
    { Private declarations }
    over:boolean;
    colonnes,lignes:byte;
    premier:char;
    text:string;
    TransColor,TextColor:TColor;
    Policelargeur:array[Byte] of byte;
    change,entre,sortie:TNotifyEvent;
    procedure SetText(Value:string);
    procedure SetCouleur(Value:TColor);
    procedure SetOnChange(Value:TNotifyEvent);
    procedure SetOnEntre(Value:TNotifyEvent);
    procedure SetOnSortie(Value:TNotifyEvent);
    procedure MouseEnter(var Message: TMessage); message CM_MOUSEENTER;
    procedure MouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
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
    property OnClick;
    property OnChange:TNotifyEvent READ change write SetOnChange;
    property OnEntre:TNotifyEvent READ entre write SetOnEntre;
    property OnSortie:TNotifyEvent READ sortie write SetOnSortie;
    property Enabled;
    property Caption:string READ text Write SetText;
    property Couleur:TColor READ TextColor Write SetCouleur;
  end;
//----------------------------------------------------------------
//----------------------------------------------------------------
//----------------------------------------------------------------
implementation
//----------------------------------------------------------------
constructor TSkinLabel.Create(AOwner: TComponent);
begin
        inherited Create(AOwner);
        typ:=SkLabel;
        text:='Text';
        over:=false;
        change:=nil;
        ControlStyle := [csCaptureMouse, csClickEvents,
                        csDoubleClicks, csReplicatable,csFixedWidth,csFixedHeight];
end;
//----------------------------------------------------------------
procedure TSkinLabel.SkinPaint();
var w,h,i,x,col,lgn:integer;
    p:pchar;
    ch:char;
begin
        h:=(SkinBitmap.Height-1) div lignes;
        w:=(SkinBitmap.Width-1) div colonnes;
        p:=pchar(text);
        x:=0;
        for i:=0 to Length(text)-1 do
        begin
                ch:=p[i];
                lgn:=(byte(ch)-byte(premier)) div colonnes;
                col:=(byte(ch)-byte(premier)) mod colonnes;
                if (lgn>=0) and (col>=0) and (lgn<lignes) and (col<colonnes) then
                begin
                        CanvasMaskColorCopy(SkinBitmap.Canvas,Rect(col*w+1,lgn*h+1,col*w+w-1,lgn*h+h-1),Canvas,Point(x,0),TransColor,TextColor);
                        x:=x+Policelargeur[byte(ch)];
                end;
        end;
end;
//----------------------------------------------------------------
procedure TSkinLabel.SkinChargement(SkinParam:TSOParam);
var     P:TSOParamLabel;
        w,h,i,col,lgn,x,y:integer;
begin
        P:=TSOParamLabel(SkinParam);
        Height:=P.hauteur;
        Width:=P.largeur;
        Top:=P.MargeV;
        left:=P.MargeH;
        colonnes:=P.Colonnes;
        lignes:=P.Lignes;
        premier:=P.Premier;
        TransColor:=P.Couleur;
        TextColor:=P.CouleurText;

        if SkinBitmap.Empty then exit;


        h:=(SkinBitmap.Height-1) div lignes;
        w:=(SkinBitmap.Width-1) div colonnes;
        for i:=0 to 255 do
        begin
                lgn:=(i-byte(premier)) div colonnes;
                col:=(i-byte(premier)) mod colonnes;
                if (lgn>=0) and (col>=0) and (lgn<lignes) and (col<colonnes) then
                begin
                        for x:=1 to w-1 do
                        begin
                                for y:=1 to h-1 do
                                begin
                                        if SkinBitmap.Canvas.Pixels[col*w+x,lgn*h+y]<>TransColor then
                                                PoliceLargeur[i]:=x;
                                end;
                        end;
                end
                else
                        PoliceLargeur[i]:=0;
        end;
end;
//----------------------------------------------------------------
procedure TSkinLabel.MouseEnter(var Message: TMessage);
begin
        over:=true;
        invalidate;
        repaint;
        if @entre<>nil then
        entre(self);
end;
//----------------------------------------------------------------
procedure TSkinLabel.MouseLeave(var Message: TMessage);
begin
        over:=false;
        invalidate;
        repaint;
        if @sortie<>nil then
        sortie(self);
end;
//----------------------------------------------------------------
procedure TSkinLabel.SetText(Value:string);
begin
        text:=Value;
        invalidate;
        repaint;
        if @change<>nil then
        change(self);
end;
//----------------------------------------------------------------
procedure TSkinLabel.SetCouleur(Value:TColor);
begin
        TextColor:=Value;
        invalidate;
        repaint;
end;
//----------------------------------------------------------------
procedure TSkinLabel.SetEnabled(Value:Boolean);
begin
        inherited SetEnabled(Value);
        invalidate;
        repaint;
end;
//----------------------------------------------------------------
procedure TSkinLabel.SetOnChange(Value:TNotifyEvent);
begin
        Change:=Value;
end;
//----------------------------------------------------------------
procedure TSkinLabel.SetOnEntre(Value:TNotifyEvent);
begin
        Entre:=Value;
end;
//----------------------------------------------------------------
procedure TSkinLabel.SetOnSortie(Value:TNotifyEvent);
begin
        Sortie:=Value;
end;
//----------------------------------------------------------------
end.

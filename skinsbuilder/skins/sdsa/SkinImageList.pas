unit SkinImageList;
//----------------------------------------------------------------
//----------------------------------------------------------------
//----------------------------------------------------------------
interface
//----------------------------------------------------------------
uses
  ImgList,SysUtils, WinTypes, WinProcs, Messages, Classes,Graphics, Controls,
  Skin,SkinChargeur,SkinType,SkinObjet;
//----------------------------------------------------------------
type
  TSkinImageList = class(TSkinCustomImageList)
  private
    { Private declarations }
    SkinCh:TSkinChargeur;
    SkinObjetNom:string;
  protected
    { Protected declarations }
    typ:TSkinType;
    procedure SetSkinChargeur(Value: TSkinChargeur);override;
    procedure SetSkinObjet(Value: string);
    procedure Chargement; override;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor destroy(); override;
  published
    { Published declarations }
    property SkinChargeur:TSkinChargeur READ SkinCh WRITE SetSkinChargeur;
    property SkinObjet:string READ SkinObjetNom WRITE SetSkinObjet;
  end;
//----------------------------------------------------------------
//----------------------------------------------------------------
//----------------------------------------------------------------
implementation
//----------------------------------------------------------------
constructor TSkinImageList.Create(AOwner: TComponent);
begin
        inherited Create(AOwner);
        SkinCh:=nil;
        SkinObjetNom:='';
        typ:=SkList;
end;
//----------------------------------------------------------------
destructor TSkinImageList.destroy();
begin
        If SkinCh<>nil then
                SkinCh.deleteList(self);
        inherited destroy;
end;
//----------------------------------------------------------------
procedure TSkinImageList.SetSkinChargeur(Value: TSkinChargeur);
begin
        //je m'enleve de l'ancien  Chargeur
        If SkinCh<>nil then
                SkinCh.deleteList(self);

        //j'actualise
        SkinCh:=Value;

        //je me declare dans le nouveau Chargeur
        If SkinCh<>nil then
                SkinCh.addList(self);

        //chargement des valeurs
        Chargement;
end;
//----------------------------------------------------------------
procedure TSkinImageList.SetSkinObjet(Value: string);
begin
        //j'actualise
        SkinObjetNom:=Value;
        //chargement des valeurs
        Chargement;
end;
//----------------------------------------------------------------
procedure TSkinImageList.Chargement();
var     tmp:TSkinObjet;
        P:TSOParamList;
        bmp:TBitmap;
        i:integer;
begin
        //chargeur defini
        if (SkinCh<>nil) then
                //oui, skin par defaut assigné ?
                if SkinCh.Skin<>nil then
                begin
                        //oui, je cherche mes donné dedans
                        tmp:=SkinCh.Skin.GetData(SkinObjetNom);
                        //elle existe ?
                        if tmp<>nil then
                        begin
                                //oui, mais du bon type ?
                                if tmp.typ=typ then
                                begin
                                        //tout est ok je met a jour
                                        SkinObjetNom:=tmp.nom;
                                        P:=TSOParamList(tmp.par);
                                        self.Clear;
                                        self.Height:=tmp.bmp.Height;
                                        self.Width:=tmp.bmp.Width div P.Nombre;
                                        for i:=0 to P.Nombre-1 do
                                        begin
                                                bmp:=TBitmap.Create;
                                                bmp.Height:=self.Height;
                                                bmp.Width:=self.Width;
                                                bmp.Canvas.CopyRect(Rect(0,0,self.Width-1,self.Height-1),tmp.bmp.Canvas,Rect(self.Width*i,0,self.Width*(i+1)-1,self.Height-1));
                                                self.AddMasked(bmp,P.Couleur);
                                                bmp.Free;
                                        end;


                                end;
                        end;
                end;
end;
//----------------------------------------------------------------
end.

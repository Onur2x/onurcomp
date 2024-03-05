//----------------------------------------------------------------
unit SkinChargeur;
interface
//----------------------------------------------------------------
uses
  ImgList,Dialogs,Controls, SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics,
  Forms,SkinObjet,Skin,SkinType;
//----------------------------------------------------------------
  type
  TSkinChargeur = class(TComponent)
    Skin:TSkin;
    ListeSkinControl:TList;             //Les controles qui dependent de cette skin
    ListeSkinList:TList;                //Les TImagesList qui dependent de cette skin
    procedure SetSkin(Value: TSkin);
    procedure RepaintSkinControl();
  protected
    { Protected declarations }
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure LoadFromFile(fichier:string);
    function CompatibleLoadFromFile(fichier:string):boolean;

    //gestion des controles
    procedure add(Component:TGraphicControl);
    procedure delete(Component:TGraphicControl);
    procedure addList(Component:TCustomImageList);
    procedure deleteList(Component:TCustomImageList);
  published
    { Published declarations }
    property DefaultSkin:TSkin READ Skin WRITE SetSkin;
  end;
//----------------------------------------------------------------
  TSkinCustomImageList = class(TCustomImageList)
  protected
    { Protected declarations }
    procedure Chargement;virtual;abstract;
    procedure SetSkinChargeur(Value: TSkinChargeur);virtual;abstract;
  end;
//----------------------------------------------------------------
  //Classe type des control skinable
  TSkinCustomControl = class(TGraphicControl)
  private
    { Private declarations }
    SkinCh:TSkinChargeur;
    SkinObjetNom:string;
    procedure SetSkinChargeur(Value: TSkinChargeur);
    procedure SetSkinObjet(Value: string);
  protected
    { Protected declarations }
    typ:TSkinType;
    SkinBitmap:TBitmap;
    SkinParamOk:boolean;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor destroy(); override;
    procedure SkinChargement(SkinParam:TSOParam);virtual;abstract;
    procedure Chargement;virtual;
    procedure SkinPaint;virtual;abstract;
    procedure Paint;override;
  published
    { Published declarations }
    property SkinChargeur:TSkinChargeur READ SkinCh WRITE SetSkinChargeur;
    property SkinObjet:string READ SkinObjetNom WRITE SetSkinObjet;
    property visible;
  end;
//----------------------------------------------------------------
var ListeSkinChargeur:TList;
//----------------------------------------------------------------
implementation
//----------------------------------------------------------------
//----------------------------------------------------------------
//----------------------------------------------------------------
//----------------------------------------------------------------
//----------------------------------------------------------------
constructor TSkinChargeur.Create(AOwner: TComponent);
begin
        inherited Create(AOwner);
        Skin:=TSkin.Create();
        ListeSkinControl:=TList.Create();
        ListeSkinList:=TList.Create();
        //je me declare dans la liste des chargeur
        ListeSkinChargeur.Add(self);
end;
//----------------------------------------------------------------
destructor TSkinChargeur.Destroy;
begin
        //Je romps le lien avec les controles dependant
        while ListeSkinControl.Count<>0 do
                TSkinCustomControl(ListeSkinControl.Items[0]).SetSkinChargeur(nil);
        while ListeSkinList.Count<>0 do
                TSkinCustomImageList(ListeSkinList.Items[0]).SetSkinChargeur(nil);

        //je m'enleve de la liste des chargeur
        ListeSkinChargeur.Delete(ListeSkinChargeur.IndexOf(self));
        ListeSkinControl.free;
        ListeSkinList.Free;
        Skin.free;
        inherited Destroy;
end;
//----------------------------------------------------------------
procedure TSkinChargeur.SetSkin(Value: TSkin);
var     i:integer;
        etat:array of bool;
begin
        //je cree la liste d'etat
        setlength(etat,ListeSkinControl.Count);
        //j'empeche tout repaint des objets dependants pendant le chargement
        for i:=0 to ListeSkinControl.Count-1 do
        begin
                etat[i]:=TSkinCustomControl(ListeSkinControl.Items[i]).visible;
                TSkinCustomControl(ListeSkinControl.Items[i]).visible:=false;
        end;
        //j'assign la skin
        Skin.Assign(Value);
        //je demande un rechargement des objets dependants
        for i:=0 to ListeSkinControl.Count-1 do
                TSkinCustomControl(ListeSkinControl.Items[i]).Chargement;
        for i:=0 to ListeSkinList.Count-1 do
                TSkinCustomImageList(ListeSkinList.Items[i]).Chargement;
        //je reautorise les repaints
        for i:=0 to ListeSkinControl.Count-1 do
                TSkinCustomControl(ListeSkinControl.Items[i]).visible:=etat[i];
        //je demande un repaint global
        RepaintSkinControl();
end;
//----------------------------------------------------------------
procedure TSkinChargeur.LoadFromFile(fichier:string);
var     i:integer;
        etat:array of bool;
begin
        //je cree la liste d'etat
        setlength(etat,ListeSkinControl.Count);
        //j'empeche tout repaint des objets dependants pendant le chargement
        for i:=0 to ListeSkinControl.Count-1 do
        begin
                etat[i]:=TSkinCustomControl(ListeSkinControl.Items[i]).visible;
                TSkinCustomControl(ListeSkinControl.Items[i]).visible:=false;
        end;
        //je charge la skin
        Skin.LoadFromFile(fichier);
        //je demande un rechargement des objets dependants
        for i:=0 to ListeSkinControl.Count-1 do
                TSkinCustomControl(ListeSkinControl.Items[i]).Chargement;
        for i:=0 to ListeSkinList.Count-1 do
                TSkinCustomImageList(ListeSkinList.Items[i]).Chargement;
        //je reautorise les repaints
        for i:=0 to ListeSkinControl.Count-1 do
                TSkinCustomControl(ListeSkinControl.Items[i]).visible:=etat[i];
        //je demande un repaint global
        RepaintSkinControl();
end;
//----------------------------------------------------------------
function TSkinChargeur.CompatibleLoadFromFile(fichier:string):boolean;
var     i:integer;
        NouvSkin:TSkin;
        control:TSkinCustomControl;
        objet:TSkinObjet;
begin
        Result:=true;
        NouvSkin:=TSkin.Create;
        NouvSkin.LoadFromFile(fichier);
        for i:=0 to ListeSkinControl.Count-1 do
        begin
                //je pointe sur le control i
                control:=TSkinCustomControl(ListeSkinControl.Items[i]);
                // il corespond a 'objet' dasn la nouvel skin
                objet:=NouvSkin.GetData(control.SkinObjetNom);
                //objet exist ?
                if objet=nil then
                        // non: skin incompatible
                        Result:=False
                // oui mais du meme type ?
                else if objet.typ<>control.typ then
                        // non: skin incompatible
                        Result:=False;
        end;
        if Result then
        begin
                //skin compatible
                //j'empeche tout repaint des objets dependants pendant le chargement
                for i:=0 to ListeSkinControl.Count-1 do
                        TSkinCustomControl(ListeSkinControl.Items[i]).visible:=false;
                //j'assign la skin
                Skin.Assign(NouvSkin);
                //je demande un rechargement des objets dependants
                for i:=0 to ListeSkinControl.Count-1 do
                        TSkinCustomControl(ListeSkinControl.Items[i]).Chargement;
                for i:=0 to ListeSkinList.Count-1 do
                        TSkinCustomImageList(ListeSkinList.Items[i]).Chargement;
                //je reautorise les repaints
                for i:=0 to ListeSkinControl.Count-1 do
                        TSkinCustomControl(ListeSkinControl.Items[i]).visible:=true;
                //je demande un repaint global
                RepaintSkinControl();
        end
        else
                //skin incompatible : j'en informe l'utilisateur
                messagedlg('Skin Incompatible', mtError,[mbOk], 0);

        NouvSkin.free;
end;
//----------------------------------------------------------------
procedure TSkinChargeur.RepaintSkinControl();
var i:integer;
begin
        //tout les composant dependants se redessine !!!
        for i:=0 to ListeSkinControl.Count-1 do
                TCustomControl(ListeSkinControl.Items[i]).repaint;
end;
//----------------------------------------------------------------
procedure TSkinChargeur.add(Component:TGraphicControl);
begin
        //j'inscrit dans la liste de control dependant
        ListeSkinControl.Add(Component);
end;
//----------------------------------------------------------------
procedure TSkinChargeur.delete(Component:TGraphicControl);
begin
        //je desinscrit de la liste de control dependant
        ListeSkinControl.Delete(ListeSkinControl.IndexOf(Component));
end;
//----------------------------------------------------------------
procedure TSkinChargeur.addList(Component:TCustomImageList);
begin
        //j'inscrit dans la liste de control dependant
        ListeSkinList.Add(Component);
end;
//----------------------------------------------------------------
procedure TSkinChargeur.deleteList(Component:TCustomImageList);
begin
        //je desinscrit de la liste de control dependant
        ListeSkinList.Delete(ListeSkinControl.IndexOf(Component));
end;
//----------------------------------------------------------------
//----------------------------------------------------------------
//----------------------------------------------------------------
constructor TSkinCustomControl.Create(AOwner: TComponent);
begin
        inherited Create(AOwner);
        SkinCh:=nil;
        SkinObjetNom:='';
        typ:=SkNone;
        SkinParamOk:=false;
        SkinBitmap:=nil;
end;
//----------------------------------------------------------------
destructor TSkinCustomControl.destroy();
begin
        If SkinCh<>nil then
                SkinCh.delete(self);
        inherited destroy;
end;
//----------------------------------------------------------------
procedure TSkinCustomControl.SetSkinChargeur(Value: TSkinChargeur);
begin
        //je m'enleve de l'ancien  Chargeur
        If SkinCh<>nil then
                SkinCh.delete(self);

        //j'actualise
        SkinCh:=Value;

        //je me declare dans le nouveau Chargeur
        If SkinCh<>nil then
                SkinCh.add(self);

        //chargement des valeurs
        Chargement;
end;
//----------------------------------------------------------------
procedure TSkinCustomControl.SetSkinObjet(Value: string);
begin
        //j'actualise
        SkinObjetNom:=Value;
        //chargement des valeurs
        Chargement;
end;
//----------------------------------------------------------------
procedure TSkinCustomControl.paint();
begin
        inherited paint;

        // Chargement reussi ?
        if not SkinParamOk then
        begin
                //non je dessine un contour en pointillé
                Canvas.Pen.Color:=clWindowText;
                Canvas.Pen.Width:=1;
                Canvas.Pen.Style:=psDash;
                Canvas.Pen.Mode:=pmMask;
                Canvas.Polyline([Point(0,0), Point(0,Height-1)]);
                Canvas.Polyline([Point(0,Height-1),Point(Width-1,Height-1)]);
                Canvas.Polyline([Point(0,0), Point(Width-1,0)]);
                Canvas.Polyline([Point(Width-1,0),Point(Width-1,Height-1)]);
        end
        else if visible then
                //oui alors je demande au descendant de se redessiner
                SkinPaint;
end;
//----------------------------------------------------------------
procedure TSkinCustomControl.Chargement();
var     tmp:TSkinObjet;
begin
        SkinParamOk:=false;
        SkinBitmap:=nil;
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
                                        SkinBitmap:=tmp.bmp;
                                        SkinParamOk:=true;
                                        //chargement du descendant
                                        SkinChargement(tmp.par);
                                end;
                        end;
                end;
        //representation graphique invalide
        invalidate;
        //se redessiner
        repaint;
end;
//----------------------------------------------------------------
begin
        ListeSkinChargeur:=TList.Create();
end.

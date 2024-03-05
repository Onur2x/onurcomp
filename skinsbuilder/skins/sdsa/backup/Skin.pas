unit Skin;

interface

uses SkinCompression,SkinObjet,Classes, SysUtils,SkinType;

//----------------------------------------------------------------
type  TSkin = class(TPersistent)
  private
    { Private declarations }

        procedure LoadEditor(S : TStream);
        procedure SaveEditor(S : TStream);
  public
    { Public declarations }
        nom:string;
        ObjList:TList;

        constructor Create();
        destructor destroy();override;
        procedure LoadFromFile(fichier:string);
        procedure SaveToFile(fichier:string);
        function GetData(nom:string):TSkinObjet;
        procedure Assign(Source: TPersistent);override;
        procedure DefineProperties(Filer : TFiler); override;
  end;
//----------------------------------------------------------------
procedure WriteString(str:string;S : TStream);
function ReadString(S : TStream):string;
//----------------------------------------------------------------
//----------------------------------------------------------------
//----------------------------------------------------------------
implementation
//----------------------------------------------------------------
constructor TSkin.Create();
begin
        inherited Create();
        ObjList:=TList.Create;
        nom:='';
end;
//----------------------------------------------------------------
destructor TSkin.destroy();
var i:integer;
begin
        //j'efface tout
        For i:=0 to ObjList.Count-1 do
                TSkinObjet(ObjList.Items[i]).free;
        ObjList.free;
        inherited destroy();
end;
//----------------------------------------------------------------
procedure TSkin.LoadFromFile(fichier:string);
var TFS:TFileStream;
begin
        TFS:=TFileStream.Create(fichier,fmOpenRead or fmShareDenyWrite);
        if TFS=nil then exit;
        LoadEditor(TFS);
        TFS.free;
end;
//----------------------------------------------------------------
function TSkin.GetData(nom:string):TSkinObjet;
var     i:integer;
begin
        Result:=nil;
        For i:=0 to ObjList.Count-1 do
        begin
                // je test si un objet existe avec le meme nom
                // maj/min sans imprtance
                if LowerCase(TSkinObjet(ObjList.Items[i]).nom)=LowerCase(nom) then
                begin
                        //alors c ok
                        Result:=TSkinObjet(ObjList.Items[i]);
                end;
        end;
end;
//----------------------------------------------------------------
procedure TSkin.SaveToFile(fichier:string);
var TFS:TFileStream;
begin
        // le fichier existe ?
        if FileExists(fichier) then
                //oui alors je le detruit
                DeleteFile(fichier);
        //je cree le fichier et ouvre le flux
        TFS:=TFileStream.Create(fichier,fmCreate or fmShareDenyWrite);
        //je sauve
        SaveEditor(TFS);
        //je ferme le flux
        TFS.free;
end;
//----------------------------------------------------------------
procedure TSkin.Assign(Source: TPersistent);
var     i:integer;
        OS,O:TSkinObjet;
begin
        //j'assign un Tskin
        if Source is TSkin then
        begin
                //oui alors on copie la valeur

                //j'efface d'abord les valeur deja existante
                For i:=0 to ObjList.Count-1 do
                        TSkinObjet(ObjList.Items[i]).free;
                ObjList.Clear;

                //et je cree les nouvelles
                For i:=0 to TSkin(Source).ObjList.Count-1 do
                begin
                        OS:=TSkinObjet(TSkin(Source).ObjList.Items[i]);
                        //un nouveau TSkinObjet fidel a l'ancien
                        O:=TSkinObjet.Create;
                        O.nom:=OS.nom;
                        O.typ:=OS.typ;
                        O.bmp.Assign(OS.bmp);
                        O.par:=OS.par;
                        //que j'ajoute a Objlist
                        ObjList.Add(O);
                end;
        end
        else
                //non alors erreur (la methode herite la generera)
                inherited;

end; {}
//----------------------------------------------------------------
procedure TSkin.DefineProperties(Filer : TFiler);
begin
  inherited;
  Filer.DefineBinaryProperty('Data', LoadEditor, SaveEditor, True);
end;
//----------------------------------------------------------------
procedure TSkin.LoadEditor(S : TStream);
var     i,count:integer;
        Ob:TSkinObjet;
        empty:byte;
        SNC:TStream;
begin
        //creation du flux intermediaire
        SNC:=TMemoryStream.Create;

        //decompression
        SkinDecompresse(S,SNC);
        //retour au debut
        SNC.Seek(0,soFromBeginning);

        //au besoin je vide les valeurs preexistante
        For i:=0 to ObjList.Count-1 do
                TSkinObjet(ObjList.Items[i]).free;
        ObjList.Clear;

        //je lit le nom
        nom:=ReadString(SNC);

        //je lit le nombre
        SNC.Read(count,sizeof(integer));

        for i:=1 to count do
        begin
                //je cree une instance
                Ob:=TSkinObjet.Create;
                Ob.nom:=ReadString(SNC);
                SNC.Read(Ob.typ,sizeof(TSkinType));
                SNC.Read(Ob.par,sizeof(TSOParam));
                SNC.Read(empty,sizeof(byte));
                if empty<>1 then
                        Ob.bmp.LoadFromStream(SNC);
                //et je l'ajoute a ObjList
                ObjList.Add(Ob);
        end;

        //je libere la memoire
        SNC.Free;
end;
//----------------------------------------------------------------
procedure TSkin.SaveEditor(S : TStream);
var     i:integer;
        Ob:TSkinObjet;
        empty:byte;
        SNC:TStream;
begin
        //creation du flux intermediaire
        SNC:=TMemoryStream.Create;
        //J'ecrit le nom
        WriteString(nom,SNC);
        //J'ecrit le nombre
        SNC.Write(ObjList.Count,sizeof(integer));
        For i:=0 to ObjList.Count-1 do
        begin
                //je cree un intermediaire qui pointe sur l'objet stocké
                Ob:=TSkinObjet(ObjList.Items[i]);

                //j'ecrit ses parametres
                WriteString(Ob.nom,SNC);
                SNC.Write(Ob.typ,sizeof(TSkinType));
                SNC.Write(Ob.par,sizeof(TSOParam));
                if Ob.bmp.Empty then
                        empty:=1
                else
                        empty:=0;
                SNC.Write(empty,sizeof(byte));
                Ob.bmp.SaveToStream(SNC);
        end;

        //compression
        SkinCompresse(SNC,S);

        //liberation memoire
        SNC.Free;
end;
//----------------------------------------------------------------
//----------------------------------------------------------------
//----------------------------------------------------------------
//----------------------------------------------------------------
//----------------------------------------------------------------
//----------------------------------------------------------------
procedure WriteString(str:string;S : TStream);
var     p:pchar;
        i:integer;
begin
        p:=pchar(str);
        i:=length(p);
        S.Write(i, sizeof(integer));
        S.Write(p^,(i+1)*sizeof(char));
end;
//----------------------------------------------------------------
function ReadString(S : TStream):string;
var     p:pchar;
        i:integer;
begin
        S.Read(i,sizeof(integer));
        GetMem(p,(i+1)*sizeof(char));
        S.Read(p^,(i+1)*sizeof(char));
        Result:=string(p);
end;
//----------------------------------------------------------------
end.

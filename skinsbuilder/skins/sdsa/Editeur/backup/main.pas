unit main;

{$MODE Delphi}

interface

uses
  test,LCLIntf, LCLType, LMessages, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, ComCtrls, ToolWin, Menus, Grids, ValEdit, StdCtrls,
  Spin, ExtDlgs,Skin,SkinObjet,ImgList,SkinType, Buttons,math;
//---------------------------------------------------------------------
type
  TSEForm = class(TForm)
    MenuTexte: TMainMenu;
    Fichier1: TMenuItem;
    Inserer1: TMenuItem;
    VerticalSplitter: TSplitter;
    PanelControl: TPanel;
    SkinTree: TTreeView;
    HorizontalSplitter: TSplitter;
    PropEdit: TValueListEditor;
    IsPanel: TMenuItem;
    IsBouton: TMenuItem;
    Nouveau: TMenuItem;
    Ouvrir: TMenuItem;
    Sauver: TMenuItem;
    ImageListTree: TImageList;
    PanelFond: TPanel;
    SauverSous: TMenuItem;
    Quitter: TMenuItem;
    IsLabel: TMenuItem;
    PanelImage: TPanel;
    ImageListFich: TImageList;
    PanelOutils: TPanel;
    ImagePreview: TImage;
    BoutonOuvrir: TBitBtn;
    BoutonTest: TBitBtn;
    IsCheck: TMenuItem;
    BoutonGenerer: TBitBtn;
    FontDialog: TFontDialog;
    IsList: TMenuItem;
    procedure RefaireTree();
    procedure RefaireProp();
    procedure RefaireImage();
    procedure NouveauClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure OuvrirClick(Sender: TObject);
    procedure SkinTreeChange(Sender: TObject; Node: TTreeNode);
    procedure IsPanelClick(Sender: TObject);
    procedure Inserer1Click(Sender: TObject);
    procedure IsBoutonClick(Sender: TObject);
    procedure IsLabelClick(Sender: TObject);
    procedure SauverClick(Sender: TObject);
    procedure SauverSousClick(Sender: TObject);
    procedure QuitterClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure PropEditValidate(Sender: TObject; ACol, ARow: Integer;
      const KeyName, KeyValue: String);
    procedure PropEditKeyPress(Sender: TObject; var Key: Char);
    procedure PropEditExit(Sender: TObject);
    procedure Fichier1Click(Sender: TObject);
    procedure BoutonOuvrirClick(Sender: TObject);
    procedure SkinTreeKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure PanelOutilsResize(Sender: TObject);
    procedure BoutonTestClick(Sender: TObject);
    procedure ImagePreviewMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure ImagePreviewMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure IsCheckClick(Sender: TObject);
    procedure BoutonGenererClick(Sender: TObject);
    procedure IsListClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

const formcaption='SkinEdit 1.0';

var

  SEForm: TSEForm;

  SESkin:TSkin;

  SESkinObjet:TSkinObjet;
  SENode:TTreeNode;

  NomFichier:string;            //nom du fichier en cours
  modif:boolean;                //fichier modifier depuis sauvegarde

  quit:boolean;                 //demande de fermeture

implementation

{$R *.lfm}

//---------------------------------------------------------------------
procedure TSEForm.NouveauClick(Sender: TObject);
var boucle:boolean;
begin
        boucle:=modif;
        while boucle do
        begin
                case MessageDlg('Voulez vous sauver vos modifications ?',mtWarning,[mbYes, mbNo,mbCancel],0) of
                        mrCancel :exit;
                        mrYes : begin
                                        SauverClick(Sender);
                                        boucle:=modif;
                                end;
                        mrNo :  boucle:=false;
                end;
        end;

        caption:=formcaption;
        NomFichier:='';
        modif:=false;
        SESkin.free;
        SESkin:=TSkin.Create;
        SESkin.nom:='Nouvelle Skin';
        SESkinObjet:=nil;
        SENode:=SkinTree.Items.GetFirstNode;
        RefaireTree();
end;
//---------------------------------------------------------------------
procedure TSEForm.FormCreate(Sender: TObject);
var     i: Integer;
begin
        caption:=formcaption;
        NomFichier:='';
        modif:=false;
        quit:=false;
        SESkin:=TSkin.Create;
        SESkin.nom:='Nouvelle Skin';
        SESkinObjet:=nil;
        SENode:=SkinTree.Items.GetFirstNode;
        SENode.Data:=nil;
        SENode.ImageIndex:=0;
        SENode.SelectedIndex:=0;

        for i := 1 to ParamCount do
        begin
                SESkin.LoadFromFile(ParamStr(i));
                NomFichier:=ParamStr(i);
        end;
        RefaireTree();
end;
//---------------------------------------------------------------------
procedure TSEForm.OuvrirClick(Sender: TObject);
var boucle:boolean;
begin
        boucle:=modif;
        while boucle do
        begin
                case MessageDlg('Voulez vous sauver vos modifications ?',mtWarning,[mbYes, mbNo,mbCancel],0) of
                        mrCancel :exit;
                        mrYes : begin
                                        SauverClick(Sender);
                                        boucle:=modif;
                                end;
                        mrNo :  boucle:=false;
                end;
        end;
         with TOpenDialog.Create(Application) do
                try
                        Title := 'Charger une Skin';
                        Filename := '';
                        Filter := 'Fichier Skin (*.skn)|*.skn|Tout les Fichiers (*.*)|*.*';
                        HelpContext := 0;
                        Options := Options + [ofShowHelp, ofPathMustExist, ofFileMustExist];

                        if Execute then
                        begin
                                SESkin.LoadFromFile(Filename);
                                NomFichier:=Filename;
                                modif:=false;
                                RefaireTree();
                                caption:=formcaption+' - '+ExtractFileName(NomFichier);
                        end;
                finally
                        Free
        end;
end;
//---------------------------------------------------------------------
procedure TSEForm.RefaireTree();
var     root,cur,cur2:TTreeNode;
        i,j:integer;
        tmp,tmp2:TSkinObjet;
begin
        root:=SkinTree.Items.GetFirstNode;
        root.Text:=SESkin.nom;
        root.DeleteChildren;

        for i:=0 to SESkin.ObjList.Count-1 do
        begin
                tmp:=TSkinObjet(SESkin.ObjList.Items[i]);
                if tmp.typ=SkPanel then
                begin
                        cur:=SkinTree.Items.AddChild(root,tmp.nom);
                        cur.Text:=tmp.nom;
                        cur.ImageIndex:=1;
                        cur.SelectedIndex:=1;
                        cur.Data:=tmp;
                        for j:=0 to SESkin.ObjList.Count-1 do
                        begin
                                tmp2:=TSkinObjet(SESkin.ObjList.Items[j]);
                                if (tmp2.typ<>SkPanel) and (ExtractFilePath(tmp2.nom)=tmp.nom+'\')then
                                begin
                                        cur2:=SkinTree.Items.AddChild(cur,ExtractFileName(tmp2.nom));
                                        case tmp2.typ of
                                                SkButton:cur2.ImageIndex:=2;
                                                SkLabel:cur2.ImageIndex:=3;
                                                SkCheck:cur2.ImageIndex:=4;
                                                SkList:cur2.ImageIndex:=5;
                                        end;
                                        cur2.SelectedIndex:=cur2.ImageIndex;
                                        cur2.Data:=tmp2;
                                end;
                        end;
                        cur.Expand(true);
                end;
        end;
        root.Expand(true);
        SkinTree.Select(root,[]);
        SENode:=root;
        RefaireProp;
end;
//---------------------------------------------------------------------
procedure TSEForm.RefaireImage();
var     S:TMemoryStream;
begin
        if SESkinObjet=nil then exit;
        if SESkinObjet.bmp.Empty then
                ImagePreview.Visible:=false
        else
        begin
                ImagePreview.Visible:=true;
                if ImagePreview.Picture.Graphic=nil then
                        ImagePreview.Picture.Graphic:=TBitmap.Create;
                S:=TMemoryStream.Create;
                SESkinObjet.bmp.SaveToStream(S);
                S.Seek(0,soFromBeginning);
                ImagePreview.Picture.Graphic.LoadFromStream(S);
                S.Free;
        end;
end;
//---------------------------------------------------------------------
procedure TSEForm.RefaireProp();
var     ParamPanel:TSOParamPanel;
        ParamButton:TSOParamBouton;
        ParamLabel:TSOParamLabel;
        ParamCheck:TSOParamCheck;
        ParamList:TSOParamList;
begin
        case SENode.ImageIndex of
        0: begin
                SESkinObjet:=nil;
                PropEdit.Strings.clear;
                PropEdit.InsertRow('Nom',SENode.Text,true);
                PanelImage.Visible:=false;
                PanelOutils.Height:=0;
           end;
        1: begin
                PropEdit.Strings.clear;
                ParamPanel:=TSOParamPanel(TSkinObjet(SENode.Data).par);
                PropEdit.InsertRow('Nom',SENode.Text,true);
                PropEdit.InsertRow('Hauteur',inttostr(ParamPanel.hauteur),true);
                PropEdit.InsertRow('Largeur',inttostr(ParamPanel.largeur),true);
                PropEdit.InsertRow('Marge Haut',inttostr(ParamPanel.MargeH ),true);
                PropEdit.InsertRow('Marge Bas',inttostr(ParamPanel.MargeB ),true);
                PropEdit.InsertRow('Marge Droite',inttostr(ParamPanel.MargeD),true);
                PropEdit.InsertRow('Marge Gauche',inttostr(ParamPanel.MargeG),true);
                PropEdit.InsertRow('Couleur','$'+IntToHex(ParamPanel.Couleur,8),true);
                PanelImage.Color:=ParamPanel.Couleur;
                PanelImage.Visible:=true;
                PanelOutils.Height:=84;
           end;
        2: begin
                PropEdit.Strings.clear;
                ParamButton:=TSOParamBouton(TSkinObjet(SENode.Data).par);
                PropEdit.InsertRow('Nom',SENode.Text,true);
                PropEdit.InsertRow('Hauteur',inttostr(ParamButton.hauteur),true);
                PropEdit.InsertRow('Largeur',inttostr(ParamButton.largeur),true);
                PropEdit.InsertRow('Marge Haut',inttostr(ParamButton.MargeV),true);
                PropEdit.InsertRow('Marge Gauche',inttostr(ParamButton.MargeH),true);
                PropEdit.InsertRow('Couleur','$'+IntToHex(ParamButton.Couleur,8),true);
                PanelImage.Color:=ParamButton.Couleur;
                PanelImage.Visible:=true;
                PanelOutils.Height:=84;
           end;
        3: begin
                PropEdit.Strings.clear;
                ParamLabel:=TSOParamLabel(TSkinObjet(SENode.Data).par);
                PropEdit.InsertRow('Nom',SENode.Text,true);
                PropEdit.InsertRow('Hauteur',inttostr(ParamLabel.hauteur),true);
                PropEdit.InsertRow('Largeur',inttostr(ParamLabel.largeur),true);
                PropEdit.InsertRow('Marge Haut',inttostr(ParamLabel.MargeV),true);
                PropEdit.InsertRow('Marge Gauche',inttostr(ParamLabel.MargeH),true);
                PropEdit.InsertRow('1° Caractère',inttostr(byte(ParamLabel.Premier)),true);
                PropEdit.InsertRow('Colonnes',inttostr(ParamLabel.Colonnes),true);
                PropEdit.InsertRow('Lignes',inttostr(ParamLabel.Lignes),true);
                PropEdit.InsertRow('Couleur','$'+IntToHex(ParamLabel.Couleur,8),true);
                PropEdit.InsertRow('Couleur Texte','$'+IntToHex(ParamLabel.CouleurText,8),true);
                PanelImage.Color:=ParamLabel.Couleur;
                PanelImage.Visible:=true;
                PanelOutils.Height:=120;
           end;
        4: begin
                PropEdit.Strings.clear;
                ParamCheck:=TSOParamCheck(TSkinObjet(SENode.Data).par);
                PropEdit.InsertRow('Nom',SENode.Text,true);
                PropEdit.InsertRow('Hauteur',inttostr(ParamCheck.hauteur),true);
                PropEdit.InsertRow('Largeur',inttostr(ParamCheck.largeur),true);
                PropEdit.InsertRow('Marge Haut',inttostr(ParamCheck.MargeV),true);
                PropEdit.InsertRow('Marge Gauche',inttostr(ParamCheck.MargeH),true);
                PropEdit.InsertRow('Couleur','$'+IntToHex(ParamCheck.Couleur,8),true);
                PanelImage.Color:=ParamCheck.Couleur;
                PanelImage.Visible:=true;
                PanelOutils.Visible:=true;
                PanelOutils.Height:=84;
           end;
        5: begin
                PropEdit.Strings.clear;
                ParamList:=TSOParamList(TSkinObjet(SENode.Data).par);
                PropEdit.InsertRow('Nom',SENode.Text,true);
                PropEdit.InsertRow('Nombre',inttostr(ParamList.Nombre),true);
                PropEdit.InsertRow('Couleur','$'+IntToHex(ParamList.Couleur,8),true);
                PanelImage.Color:=ParamList.Couleur;
                PanelImage.Visible:=true;
                PanelOutils.Visible:=true;
                PanelOutils.Height:=84;
           end;
        end;
        RefaireImage;
end;
//---------------------------------------------------------------------
procedure TSEForm.SkinTreeChange(Sender: TObject; Node: TTreeNode);
begin
        PropEditValidate(Sender,PropEdit.Col,PropEdit.Row,PropEdit.Keys[PropEdit.Row],Propedit.Values[PropEdit.Keys[PropEdit.Row]]);

        SENode:=Node;
        SESkinObjet:=TSkinObjet(SENode.Data);
        RefaireProp;
end;
//---------------------------------------------------------------------
procedure TSEForm.IsPanelClick(Sender: TObject);
var     i:integer;
begin
        i:=1;
        while (SESkin.GetData('Panel'+inttostr(i))<>nil) do inc(i);

        modif:=true;

        SESkinObjet:=TSkinObjet.Create;
        SESkinObjet.nom:='Panel'+inttostr(i);
        SESkinObjet.typ:=SkPanel;
        SESkin.ObjList.Add(SESkinObjet);

        SENode:=SkinTree.Items.AddChild(SkinTree.Items.GetFirstNode,SESkinObjet.nom);

        SENode.ImageIndex:=1;
        SENode.SelectedIndex:=1;
        SENode.Data:=SESkinObjet;

        //On range les noeud par ordre
      //  SENode.Parent.AlphaSort(true);

        RefaireProp;
        SkinTree.Select(SENode,[]);
end;
//---------------------------------------------------------------------
procedure TSEForm.Inserer1Click(Sender: TObject);
begin
        //Quand l'editeur de valeur perds le focus on sauve la valeur
        PropEditValidate(Sender,PropEdit.Col,PropEdit.Row,PropEdit.Keys[PropEdit.Row],Propedit.Values[PropEdit.Keys[PropEdit.Row]]);

        IsBouton.Enabled:=SENode.ImageIndex<>0;
        IsLabel.Enabled:=SENode.ImageIndex<>0;
        IsCheck.Enabled:=SENode.ImageIndex<>0;
        IsList.Enabled:=SENode.ImageIndex<>0;
end;
//---------------------------------------------------------------------
procedure TSEForm.IsBoutonClick(Sender: TObject);
var     i:integer;
begin
        if SENode.ImageIndex<>1 then
                SENode:=SENode.Parent;

        modif:=true;

        i:=1;
        while (SESkin.GetData(SENode.Text+'\Bouton'+inttostr(i))<>nil) do inc(i);

        SESkinObjet:=TSkinObjet.Create;
        SESkinObjet.nom:=SENode.Text+'\Bouton'+inttostr(i);
        SESkinObjet.typ:=SkButton;
        SESkin.ObjList.Add(SESkinObjet);

        SENode:=SkinTree.Items.AddChild(SENode,ExtractFileName(SESkinObjet.nom));

        SENode.ImageIndex:=2;
        SENode.SelectedIndex:=2;
        SENode.Data:=SESkinObjet;

        //On range les noeud par ordre
    //    SENode.Parent.AlphaSort(true);

        RefaireProp;
        SkinTree.Select(SENode,[]);
end;
//---------------------------------------------------------------------
procedure TSEForm.IsLabelClick(Sender: TObject);
var     i:integer;
begin
        if SENode.ImageIndex<>1 then
                SENode:=SENode.Parent;

        modif:=true;

        i:=1;
        while (SESkin.GetData(SENode.Text+'\Label'+inttostr(i))<>nil) do inc(i);

        SESkinObjet:=TSkinObjet.Create;
        SESkinObjet.nom:=SENode.Text+'\Label'+inttostr(i);
        SESkinObjet.typ:=SkLabel;
        SESkin.ObjList.Add(SESkinObjet);

        SENode:=SkinTree.Items.AddChild(SENode,ExtractFileName(SESkinObjet.nom));

        SENode.ImageIndex:=3;
        SENode.SelectedIndex:=3;
        SENode.Data:=SESkinObjet;

        //On range les noeud par ordre
     //   SENode.Parent.AlphaSort(true);

        RefaireProp;
        SkinTree.Select(SENode,[]);
end;
//---------------------------------------------------------------------
procedure TSEForm.SauverClick(Sender: TObject);
begin
        if NomFichier='' then
                SauverSousClick(Sender)
        else
        begin
                SESkin.SaveToFile(NomFichier);
                modif:=false;
        end;
        if quit then close;
end;
//---------------------------------------------------------------------
procedure TSEForm.SauverSousClick(Sender: TObject);
begin
        with  TSaveDialog.Create(Application) do
                try
                        Title := 'Sauver Skin';
                        Filename := SESkin.nom + '.skn';
                        Filter := 'Fichier Skin (*.skn)|*.skn|Tout les Fichiers (*.*)|*.*';
                        HelpContext := 0;
                        Options := Options + [ofShowHelp, ofPathMustExist, ofFileMustExist];

                        if Execute then
                        begin
                                SESkin.SaveToFile(Filename);
                                NomFichier:=Filename;
                                modif:=false;
                                caption:=formcaption+' - '+ExtractFileName(NomFichier);
                        end;
                finally
                        Free;
                end;
end;
//---------------------------------------------------------------------
procedure TSEForm.QuitterClick(Sender: TObject);
begin
        self.Close();
end;
//---------------------------------------------------------------------
procedure TSEForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
        //Quand l'editeur de valeur perds le focus on sauve la valeur
        PropEditValidate(Sender,PropEdit.Col,PropEdit.Row,PropEdit.Keys[PropEdit.Row],Propedit.Values[PropEdit.Keys[PropEdit.Row]]);
        if modif then
        begin
                case MessageDlg('Voulez vous sauver avant de quitter ?',mtWarning,[mbYes, mbNo,mbCancel],0) of
                        mrCancel :Action := caNone;
                        mrYes : begin
                                        quit:=true;
                                        SauverClick(Sender);
                                end;
                end;
        end;

end;
//---------------------------------------------------------------------
procedure TSEForm.PropEditValidate(Sender: TObject; ACol, ARow: Integer;
  const KeyName, KeyValue: String);
var     ParamPanel:TSOParamPanel;
        ParamButton:TSOParamBouton;
        ParamLabel:TSOParamLabel;
        ParamCheck:TSOParamCheck;
        ParamList:TSOParamList;
        i:integer;
begin
        //on change le nom
        if KeyName='Nom' then
        begin
                //Pas de '/' dans le nom
                if  Pos('\',KeyValue)<>0 then
                begin
                        //si alors on restitue
                        if  SESkinObjet=nil then
                                PropEdit.Values['Nom']:=SESkin.nom
                        else
                                PropEdit.Values['Nom']:=SESkinObjet.nom;
                        //on sort
                        exit;
                end;

                if  SESkinObjet=nil then
                begin
                        // on est sur la racine
                        SESkin.nom:=KeyValue;
                        SENode.Text:=KeyValue;
                        //on sort
                        exit;
                end;

                //pas besoin de renomer alors on sort
                if (ExtractFileName(SESkinObjet.nom)=KeyValue) then exit;

                //Juste Mise en forme ?
                if (LowerCase(ExtractFileName(SESkinObjet.nom))<>LowerCase(KeyValue)) then
                begin
                        //non, nom deja existant ?
                        if SESkin.GetData(ExtractFilePath(SESkinObjet.nom)+KeyValue)=nil then
                        begin
                                //non alors c ok
                                //c'est un Panel ?
                                if ExtractFilePath(SESkinObjet.nom)='' then
                                begin
                                        //alors on renomme aussi les descendant
                                        for i:=0 to SENode.Count-1   do
                                                TSkinObjet(SENode.Items[i].Data).nom:=KeyValue+'\'+ExtractFileName(TSkinObjet(SENode.Items[i].Data).nom);
                                        //puis le panel
                                        SESkinObjet.nom:=KeyValue;
                                end
                                else
                                        // on renome juste l'objet
                                        SESkinObjet.nom:=ExtractFilePath(SESkinObjet.nom)+KeyValue;
                        end
                        else
                                //oui alors on le dit
                                begin
                                        MessageDlg('Nom deja existant.',mtError,[mbYes],0);
                                        PropEdit.Values['Nom']:=ExtractFileName(SESkinObjet.nom);
                                end;
                end
                else
                        //oui, alors on met en forme
                        SESkinObjet.nom:=ExtractFilePath(SESkinObjet.nom)+KeyValue;

                //on renome aussi le neud du treeview
                SENode.Text:=ExtractFileName(SESkinObjet.nom);

                //On range les noeud par ordre
             //   SENode.Parent.AlphaSort(true);

                //on sort
                exit;
        end;

        // Si on change un propriete autre que nom sur la racine on sort
        // ca ne devrait pas arriver !!!!!
        if  SESkinObjet=nil then exit;



        //traitement different pour chaque type
        case SESkinObjet.typ of
        SkPanel:begin
                        ParamPanel:=TSOParamPanel(TSkinObjet(SENode.Data).par);
                        try
                                if KeyName='Hauteur' then
                                        ParamPanel.hauteur:=strtoint(KeyValue);
                                if KeyName='Largeur' then
                                        ParamPanel.largeur:=strtoint(KeyValue);
                                if KeyName='Marge Haut' then
                                        ParamPanel.MargeH:=strtoint(KeyValue);
                                if KeyName='Marge Bas' then
                                        ParamPanel.MargeB:=strtoint(KeyValue);
                                if KeyName='Marge Droite' then
                                        ParamPanel.MargeD:=strtoint(KeyValue);
                                if KeyName='Marge Gauche' then
                                        ParamPanel.MargeG:=strtoint(KeyValue);
                                if KeyName='Couleur' then
                                        ParamPanel.Couleur:=StrToInt(KeyValue);
                                TSkinObjet(SENode.Data).par:=TSOParam(ParamPanel);
                        except
                                PropEdit.Values['Hauteur']:=inttostr(ParamPanel.hauteur);
                                PropEdit.Values['Largeur']:=inttostr(ParamPanel.largeur);
                                PropEdit.Values['Marge Haut']:=inttostr(ParamPanel.MargeH);
                                PropEdit.Values['Marge Bas']:=inttostr(ParamPanel.MargeB);
                                PropEdit.Values['Marge Droite']:=inttostr(ParamPanel.MargeD);
                                PropEdit.Values['Marge Gauche']:=inttostr(ParamPanel.MargeG);
                                PropEdit.Values['Couleur']:='$'+IntToHex(ParamPanel.Couleur,8);
                        end;
                        PanelImage.Color:=ParamPanel.Couleur;
                end;
        SkButton:begin
                        ParamButton:=TSOParamBouton(TSkinObjet(SENode.Data).par);
                        try
                                if KeyName='Hauteur' then
                                        ParamButton.hauteur:=strtoint(KeyValue);
                                if KeyName='Largeur' then
                                        ParamButton.largeur:=strtoint(KeyValue);
                                if KeyName='Marge Haut' then
                                        ParamButton.MargeV:=strtoint(KeyValue);
                                if KeyName='Marge Gauche' then
                                        ParamButton.MargeH:=strtoint(KeyValue);
                                if KeyName='Couleur' then
                                        ParamButton.Couleur:=StrToInt(KeyValue);
                                TSkinObjet(SENode.Data).par:=TSOParam(ParamButton);
                        except
                                PropEdit.Values['Hauteur']:=inttostr(ParamButton.hauteur);
                                PropEdit.Values['Largeur']:=inttostr(ParamButton.largeur);
                                PropEdit.Values['Marge Haut']:=inttostr(ParamButton.MargeV);
                                PropEdit.Values['Marge Gauche']:=inttostr(ParamButton.MargeH);
                                PropEdit.Values['Couleur']:='$'+IntToHex(ParamButton.Couleur,8);
                        end;
                        PanelImage.Color:=ParamButton.Couleur;
                end;
        SkLabel:begin
                        ParamLabel:=TSOParamLabel(TSkinObjet(SENode.Data).par);
                        try
                                if KeyName='Hauteur' then
                                        ParamLabel.hauteur:=strtoint(KeyValue);
                                if KeyName='Largeur' then
                                        ParamLabel.largeur:=strtoint(KeyValue);
                                if KeyName='Marge Haut' then
                                        ParamLabel.MargeV:=strtoint(KeyValue);
                                if KeyName='Marge Gauche' then
                                        ParamLabel.MargeH:=strtoint(KeyValue);
                                if KeyName='Couleur' then
                                        ParamLabel.Couleur:=StrToInt(KeyValue);
                                if KeyName='Couleur Texte' then
                                        ParamLabel.CouleurText:=StrToInt(KeyValue);
                                if KeyName='1° Caractère' then
                                begin
                                        if Length(KeyValue)=1 then
                                                ParamLabel.Premier:=PChar(KeyValue)[0]
                                        else
                                                ParamLabel.Premier:=char(byte(strtoint(KeyValue)));
                                        PropEdit.Values['1° Caractère']:=inttostr(byte(ParamLabel.Premier));
                                end;
                                if KeyName='Colonnes' then
                                begin
                                        ParamLabel.Colonnes:=StrToInt(KeyValue);
                                        PropEdit.Values['Colonnes']:=inttostr(ParamLabel.Colonnes);
                                end;
                                if KeyName='Lignes' then
                                begin
                                        ParamLabel.Lignes:=StrToInt(KeyValue);
                                        PropEdit.Values['Lignes']:=inttostr(ParamLabel.Lignes);
                                end;

                                TSkinObjet(SENode.Data).par:=TSOParam(ParamLabel);
                        except
                                PropEdit.Values['Hauteur']:=inttostr(ParamLabel.hauteur);
                                PropEdit.Values['Largeur']:=inttostr(ParamLabel.largeur);
                                PropEdit.Values['Marge Haut']:=inttostr(ParamLabel.MargeV);
                                PropEdit.Values['Marge Gauche']:=inttostr(ParamLabel.MargeH);
                                PropEdit.Values['1° Caractère']:=inttostr(byte(ParamLabel.Premier));
                                PropEdit.Values['Colonnes']:=inttostr(ParamLabel.Colonnes);
                                PropEdit.Values['Lignes']:=inttostr(ParamLabel.Lignes);
                                PropEdit.Values['Couleur']:='$'+IntToHex(ParamLabel.Couleur,8);
                                PropEdit.Values['Couleur Texte']:='$'+IntToHex(ParamLabel.CouleurText,8);
                        end;
                        PanelImage.Color:=ParamLabel.Couleur;
                end;
        SkCheck:begin
                        ParamCheck:=TSOParamCheck(TSkinObjet(SENode.Data).par);
                        try
                                if KeyName='Hauteur' then
                                        ParamCheck.hauteur:=strtoint(KeyValue);
                                if KeyName='Largeur' then
                                        ParamCheck.largeur:=strtoint(KeyValue);
                                if KeyName='Marge Haut' then
                                        ParamCheck.MargeV:=strtoint(KeyValue);
                                if KeyName='Marge Gauche' then
                                        ParamCheck.MargeH:=strtoint(KeyValue);
                                if KeyName='Couleur' then
                                        ParamCheck.Couleur:=StrToInt(KeyValue);
                                TSkinObjet(SENode.Data).par:=TSOParam(ParamCheck);
                        except
                                PropEdit.Values['Hauteur']:=inttostr(ParamCheck.hauteur);
                                PropEdit.Values['Largeur']:=inttostr(ParamCheck.largeur);
                                PropEdit.Values['Marge Haut']:=inttostr(ParamCheck.MargeV);
                                PropEdit.Values['Marge Gauche']:=inttostr(ParamCheck.MargeH);
                                PropEdit.Values['Couleur']:='$'+IntToHex(ParamCheck.Couleur,8);
                        end;
                        PanelImage.Color:=ParamCheck.Couleur;
                end;
        SkList:begin
                        ParamList:=TSOParamList(TSkinObjet(SENode.Data).par);
                        try
                                if KeyName='Nombre' then
                                        ParamList.Nombre:=strtoint(KeyValue);
                                if KeyName='Couleur' then
                                        ParamList.Couleur:=StrToInt(KeyValue);
                                TSkinObjet(SENode.Data).par:=TSOParam(ParamList);
                        except
                                PropEdit.Values['Nombre']:=inttostr(ParamList.Nombre);
                                PropEdit.Values['Couleur']:='$'+IntToHex(ParamList.Couleur,8);
                        end;
                        PanelImage.Color:=ParamList.Couleur;
                end;

        end;
end;
//---------------------------------------------------------------------
procedure TSEForm.PropEditKeyPress(Sender: TObject; var Key: Char);
begin
        if Key=chr(VK_RETURN) then
        begin
                PropEditValidate(Sender,PropEdit.Col,PropEdit.Row,PropEdit.Keys[PropEdit.Row],Propedit.Values[PropEdit.Keys[PropEdit.Row]]);
                modif:=true;
        end;
end;
//---------------------------------------------------------------------
procedure TSEForm.PropEditExit(Sender: TObject);
begin
        //Quand l'editeur de valeur perds le focus on sauve la valeur
        PropEditValidate(Sender,PropEdit.Col,PropEdit.Row,PropEdit.Keys[PropEdit.Row],Propedit.Values[PropEdit.Keys[PropEdit.Row]]);
end;
//---------------------------------------------------------------------
procedure TSEForm.Fichier1Click(Sender: TObject);
begin
        //Quand l'editeur de valeur perds le focus on sauve la valeur
        PropEditValidate(Sender,PropEdit.Col,PropEdit.Row,PropEdit.Keys[PropEdit.Row],Propedit.Values[PropEdit.Keys[PropEdit.Row]]);
end;
//---------------------------------------------------------------------
procedure TSEForm.BoutonOuvrirClick(Sender: TObject);
var     ParamPanel:TSOParamPanel;
        ParamButton:TSOParamBouton;
        ParamLabel:TSOParamLabel;
        ParamCheck:TSOParamCheck;
        ParamList:TSOParamList;
begin
        with TOpenPictureDialog.Create(Application) do
                try
                        Title := 'Charger une image';
                        Filename := '';
                        Filter := 'Fichier Image (*.bmp)|*.bmp|Tout les Fichiers (*.*)|*.*';
                        HelpContext := 0;
                        Options := Options + [ofShowHelp, ofPathMustExist, ofFileMustExist];

                        if Execute then
                                SESkinObjet.bmp.LoadFromFile(Filename);


                        case SESkinObjet.typ of
                        SkPanel:begin
                                ParamPanel:=TSOParamPanel(SESkinObjet.par);
                                ParamPanel.hauteur:=SESkinObjet.bmp.Height;
                                ParamPanel.largeur:=SESkinObjet.bmp.Width;
                                SESkinObjet.par:=TSOParam(ParamPanel);
                                end;
                        SkButton:begin
                                ParamButton:=TSOParamBouton(SESkinObjet.par);
                                ParamButton.hauteur:=SESkinObjet.bmp.Height;
                                ParamButton.largeur:=SESkinObjet.bmp.Width div 4;
                                SESkinObjet.par:=TSOParam(ParamButton);
                                end;
                        SkCheck:begin
                                ParamCheck:=TSOParamCheck(SESkinObjet.par);
                                ParamCheck.hauteur:=SESkinObjet.bmp.Height;
                                ParamCheck.largeur:=SESkinObjet.bmp.Width div 6;
                                SESkinObjet.par:=TSOParam(ParamCheck);
                                end;
                        SkLabel:begin
                                ParamLabel:=TSOParamLabel(SESkinObjet.par);

                                SESkinObjet.par:=TSOParam(ParamLabel);
                                end;
                        SkList:begin
                                ParamList:=TSOParamList(SESkinObjet.par);

                                SESkinObjet.par:=TSOParam(ParamList);
                                end;
                        end;
                        RefaireImage;
                        RefaireProp;
                finally
                        Free;
                end;
end;
//---------------------------------------------------------------------
procedure TSEForm.SkinTreeKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var     i:integer;
        tmp:TSkinObjet;
        ob:TSkinObjet;
begin
        if (Key=VK_DELETE) and (SESkinObjet<>nil) then
        begin
                Ob:=SESkinObjet;
                //je l'enleve de l'arbre
                SkinTree.Items.Delete(SENode);

                //si c un panel j'efface ses descendant de la skin
                if Ob.typ=SkPanel then
                begin
                        i:=0;
                        while (i<SESkin.ObjList.Count) do
                        begin;
                                tmp:=TSkinObjet(SESkin.ObjList.Items[i]);
                                if (tmp.typ<>SkPanel) and (ExtractFilePath(tmp.nom)=Ob.nom+'\')then
                                begin
                                        SESkin.ObjList.Delete(SESkin.ObjList.IndexOf(tmp));
                                        tmp.free;
                                end;
                                inc(i);
                        end;
                end;

                //j'efface l'objet de la skin
                SESkin.ObjList.Delete(SESkin.ObjList.IndexOf(Ob));
                //et je le detruit
                Ob.Free;
        end;
end;
//---------------------------------------------------------------------
procedure TSEForm.PanelOutilsResize(Sender: TObject);
begin
        BoutonOuvrir.Left:=(PanelOutils.Width-BoutonOuvrir.Width) div 2;
        BoutonTest.Left:=(PanelOutils.Width-BoutonTest.Width) div 2;
        BoutonGenerer.Left:=(PanelOutils.Width-BoutonGenerer.Width) div 2;
end;
//---------------------------------------------------------------------
procedure TSEForm.BoutonTestClick(Sender: TObject);
var F:TFormTest;
begin
        //Quand l'editeur de valeur perds le focus on sauve la valeur
        PropEditValidate(Sender,PropEdit.Col,PropEdit.Row,PropEdit.Keys[PropEdit.Row],Propedit.Values[PropEdit.Keys[PropEdit.Row]]);

        F:=TFormTest.Create(self);
                F.Chargeur.Skin:=SESkin;
                if SESkinObjet.typ=SkPanel then
                        F.Panel.SkinObjet:=SESkinObjet.nom
                else
                begin
                        F.Panel.SkinObjet:=TSkinObjet(SENode.Parent.Data).nom;
                        case SESkinObjet.typ of
                        SkButton: begin
                                        F.Button.SkinObjet:=SESkinObjet.nom;
                                        F.Button.visible:=true;
                                  end;
                        SkCheck:  begin
                                        F.Check.SkinObjet:=SESkinObjet.nom;
                                        F.Check.visible:=true;
                                  end;
                        SkLabel:  begin
                                        F.Lab.SkinObjet:=SESkinObjet.nom;
                                        F.Lab.Caption:='SkinTest';
                                        F.lab.visible:=true;
                                  end;
                        end;
                end;
                F.ShowModal;
                F.Chargeur.Skin:=nil;
        F.Free;
end;
//---------------------------------------------------------------------
procedure TSEForm.ImagePreviewMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var xc,yc:integer;
    c:TColor;

begin
        if ssleft in shift then
        begin
                xc:=x-((ImagePreview.Width-ImagePreview.Picture.Width) div 2);
                yc:=y-((ImagePreview.Height-ImagePreview.Picture.Height) div 2);

                c:=ImagePreview.Canvas.Pixels[xc,yc];
                if c<>-1 then
                        PropEditValidate(Sender,0,0,'Couleur','$'+IntToHex(c,8));
        end;
end;
//---------------------------------------------------------------------
procedure TSEForm.ImagePreviewMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var xc,yc:integer;
    c:TColor;
begin
        if ssleft in shift then
        begin
                xc:=x-((ImagePreview.Width-ImagePreview.Picture.Width) div 2);
                yc:=y-((ImagePreview.Height-ImagePreview.Picture.Height) div 2);
               // c:=GetPixel(ImagePreview.Canvas.Handle,xc,yc);
                c:=ImagePreview.Canvas.Pixels[xc,yc];
                if c<>-1 then
                begin
                        PropEditValidate(Sender,0,0,'Couleur','$'+IntToHex(c,8));
                        PropEdit.Values['Couleur']:='$'+IntToHex(c,8);
                end;
        end;
end;
//---------------------------------------------------------------------
procedure TSEForm.IsCheckClick(Sender: TObject);
var     i:integer;
begin
        if SENode.ImageIndex<>1 then
                SENode:=SENode.Parent;

        modif:=true;

        i:=1;
        while (SESkin.GetData(SENode.Text+'\Case'+inttostr(i))<>nil) do inc(i);

        SESkinObjet:=TSkinObjet.Create;
        SESkinObjet.nom:=SENode.Text+'\Case'+inttostr(i);
        SESkinObjet.typ:=SkCheck;
        SESkin.ObjList.Add(SESkinObjet);

        SENode:=SkinTree.Items.AddChild(SENode,ExtractFileName(SESkinObjet.nom));

        SENode.ImageIndex:=4;
        SENode.SelectedIndex:=4;
        SENode.Data:=SESkinObjet;

        //On range les noeud par ordre
      //  SENode.Parent.AlphaSort(true);

        RefaireProp;
        SkinTree.Select(SENode,[]);
end;
//---------------------------------------------------------------------
procedure TSEForm.IsListClick(Sender: TObject);
var     i:integer;
begin
        if SENode.ImageIndex<>1 then
                SENode:=SENode.Parent;

        modif:=true;

        i:=1;
        while (SESkin.GetData(SENode.Text+'\List'+inttostr(i))<>nil) do inc(i);

        SESkinObjet:=TSkinObjet.Create;
        SESkinObjet.nom:=SENode.Text+'\List'+inttostr(i);
        SESkinObjet.typ:=SkList;
        SESkin.ObjList.Add(SESkinObjet);

        SENode:=SkinTree.Items.AddChild(SENode,ExtractFileName(SESkinObjet.nom));

        SENode.ImageIndex:=5;
        SENode.SelectedIndex:=5;
        SENode.Data:=SESkinObjet;

        //On range les noeud par ordre
    //    SENode.Parent.AlphaSort(true);

        RefaireProp;
        SkinTree.Select(SENode,[]);
end;
//---------------------------------------------------------------------
procedure TSEForm.BoutonGenererClick(Sender: TObject);
var ParamLabel:TSOParamLabel;
    bmp:TBitmap;
    i,h,w:integer;
    Pal: TMaxLogPalette;
begin
        if FontDialog.Execute  then
        begin
                bmp:=TBitmap.Create;
                bmp.PixelFormat:=pf8bit;

                Pal.palVersion:=$300;
                Pal.palNumEntries:=2;
                Pal.palPalEntry[0].peRed:=GetRValue(FontDialog.Font.Color);
                Pal.palPalEntry[0].peGreen:=GetGValue(FontDialog.Font.Color);
                Pal.palPalEntry[0].peBlue:=GetBValue(FontDialog.Font.Color);
                Pal.palPalEntry[1].peRed:=$FF xor GetRValue(FontDialog.Font.Color);
                Pal.palPalEntry[1].peGreen:=$FF xor GetGValue(FontDialog.Font.Color);
                Pal.palPalEntry[1].peBlue:=$FF xor GetBValue(FontDialog.Font.Color);
                bmp.Palette:=CreatePalette(PLogPalette(@Pal)^);


                bmp.Canvas.Pen.Color:=FontDialog.Font.Color;
                bmp.Canvas.Brush.Color:=$FFFFFF xor FontDialog.Font.Color;
                bmp.Canvas.Brush.Style :=bsSolid;
                bmp.Canvas.Font:=FontDialog.Font;

                h:=0;
                w:=0;
                for i:=0 to 255 do
                begin
                        h:=max(h,bmp.Canvas.TextHeight(char(i))+2);
                        w:=max(w,bmp.Canvas.TextWidth(char(i))+2);
                end;

                bmp.Height:=16*(h+1)+1;
                bmp.Width:=16*(w+1)+1;

                bmp.Canvas.Rectangle(0,0,16*(w+1)+1,16*(h+1)+1);
                for i:=0 to 16 do
                begin
                        bmp.Canvas.MoveTo(0,i*(h+1));
                        bmp.Canvas.LineTo(16*(w+1)+1,i*(h+1));
                        bmp.Canvas.MoveTo(i*(w+1),0);
                        bmp.Canvas.LineTo(i*(w+1),16*(h+1)+1);
                end;
                for i:=0 to 255 do
                begin
                        bmp.Canvas.TextRect(Rect((i mod 16)*(w+1)+1,(i div 16)*(h+1)+1,(i mod 16)*(w+1)+w-1,(i div 16)*(h+1)+h-1),(i mod 16)*(w+1)+2,(i div 16)*(h+1)+2,char(i));
                end;

                ParamLabel:=TSOParamLabel(SESkinObjet.par);
                ParamLabel.Couleur:=$FFFFFF xor FontDialog.Font.Color;
                ParamLabel.Premier:=char(0);
                ParamLabel.Colonnes:=16;
                ParamLabel.Lignes:=16;
                SESkinObjet.par:=TSOParam(ParamLabel);
                SESkinObjet.bmp.Assign(bmp);
                bmp.Free;
                RefaireImage;
                RefaireProp;

        end;
end;
//---------------------------------------------------------------------


end.

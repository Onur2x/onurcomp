Package gestion complet de skin (avec editeur & exemple d'utilisation)----------------------------------------------------------------------
Url     : http://codes-sources.commentcamarche.net/source/30121-package-gestion-complet-de-skin-avec-editeur-exemple-d-utilisationAuteur  : GordoCabronDate    : 02/08/2013
Licence :
=========

Ce document intitulé « Package gestion complet de skin (avec editeur & exemple d'utilisation) » issu de CommentCaMarche
(codes-sources.commentcamarche.net) est mis à disposition sous les termes de
la licence Creative Commons. Vous pouvez copier, modifier des copies de cette
source, dans les conditions fixées par la licence, tant que cette note
apparaît clairement.

Description :
=============

J'en avait marre de toujours mettre en place le meme code a chaque fois que je v
ouslait faire une application un peu plus jolie que la moyenne, alors j'ai comme
ncer a cree quelques composants. La je me suis un peu emballe et apres quelque n
uit blanche j'ai deboucher sur un package complet (rapport a mon utilisation, on
 peu toujours rajouter!!!) de gestion de skin.
<br />
<br />  Le concept de ba
se, une skin=un fichier. Le fichier en question contient un descriptif des comos
ant visuelles present dans mon application avec les valeurs a leurs assignees. J
e source contient un editeur pour ce type de fichier.
<br />
<br />  Quand je 
cree un application, je cree une skin par defaut. Dans une form de l'application
 je cree un SkinChargeur qui sert justement a charger la skin pardefaut. Apres q
uoi je cree des composant skinable qui font reference a cette skin (cf applicati
on test).  Pour qu'une skin soit compatible il suffit qu'elle est le meme squele
tte.
<br />
<br />   Je sais c pas super clair mais en regardant l'application
 de test ca devrait s'eclairer, sinon cous reste plus qu'a demander.
<br />
<b
r />Merci pour votre temps ;)
<br /><a name='source-exemple'></a><h2> Source / 
Exemple : </h2>
<br /><pre class='code' data-mode='basic'>
unit main;

inte
rface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Contr
ols, Forms,
  Dialogs, SkinChargeur, SkinButton, SkinPanel, SkinLabel, SkinChec
k;

type
  TForm1 = class(TForm)
    SkinPanel1: TSkinPanel;
    SkinButton1: TSkinButton;
    SkinCheck1: TSkinCheck;
    SkinLabel1: TSkinLabel;
    SkinButton2: TSkinButton;
    OpenDialog1: TOpenDialog;
    SkinChargeur1: TSkinChargeur;
    procedure SkinCheck1Change(Sender: TObject);
    procedure SkinButton1Click(Sender: TObject);
    procedure SkinButton2Click(Sender: TObject);

    procedure FormCreate(Sender: TObject);
  private
    { Private declarati
ons }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;


implementation

{$R *.dfm}
//-----------------------------------------------
--------------------
procedure TForm1.SkinCheck1Change(Sender: TObject);
begin

        // Activation / desactivation des autres composants
        SkinButton1.Enabled:=not SkinCheck1.Etat;
        SkinButton2.Enabled:=not SkinCheck1.Etat;

        //changement du texte du label
        if not SkinCheck1.Etat then
                SkinLabel1.Caption:='Actif'
        else
                SkinLabel1.Caption:='Inactif';
end;
//-----------------------------------------
--------------------------
procedure TForm1.SkinButton1Click(Sender: TObject);

begin
        // action du bouton 1 : fermer
        Form1.close;
end;
//--
-----------------------------------------------------------------
procedure TFo
rm1.SkinButton2Click(Sender: TObject);
begin
        //action du bouton 2 : ch
oix d'une autre skin
        if OpenDialog1.Execute then
                SkinC
hargeur1.CompatibleLoadFromFile(OpenDialog1.FileName);
end;
//----------------
---------------------------------------------------
procedure TForm1.FormCreate
(Sender: TObject);
begin
        //au demarage changement de la couleur du tex
te
        //n'affectera que la skin par default
        SkinLabel1.Couleur:=c
lRed;
end;
//-----------------------------------------------------------------
--
end.
</pre>
<br /><a name='conclusion'></a><h2> Conclusion : </h2>
<br /
>mise a jour : aucune idee (mais disons : bientot !!!)
<br />
<br />bug : ca a
 l'air d'etre enfin stable mais bon la perfection ca n'existe pas.
<br />
<br 
/>truc a faire: 
<br />   - &quot;SkinCanvasCopy.pas&quot; c'est du bricolage p
rovisoire, si vous jetez un oeil soyez comprehensif
<br />   - Rajouter un comp
osant type barre de defilement

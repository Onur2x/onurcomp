unit main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, SkinChargeur, SkinButton, SkinPanel, SkinLabel, SkinCheck;

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
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}
//-------------------------------------------------------------------
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
//-------------------------------------------------------------------
procedure TForm1.SkinButton1Click(Sender: TObject);
begin
        // action du bouton 1 : fermer
        Form1.close;
end;
//-------------------------------------------------------------------
procedure TForm1.SkinButton2Click(Sender: TObject);
begin
        //action du bouton 2 : choix d'une autre skin
        if OpenDialog1.Execute then
                SkinChargeur1.CompatibleLoadFromFile(OpenDialog1.FileName);
end;
//-------------------------------------------------------------------
procedure TForm1.FormCreate(Sender: TObject);
begin
        //au demarage changement de la couleur du texte
        //n'affectera que la skin par default
        SkinLabel1.Couleur:=clRed;
end;
//-------------------------------------------------------------------
end.

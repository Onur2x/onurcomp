unit SkinEditor;
interface
//----------------------------------------------------------------
uses
   SysUtils,DesignEditors, DesignIntf, Dialogs, Forms, SkinPanel, Skin;
//----------------------------------------------------------------
  type
  TSkinEditor = class(TClassProperty)
  public
    //choix de l'affichae dans l'inspecteur
    function GetAttributes: TPropertyAttributes;  override;
    //on demande de choisir un fichier
    procedure Edit; override;
  end;
//----------------------------------------------------------------
implementation
//----------------------------------------------------------------
//----------------------------------------------------------------
//----------------------------------------------------------------
function TSkinEditor.GetAttributes: TPropertyAttributes;
  begin
      Result:= [paDialog];//on affiche les "..."
  end;
//----------------------------------------------------------------
procedure TSkinEditor.Edit;
var tmp:TSkin;
begin
  with TOpenDialog.Create(Application) do
    try
      Title := 'Load Skin ';
      Filename := '';
      Filter := 'Skin files (*.skn)|*.skn|All files (*.*)|*.*';
      HelpContext := 0;
      Options := Options + [ofShowHelp, ofPathMustExist, ofFileMustExist];

      if Execute then
      begin
              //fichier choisi
              tmp:=TSkin.Create;
              tmp.LoadFromFile(Filename);
              SetOrdValue(LongInt(tmp));
              designer.Modified;
      end;
    finally
      Free
    end;
end;
//----------------------------------------------------------------
end.

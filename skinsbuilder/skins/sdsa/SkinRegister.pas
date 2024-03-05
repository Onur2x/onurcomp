unit SkinRegister;
//----------------------------------------------------------------
interface
//----------------------------------------------------------------
uses
   Classes, DesignEditors, DesignIntf,
   Skin, SkinChargeur, SkinEditor,SkinImageList,
   SkinPanel,SkinButton,SkinCheck,SkinLabel;

//----------------------------------------------------------------
procedure Register;
//----------------------------------------------------------------
implementation
//----------------------------------------------------------------
procedure Register;
begin
  RegisterComponents('Skin Controls', [TSkinChargeur]);
  RegisterComponents('Skin Controls', [TSkinPanel]);
  RegisterComponents('Skin Controls', [TSkinButton]);
  RegisterComponents('Skin Controls', [TSkinLabel]);
  RegisterComponents('Skin Controls', [TSkinCheck]);
  RegisterComponents('Skin Controls', [TSkinImageList]);
  RegisterPropertyEditor(TypeInfo(TSkin),nil,'',TSkinEditor);
end;
//----------------------------------------------------------------
end.
 
{ This file was automatically created by Lazarus. Do not edit!
  This source is only used to compile and install the package.
 }

unit onur;

{$warn 5023 off : no warning about unused units}
interface

uses
  onurbutton, LazarusPackageIntf;

implementation

procedure Register;
begin
  RegisterUnit('onurbutton', @onurbutton.Register);
end;

initialization
  RegisterPackage('onur', @Register);
end.

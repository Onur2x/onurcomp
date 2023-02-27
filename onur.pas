{ This file was automatically created by Lazarus. Do not edit!
  This source is only used to compile and install the package.
 }

unit onur;

{$warn 5023 off : no warning about unused units}
interface

uses
  onurctrl, onurpanel, onuredit, onurpage, onurlist, onurbutton, onurbar, 
  LazarusPackageIntf;

implementation

procedure Register;
begin
  RegisterUnit('onurctrl', @onurctrl.Register);
  RegisterUnit('onurpanel', @onurpanel.Register);
  RegisterUnit('onuredit', @onuredit.Register);
  RegisterUnit('onurpage', @onurpage.Register);
  RegisterUnit('onurlist', @onurlist.Register);
  RegisterUnit('onurbutton', @onurbutton.Register);
  RegisterUnit('onurbar', @onurbar.Register);
end;

initialization
  RegisterPackage('onur', @Register);
end.

program SkinEdit;

{$MODE Delphi}

uses
  Forms, Interfaces,
  main in 'main.pas' {SEForm},
  test in 'test.pas' {FormTest};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TSEForm, SEForm);
  Application.Run;
end.

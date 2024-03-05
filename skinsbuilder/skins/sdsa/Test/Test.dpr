program Test;

uses
  Forms,
  main in 'main.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Skin Test';
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.

program Project1;

uses
  Forms,
  Unit1 in 'Unit1.pas' {Form1},
  resim in 'resim.pas',
  SkinIniFiles in 'SkinIniFiles.pas',
  oizleme in 'oizleme.pas' {Form2},
  resimkoy in 'resimkoy.pas' {Form3},
  bilesenim in 'bilesenim.pas',
  bilesenutil in 'bilesenutil.pas',
  skinana in 'skinana.pas',
  sikinkodu in 'sikinkodu.pas',
  sikinkaydi in 'sikinkaydi.pas',
  kontur in 'kontur.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TForm2, Form2);
  Application.CreateForm(TForm3, Form3);
  Application.Run;
end.
program RTOI;

uses
  Forms,
  Main in 'Main.pas' {wndMain},
  OI in '..\OI.PAS';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TwndMain, wndMain);
  Application.Run;
end.

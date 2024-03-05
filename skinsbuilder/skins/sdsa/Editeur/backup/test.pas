unit test;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, SkinChargeur, SkinCheck, SkinLabel, SkinButton, SkinPanel;

type
  TFormTest = class(TForm)
    Chargeur: TSkinChargeur;
    Panel: TSkinPanel;
    Button: TSkinButton;
    Lab: TSkinLabel;
    Check: TSkinCheck;
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;


implementation

{$R *.dfm}

procedure TFormTest.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
        if Key=VK_ESCAPE then
                self.Close;
        if Key=VK_SPACE then
        begin
                Button.Enabled:=not Button.Enabled;
                Check.Enabled:=not Check.Enabled;
        end;
end;

end.

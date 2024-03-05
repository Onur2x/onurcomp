unit SkinConvertForm;

interface

uses
  Windows, Messages, SysUtils, Classes, Controls, Forms, Dialogs, Menus,
  StdCtrls, ExtCtrls, Buttons, CheckLst, Graphics, ComCtrls, SkinConvert;

type

{ TSkinConverterForm }

  TConvForm = class(TForm)
    Image1: TImage;
    btnConvert: TBitBtn;
    btnClose: TBitBtn;
    Label1: TLabel;
    CompList: TCheckListBox;
    Bevel1: TBevel;
    Bevel2: TBevel;
    procedure FormCreate(Sender: TObject);
  private
  protected
  public
  end;

implementation

{$R *.DFM}

{ TSkinConverterForm }

procedure TConvForm.FormCreate(Sender: TObject);
var
  i: integer;
begin
  for i := 0 to CompList.Items.Count-1 do
    CompList.Checked[i] := true;
end;

end.

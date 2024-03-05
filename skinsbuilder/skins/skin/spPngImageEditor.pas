{*******************************************************************}
{                                                                   }
{       Almediadev Visual Component Library                         }
{       DynamicSkinForm                                             }
{       Version 12.55                                               }
{                                                                   }
{       Copyright (c) 2000-2012 Almediadev                          }
{       ALL RIGHTS RESERVED                                         }
{                                                                   }
{       Home:  http://www.almdev.com                                }
{       Support: support@almdev.com                                 }
{                                                                   }
{*******************************************************************}

unit spPngImageEditor;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, SkinCtrls, spPngImage, Buttons;

type
  TspPNGEditorForm = class(TForm)
    Button1: TButton;
    Button2: TButton;
    OD: TOpenDialog;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Label1: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    PaintPanel: TspskinPaintPanel;
    procedure PaintPanelOnPaint(Cnvs: TCanvas; R: TRect);
  public
    { Public declarations }
    FPngImage: TspPngImage;
  end;

var
  spPNGEditorForm: TspPNGEditorForm;

  procedure ExecutePngEditor(AEditImage: TspPngImage);

implementation

{$R *.DFM}

procedure ExecutePngEditor(AEditImage: TspPngImage);
var
  F: TspPNGEditorForm;
begin
  F := TspPNGEditorForm.Create(Application);
  F.Position := poScreenCenter;
  F.FPngImage.Assign(AEditImage);
  if F.ShowModal = mrOk
  then
    begin
      AEditImage.Assign(F.FPngImage);
    end;
  F.Free;
end;

procedure TspPNGEditorForm.FormCreate(Sender: TObject);
begin
  FPngImage := TspPngImage.Create;
  PaintPanel := TspSkinPaintPanel.Create(Self);
  PaintPanel.SetBounds(96, 8, 251, 251);
  PaintPanel.Parent := Self;
  PaintPanel.OnPanelPaint := PaintPanelOnPaint;
end;

procedure TspPNGEditorForm. PaintPanelOnPaint(Cnvs: TCanvas; R: TRect);
begin
 Cnvs.Brush.Color := clWhite;
 Cnvs.Brush.Style := bsSolid;
 Cnvs.FillRect(R);
 if not FPngImage.Empty
 then
   begin
     FPngImage.Draw(Cnvs, R);
   end;
end;

procedure TspPNGEditorForm.Button2Click(Sender: TObject);
begin
  FPngImage.Assign(nil);
  PaintPanel.RePaint;
  Label1.Caption := IntToStr(FPngImage.Width) + ' x ' + IntToStr(FPngImage.Height);
end;

procedure TspPNGEditorForm.Button1Click(Sender: TObject);
begin
  if OD.Execute
  then
    begin
      FPngImage.LoadFromFile(OD.FileName);
      PaintPanel.RePaint;
      Label1.Caption := IntToStr(FPngImage.Width) + ' x ' + IntToStr(FPngImage.Height); 
    end;
end;

procedure TspPNGEditorForm.BitBtn1Click(Sender: TObject);
begin
  ModalResult := mrOk;
end;

procedure TspPNGEditorForm.BitBtn2Click(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TspPNGEditorForm.FormDestroy(Sender: TObject);
begin
  FPngImage.Free;
end;

procedure TspPNGEditorForm.FormShow(Sender: TObject);
begin
  Label1.Caption := IntToStr(FPngImage.Width) + ' x ' + IntToStr(FPngImage.Height);
end;

end.

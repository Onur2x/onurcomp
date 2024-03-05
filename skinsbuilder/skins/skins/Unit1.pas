unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs,ExtCtrls, panelresim, Buttons, StdCtrls, ExtDlgs,resim,
  SkinIniFiles,skinana,sikinkodu,bilesenim;

type
  TForm1 = class(TForm)
    panelresimli5: Tpanel;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    Edit6: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Edit7: TEdit;
    Edit8: TEdit;
    Label7: TLabel;
    ComboBox1: TComboBox;
    Label8: TLabel;
    Label9: TLabel;
    ana: Tpanel;
    o1: Tpanel;
    o2: Tpanel;
    o3: Tpanel;
    o4: Tpanel;
    o5: Tpanel;
    o6: Tpanel;
    o7: Tpanel;
    o8: Tpanel;
    o9: Tpanel;
    o10: Tpanel;
    o11: Tpanel;
    o12: Tpanel;
    o14: Tpanel;
    transparent: TLabel;
    secili: TLabel;
    panelresimli1: Tpanel;
    Button1: TButton;
    Button2: TButton;
    ac: TSpeedButton;
    OpenPictureDialog1: TOpenPictureDialog;
    sayi: TLabel;
    ColorDialog1: TColorDialog;
    SpeedButton1: TSpeedButton;
    o13: Tpanel;
    Label12: TLabel;
    ComboBox2: TComboBox;
    Button3: TButton;
    Button4: TButton;
    Panel1: TPanel;
    Label10: TLabel;
    Label11: TLabel;
procedure SaveToStream(Stream: TStream);
 procedure resimduzeni(eleman:Tpanel);
procedure SaveObjectToStrings(SkinObject: Tpanel; Data: TscCustomIniFile);
  procedure Tasi(eleman:Tpanel);
  procedure yaz(eleman:Tpanel);
  procedure transparentyap(eleman:Tpanel);
    procedure o1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure o2MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure oMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure o4MouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure o5MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure o3MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure o6MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure o7MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure o8MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure o9MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure o10MouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure o11MouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure o13MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure o12MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure o14MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure o1Click(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure Edit2Change(Sender: TObject);
    procedure Edit3Change(Sender: TObject);
    procedure Edit4Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure acClick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure ComboBox2Change(Sender: TObject);
    procedure Button3Click(Sender: TObject);
   procedure Resimler(Images: TList);
    procedure Button2Click(Sender: TObject);
  private

    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  kod:TscCustomIniFile;
 ad,p,operator:String;
   i: byte;
   e:integer;
  ty:TscSkinSource;

const
Sign = 'MoonAndStar Skin Dosyas�';
Suyari='L�tfen Bu Dosyada Hi� Bir De�i�iklik Uygulamay�n Aksi Halde Skin Dosyas�n� �al��t�ramazs�n�z';
sImagesSection= 'Resimler';
sGeneralSection ='GENEL';
RE='onur.Msd';

implementation

uses oizleme, resimkoy,bilesenutil;

{$R *.dfm}
function PackImage(Resim: TBitmap): string;
var dst:TRect;
begin
//dst.Left
// Result := Resim.Name;
{  if (Resim.Rect.Right <> 0) and
     (Resim.Rect.Bottom <> 0) then  }
   if (dst.Right <> 0) and
     (dst.Bottom <> 0) then

  with dst do
  begin
    Result := ad + ',' + IntToStr(left)+','+IntToStr(top)+','+IntToStr(right)+','+IntToStr(bottom);
  end;
end;
procedure TForm1.resimler(Images: TList);
begin
{for i:=0 to FImages.Count-1 do
Images.Add(FImages.Items[i]);}
end;
procedure TForm1.o1MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
secili.Caption:='o1';
Tasi((FindComponent(Label10.Caption)as Tpanel));
yaz(o1);
sayi.Caption:=inttostr(1);
label11.Caption:=(FindComponent(Label10.Caption)as Tpanel).Name;
//SaveObjectToStrings(anapanel,kod);
end;
procedure TForm1.o2MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
//secili.Caption:='o2';Tasi(o2); yaz(o2);
sayi.Caption:=inttostr(2);
//SaveObjectToStrings(Baslik,kod);
end;
procedure Tform1.Tasi(eleman:Tpanel);
begin
//eleman.Name:=Label10.Caption;
 with eleman do begin
   ReleaseCapture;
   SendMessage(eleman.Handle,WM_SYSCOMMAND,SC_MOVE+1,0);
 end;
 end;


procedure TForm1.oMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
//secili.Caption:='o2';Tasi(o2);yaz(o2);
sayi.Caption:=inttostr(2);
//SaveObjectToStrings(Geributonu,kod);
end;

procedure TForm1.o4MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
//secili.Caption:='o4';Tasi(o4); yaz(o4);
sayi.Caption:=inttostr(4);
//SaveObjectToStrings(Duraklatbutonu,kod);
end;

procedure TForm1.o5MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
//secili.Caption:='o5';Tasi(o5);yaz(o5);
sayi.Caption:=inttostr(5);
//SaveObjectToStrings(Durdurbutonu,kod);
end;

procedure TForm1.o3MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
//secili.Caption:='o3';Tasi(o3); yaz(o3);
sayi.Caption:=inttostr(3);
//SaveObjectToStrings(Calbutonu,kod);
end;

procedure TForm1.o6MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
//secili.Caption:='o6';Tasi(o6);yaz(o6);
sayi.Caption:=inttostr(6);
//SaveObjectToStrings(ileriButonu,kod);
end;

procedure TForm1.o7MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
//secili.Caption:='o7';Tasi(o7);yaz(o7);
sayi.Caption:=inttostr(7);
//SaveObjectToStrings(Mutebutonu,kod);
end;

procedure TForm1.o8MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
// secili.Caption:='o8';Tasi(o8);yaz(o8);
 sayi.Caption:=inttostr(8);
// SaveObjectToStrings(SurekliButonu,kod);
end;

procedure TForm1.o9MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
//secili.Caption:='o9';Tasi(o9);yaz(o9);
sayi.Caption:=inttostr(9);
//SaveObjectToStrings(Karisikbutonu,kod);
end;

procedure TForm1.o10MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
//secili.Caption:='o10';Tasi(o10);yaz(o10);
sayi.Caption:=inttostr(10);
//SaveObjectToStrings(sarkipanelgoster,kod);
end;

procedure TForm1.o11MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
//secili.Caption:='o11';Tasi(o11);yaz(o11);
sayi.Caption:=inttostr(11);
//SaveObjectToStrings(ekopanelgoster,kod);
end;

procedure TForm1.o13MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
//secili.Caption:='o13';Tasi(o13);yaz(o13);
sayi.Caption:=inttostr(13);
//SaveObjectToStrings(Ekolayzirsec,kod);
end;

procedure TForm1.o12MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
//secili.Caption:='o12'; Tasi(o12);  yaz(o12);
sayi.Caption:=inttostr(12);
//SaveObjectToStrings(ekopanel,kod);
end;

procedure TForm1.o14MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
//secili.Caption:='o14';yaz(o14);Tasi(o14);
sayi.Caption:=inttostr(14);
//SaveObjectToStrings(listepanel,kod);
end;

procedure TForm1.o1Click(Sender: TObject);
begin
secili.Caption:='01';edit6.Enabled:=false; yaz(o1);
label11.Caption:=name;//(FindComponent(Label10.Caption)as Tpanel).Name;
label10.Caption:=name;
sayi.Caption:=inttostr(1);
//SaveObjectToStrings(Anaform,kod);
end;
procedure Tform1.yaz(eleman:Tpanel);
begin
edit1.Text:=IntToStr(eleman.Left);
edit2.Text:=IntToStr(eleman.top);
edit3.Text:=IntToStr(eleman.Height);
edit4.Text:=IntToStr(eleman.Width);
edit5.text:=ColorToString(ColorToRGB(eleman.Color));
edit7.Text:=ColorToString(ColorToRGB(transparent.Color));
edit8.Text:=eleman.Name;
end;
procedure TForm1.Edit1Change(Sender: TObject);
begin
if (Edit1.Text='') then exit;
(FindComponent(secili.Caption)as Tpanel).left:=strtoint(edit1.Text);

end;

procedure TForm1.Edit2Change(Sender: TObject);
begin
if (Edit2.Text='') then exit;
(FindComponent(secili.Caption)as TPanelResim).top:=strtoint(edit2.Text);

end;

procedure TForm1.Edit3Change(Sender: TObject);
begin
if (Edit3.Text='') then exit;
(FindComponent(secili.Caption)as TPanelResim).Height:=strtoint(edit3.Text);

end;

procedure TForm1.Edit4Change(Sender: TObject);
begin
if (Edit4.Text='') then exit;
(FindComponent(secili.Caption)as TPanelResim).Width:=strtoint(edit4.Text);

end;
procedure TForm1.FormCreate(Sender: TObject);
begin
p:=extractFilePath(application.ExeName)+'\';
e:=-1;
end;
function uyoket(dsy:string):string;  //uzanti yok ediliyor
var sonuc:string;
begin
sonuc:='';
sonuc:=copy(dsy,1,length(dsy)-length(extractfileext(dsy)) );
uyoket:=sonuc;
end;

function dyoket(dsy:string):string;  //uzanti ve klas�r yok ediliyor
var sonuc:string;
begin
sonuc:='';
sonuc:=copy(dsy,length(ExtractFilePath(dsy))+1,length(dsy)-length(ExtractFilePath(dsy))+1);
dyoket:=sonuc;
end;
procedure TForm1.acClick(Sender: TObject);
//var pdk:Tstream;
begin
if (secili.Caption='') or (sayi.Caption='') then begin
ShowMessage('L�tfen Resmi Koymak �stedi�iniz Elaman� Se�in');
exit; end else begin
if OpenPictureDialog1.Execute then
(FindComponent(secili.Caption)as Tpanel).Resim.LoadFromFile(OpenPictureDialog1.FileName);
edit6.Text:=OpenPictureDialog1.FileName;
//pdk:=TFileStream.Create(OpenPictureDialog1.FileName,fmOpenRead);
//Imagem := TksBmp.CreateFromStream(pdk);
//imagem.CreateFromStream(pdk);
//imagem.
ad:=dyoket(uyoket(OpenPictureDialog1.FileName));
//FImages.Add(imagem);
//imagem.Free;
//pdk.Free;
end;
end;
procedure Tform1.SaveObjectToStrings(SkinObject: Tpanel; Data: TscCustomIniFile);
begin
{var
ak,pa,ObjectName: string;
begin
 if SkinObject.Name = '' then Exit;
  with SkinObject do
  begin
if Transparent=true then ak:='Aktif' else ak:='Pasif';
if stili=normal then Pa:='Normal' ;
if stili=dose then Pa:='D��e' ;
if stili=ortala then Pa:='Kapla' ;
    ObjectName := Name;
    Data.WriteString(ObjectName, 'Renk',ColorToString(Color) );
    Data.WriteString(ObjectName, 'Sol', IntToStr(Left));
    Data.WriteString(ObjectName, '�st', IntToStr(Top));
    Data.WriteString(ObjectName, 'Geni�lik', IntToStr(Width));
    Data.WriteString(ObjectName, 'Y�kseklik', IntToStr(Height));
    Data.WriteString(ObjectName, 'Resim D�zeni',pa);
    Data.WriteString(ObjectName, 'Transparent',ak);
   if Imagem <> nil then
   Data.WriteString(ObjectName, 'Resim',PackImage(Resim.Bitmap));

 end;  }
  end;
procedure TForm1.SaveToStream(Stream: TStream);
begin{var
 SkinImage: TksBmp;
  SkinFile: TscStringsIniFile;
  Str: TStrings;
  i: integer;
  ObjectName:string;
begin
  { Save to file }
//  if csDesigning in ComponentState then Exit;

  { Save sign }
//  WriteString(Stream, Sign);
// WriteString(Stream, Suyari);
 { SkinFile := TscStringsIniFile.Create;
  try

    { Saving general data }
{    SkinFile.WriteString(sGeneralSection, 'Skin Ad�', SkinFile.FileName);
    SkinFile.WriteString(sGeneralSection, 'SkinVersion', '2');
    SkinFile.WriteString(sGeneralSection, 'Author', 'DENEEME');
    SkinFile.WriteString(sGeneralSection, 'AuthorEmail', 'MAil');
    SkinFile.WriteString(sGeneralSection, 'AuthorURL', 'Url');
       { Save skin images to config }
 {   for i := 0 to FImages.Count-1 do
    begin
      { Save bitmap to config }
{       SkinFile.WriteString(sImagesSection, TksBmp(FImages[i]).Name,
        TksBmp(FImages[i]).Name+'.bmp');
    end;
   { Saving skin objects }
{   for i := 0 to 13 do
SaveObjectToStrings((FindComponent('o'+inttostr(i+1))as Tpanel), SkinFile);
//       skinfile. WriteString(ObjectName, 'Resim Dosyas�',(FindComponent('o'+inttostr(i+1))as Tpanel).Resim.Bitmap.SaveToStream(stream));
   //  (FindComponent('o'+inttostr(i+1))as Tpanel).Resim.Bitmap.SaveToStream(stream);
  //     Stream.Position:=11;
    { Save to package }
{   SkinFile.SaveToStream(stream);
      { Save skin images }
{   for i := 0 to FImages.Count-1 do
   begin
      { Save bitmap to pack }
{     TksBmp(FImages[i]).SaveToStream(Stream);
    end;
  finally
    SkinFile.Free;
  end;}
end;


procedure TForm1.Button1Click(Sender: TObject);
//var
//packfile:Tstream;
begin
ty.SaveToFile(p+re);
{ PackFile := TFileStream.Create(p+re, fmCreate);
  try
SaveToStream(packfile);
  finally
   PackFile.Free;
 end;   }
end;

procedure TForm1.SpeedButton1Click(Sender: TObject);
begin
if secili.Caption='' then begin
ShowMessage('L�tfen Renklendirmek �stedi�iniz Elaman� Se�in');
exit; end else begin
if ColorDialog1.Execute then
(FindComponent(secili.Caption)as Tpanel).Color:=(ColorDialog1.Color);
end;
end;
procedure Tform1.transparentyap(eleman:Tpanel);
begin
if combobox1.itemindex=0 then eleman.transparent:=true else eleman.transparent:=false;
end;
procedure TForm1.ComboBox1Change(Sender: TObject);
begin
if secili.Caption='' then exit;
transparentyap((FindComponent(secili.caption)as Tpanel));
end;
procedure Tform1.resimduzeni(eleman:Tpanel);
begin
if combobox2.itemindex=0 then eleman.Stili:=Normal;
if combobox2.itemindex=1 then eleman.stili:=Dose;
if combobox2.itemindex=2 then eleman.stili:=Ortala;
end;
procedure TForm1.ComboBox2Change(Sender: TObject);
begin
if secili.Caption='' then exit;
resimduzeni((FindComponent(secili.caption)as Tpanel));
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
form2.showmodal;
end;

procedure TForm1.Button2Click(Sender: TObject);
var tt:TscSkinObject;
oo:TPanelresim;
begin
e:=e+1;
tt:=TscSkinObject.Create;
ty:=TscSkinSource.Create(self);
oo:=Tpanel.Create(Self);
With oo do begin
Parent:=Panel1;
Left:=0;
Top:=0;
Height:=20;
name:='Adsiz'+ inttostr(e);
label10.Caption:='Adsiz'+ inttostr(e);
OnMouseDown:=o1.OnMouseDown;// MouseDowntasi(sender,mbLeft,e);
OnClick:=o1.OnClick;
end;
With tt do begin
FTop:=0;
Fleft:=0;
FHeight:=40;
FWidth:=40;
Name:=oo.Name;
//FindObjectByKind(skForm);
//ty.Form.Parent:=tt;
Source:=ty;
end;
ty.Objects.Add(tt);
//ty.
//ty.Form.Assign(tt);// AddObject(tt);

//ty.Form.Create;
//ty.Form.Text:='Onur';
end;
end.
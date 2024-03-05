unit SkinObjet;

interface

uses Graphics,Classes, SysUtils,SkinType;
//----------------------------------------------------------------
type TSkinObjet = class
  public
    { Public declarations }
        nom:string;
        typ:TSkinType;
        par:TSOParam;
        bmp:TBitmap;
        constructor Create();
        destructor destroy();override;
        procedure vide();
end;
//----------------------------------------------------------------
implementation
//----------------------------------------------------------------
constructor TSkinObjet.Create();
begin
        typ:=SkNone;
        bmp:=TBitmap.Create;
end;
//----------------------------------------------------------------
destructor TSkinObjet.destroy();
begin
        bmp.Free;
        inherited destroy;
end;
//----------------------------------------------------------------
procedure TSkinObjet.vide();
begin
        bmp.Free;
        bmp:=TBitmap.Create;
end;
//----------------------------------------------------------------
end.

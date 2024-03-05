unit SkinType;

interface

uses Graphics;
//---------------------------------------------------------------------
type TSkinType = (SkNone,SkPanel,SkButton,SkLabel,SkCheck,SkList);
//---------------------------------------------------------------------
type TSOParam =array[0..39] of char;
//---------------------------------------------------------------------
type TSOParamPanel = record
        hauteur:integer;
        largeur:integer;
        MargeH:integer;
        MargeB:integer;
        MargeD:integer;
        MargeG:integer;
        Couleur:TColor;
        Sizeable:integer;
        fin:array[0..4] of char;
end;
//---------------------------------------------------------------------
type TSOParamBouton = record
        hauteur:integer;
        largeur:integer;
        MargeV:integer;
        MargeH:integer;
        Couleur:TColor;
        fin:array[0..16] of char;
end;
//---------------------------------------------------------------------
type TSOParamLabel = record
        hauteur:integer;
        largeur:integer;
        MargeV:integer;
        MargeH:integer;
        Premier:char;
        Colonnes:byte;
        Lignes:byte;
        Couleur:TColor;
        CouleurText:TColor;
        fin:array[0..9] of char;
end;
//---------------------------------------------------------------------
type TSOParamCheck = record
        hauteur:integer;
        largeur:integer;
        MargeV:integer;
        MargeH:integer;
        Couleur:TColor;
        fin:array[0..16] of char;
end;
//---------------------------------------------------------------------
type TSOParamList = record
        Nombre:byte;
        Couleur:TColor;
        fin:array[0..29] of char;
end;
//---------------------------------------------------------------------
implementation

end.

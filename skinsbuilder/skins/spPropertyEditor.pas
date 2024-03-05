unit spPropertyEditor;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Grids, SkinData, ExtCtrls;

type

  TspPropertyEditor = class;

  TspProperty = class(TObject)
  protected
    procedure SetValue(AValue: String);
    function GetValue: String;
  public
    PE: TspPropertyEditor;
    R, C: Integer;
    Name: String;
    PropertyType: String;
    property Value: String read GetValue write SetValue;
    constructor Create(AName, AValue: String; APT: String;
                       APE: TspPropertyEditor;
                       AC, AR: Integer);
  end;


  TspOnEditProperty = procedure (P: TspProperty) of object;

  TspPropertyEditor = class(TStringGrid)
  private
    { Private declarations }
  protected
    { Protected declarations }
    FOnEditProperty: TspOnEditProperty;
    CurProperty: TspProperty;
    ColorDlg: TColorDialog;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure EditProperty;
    procedure KeyPress(var Key: Char); override;
    procedure SetEditText(ACol, ARow: Integer; const Value: String); override;
    function GetCurProperty: TspProperty;
  public
    PropertyList: TList;
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure DeleteProperties(UpDate: Boolean);

    function GetPropertyValue(AName: String): String;
    function GetProperty(AName: String): TspProperty;

    procedure AddProperty(AName, AValue, APT: String);
    procedure AddIntProperty(AName: String; AValue: Integer; APT: String);
    procedure AddBolProperty(AName: String; AValue: Boolean; APT: String);
    procedure AddFSProperty(AName: String; AValue: TFontStyles; APT: String);
    procedure AddPointProperty(AName: String; AValue: TPoint; APT: String);
    procedure AddRectProperty(AName: String; AValue: TRect; APT: String);
    procedure AddAlignmentProperty(AName: String;
      AValue: TAlignment; APT: String);
    //
    function GetStrProperty(AName: String): String;
    function GetIntProperty(AName: String): Integer;
    function GetBolProperty(AName: String): Boolean;
    function GetFSProperty(AName: String): TFontStyles;
    function GetPointProperty(AName: String): TPoint;
    function GetRectProperty(AName: String): TRect;
    function GetAlignmentProperty(AName: String): TAlignment;

  published
    { Published declarations }
    property OnEditProperty: TspOnEditProperty
      read FOnEditProperty write FOnEditProperty;
  end;

  function GetBoolean(S: String): Boolean;
  function SetBoolean(B: Boolean): String;
  function GetPoint(S: String): TPoint;
  function SetPoint(P: TPoint): String;
  function GetRect(S: String): TRect;
  function SetRect(R: TRect): String;
  function GetFontStyle(S: String): TFontStyles;
  function SetFontStyle(FS: TFontStyles): String;
  function GetInteger(S: String): Integer;
  function SetInteger(I: Integer): String;
  function GetAlignment(S: String): TAlignment;
  function SetAlignment(A: TAlignment): String;

procedure Register;

implementation

const
    nums = '1234567890';
    symbols = ', ';

function GetAlignment(S: String): TAlignment;
begin
  Result := tacenter;
  if S = 'taleftjustify' then Result := taleftjustify else
  if S = 'tarightjustify' then Result := tarightjustify;
end;

function SetAlignment(A: TAlignment): String;
begin
  Result := 'tacenter';
  if A = taleftjustify then Result := 'taleftjustify' else
  if A = tarightjustify then Result := 'tarightjustify';
end;

function GetBoolean(S: String): Boolean;
begin
  if (S = '') or (S = '0')
  then Result := False else Result := True;
end;

function SetBoolean(B: Boolean): String;
begin
  if B then Result := '1' else Result := '0';
end;

function GetPoint(S: String): TPoint;
var
  i, j: Integer;
  S1: String;
  SA: array[1..2] of String;
begin
  S1 := '';
  j := 1;
  for i := 1 to Length(S) do
  begin
    if S[i] = ','
    then
      begin
        SA[j] := S1;
        S1 := '';
        Inc(j);
      end
    else
      if Pos(S[i], nums) <> 0 then S1 := S1 + S[i];
  end;
  SA[j] := S1;
  Result := Point(StrToInt(SA[1]), StrToInt(SA[2]));;
end;

function SetPoint(P: TPoint): String;
begin
  Result := IntToStr(P.X) + ',' + IntToStr(P.Y);
end;

function GetRect(S: String): TRect;
var
  i, j: Integer;
  S1: String;
  SA: array[1..4] of String;
begin
  S1 := '';
  j := 1;
  for i := 1 to Length(S) do
  begin
    if S[i] = ','
    then
      begin
        SA[j] := S1;
        S1 := '';
        Inc(j);
      end
    else
      if Pos(S[i], nums) <> 0 then S1 := S1 + S[i];
  end;
  SA[j] := S1;
  Result := Rect(StrToInt(SA[1]), StrToInt(SA[2]),
                 StrToInt(SA[3]), StrToInt(SA[4]));
end;

function SetRect(R: TRect): String;
begin
  Result := IntToStr(R.Left) + ',' +
    IntToStr(R.Top) + ',' + IntToStr(R.Right) + ',' +
    IntToStr(R.Bottom);
end;

function GetFontStyle(S: String): TFontStyles;
var
  FS: TFontStyles;
begin
  FS := [];
  if Pos('fsbold', S) <> 0 then FS := FS + [fsBold];
  if Pos('fsitalic', S) <> 0 then FS := FS + [fsItalic];
  if Pos('fsunderline', S) <> 0 then FS := FS + [fsUnderline];
  if Pos('fsstrikeout', S) <> 0 then FS := FS + [fsStrikeOut];
  Result := FS;
end;

function SetFontStyle(FS: TFontStyles): String;
var
  S: String;
begin
  S := '';
  if fsBold in FS then S := S + 'fsbold';
  if fsItalic in FS
  then
    begin
      if Length(S) > 0 then S := S + ',';
      S := S + 'fsitalic';
    end;
  if fsUnderline in FS
  then
    begin
      if Length(S) > 0 then S := S + ',';
      S := S + 'fsunderline';
    end;
  if fsStrikeOut in FS
  then
    begin
      if Length(S) > 0 then S := S + ',';
      S := S + 'fsstrikeout';
    end;
  Result := S;  
end;

function GetInteger(S: String): Integer;
var
  Code: Integer;
  I: Integer;
begin
  Val(S, I, Code);
  if code = 0 then Result := I else Result := 0;
end;

function SetInteger(I: Integer): String;
begin
  Result := IntToStr(I);
end;

procedure Register;
begin
  RegisterComponents('Samples', [TspPropertyEditor]);
end;

constructor TspProperty.Create;
begin
  Name := AName;
  PropertyType := APT;
  PE := APE;
  R := AR;
  C := AC;
  PE.Cells[C, R] := AValue;
  PE.Cells[C - 1, R] := Name;
end;

function TspProperty.GetValue;
begin
  Result := PE.Cells[C, R];
end;

procedure TspProperty.SetValue;
begin
  PE.Cells[C, R] := AValue;
end;

constructor TspPropertyEditor.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ColCount := 2;
  RowCount := 2;
  FixedRows := 1;
  FixedCols := 1;
  PropertyList := TList.Create;
  CurProperty := nil;
  DefaultColWidth := 150;
  ColorDlg := TColorDialog.Create(Self);
end;

destructor TspPropertyEditor.Destroy;
begin
  DeleteProperties(False);
  PropertyList.Free;
  ColorDlg.Free;
  inherited;
end;

procedure TspPropertyEditor.DeleteProperties;
var
  i: Integer;
begin
  for i := 0 to PropertyList.Count - 1 do
   TspProperty(PropertyList.Items[i]).Free;
  PropertyList.Clear;
  if UpDate
  then
    begin
      RowCount := 2;
      Cells[0, 0] := '';
      Cells[1, 1] := '';
      Cells[0, 1] := '';
    end;
end;

procedure TspPropertyEditor.AddProperty;
var
  AR, AC: Integer;
begin
  AC := 1;
  if PropertyList.Count <> 0 then RowCount := RowCount + 1;
  AR := RowCount - 1;
  PropertyList.Add(TspProperty.Create(AName, AValue, APT, Self, AC, AR));
end;

procedure TspPropertyEditor.MouseUp;
var
  C, R: Integer;
begin
  inherited;
  if Button = mbLeft
  then
    begin
      MouseToCell(X, Y, C, R);
      if (C > FixedCols - 1) and (R > FixedRows - 1)
      then
       EditProperty;
    end;   
end;

procedure TspPropertyEditor.KeyPress(var Key: Char);
begin
  if Key = #13 then EditProperty;
  inherited;
end;

procedure TspPropertyEditor.SetEditText;
var
  i: Integer;
  Code: Integer;
begin
  inherited;
  if (CurProperty <> nil) and (CurProperty.PropertyType = 'int')
     and (Value <> '') and (Value <> '-')
  then
    begin
      Val(Value, I, Code);
      if Code <> 0 then MessageDlg('Invalid format!', mtError, [mbOk], 0);
    end;
end;

function TspPropertyEditor.GetCurProperty;
var
  i, j: Integer;
begin
  j := -1;
  for i := 0 to PropertyList.Count - 1 do
    with TspProperty(PropertyList.Items[i]) do
      if (R = Row) and (C = Col)
      then
        begin
          j := i;
          Break;
        end;
  if j <> -1
  then Result := TspProperty(PropertyList.Items[j])
  else Result := nil;
end;

procedure TspPropertyEditor.EditProperty;
begin
  inherited;
  CurProperty := GetCurProperty;
  if (CurProperty <> nil) and ((CurProperty.PropertyType = 'int') or
     (CurProperty.PropertyType = 'string'))
  then
    Options := Options + [goEditing]
  else
    begin
      Options := Options - [goEditing];
      if (CurProperty <> nil) then
      begin
        if CurProperty.PropertyType = 'color'
        then
          begin
           ColorDlg.Color := StrToInt(CurProperty.Value);
           if ColorDlg.Execute
           then
             CurProperty.Value := IntToStr(ColorDlg.Color);
          end
        else
        if CurProperty.PropertyType = 'boolean'
        then
          begin
            if CurProperty.Value = '0'
            then CurProperty.Value := '1' else CurProperty.Value := '0';
          end
        else
        if CurProperty.PropertyType = 'alignment'
        then
          begin
            if CurProperty.Value = 'tacenter'
            then CurProperty.Value := 'taleftjustify' else
            if CurProperty.Value = 'taleftjustify'
            then CurProperty.Value := 'tarightjustify' else
            if CurProperty.Value = 'tarightjustify'
            then CurProperty.Value := 'tacenter';
          end;
      end;
    end;
  if (CurProperty <> nil) and Assigned(FOnEditProperty)
  then FOnEditProperty(CurProperty);
end;

function TspPropertyEditor.GetProperty;
var
  i: Integer;
begin
  Result := nil;
  for i := 0 to PropertyList.Count - 1 do
  with TspProperty(PropertyList.Items[i]) do
  if Name = AName
  then
    begin
      Result := TspProperty(PropertyList.Items[i]);
      Break;
    end;
end;

function TspPropertyEditor.GetPropertyValue;
var
  i: Integer;
begin
  Result := '';
  for i := 0 to PropertyList.Count - 1 do
  with TspProperty(PropertyList.Items[i]) do
  if Name = AName
  then
    begin
      Result := Value;
      Break;
    end;
end;

procedure TspPropertyEditor.AddIntProperty;
begin
  AddProperty(AName, SetInteger(AValue), APT);
end;

procedure TspPropertyEditor.AddBolProperty;
begin
  AddProperty(AName, SetBoolean(AValue), APT);
end;

procedure TspPropertyEditor.AddFSProperty;
begin
  AddProperty(AName, SetFontStyle(AValue), APT);
end;

procedure TspPropertyEditor.AddPointProperty;
begin
  AddProperty(AName, SetPoint(AValue), APT);
end;

procedure TspPropertyEditor.AddRectProperty;
begin
  AddProperty(AName, SetRect(AValue), APT);
end;

procedure TspPropertyEditor.AddAlignmentProperty;
begin
  AddProperty(AName, SetAlignment(AValue), APT);
end;

function TspPropertyEditor.GetStrProperty;
begin
  Result := GetPropertyValue(AName);
end;

function TspPropertyEditor.GetIntProperty;
begin
  Result := GetInteger(GetPropertyValue(AName));
end;

function TspPropertyEditor.GetBolProperty;
begin
  Result := GetBoolean(GetPropertyValue(AName));
end;

function TspPropertyEditor.GetFSProperty;
begin
  Result := GetFontStyle(GetPropertyValue(AName));
end;

function TspPropertyEditor.GetPointProperty;
begin
  Result := GetPoint(GetPropertyValue(AName));
end;

function TspPropertyEditor.GetRectProperty;
begin
  Result := GetRect(GetPropertyValue(AName));
end;

function TspPropertyEditor.GetAlignmentProperty;
begin
  Result := GetAlignment(GetPropertyValue(AName));
end;

end.

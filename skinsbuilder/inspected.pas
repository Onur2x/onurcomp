unit inspected;

{$mode ObjFPC}{$H+}

interface
uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  ComCtrls, onurbutton,TypInfo,messages,LCLType,ValEdit,LResources;

 Type
   TsInspectorMode = (imWorkbook, imWorksheet, imCellValue, imCellProperties,
    imRow, imCol);

  {@@ Inspector expanded nodes }
  TsInspectorExpandedNode = (ienFormatSettings, ienConditionalFormats,
    ienPageLayout, ienFonts, ienFormats, ienEmbeddedObj, ienImages,
    ienCryptoInfo);
  TsInspectorExpandedNodes = set of TsInspectorExpandedNode;


 { TsSpreadsheetInspector }

 TOInspector = class(TValueListEditor)
  private
    FWorkbookSource:TONCustomControl;
    FWorkbookSource1:TONGraphicControl;
    FCurrRow, FCurrCol: Integer;
    function GetOcustomControl: TONCustomControl;
    function GetOgraphicControl: TONGraphicControl;
     procedure SetExpanded(AValue: TsInspectorExpandedNodes);
    procedure SetMode(AValue: TsInspectorMode);
    procedure SetOcustomControl(AValue: TONCustomControl);
    procedure SetOgraphicControl(AValue: TONGraphicControl);

  protected
    procedure DblClick; override;
    procedure DoUpdate; virtual;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
//    procedure UpdateCellValue(ACell: PCell; AStrings: TStrings); virtual;
//    procedure UpdateCellProperties(ACell: PCell; AStrings: TStrings); virtual;
//    procedure UpdateCol(ACol: Integer; AStrings: TStrings); virtual;
//    procedure UpdateFormatProperties(AFormatIndex: integer; AStrings: TStrings); virtual;
//    procedure UpdateRow(ARow: Integer; AStrings: TStrings); virtual;
    procedure UpdateOcustomControl(AWorkbook: TONCustomControl; AStrings: TStrings); virtual;
    procedure UpdateOgraphicControl(AWorkbook: TONGraphicControl; AStrings: TStrings); virtual;

//    procedure UpdateWorksheet(ASheet: TsWorksheet; AStrings: TStrings); virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
//    procedure ListenerNotification(AChangedItems: TsNotificationItems;
//      AData: Pointer = nil);
    procedure RemoveWorkbookSource;
    {@@ Refers to the underlying workbook which is displayed by the inspector. }
//    property ONCustomControl: TONCustomControl read GetOcustomControl;
    {@@ Refers to the underlying worksheet which is displayed by the inspector. }
//    property ONGraphicControl: TONGraphicControl read GetOgraphicControl;
  published
    property ONCustomControl: TONCustomControl read GetOcustomControl  write SetOcustomControl;
    property ONGraphicControl: TONGraphicControl read GetOgraphicControl  write SetOgraphicControl;
    {@@ Refers to the underlying worksheet from which the active cell is taken }
//    property WorkbookSource: TsWorkbookSource read FWorkbookSource write SetWorkbookSource;
    {@@ Classification of data displayed by the SpreadsheetInspector. Each mode
      can be assigned to a tab of a TabControl. }
 //   property Mode: TsInspectorMode read FMode write SetMode;
    {@@ inherited from TValueListEditor, activates column titles and automatic
      column width adjustment by default }
    property DisplayOptions default [doColumnTitles, doAutoColResize];
    {@@ Displays subproperties }
//    property ExpandedNodes: TsInspectorExpandedNodes
//      read FExpanded write SetExpanded
//      default [ienFormatSettings, ienConditionalFormats, ienPageLayout,
 //              ienFonts, ienFormats, ienEmbeddedObj, ienImages, ienCryptoInfo];
    {@@ inherited from TValueListEditor. Turns of the fixed column by default}
 //   property FixedCols default 0;
    {@@ inherited from TStringGrid, but not published in TValueListEditor. }
    property ExtendedColSizing;
  end;
 implementation


constructor TOInspector.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  DisplayOptions := DisplayOptions - [doKeyColFixed];
  FixedCols := 0;
//  FExpanded := [ienFormatSettings, ienConditionalFormats, ienPageLayout,
//    ienFonts, ienFormats, ienEmbeddedObj, ienImages, ienCryptoInfo];
  with (TitleCaptions as TStringList) do begin
    OnChange := nil;        // This fixes an issue with Laz 1.0
    Clear;
    Add('Properties');
    Add('Values');
    OnChange := @TitlesChanged;
  end;
end;


{@@ ----------------------------------------------------------------------------
  Destructor of the spreadsheet inspector. Removes itself from the
  WorkbookSource's listener list.
-------------------------------------------------------------------------------}
destructor TOInspector.Destroy;
begin
 // if FWorkbookSource <> nil then FWorkbookSource.RemoveListener(self);
  inherited Destroy;
end;

{@@ ----------------------------------------------------------------------------
  Double-click on an expandable line expands or collapsed the sub-items
-------------------------------------------------------------------------------}
procedure TOInspector.DblClick;
var
  s: String;
  expNodes: TsInspectorExpandedNodes;
begin
//  expNodes := FExpanded;
  s := Cells[0, Row];
  if (pos('FormatSettings', s) > 0) or (pos('Format settings', s) > 0) then
  begin
    if (ienFormatSettings in expNodes)
      then Exclude(expNodes, ienFormatSettings)
      else Include(expNodes, ienFormatSettings);
  end else
  if (pos('Conditional formats', s) > 0) or (pos('ConditionalFormats', s) > 0) then
  begin
    if (ienConditionalFormats in expNodes)
      then Exclude(expNodes, ienConditionalFormats)
      else Include(expNodes, ienConditionalFormats);
  end else
  if (pos('Page layout', s) > 0) or (pos('PageLayout', s) > 0) then
  begin
    if (ienPageLayout in expNodes)
      then Exclude(expNodes, ienPageLayout)
      else Include(expNodes, ienPageLayout);
  end else
  if (pos('Images', s) > 0) then
  begin
    if (ienEmbeddedObj in expNodes)
      then Exclude(expNodes, ienEmbeddedObj)
      else Include(expNodes, ienEmbeddedObj);
    if (ienImages in expNodes)
      then Exclude(expNodes, ienImages)
      else Include(expNodes, ienImages);
  end else
  if (pos('Fonts', s) > 0) then
  begin
    if (ienFonts in expNodes)
      then Exclude(expNodes, ienFonts)
      else Include(expNodes, ienFonts);
  end else
  if (pos('Cell formats', s) > 0) then
  begin
    if (ienFormats in expNodes)
      then Exclude(expNodes, ienFormats)
      else Include(expNodes, ienFormats);
  end else
  if (pos('CryptoInfo', s) > 0) then
  begin
    if (ienCryptoInfo in expNodes)
      then Exclude(expNodes, ienCryptoInfo)
      else Include(expNodes, ienCryptoInfo);
  end else
    exit;
  SetExpanded(expNodes);
end;

{@@ ----------------------------------------------------------------------------
  Updates the data shown by the inspector grid. Display depends on the FMode
  setting (workbook, worksheet, cell values, cell properties).
-------------------------------------------------------------------------------}
procedure TOInspector.DoUpdate;
var
 // cell: PCell;
 // sheet: TsWorksheet;
//  book: TsWorkbook;
  list: TStringList;
begin

//  if FWorkbookSource <> nil then
//  begin
 //   book := FWorkbookSource.Workbook;
 //   sheet := FWorkbookSource.Worksheet;
 //   if sheet <> nil then begin
//      FCurrRow := sheet.ActiveCellRow;
//      FCurrCol := sheet.ActiveCellCol;
//      cell := sheet.FindCell(FCurrRow, FCurrCol);
 //   end;
//  end;

  list := TStringList.Create;
  try
    if FWorkbookSource <> nil then
     UpdateOcustomControl(ONCustomControl,list)
    else
     UpdateOgraphicControl(ONGraphicControl,list);

 //   case FMode of
 //     imCellValue      : UpdateCellValue(cell, list);
//      imCellProperties : UpdateCellProperties(cell, list);
//      imWorksheet      : UpdateWorksheet(sheet, list);
//      imWorkbook       : UpdateWorkbook(book, list);
//      imRow            : UpdateRow(FCurrRow, list);
//      imCol            : UpdateCol(FCurrCol, list);
//    end;
    Strings.Assign(list);
  finally
    list.Free;
  end;
end;


function TOInspector.GetOcustomControl: TONCustomControl;
begin
   if FWorkbookSource <> nil then
    Result := FWorkbookSource
  else
    Result := nil;
end;

function TOInspector.GetOgraphicControl: TONGraphicControl;
begin
    if FWorkbookSource1 <> nil then
    Result := FWorkbookSource1
  else
    Result := nil;
end;

{procedure TsSpreadsheetInspector.ListenerNotification(
  AChangedItems: TsNotificationItems; AData: Pointer = nil);
begin
  case FMode of
    imWorkbook:
      if ([lniWorkbook, lniWorksheet]*AChangedItems <> []) then
        DoUpdate;
    imWorksheet:
      if ([lniWorksheet, lniSelection, lniWorksheetZoom]*AChangedItems <> []) then
        DoUpdate;
    imCellValue, imCellProperties:
      if ([lniCell, lniSelection]*AChangedItems <> []) then
        DoUpdate;
    imRow:
      begin
        if ([lniSelection] * AChangedItems <> []) then begin
          if AData <> nil then
            FCurrRow := PCell(AData)^.Row;
        end else if ([lniRow] * AChangedItems <> []) then
          FCurrRow := {%H-}PtrInt(AData)
        else
          exit;
        DoUpdate;
      end;
    imCol:
      begin
        if ([lniSelection] * AChangedItems <> []) then begin
          if AData <> nil then
            FCurrCol := PCell(AData)^.Col;
        end else if ([lniCol] * AChangedItems <> []) then
          FCurrCol := {%H-}PtrInt(AData)
        else
          exit;
        DoUpdate;
      end;
  end;
end;
}
{@@ ----------------------------------------------------------------------------
  Standard component notification method called when the WorkbookSource
  is deleted.
-------------------------------------------------------------------------------}
procedure TOInspector.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
 { if (Operation = opRemove) and (AComponent = FWorkbookSource) then
    SetWorkbookSource(nil);
  }
end;

{@@ ----------------------------------------------------------------------------
  Removes the link of the SpreadsheetInspector to the WorkbookSource.
  Required before destruction.
-------------------------------------------------------------------------------}
procedure TOInspector.RemoveWorkbookSource;
begin
  SetOcustomControl(nil);
  SetOgraphicControl(nil);
end;



{@@ ----------------------------------------------------------------------------
  Setter method for the Expanded property
-------------------------------------------------------------------------------}
procedure TOInspector.SetExpanded(AValue: TsInspectorExpandedNodes);
begin
//  if AValue = FExpanded then
//    exit;
//  FExpanded := AValue;
  DoUpdate;
end;

{@@ ----------------------------------------------------------------------------
  Setter method for the Mode property. This property filters groups of properties
  for display (workbook-, worksheet-, cell value- or cell formatting-related
  data).
-------------------------------------------------------------------------------}
procedure TOInspector.SetMode(AValue: TsInspectorMode);
begin
//  if AValue = FMode then
//    exit;
//  FMode := AValue;
  DoUpdate;
end;

procedure TOInspector.SetOcustomControl(AValue: TONCustomControl);
begin
    if AValue = FWorkbookSource then
       exit;
//     if FWorkbookSource <> nil then
//       FWorkbookSource.RemoveListener(self);
     FWorkbookSource := AValue;
//     if FWorkbookSource <> nil then
//       FWorkbookSource.AddListener(self);
 //    ListenerNotification([lniWorkbook, lniWorksheet, lniSelection]);
 DoUpdate;
end;

procedure TOInspector.SetOgraphicControl(AValue: TONGraphicControl);
begin
 if AValue = FWorkbookSource1 then
    exit;
 // if FWorkbookSource1 <> nil then
 //   FWorkbookSource.RemoveListener(self);
  FWorkbookSource1 := AValue;
 // if FWorkbookSource1 <> nil then
 //   FWorkbookSource1.AddListener(self);
//  ListenerNotification([lniWorkbook, lniWorksheet, lniSelection]);
DoUpdate;
end;




{@@ ----------------------------------------------------------------------------
  Creates a string list containing the properties of the workbook.
  The string list items are name-value pairs in the format "name=value".
  The string list is displayed in the inspector's grid.

  @param  AWorkbook  Workbook under investigation
  @param  AStrings   Stringlist receiving the name-value pairs.
-------------------------------------------------------------------------------}
procedure TOInspector.UpdateOcustomControl(
  AWorkbook: TONCustomControl;  AStrings: TStrings);
var
 // bo: TsWorkbookOption;
  s: String;
  i: Integer;
  Value: Variant;
//  embobj: TsEmbeddedObj;
//  bp: TsWorkbookProtection;
begin
  if AWorkbook = nil then
  begin
    AStrings.Add('TOPLEFT=');
    AStrings.Add('BOTTOMLEFT=');
    AStrings.Add('LEFT=');
    AStrings.Add('TOPRIGHT=');
    AStrings.Add('BOTTOMRIGHT=');
    AStrings.Add('RIGHT=');
    AStrings.Add('TOP=');
    AStrings.Add('BOTTOM=');
    AStrings.Add('NORMAL=');
    AStrings.Add('HOVER=');
    AStrings.Add('PRESS=');
    AStrings.Add('DISABLED=');



  end else
  begin
     //For i:=0 to 10 do begin
    Value:=GetPropValue(AWorkbook,'ONLEFT');
    Value:=GetPropValue(AWorkbook,Value);
    ShowMessage(Value);
    if Value <> -1 then
       AStrings.Add('DISABLED='+Value);//GetVariantProp(AWorkbook,TypeInfo(AWorkbook)));//'ONLEFT.LEFT'));
     //end;
    // AStrings.Add('DISABLED='+GetPropValue(AWorkbook,'ONLEFT.LEFT'));
     //GetEnumValue(TypeInfo(AWorkbook),'ONDISABLE'); //+GetEnumName(TypeInfo(AWorkbook), ord(81)));

   { AStrings.Add(Format('FileName=%s', [AWorkbook.]));
    if AWorkbook.FileFormatID = -1 then
      AStrings.Add('FileFormat=(unknown)')
    else
      AStrings.Add(Format('FileFormat=%d [%s]', [
        AWorkbook.FileFormatID, GetSpreadTechnicalName(AWorkbook.FileFormatID)
      ]));

    if AWorkbook.ActiveWorksheet <> nil then
      AStrings.Add('ActiveWorksheet=' + AWorkbook.ActiveWorksheet.Name)
    else
      AStrings.Add('ActiveWorksheet=');

    s := '';
    for bo in TsWorkbookOption do
      if bo in AWorkbook.Options then
        s := s + ', ' + GetEnumName(TypeInfo(TsWorkbookOption), ord(bo));
    if s <> '' then Delete(s, 1, 2);
    AStrings.Add('Options='+s);

    if (ienFormatSettings in FExpanded) then begin
      AStrings.Add('(-) FormatSettings=');
      AStrings.Add('  ThousandSeparator='+AWorkbook.FormatSettings.ThousandSeparator);
      AStrings.Add('  DecimalSeparator='+AWorkbook.FormatSettings.DecimalSeparator);
      AStrings.Add('  ListSeparator='+AWorkbook.FormatSettings.ListSeparator);
      AStrings.Add('  DateSeparator='+AWorkbook.FormatSettings.DateSeparator);
      AStrings.Add('  TimeSeparator='+AWorkbook.FormatSettings.TimeSeparator);
      AStrings.Add('  ShortDateFormat='+AWorkbook.FormatSettings.ShortDateFormat);
      AStrings.Add('  LongDateFormat='+AWorkbook.FormatSettings.LongDateFormat);
      AStrings.Add('  ShortTimeFormat='+AWorkbook.FormatSettings.ShortTimeFormat);
      AStrings.Add('  LongTimeFormat='+AWorkbook.FormatSettings.LongTimeFormat);
      AStrings.Add('  TimeAMString='+AWorkbook.FormatSettings.TimeAMString);
      AStrings.Add('  TimePMString='+AWorkbook.FormatSettings.TimePMString);
      s := AWorkbook.FormatSettings.ShortMonthNames[1];
      for i:=2 to 12 do
        s := s + ', ' + AWorkbook.FormatSettings.ShortMonthNames[i];
      AStrings.Add('  ShortMonthNames='+s);
      s := AWorkbook.FormatSettings.LongMonthnames[1];
      for i:=2 to 12 do
        s := s +', ' + AWorkbook.FormatSettings.LongMonthNames[i];
      AStrings.Add('  LongMontNames='+s);
      s := AWorkbook.FormatSettings.ShortDayNames[1];
      for i:=2 to 7 do
        s := s + ', ' + AWorkbook.FormatSettings.ShortDayNames[i];
      AStrings.Add('  ShortMonthNames='+s);
      s := AWorkbook.FormatSettings.LongDayNames[1];
      for i:=2 to 7 do
        s := s +', ' + AWorkbook.FormatSettings.LongDayNames[i];
      AStrings.Add('  LongMontNames='+s);
      AStrings.Add('  CurrencyString='+AWorkbook.FormatSettings.CurrencyString);
      AStrings.Add('  PosCurrencyFormat='+IntToStr(AWorkbook.FormatSettings.CurrencyFormat));
      AStrings.Add('  NegCurrencyFormat='+IntToStr(AWorkbook.FormatSettings.NegCurrFormat));
      AStrings.Add('  TwoDigitYearCenturyWindow='+IntToStr(AWorkbook.FormatSettings.TwoDigitYearCenturyWindow));
    end else
      AStrings.Add('(+) FormatSettings=(dblclick for more...)');

    if (ienEmbeddedObj in FExpanded) then begin
      AStrings.Add('(-) Images=');
      for i:=0 to AWorkbook.GetEmbeddedObjCount-1 do
      begin
        embObj := AWorkbook.GetEmbeddedObj(i);
        AStrings.Add('  Filename='+embobj.FileName);
        AStrings.Add(Format('  ImageWidth=%.2f mm', [embObj.ImageWidth]));
        AStrings.Add(Format('  ImageHeight=%.2f mm', [embObj.ImageHeight]));
      end;
    end else
      AStrings.Add('(+) Images=(dblclick for more...)');

    if (ienFonts in FExpanded) then begin
      AStrings.Add('(-) Fonts=');
      for i:=0 to AWorkbook.GetFontCount-1 do
        AStrings.Add(Format('  Font%d=%s', [i, AWorkbook.GetFontAsString(i)]));
    end else
      AStrings.Add('(+) Fonts=(dblclick for more...)');

    if (ienFormats in FExpanded) then begin
      AStrings.Add('(-) Cell formats=');
      for i:=0 to AWorkbook.GetNumCellFormats-1 do
        AStrings.Add(Format('  CellFormat%d=%s', [i, AWorkbook.GetCellFormatAsString(i)]));
    end else
      AStrings.Add('(+) Cell formats=(dblclick for more...)');

    s := '';
    for bp in TsWorkbookProtection do
      if bp in AWorkbook.Protection then
        s := s + ', ' + GetEnumName(TypeInfo(TsWorkbookProtection), ord(bp));
    if s <> '' then Delete(s, 1, 2) else s := '(default)';
    AStrings.Add('Protection=' + s);

    if (ienCryptoInfo in FExpanded) then begin
      AStrings.Add('(-) CryptoInfo=');
      AStrings.Add(Format('  PasswordHash=%s', [Workbook.CryptoInfo.PasswordHash]));
      AStrings.Add(Format('  Algorithm=%s', [AlgorithmToStr(Workbook.CryptoInfo.Algorithm, auExcel)]));
      AStrings.Add(Format('  SaltValue=%s', [Workbook.CryptoInfo.SaltValue]));
      AStrings.Add(Format('  SpinCount=%d', [Workbook.CryptoInfo.SpinCount]));
    end else
      AStrings.Add('(+) CryptoInfo=(dblclick for more...)');
      }
  end;
end;

{@@ ----------------------------------------------------------------------------
  Creates a string list containing the properties of a worksheet.
  The string list items are name-value pairs in the format "name=value".
  The string list is displayed in the inspector's grid.

  @param  ASheet    Worksheet under investigation
  @param  AStrings  Stringlist receiving the name-value pairs.
-------------------------------------------------------------------------------}
procedure TOInspector.UpdateOgraphicControl(
  AWorkbook: TONGraphicControl;
  AStrings: TStrings);
var
  i: Integer;
  s: String;
  {po: TsPrintOption;
  img: TsImage;
  embObj: TsEmbeddedObj;
  so: TsSheetOption;
  sp: TsWorksheetProtection; }
begin
 { if ASheet = nil then
  begin
    AStrings.Add('Name=');
    AStrings.Add('Index=');
    AStrings.Add('First row=');
    AStrings.Add('Last row=');
    AStrings.Add('First column=');
    AStrings.Add('Last column=');
    AStrings.Add('Active cell=');
    AStrings.Add('Selection=');
    AStrings.Add('Default column width=');
    AStrings.Add('Default row height=');
    AStrings.Add('Zoom factor=');
    AStrings.Add('Page layout=');
    AStrings.Add('Options=');
    AStrings.Add('Protection=');
    AStrings.Add('TabColor=');
    AStrings.Add('Conditional formats=');
  end else
  begin
    AStrings.Add(Format('Name=%s', [ASheet.Name]));
    AStrings.Add(Format('Index=%d', [ASheet.Index]));
    AStrings.Add(Format('First row=%d', [Integer(ASheet.GetFirstRowIndex)]));
    AStrings.Add(Format('Last row=%d', [ASheet.GetLastRowIndex(true)]));
    AStrings.Add(Format('First column=%d', [Integer(ASheet.GetFirstColIndex)]));
    AStrings.Add(Format('Last column=%d', [ASheet.GetLastColIndex(true)]));
    AStrings.Add(Format('Active cell=%s',
      [GetCellString(ASheet.ActiveCellRow, ASheet.ActiveCellCol)]));
    AStrings.Add(Format('Selection=%s', [ASheet.GetSelectionAsString]));
    AStrings.Add(Format('Default column width=%.1f %s', [
      ASheet.ReadDefaultColWidth(ASheet.Workbook.Units),
      SizeUnitNames[ASheet.Workbook.Units]]));
    AStrings.Add(Format('Default row height=%.1f %s', [
      ASheet.ReadDefaultRowHeight(ASheet.Workbook.Units),
      SizeUnitNames[ASheet.Workbook.Units]]));
    AStrings.Add(Format('Zoom factor=%d%%', [round(ASheet.ZoomFactor*100)]));
    AStrings.Add(Format('Comments=%d items', [ASheet.Comments.Count]));
    AStrings.Add(Format('Hyperlinks=%d items', [ASheet.Hyperlinks.Count]));
    AStrings.Add(Format('MergedCells=%d items', [ASheet.MergedCells.Count]));
    AStrings.Add(Format('TabColor=$%.8x (%s)', [ASheet.TabColor, GetColorName(ASheet.TabColor)]));
                                    (*
    if ienConditionalFormats in FExpanded then
    begin
      AStrings.Add('(-) Conditional formats=');
      AStrings.Add(Format('  Count=%d', [ASheet.ConditionalFormatCount]));
      for i := 0 to ASheet.ConditionalFormatCount-1 do
      begin
        cf := ASheet.ReadConditionalFormat(i);
        AStrings.Add('  Item #' + IntToStr(i) + ':');
        with cf.CellRange do
          AStrings.Add(Format('    CellRange=%s', [GetCellRangeString(Row1, Col1, Row2, Col2)]));
      end;
    end else
    begin
      AStrings.Add('(+) Conditional formats=(dblclick for more...)');
    end;
                       *)
    if ienPageLayout in FExpanded then
    begin
      AStrings.Add('(-) Page layout=');
      AStrings.Add(Format('  Orientation=%s', [
        GetEnumName(TypeInfo(TsPageOrientation),
        ord(ASheet.PageLayout.Orientation))]));
      AStrings.Add(Format('  Page width=%.1f mm', [ASheet.PageLayout.PageWidth]));
      AStrings.Add(Format('  Page height=%.1f mm', [ASheet.PageLayout.PageHeight]));
      AStrings.Add(Format('  Left margin=%.1f mm', [ASheet.PageLayout.LeftMargin]));
      AStrings.Add(Format('  Right margin=%.1f mm', [ASheet.PageLayout.RightMargin]));
      AStrings.Add(Format('  Top margin=%.1f mm', [ASheet.PageLayout.TopMargin]));
      AStrings.Add(Format('  Bottom margin=%.1f mm', [ASheet.PageLayout.BottomMargin]));
      AStrings.Add(Format('  Header distance=%.1f mm', [ASheet.PageLayout.HeaderMargin]));
      AStrings.Add(Format('  Footer distance=%.1f mm', [ASheet.PageLayout.FooterMargin]));
      if poUseStartPageNumber in ASheet.PageLayout.Options then
        AStrings.Add(Format('  Start page number=%d', [ASheet.pageLayout.StartPageNumber]))
      else
        AStrings.Add('  Start page number=automatic');
      AStrings.Add(Format('  Scaling factor (Zoom)=%d%%',
        [ASheet.PageLayout.ScalingFactor]));
      AStrings.Add(Format('  Copies=%d', [ASheet.PageLayout.Copies]));
      if (ASheet.PageLayout.Options * [poDifferentOddEven, poDifferentFirst] <> []) then
      begin
        AStrings.Add(Format('  Header (first)=%s',
          [StringReplace(ASheet.PageLayout.Headers[0], LineEnding, '\n', [rfReplaceAll])]));
        AStrings.Add(Format('  Header (odd)=%s',
          [StringReplace(ASheet.PageLayout.Headers[1], LineEnding, '\n', [rfReplaceAll])]));
        AStrings.Add(Format('  Header (even)=%s',
          [StringReplace(ASheet.PageLayout.Headers[2], LineEnding, '\n', [rfReplaceAll])]));
        AStrings.Add(Format('  Footer (first)=%s',
          [StringReplace(ASheet.PageLayout.Footers[0], LineEnding, '\n', [rfReplaceAll])]));
        AStrings.Add(Format('  Footer (odd)=%s',
          [StringReplace(ASheet.PageLayout.Footers[1], LineEnding, '\n', [rfReplaceall])]));
        AStrings.Add(Format('  Footer (even)=%s',
          [StringReplace(ASheet.PageLayout.Footers[2], LineEnding, '\n', [rfReplaceAll])]));
      end else
      begin
        AStrings.Add(Format('  Header=%s', [StringReplace(ASheet.PageLayout.Headers[1], LineEnding, '\n', [rfReplaceAll])]));
        AStrings.Add(Format('  Footer=%s', [StringReplace(ASheet.PageLayout.Footers[1], LineEnding, '\n', [rfReplaceAll])]));
      end;

      if ASheet.PageLayout.HeaderImages[hfsLeft].Index > -1 then
        AStrings.Add(Format('  HeaderImage, left=%s',
          [ASheet.Workbook.GetEmbeddedObj(ASheet.PageLayout.HeaderImages[hfsLeft].Index).FileName]))
      else
        AStrings.Add('  HeaderImage, left =');
      if ASheet.PageLayout.HeaderImages[hfsCenter].Index > -1 then
        AStrings.Add(Format('  HeaderImage, center=%s',
          [ASheet.Workbook.GetEmbeddedObj(ASheet.PageLayout.HeaderImages[hfsCenter].Index).FileName]))
      else
        AStrings.Add('  HeaderImage, center=');
      if ASheet.PageLayout.HeaderImages[hfsRight].Index > -1 then
        AStrings.Add(Format('  HeaderImage, right=%s',
          [ASheet.Workbook.GetEmbeddedObj(ASheet.PageLayout.HeaderImages[hfsRight].Index).FileName]))
      else
        AStrings.Add('  HeaderImage, right=');

      if ASheet.PageLayout.FooterImages[hfsLeft].Index > -1 then
        AStrings.Add(Format('  FooterImage, left=%s',
          [ASheet.Workbook.GetEmbeddedObj(ASheet.PageLayout.FooterImages[hfsLeft].Index).FileName]))
      else
        AStrings.Add('  FooterImage, left =');
      if ASheet.PageLayout.FooterImages[hfsCenter].Index > -1 then
        AStrings.Add(Format('  FooterImage, center=%s',
          [ASheet.Workbook.GetEmbeddedObj(ASheet.PageLayout.FooterImages[hfsCenter].Index).FileName]))
      else
        AStrings.Add('  FooterImage, center=');
      if ASheet.PageLayout.FooterImages[hfsRight].Index > -1 then
        AStrings.Add(Format('  FooterImage, right=%s', [
          ASheet.Workbook.GetEmbeddedObj(ASheet.PageLayout.FooterImages[hfsRight].Index).FileName]))
      else
        AStrings.Add('  FooterImage, right=');

      if ASheet.PageLayout.NumPrintRanges = 0 then
        AStrings.Add('  Print ranges=')
      else
        for i := 0 to ASheet.PageLayout.NumPrintRanges-1 do
          with ASheet.PageLayout.PrintRange[i] do
            AStrings.Add(Format('  Print range #%d=$%s$%s:$%s$%s', [ i,
              GetColString(Col1), GetRowString(Row1), GetColString(Col2), GetRowString(Row2)
            ]));

      if ASheet.PageLayout.RepeatedRows.FirstIndex = UNASSIGNED_ROW_COL_INDEX then
        AStrings.Add('  Repeated rows=')
      else
      if ASheet.PageLayout.RepeatedRows.FirstIndex = ASheet.PageLayout.RepeatedRows.LastIndex then
        AStrings.Add(Format('  Repeated rows=$%s', [
          GetRowString(ASheet.PageLayout.RepeatedRows.FirstIndex)
        ]))
      else
        AStrings.Add(Format('  Repeated rows=$%s:$%s', [
          GetRowString(ASheet.PageLayout.RepeatedRows.FirstIndex),
          GetRowString(ASheet.PageLayout.RepeatedRows.lastIndex)
        ]));

      if ASheet.PageLayout.RepeatedCols.FirstIndex = UNASSIGNED_ROW_COL_INDEX then
        AStrings.Add('  Repeated columns=')
      else
      if ASheet.PageLayout.RepeatedCols.FirstIndex = ASheet.PageLayout.RepeatedCols.LastIndex then
        AStrings.Add(Format('  Repeated columns=$%s', [
          GetColString(ASheet.PageLayout.RepeatedCols.FirstIndex)
        ]))
      else
        AStrings.Add(Format('  Repeated columns=$%s:$%s', [
          GetColString(ASheet.PageLayout.RepeatedCols.FirstIndex),
          GetColString(ASheet.PageLayout.RepeatedCols.lastIndex)
        ]));

      s := '';
      for po in TsPrintOption do
        if po in ASheet.PageLayout.Options then s := s + '; ' + GetEnumName(typeInfo(TsPrintOption), ord(po));
      if s <> '' then Delete(s, 1, 2);
      AStrings.Add(Format('  Options=%s', [s]));
    end else
      AStrings.Add('(+) Page layout=(dblclick for more...)');

    if (ienImages in FExpanded) then begin
      AStrings.Add('(-) Images=');
      for i:=0 to ASheet.GetImageCount-1 do
      begin
        img := ASheet.GetImage(i);
        AStrings.Add(Format('  Row=%d', [img.Row]));
        AStrings.Add(Format('  Col=%d', [img.Col]));
        embObj := ASheet.Workbook.GetEmbeddedObj(img.Index);
        AStrings.Add(Format('  Index=%d [%s; %.2fmm x %.2fmm]',
          [img.Index, embobj.FileName, embObj.ImageWidth, embObj.ImageHeight]));
        AStrings.Add(Format('  OffsetX=%.2f mm', [img.OffsetX]));
        AStrings.Add(Format('  OffsetY=%.2f mm', [img.OffsetY]));
        AStrings.Add(Format('  ScaleX=%.2f', [img.ScaleX]));
        AStrings.Add(Format('  ScaleY=%.2f', [img.ScaleY]));
        AStrings.Add(Format('  HyperlinkTarget=%s', [img.HyperlinkTarget]));
        AStrings.Add(Format('  HyperlinkTooltip=%s', [img.HyperlinkToolTip]));
      end;
    end else
      AStrings.Add('(+) Images=(dblclick for more...)');

    s := '';
    for so in TsSheetOption do
      if so in ASheet.Options then
        s := s + ', ' + GetEnumName(TypeInfo(TsSheetOption), ord(so));
    if s <> '' then Delete(s, 1, 2);
    AStrings.Add('Options='+s);

    if ASheet.IsProtected then begin
      s := '';
      for sp in TsWorksheetProtection do
        if sp in ASheet.Protection then
          s := s + ', ' + GetEnumName(TypeInfo(TsWorksheetProtection), ord(sp));
      if s <> '' then Delete(s, 1, 2) else s := '(default)';
    end else
      s := '(not protected)';
    AStrings.Add('Protection=' + s);

    if (ienCryptoInfo in FExpanded) then begin
      AStrings.Add('(-) CryptoInfo=');
      AStrings.Add(Format('  PasswordHash=%s', [Worksheet.CryptoInfo.PasswordHash]));
      AStrings.Add(Format('  Algorithm=%s', [AlgorithmToStr(Worksheet.CryptoInfo.Algorithm, auExcel)]));
      AStrings.Add(Format('  SaltValue=%s', [Worksheet.CryptoInfo.SaltValue]));
      AStrings.Add(Format('  SpinCount=%d', [Worksheet.CryptoInfo.SpinCount]));
    end else
      AStrings.Add('(+) CryptoInfo=(dblclick for more...)');

  end; }
end;


initialization
  RegisterPropertyToSkip(TOInspector, 'ONLEFT',  'For compatibility with older Laz versions.', '');
  RegisterPropertyToSkip(TOInspector, 'ONRIGHT', 'For compatibility with older Laz versions.', '');



  { not working...
  cfOpenDocumentFormat := RegisterClipboardFormat('application/x-openoffice-embed-source-xml;windows_formatname="Star Embed Source (XML)"');
  cfStarObjectDescriptor := RegisterClipboardFormat('application/x-openoffice-objectdescriptor-xml;windows_formatname="Star Object Descriptor (XML)"');
  }

end.

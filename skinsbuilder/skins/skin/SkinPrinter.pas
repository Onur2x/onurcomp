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

unit SkinPrinter;

{$WARNINGS OFF}
{$HINTS OFF}

interface

uses Windows, SysUtils, Messages, Classes, Graphics, Controls, Forms,
     DynamicSkinForm, SkinData, SkinCtrls, SkinBoxCtrls, Dialogs,
     StdCtrls, ExtCtrls, spEffBmp;

type

  TspPrintRange = (bsprAllPages, bsprSelection, bsprPageNums);
  TspPrintDialogOption = (bspoPrintToFile, bspoPageNums, bspoSelection,
    bspoDisablePrintToFile);
  TspPrintDialogOptions = set of TspPrintDialogOption;

  TspSkinPrintDialog = class(TComponent)
  private
    PrinterCombobox: TspSkinComboBox;
    L1, L2, L3, L4: TspSkinStdLabel;
    NumCopiesEdit: TspSkinSpinEdit;
    CollateCheckBox: TspSkinCheckRadioBox;
    StopCheck: Boolean;
    CollateImage: TImage;
    RBAll, RBPages, RBSelection: TspSkinCheckRadioBox;
    FromPageEdit, ToPageEdit: TspSkinSpinEdit;
    PrintToFileCheckBox: TspSkinCheckRadioBox;
    FGroupBoxTransparentMode: Boolean;
  protected
    Form: TForm;
    FSD: TspSkinData;
    FCtrlFSD: TspSkinData;
    FButtonSkinDataName: String;
    FSelectSkinDataName: String;
    FLabelSkinDataName: String;
    FDefaultLabelFont: TFont;
    FDefaultSelectFont: TFont;
    FDefaultButtonFont: TFont;
    FAlphaBlend: Boolean;
    FAlphaBlendValue: Byte;
    FAlphaBlendAnimation: Boolean;
    FUseSkinFont: Boolean;
    FTitle: String;
    //
    FFromPage: Integer;
    FToPage: Integer;
    FCollate: Boolean;
    FOptions: TspPrintDialogOptions;
    FPrintToFile: Boolean;
    FPrintRange: TspPrintRange;
    FMinPage: Integer;
    FMaxPage: Integer;
    FCopies: Integer;
    procedure SetNumCopies(Value: Integer);
    //
    procedure FromPageEditChange(Sender: TObject);
    procedure ToPageEditChange(Sender: TObject);

    procedure SetDefaultLabelFont(Value: TFont);
    procedure SetDefaultButtonFont(Value: TFont);
    procedure SetDefaultSelectFont(Value: TFont);
    function GetTitle: string;
    procedure SetTitle(const Value: string);
    procedure Notification(AComponent: TComponent;  Operation: TOperation); override;
    procedure PrinterComboBoxChange(Sender: TObject);
    procedure PropertiesButtonClick(Sender: TObject);
    procedure NumCopiesEditChange(Sender: TObject);
    procedure CollateCheckBoxClick(Sender: TObject);
  public
    function Execute: Boolean;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property GroupBoxTransparentMode: Boolean
      read FGroupBoxTransparentMode write FGroupBoxTransparentMode;
    property Title: string read GetTitle write SetTitle;
    property AlphaBlend: Boolean read FAlphaBlend write FAlphaBlend;
    property AlphaBlendValue: Byte read FAlphaBlendValue write FAlphaBlendValue;
    property AlphaBlendAnimation: Boolean
      read FAlphaBlendAnimation write FAlphaBlendAnimation;
    property SkinData: TspSkinData read FSD write FSD;
    property CtrlSkinData: TspSkinData read FCtrlFSD write FCtrlFSD;
    property ButtonSkinDataName: String read FButtonSkinDataName write FButtonSkinDataName;
    property LabelSkinDataName: String read FLabelSkinDataName write FLabelSkinDataName;
    property ComboboxSkinDataName: String read FSelectSkinDataName write FSelectSkinDataName;
    property DefaultLabelFont: TFont read FDefaultLabelFont write SetDefaultLabelFont;
    property DefaultButtonFont: TFont read FDefaultButtonFont write SetDefaultButtonFont;
    property DefaultComboBoxFont: TFont read FDefaultSelectFont write SetDefaultSelectFont;
    property UseSkinFont: Boolean read FUseSkinFont write FUseSkinFont;
    //
    property Collate: Boolean read FCollate write FCollate default False;
    property Copies: Integer read FCopies write SetNumCopies default 0;
    property FromPage: Integer read FFromPage write FFromPage default 0;
    property MinPage: Integer read FMinPage write FMinPage default 0;
    property MaxPage: Integer read FMaxPage write FMaxPage default 0;
    property Options: TspPrintDialogOptions read FOptions write FOptions default [];
    property PrintToFile: Boolean read FPrintToFile write FPrintToFile default False;
    property PrintRange: TspPrintRange read FPrintRange write FPrintRange default bsprAllPages;
    property ToPage: Integer read FToPage write FToPage default 0;
    //
  end;

  TspPaperInfo = class
  private
    FDMPaper: Integer;
    FName: string;
    FSize: TPoint;
    function GetSize(Index: Integer): Integer;
    procedure SetSize(Index: Integer; Value: Integer);
  public
    procedure Assign(Source: TspPaperInfo);
    function IsEqual(Source: TspPaperInfo): Boolean;

    property DMPaper: Integer read FDMPaper;
    property Height: Integer index 1 read GetSize write SetSize;
    property Name: string read FName;
    property Size: TPoint read FSize;
    property Width: Integer index 0 read GetSize write SetSize;
  end;

  TspSkinPrinterSetupDialog = class(TComponent)
  private
    StopCheck: Boolean;
    PrinterCombobox: TspSkinComboBox;
    L1, L2, L3, L4: TspSkinStdLabel;
    RBPortrait, RBLandScape: TspSkinCheckRadioBox;
    OrientationImage: TImage;
    SizeComboBox, SourceComboBox: TspSkinComboBox;
    Bins, Papers: TStrings;
    FGroupBoxTransparentMode: Boolean;
    procedure RBPortraitClick(Sender: TObject);
    procedure RBLandScapeClick(Sender: TObject);
    procedure SizeComboBoxChange(Sender: TObject);
    procedure SourceComboBoxChange(Sender: TObject);
    procedure ClearPapersAndBins;
    procedure LoadPapersAndBins;
    procedure LoadCurrentPaperAndBin;
    procedure SaveCurrentPaperAndBin;
  protected
    Form: TForm;
    FSD: TspSkinData;
    FCtrlFSD: TspSkinData;
    FButtonSkinDataName: String;
    FSelectSkinDataName: String;
    FLabelSkinDataName: String;
    FDefaultLabelFont: TFont;
    FDefaultSelectFont: TFont;
    FDefaultButtonFont: TFont;
    FAlphaBlend: Boolean;
    FAlphaBlendValue: Byte;
    FAlphaBlendAnimation: Boolean;
    FUseSkinFont: Boolean;
    FTitle: String;
    procedure SetDefaultLabelFont(Value: TFont);
    procedure SetDefaultButtonFont(Value: TFont);
    procedure SetDefaultSelectFont(Value: TFont);
    function GetTitle: string;
    procedure SetTitle(const Value: string);
    procedure Notification(AComponent: TComponent;  Operation: TOperation); override;
    procedure PrinterComboBoxChange(Sender: TObject);
    procedure PropertiesButtonClick(Sender: TObject);
  public
    function Execute: Boolean;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property GroupBoxTransparentMode: Boolean
      read FGroupBoxTransparentMode write FGroupBoxTransparentMode;
    property Title: string read GetTitle write SetTitle;
    property AlphaBlend: Boolean read FAlphaBlend write FAlphaBlend;
    property AlphaBlendValue: Byte read FAlphaBlendValue write FAlphaBlendValue;
    property AlphaBlendAnimation: Boolean
      read FAlphaBlendAnimation write FAlphaBlendAnimation;
    property SkinData: TspSkinData read FSD write FSD;
    property CtrlSkinData: TspSkinData read FCtrlFSD write FCtrlFSD;
    property ButtonSkinDataName: String read FButtonSkinDataName write FButtonSkinDataName;
    property LabelSkinDataName: String read FLabelSkinDataName write FLabelSkinDataName;
    property ComboboxSkinDataName: String read FSelectSkinDataName write FSelectSkinDataName;
    property DefaultLabelFont: TFont read FDefaultLabelFont write SetDefaultLabelFont;
    property DefaultButtonFont: TFont read FDefaultButtonFont write SetDefaultButtonFont;
    property DefaultComboBoxFont: TFont read FDefaultSelectFont write SetDefaultSelectFont;
    property UseSkinFont: Boolean read FUseSkinFont write FUseSkinFont;
  end;

  TspSkinSmallPrintDialog = class(TComponent)
  protected
    FGroupBoxTransparentMode: Boolean; 
    Form: TForm;
    FSD: TspSkinData;
    FCtrlFSD: TspSkinData;
    FButtonSkinDataName: String;
    FSelectSkinDataName: String;
    FLabelSkinDataName: String;
    FDefaultLabelFont: TFont;
    FDefaultSelectFont: TFont;
    FDefaultButtonFont: TFont;
    FAlphaBlend: Boolean;
    FAlphaBlendValue: Byte;
    FAlphaBlendAnimation: Boolean;
    FUseSkinFont: Boolean;
    FTitle: String;
    PrinterCombobox: TspSkinComboBox;
    L1, L2, L3, L4: TspSkinStdLabel;
    procedure SetDefaultLabelFont(Value: TFont);
    procedure SetDefaultButtonFont(Value: TFont);
    procedure SetDefaultSelectFont(Value: TFont);
    function GetTitle: string;
    procedure SetTitle(const Value: string);
    procedure Notification(AComponent: TComponent;  Operation: TOperation); override;
    procedure PropertiesButtonClick(Sender: TObject);
    procedure PrinterComboBoxChange(Sender: TObject);
  public
    function Execute: Boolean;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property GroupBoxTransparentMode: Boolean
      read FGroupBoxTransparentMode write FGroupBoxTransparentMode;
    property Title: string read GetTitle write SetTitle;
    property AlphaBlend: Boolean read FAlphaBlend write FAlphaBlend;
    property AlphaBlendValue: Byte read FAlphaBlendValue write FAlphaBlendValue;
    property AlphaBlendAnimation: Boolean
      read FAlphaBlendAnimation write FAlphaBlendAnimation;
    property SkinData: TspSkinData read FSD write FSD;
    property CtrlSkinData: TspSkinData read FCtrlFSD write FCtrlFSD;
    property ButtonSkinDataName: String read FButtonSkinDataName write FButtonSkinDataName;
    property LabelSkinDataName: String read FLabelSkinDataName write FLabelSkinDataName;
    property ComboboxSkinDataName: String read FSelectSkinDataName write FSelectSkinDataName;
    property DefaultLabelFont: TFont read FDefaultLabelFont write SetDefaultLabelFont;
    property DefaultButtonFont: TFont read FDefaultButtonFont write SetDefaultButtonFont;
    property DefaultComboBoxFont: TFont read FDefaultSelectFont write SetDefaultSelectFont;
    property UseSkinFont: Boolean read FUseSkinFont write FUseSkinFont;
  end;

  TspSkinPagePreview = class;
  TspPageMeasureUnits = (sppmMillimeters, sppmInches);
  TspPageSetupDialogOption = (sppsoDisableMargins,
    sppsoDisableOrientation, sppsoDisablePaper, sppsoDisablePrinter);
  TspPageSetupDialogOptions = set of TspPageSetupDialogOption;

  TspSkinPageSetupDialog = class(TComponent)
  private
    FGroupBoxTransparentMode: Boolean;
    StopCheck: Boolean;
    RBPortrait, RBLandScape: TspSkinCheckRadioBox;
    SizeComboBox, SourceComboBox: TspSkinComboBox;
    LeftMEdit, TopMEdit, RightMEdit, BottomMEdit: TspSkinSpinEdit;
    PagePreview: TspSkinPagePreview;
    Bins, Papers: TStrings;
    //
    FUnits: TspPageMeasureUnits;
    FOptions: TspPageSetupDialogOptions;
    //
    FMinMarginLeft: Integer;
    FMinMarginTop: Integer;
    FMinMarginRight: Integer;
    FMinMarginBottom: Integer;

    FMaxMarginLeft: Integer;
    FMaxMarginTop: Integer;
    FMaxMarginRight: Integer;
    FMaxMarginBottom: Integer;

    FMarginLeft: Integer;
    FMarginTop: Integer;
    FMarginRight: Integer;
    FMarginBottom: Integer;
    FPageWidth, FPageHeight: Integer;
    //
    procedure RBPortraitClick(Sender: TObject);
    procedure RBLandScapeClick(Sender: TObject);
    procedure SizeComboBoxChange(Sender: TObject);
    procedure SourceComboBoxChange(Sender: TObject);

    procedure LeftMEditChange(Sender: TObject);
    procedure TopMEditChange(Sender: TObject);
    procedure RightMEditChange(Sender: TObject);
    procedure BottomMEditChange(Sender: TObject);

    procedure ClearPapersAndBins;
    procedure LoadPapersAndBins;
    procedure LoadCurrentPaperAndBin;
    procedure SaveCurrentPaperAndBin;
  protected
    Form: TForm;
    FSD: TspSkinData;
    FCtrlFSD: TspSkinData;
    FButtonSkinDataName: String;
    FSelectSkinDataName: String;
    FLabelSkinDataName: String;
    FDefaultLabelFont: TFont;
    FDefaultSelectFont: TFont;
    FDefaultButtonFont: TFont;
    FAlphaBlend: Boolean;
    FAlphaBlendValue: Byte;
    FAlphaBlendAnimation: Boolean;
    FUseSkinFont: Boolean;
    FTitle: String;
    procedure SetDefaultLabelFont(Value: TFont);
    procedure SetDefaultButtonFont(Value: TFont);
    procedure SetDefaultSelectFont(Value: TFont);
    function GetTitle: string;
    procedure SetTitle(const Value: string);
    procedure Notification(AComponent: TComponent;  Operation: TOperation); override;
    procedure PrinterButtonClick(Sender: TObject);
  public
    function Execute: Boolean;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    //
    property Options: TspPageSetupDialogOptions read FOptions write FOptions
      default [];
    property Units: TspPageMeasureUnits
      read FUnits write FUnits default sppmMillimeters;
    //
    property GroupBoxTransparentMode: Boolean
      read FGroupBoxTransparentMode write FGroupBoxTransparentMode;
    property MinMarginLeft: Integer read FMinMarginLeft write FMinMarginLeft;
    property MinMarginTop: Integer read FMinMarginTop write FMinMarginTop;
    property MinMarginRight: Integer read FMinMarginRight write FMinMarginRight;
    property MinMarginBottom: Integer read FMinMarginBottom write FMinMarginBottom;

    property MaxMarginLeft: Integer read FMaxMarginLeft write FMaxMarginLeft;
    property MaxMarginTop: Integer read FMaxMarginTop write FMaxMarginTop;
    property MaxMarginRight: Integer read FMaxMarginRight write FMaxMarginRight;
    property MaxMarginBottom: Integer read FMaxMarginBottom write FMaxMarginBottom;

    property MarginLeft: Integer read FMarginLeft write FMarginLeft;
    property MarginTop: Integer read FMarginTop write FMarginTop;
    property MarginRight: Integer read FMarginRight write FMarginRight;
    property MarginBottom: Integer read FMarginBottom write FMarginBottom;
    property PageWidth: Integer read FPageWidth write FPageWidth;
    property PageHeight: Integer read FPageHeight write FPageHeight;
    //
    property Title: string read GetTitle write SetTitle;
    property AlphaBlend: Boolean read FAlphaBlend write FAlphaBlend;
    property AlphaBlendValue: Byte read FAlphaBlendValue write FAlphaBlendValue;
    property AlphaBlendAnimation: Boolean
      read FAlphaBlendAnimation write FAlphaBlendAnimation;
    property SkinData: TspSkinData read FSD write FSD;
    property CtrlSkinData: TspSkinData read FCtrlFSD write FCtrlFSD;
    property ButtonSkinDataName: String read FButtonSkinDataName write FButtonSkinDataName;
    property LabelSkinDataName: String read FLabelSkinDataName write FLabelSkinDataName;
    property ComboboxSkinDataName: String read FSelectSkinDataName write FSelectSkinDataName;
    property DefaultLabelFont: TFont read FDefaultLabelFont write SetDefaultLabelFont;
    property DefaultButtonFont: TFont read FDefaultButtonFont write SetDefaultButtonFont;
    property DefaultComboBoxFont: TFont read FDefaultSelectFont write SetDefaultSelectFont;
    property UseSkinFont: Boolean read FUseSkinFont write FUseSkinFont;
  end;

  TspSkinPagePreview = class(TspSkinPanel)
  protected
    procedure CreateControlDefaultImage(B: TBitMap); override;
    procedure CreateControlSkinImage(B: TBitMap); override;
    procedure PaintTransparent(C: TCanvas); override;
  public
    PageWidth, PageHeight,
    LeftMargin, TopMargin, RightMargin, BottomMargin: Integer;
    constructor Create(AOwner: TComponent); override;
    procedure DrawPaper(R: TRect; Cnvs: TCanvas);
  end;


implementation

{$R SkinPrinter}

Uses spUtils, spConst, Printers, WinSpool, spMessages;

function GetStatusString(Status: DWORD): string;
begin
  case Status of
    0:
      Result := SP_PRNSTATUS_Ready;
    PRINTER_STATUS_PAUSED:
      Result := SP_PRNSTATUS_Paused;
    PRINTER_STATUS_PENDING_DELETION:
      Result := SP_PRNSTATUS_PendingDeletion;
    PRINTER_STATUS_BUSY:
      Result := SP_PRNSTATUS_Busy;
    PRINTER_STATUS_DOOR_OPEN:
      Result := SP_PRNSTATUS_DoorOpen;
    PRINTER_STATUS_ERROR:
      Result := SP_PRNSTATUS_Error;
    PRINTER_STATUS_INITIALIZING:
      Result := SP_PRNSTATUS_Initializing;
    PRINTER_STATUS_IO_ACTIVE:
      Result := SP_PRNSTATUS_IOActive;
    PRINTER_STATUS_MANUAL_FEED:
      Result := SP_PRNSTATUS_ManualFeed;
    PRINTER_STATUS_NO_TONER:
      Result := SP_PRNSTATUS_NoToner;
    PRINTER_STATUS_NOT_AVAILABLE:
      Result := SP_PRNSTATUS_NotAvailable;
    PRINTER_STATUS_OFFLINE:
      Result := SP_PRNSTATUS_OFFLine;
    PRINTER_STATUS_OUT_OF_MEMORY:
      Result := SP_PRNSTATUS_OutOfMemory;
    PRINTER_STATUS_OUTPUT_BIN_FULL:
      Result := SP_PRNSTATUS_OutBinFull;
    PRINTER_STATUS_PAGE_PUNT:
      Result := SP_PRNSTATUS_PagePunt;
    PRINTER_STATUS_PAPER_JAM:
      Result := SP_PRNSTATUS_PaperJam;
    PRINTER_STATUS_PAPER_OUT:
      Result := SP_PRNSTATUS_PaperOut;
    PRINTER_STATUS_PAPER_PROBLEM:
      Result := SP_PRNSTATUS_PaperProblem;
    PRINTER_STATUS_PRINTING:
      Result := SP_PRNSTATUS_Printing;
    PRINTER_STATUS_PROCESSING:
      Result := SP_PRNSTATUS_Processing;
    PRINTER_STATUS_TONER_LOW:
      Result := SP_PRNSTATUS_TonerLow;
    PRINTER_STATUS_USER_INTERVENTION:
      Result := SP_PRNSTATUS_UserIntervention;
    PRINTER_STATUS_WAITING:
      Result := SP_PRNSTATUS_Waiting;
    PRINTER_STATUS_WARMING_UP:
      Result := SP_PRNSTATUS_WarningUp;
  else
    Result := '';
  end;
end;

procedure CallDocumentPropertiesDialog(H: HWND);
var
  PPrinterDevMode: PDevMode;
  DevModeHandle: THandle;
  hPrinter: THandle;
  PrinterName, Driver, Port: array[0..79] of Char;
begin
  Printer.GetPrinter(PrinterName, Driver, Port, DevModeHandle);
  if not OpenPrinter(PrinterName, hPrinter, nil)
  then
    raise EPrinter.Create(SysErrorMessage(GetLastError ));
  PPrinterDevMode := GlobalLock(DevModeHandle);
  DocumentProperties(H, hPrinter, PrinterName, PPrinterDevMode^, PPrinterDevMode^, DM_OUT_BUFFER or DM_IN_BUFFER or DM_IN_PROMPT);
  GlobalUnlock(DevModeHandle);
  ClosePrinter(hPrinter);
end;

procedure SetCollate(Value: Boolean);
var
  PPrinterDevMode: PDevMode;
  DevModeHandle: THandle;
  hPrinter: THandle;
  PrinterName, Driver, Port: array[0..79] of Char;
begin
  Printer.GetPrinter(PrinterName, Driver, Port, DevModeHandle);
  if not OpenPrinter(PrinterName, hPrinter, nil)
  then
    raise EPrinter.Create(SysErrorMessage(GetLastError ));
  PPrinterDevMode := GlobalLock(DevModeHandle);
  if Value
  then PPrinterDevMode^.dmCollate := 1
  else PPrinterDevMode^.dmCollate := 0;
  DocumentProperties(0, hPrinter, PrinterName, PPrinterDevMode^, PPrinterDevMode^, DM_OUT_BUFFER or DM_IN_BUFFER);
  GlobalUnlock(DevModeHandle);
  ClosePrinter(hPrinter);
end;

function GetCollate: Boolean;
var
  PPrinterDevMode: PDevMode;
  DevModeHandle: THandle;
  hPrinter: THandle;
  PrinterName, Driver, Port: array[0..79] of Char;
begin
  Printer.GetPrinter(PrinterName, Driver, Port, DevModeHandle);
  if not OpenPrinter(PrinterName, hPrinter, nil)
  then
    raise EPrinter.Create(SysErrorMessage(GetLastError ));
  PPrinterDevMode := GlobalLock(DevModeHandle);
  DocumentProperties(0, hPrinter, PrinterName, PPrinterDevMode^, PPrinterDevMode^, DM_OUT_BUFFER or DM_IN_BUFFER);
  Result := PPrinterDevMode^.dmCollate > 0;
  GlobalUnlock(DevModeHandle);
  ClosePrinter(hPrinter);
end;

procedure RestoreDocumentProperties;
var
  PPrinterDevMode: PDevMode;
  DevModeHandle: THandle;
  hPrinter: THandle;
  PrinterName, Driver, Port: array[0..79] of Char;
begin
  Printer.GetPrinter(PrinterName, Driver, Port, DevModeHandle);
  if not OpenPrinter(PrinterName, hPrinter, nil)
  then
    raise EPrinter.Create(SysErrorMessage(GetLastError ));
  PPrinterDevMode := GlobalLock(DevModeHandle);
  DocumentProperties(0, hPrinter, PrinterName, PPrinterDevMode^, PPrinterDevMode^, DM_OUT_BUFFER);
  GlobalUnlock(DevModeHandle);
  ClosePrinter(hPrinter);
end;

procedure GetPrinterInfo(var AStatus, AType, APort, AComment: String);
var
  Flags, ACount, NumInfo: DWORD;
  Buffer, PInfo: PChar;
  PrinterName, Driver, Port: array[0..79] of Char;
  DevModeHandle: THandle;
  I: Integer;
  S1, S2: String;
begin
  Printer.GetPrinter(PrinterName, Driver, Port, DevModeHandle);

  Flags := PRINTER_ENUM_CONNECTIONS or PRINTER_ENUM_LOCAL;
  ACount := 0;
  EnumPrinters(Flags, nil, 2, nil, 0, ACount, NumInfo);
  if ACount = 0 then Exit;
  GetMem(Buffer, ACount);
  if not EnumPrinters(Flags, nil, 2, PByte(Buffer), ACount, ACount, NumInfo)
  then
    begin
      FreeMem(Buffer, ACount);
      Exit;
    end;

  PInfo := Buffer;

  S1 := PrinterName;
  for i := 0 to NumInfo - 1 do
  begin
    S2 := PPrinterInfo2(PInfo)^.pPrinterName;
    if S1 = S2
    then
      Break
    else
      Inc(PInfo, Sizeof(TPrinterInfo2));
  end;

  AStatus := GetStatusString(PPrinterInfo2(PInfo)^.Status);
  AType := PPrinterInfo2(PInfo)^.pDriverName;
  APort := PPrinterInfo2(PInfo)^.pPortName;
  AComment := PPrinterInfo2(PInfo)^.pComment;

  FreeMem(Buffer, ACount);
end;


constructor TspSkinPrintDialog.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FTitle := 'Print';
  FGroupBoxTransparentMode := False;

  FAlphaBlend := False;
  FAlphaBlendAnimation := False;
  FAlphaBlendValue := 200;

  FButtonSkinDataName := 'button';
  FLabelSkinDataName  := 'stdlabel';
  FSelectSkinDataName := 'combobox';

  FDefaultLabelFont := TFont.Create;
  FDefaultButtonFont := TFont.Create;
  FDefaultSelectFont := TFont.Create;

  StopCheck := False;

  FUseSkinFont := True;

  with FDefaultLabelFont do
  begin
    Name := 'Tahoma';
    Style := [];
    Height := 13;
  end;

  with FDefaultButtonFont do
  begin
    Name := 'Tahoma';
    Style := [];
    Height := 13;
  end;

  with FDefaultSelectFont do
  begin
    Name := 'Tahoma';
    Style := [];
    Height := 13;
  end;
end;

destructor TspSkinPrintDialog.Destroy;
begin
  FDefaultLabelFont.Free;
  FDefaultButtonFont.Free;
  FDefaultSelectFont.Free;
  inherited;
end;

procedure TspSkinPrintDialog.FromPageEditChange(Sender: TObject);
begin
  RBPages.Checked := True;
end;

procedure TspSkinPrintDialog.ToPageEditChange(Sender: TObject);
begin
  RBPages.Checked := True;
end;

procedure TspSkinPrintDialog.PropertiesButtonClick(Sender: TObject);
begin
  CallDocumentPropertiesDialog(Form.Handle);
  StopCheck := True;
  NumCopiesEdit.Value :=  Printer.Copies;
  CollateCheckBox.Checked := GetCollate;
  StopCheck := False;
end;

procedure TspSkinPrintDialog.PrinterComboBoxChange(Sender: TObject);
var
  S1, S2, S3, S4: String;
begin
  Printer.PrinterIndex := PrinterComboBox.ItemIndex;
  GetPrinterInfo(S1, S2, S3, S4);
  L1.Caption := S1;
  L2.Caption := S2;
  L3.Caption := S3;
  L4.Caption := S4;
  StopCheck := True;
  NumCopiesEdit.Value := Printer.Copies;
  CollateCheckBox.Checked := GetCollate;
  StopCheck := False;
end;

procedure TspSkinPrintDialog.CollateCheckBoxClick(Sender: TObject);
begin
  if not StopCheck then SetCollate(CollateCheckBox.Checked);
  if CollateCheckBox.Checked
  then
    CollateImage.Picture.Bitmap.LoadFromResourceName(HInstance, 'SP_COLLATE')
  else
    CollateImage.Picture.Bitmap.LoadFromResourceName(HInstance, 'SP_NOCOLLATE');
end;

procedure TspSkinPrintDialog.NumCopiesEditChange(Sender: TObject);
begin
  Printer.Copies := Round(NumCopiesEdit.Value);
  CollateCheckBox.Enabled := NumCopiesEdit.Value > 1;
end;

procedure TspSkinPrintDialog.SetNumCopies(Value: Integer);
begin
  FCopies := Value;
  Printer.Copies := Value;
end;

function TspSkinPrintDialog.Execute;
var
  DSF: TspDynamicSkinForm;
  OldPrinterIndex: Integer;
  PrinterGroupBox: TspSkinGroupBox;
  PrintRangeGroupBox: TspSkinGroupBox;
  CopiesGroupBox: TspSkinGroupBox;
  R: TRect;
  S1, S2, S3, S4: String;
  fromL, toL: TspSkinStdLabel;
  SkinMessage: TspSkinMessage;
  S: String;
begin
  if (Printer = nil) or (Printer.Printers = nil) or (Printer.Printers.Count = 0)
  then
    begin
      SkinMessage := TspSkinMessage.Create(Self);
      SkinMessage.SkinData := Self.SkinData;
      SkinMessage.CtrlSkinData := Self.CtrlSkinData;
      if (SkinData <> nil) and (SkinData.ResourceStrData <> nil)
      then
        S:= SkinData.ResourceStrData.GetResStr('PRNDLG_WARNING')
      else
        S := SP_PRNDLG_WARNING;
      SkinMessage.MessageDlg(S, mtError, [mbOk], 0);
      SkinMessage.Free;
      Exit;
    end;
  Form := TForm.Create(Application);
  Form.BorderStyle := bsDialog;
  Form.Position := poScreenCenter;
  Form.Caption := FTitle;
  DSF := TspDynamicSkinForm.Create(Form);
  DSF.BorderIcons := [];
  DSF.SizeAble := False;
  DSF.SkinData := SkinData;
  DSF.MenusSkinData := CtrlSkinData;
  DSF.AlphaBlend := AlphaBlend;
  DSF.AlphaBlendAnimation := AlphaBlendAnimation;
  DSF.AlphaBlendValue := AlphaBlendValue;

  Form.ClientWidth :=  470;
  Form.ClientHeight := 340;

  PrinterGroupBox := TspSkinGroupBox.Create(Self);

  with PrinterGroupBox do
  begin
    Parent := Form;
    Left := 10;
    Top := 10;
    Width := Form.ClientWidth - 20;
    Height := 150;
    SkinData := CtrlSkinData;
    if (CtrlSkinData <> nil) and (CtrlSkinData.ResourceStrData <> nil)
    then
      Caption := CtrlSkinData.ResourceStrData.GetResStr('PRNDLG_PRINTER')
    else
      Caption := SP_PRNDLG_PRINTER;
    if FGroupBoxTransparentMode then TransparentMode := True;
  end;

  R := PrinterGroupBox.GetSkinClientRect;

  PrintToFileCheckBox := TspSkinCheckRadioBox.Create(Self);
  with PrintToFileCheckBox do
  begin
    Parent := PrinterGroupBox;
    Checked := Self.PrintToFile;
    Left := R.Right - 100;
    Top := R.Bottom - 35;
    Width := 80;
    SkinData := CtrlSkinData;
    if (CtrlSkinData <> nil) and (CtrlSkinData.ResourceStrData <> nil)
    then
      Caption := CtrlSkinData.ResourceStrData.GetResStr('PRNDLG_PRINTTOFILE')
    else
      Caption := SP_PRNDLG_PRINTTOFILE;
    Enabled := not (bspoDisablePrintToFile in Options);
    Visible := bspoPrintToFile in Options;
    OnClick := CollateCheckBoxClick;
  end;

  with TspSkinStdLabel.Create(Self) do
  begin
    Parent := PrinterGroupBox;
    Left := R.Left + 10;
    Top := R.Top + 10;
    WordWrap := False;
    DefaultFont := DefaultLabelFont;
    UseSkinFont := Self.UseSkinFont;
    SkinData := CtrlSkinData;
    if (CtrlSkinData <> nil) and (CtrlSkinData.ResourceStrData <> nil)
    then
      Caption := CtrlSkinData.ResourceStrData.GetResStr('PRNDLG_NAME')
    else
      Caption := SP_PRNDLG_NAME;
  end;

  PrinterCombobox := TspSkinCombobox.Create(Form);
  with PrinterCombobox do
  begin
    Parent := PrinterGroupBox;
    DefaultFont := DefaultComboboxFont;
    UseSkinFont := Self.UseSkinFont;
    Items.Assign(Printer.Printers);
    ItemIndex := Printer.PrinterIndex;
    SkinDataName := FSelectSkinDataName;
    SkinData := CtrlSkinData;
    OnChange := PrinterComboBoxChange;
    Top := R.Top + 7;
    Left := R.Left + 80;
    Width := RectWidth(R) - 180;
   end;

  with TspSkinButton.Create(Self) do
  begin
    Parent := PrinterGroupBox;
    Left := PrinterCombobox.Left + PrinterCombobox.Width + 10;
    Top := R.Top + 5;
    Width := 80;
    DefaultFont := DefaultButtonFont;
    UseSkinFont := Self.UseSkinFont;
    SkinData := CtrlSkinData;
    if (CtrlSkinData <> nil) and (CtrlSkinData.ResourceStrData <> nil)
    then
      Caption := CtrlSkinData.ResourceStrData.GetResStr('PRNDLG_PROPERTIES')
    else
      Caption := SP_PRNDLG_PROPERTIES;
    OnClick := PropertiesButtonClick;
    TabStop := True;
  end;

  with TspSkinStdLabel.Create(Self) do
  begin
    Parent := PrinterGroupBox;
    Left := R.Left + 10;
    Top := R.Top + 40;
    WordWrap := False;
    DefaultFont := DefaultLabelFont;
    UseSkinFont := Self.UseSkinFont;
    SkinData := CtrlSkinData;
    if (CtrlSkinData <> nil) and (CtrlSkinData.ResourceStrData <> nil)
    then
      Caption := CtrlSkinData.ResourceStrData.GetResStr('PRNDLG_STATUS')
    else
      Caption := SP_PRNDLG_STATUS;
  end;

  L1 := TspSkinStdLabel.Create(Self);
  with L1 do
  begin
    Parent := PrinterGroupBox;
    Left := R.Left + 80;
    Top := R.Top + 40;
    WordWrap := False;
    DefaultFont := DefaultLabelFont;
    UseSkinFont := Self.UseSkinFont;
    SkinData := CtrlSkinData;
    Caption := '';
  end;

  with TspSkinStdLabel.Create(Self) do
  begin
    Parent := PrinterGroupBox;
    Left := R.Left + 10;
    Top := R.Top + 60;
    WordWrap := False;
    DefaultFont := DefaultLabelFont;
    UseSkinFont := Self.UseSkinFont;
    SkinData := CtrlSkinData;
    if (CtrlSkinData <> nil) and (CtrlSkinData.ResourceStrData <> nil)
    then
      Caption := CtrlSkinData.ResourceStrData.GetResStr('PRNDLG_TYPE')
    else
      Caption := SP_PRNDLG_TYPE;
  end;

  L2 := TspSkinStdLabel.Create(Self);
  with L2 do
  begin
    Parent := PrinterGroupBox;
    Left := R.Left + 80;
    Top := R.Top + 60;
    WordWrap := False;
    DefaultFont := DefaultLabelFont;
    UseSkinFont := Self.UseSkinFont;
    SkinData := CtrlSkinData;
    Caption := '';
  end;


  with TspSkinStdLabel.Create(Self) do
  begin
    Parent := PrinterGroupBox;
    Left := R.Left + 10;
    Top := R.Top + 80;
    WordWrap := False;
    DefaultFont := DefaultLabelFont;
    UseSkinFont := Self.UseSkinFont;
    SkinData := CtrlSkinData;
    if (CtrlSkinData <> nil) and (CtrlSkinData.ResourceStrData <> nil)
    then
      Caption := CtrlSkinData.ResourceStrData.GetResStr('PRNDLG_WHERE')
    else
      Caption := SP_PRNDLG_WHERE;
  end;


  L3 := TspSkinStdLabel.Create(Self);
  with L3 do
  begin
    Parent := PrinterGroupBox;
    Left := R.Left + 80;
    Top := R.Top + 80;
    WordWrap := False;
    DefaultFont := DefaultLabelFont;
    UseSkinFont := Self.UseSkinFont;
    SkinData := CtrlSkinData;
    Caption := '';
  end;

  with TspSkinStdLabel.Create(Self) do
  begin
    Parent := PrinterGroupBox;
    Left := R.Left + 10;
    Top := R.Top + 100;
    WordWrap := False;
    DefaultFont := DefaultLabelFont;
    UseSkinFont := Self.UseSkinFont;
    SkinData := CtrlSkinData;
    if (CtrlSkinData <> nil) and (CtrlSkinData.ResourceStrData <> nil)
    then
      Caption := CtrlSkinData.ResourceStrData.GetResStr('PRNDLG_COMMENT')
    else
      Caption := SP_PRNDLG_COMMENT;
  end;

  L4 := TspSkinStdLabel.Create(Self);
  with L4 do
  begin
    Parent := PrinterGroupBox;
    Left := R.Left + 80;
    Top := R.Top + 100;
    WordWrap := False;
    DefaultFont := DefaultLabelFont;
    UseSkinFont := Self.UseSkinFont;
    SkinData := CtrlSkinData;
    Caption := '';
  end;

  GetPrinterInfo(S1, S2, S3, S4);
  L1.Caption := S1;
  L2.Caption := S2;
  L3.Caption := S3;
  L4.Caption := S4;

  PrintRangeGroupBox := TspSkinGroupBox.Create(Self);

  with PrintRangeGroupBox do
  begin
    Parent := Form;
    Left := 10;
    Top := PrinterGroupBox.Top + PrinterGroupBox.Height + 10;
    Width := (Form.ClientWidth - 20) div 2 + 30;
    Height := 120;
    SkinData := CtrlSkinData;
    if (CtrlSkinData <> nil) and (CtrlSkinData.ResourceStrData <> nil)
    then
      Caption := CtrlSkinData.ResourceStrData.GetResStr('PRNDLG_PRINTRANGE')
    else
      Caption := SP_PRNDLG_PRINTRANGE;
    if FGroupBoxTransparentMode then TransparentMode := True;
  end;

  CopiesGroupBox := TspSkinGroupBox.Create(Self);

  with CopiesGroupBox do
  begin
    Parent := Form;
    Left := PrintRangeGroupBox.Left + PrintRangeGroupBox.Width + 10;
    Top := PrinterGroupBox.Top + PrinterGroupBox.Height + 10;
    Width := (Form.ClientWidth - 20) div 2 - 40;
    Height := 120;
    SkinData := CtrlSkinData;
    if (CtrlSkinData <> nil) and (CtrlSkinData.ResourceStrData <> nil)
    then
      Caption := CtrlSkinData.ResourceStrData.GetResStr('PRNDLG_COPIES')
    else
      Caption := SP_PRNDLG_COPIES;
    if FGroupBoxTransparentMode then TransparentMode := True;  
  end;

  R := CopiesGroupBox.GetSkinClientRect;

  with TspSkinStdLabel.Create(Self) do
  begin
    Parent := CopiesGroupBox;
    Left := R.Left + 5;
    Top := R.Top + 10;
    WordWrap := False;
    DefaultFont := DefaultLabelFont;
    UseSkinFont := Self.UseSkinFont;
    SkinData := CtrlSkinData;
    if (CtrlSkinData <> nil) and (CtrlSkinData.ResourceStrData <> nil)
    then
      Caption := CtrlSkinData.ResourceStrData.GetResStr('PRNDLG_NUMCOPIES')
    else
      Caption := SP_PRNDLG_NUMCOPIES;
  end;

  NumCopiesEdit := TspSkinSpinEdit.Create(Self);
  with  NumCopiesEdit do
  begin
    Parent := CopiesGroupBox;
    MinValue := 1;
    MaxValue := 1000;
    if Self.Copies > 0
    then
      Printer.Copies := Self.Copies;
    Value := Printer.Copies;
    Increment := 1;
    Left := R.Right - 65;
    Top := R.Top + 5;
    Width := 60;
    SkinData := CtrlSkinData;
    OnChange := NumCopiesEditChange;
  end;

  CollateCheckBox := TspSkinCheckRadioBox.Create(Self);
  with CollateCheckBox do
  begin
    Parent := CopiesGroupBox;
    Checked := GetCollate;
    Left := R.Right - 70;
    Top := R.Top + 50;
    Width := 60;
    SkinData := CtrlSkinData;
    if (CtrlSkinData <> nil) and (CtrlSkinData.ResourceStrData <> nil)
    then
      Caption := CtrlSkinData.ResourceStrData.GetResStr('PRNDLG_COLLATE')
    else
      Caption := SP_PRNDLG_COLLATE;
    Enabled := Printer.Copies > 1;
    OnClick := CollateCheckBoxClick;
    TabStop := True;
  end;

  CollateImage := TImage.Create(Self);
  with CollateImage do
  begin
    Left := R.Left + 5;
    Top := R.Bottom - 45;
    Parent := CopiesGroupBox;
    AutoSize := True;
    Transparent := True;
    if CollateCheckBox.Checked
    then
      Picture.Bitmap.LoadFromResourceName(HInstance, 'SP_COLLATE')
    else
      Picture.Bitmap.LoadFromResourceName(HInstance, 'SP_NOCOLLATE');
  end;

  with TspSkinButton.Create(Form) do
  begin
    Parent := Form;
    DefaultFont := DefaultButtonFont;
    UseSkinFont := Self.UseSkinFont;
    if (CtrlSkinData <> nil) and (CtrlSkinData.ResourceStrData <> nil)
    then
      Caption := CtrlSkinData.ResourceStrData.GetResStr('MSG_BTN_OK')
    else
      Caption := SP_MSG_BTN_OK;
    ModalResult := mrOk;
    Default := True;
    SetBounds(Form.ClientWidth - 160,
              CopiesGroupBox.Top + CopiesGroupBox.Height + 10,
              70, 25);
    DefaultHeight := 25;
    SkinDataName := FButtonSkinDataName;
    SkinData := CtrlSkinData;
    TabStop := True;
  end;

  with TspSkinButton.Create(Form) do
  begin
    Parent := Form;
    DefaultFont := DefaultButtonFont;
    UseSkinFont := Self.UseSkinFont;
    if (CtrlSkinData <> nil) and (CtrlSkinData.ResourceStrData <> nil)
    then
      Caption := CtrlSkinData.ResourceStrData.GetResStr('MSG_BTN_CANCEL')
    else
      Caption := SP_MSG_BTN_CANCEL;
    ModalResult := mrCancel;
    Cancel := True;
    SetBounds(Form.ClientWidth - 80,
              CopiesGroupBox.Top + CopiesGroupBox.Height + 10,
              70, 25);
    SkinDataName := FButtonSkinDataName;
    SkinData := CtrlSkinData;
    Form.ClientHeight := Top + Height + 10;
   TabStop := True;
  end;

  R := PrintRangeGroupBox.GetSkinClientRect;

  RBAll := TspSkinCheckRadioBox.Create(Self);
  with RBAll do
  begin
    GroupIndex := 1;
    Parent := PrintRangeGroupBox;
    Checked := Self.PrintRange = bsprAllPages;
    Left := R.Left + 10;
    Top := R.Top + 5;
    Width := 70;
    Radio := True;
    SkinDataName := 'radiobox';
    SkinData := CtrlSkinData;
    if (CtrlSkinData <> nil) and (CtrlSkinData.ResourceStrData <> nil)
    then
      Caption := CtrlSkinData.ResourceStrData.GetResStr('PRNDLG_ALL')
    else
      Caption := SP_PRNDLG_ALL;
     TabStop := True;  
  end;

  RBPages := TspSkinCheckRadioBox.Create(Self);
  with RBPages do
  begin
    GroupIndex := 1;
    Parent := PrintRangeGroupBox;
    Checked := Self.PrintRange = bsprPageNums;
    Left := R.Left + 10;
    Top := R.Top + 35;
    Width := 70;
    Radio := True;
    SkinDataName := 'radiobox';
    SkinData := CtrlSkinData;
    if (CtrlSkinData <> nil) and (CtrlSkinData.ResourceStrData <> nil)
    then
      Caption := CtrlSkinData.ResourceStrData.GetResStr('PRNDLG_PAGES')
    else
      Caption := SP_PRNDLG_PAGES;
    Enabled := bspoPageNums in Options;
     TabStop := True;
  end;

  RBSelection := TspSkinCheckRadioBox.Create(Self);
  with RBSelection do
  begin
    GroupIndex := 1;
    Parent := PrintRangeGroupBox;
    Checked := Self.PrintRange = bsprSelection;
    Left := R.Left + 10;
    Top := R.Top + 65;
    Width := 70;
    Radio := True;
    SkinDataName := 'radiobox';
    SkinData := CtrlSkinData;
    if (CtrlSkinData <> nil) and (CtrlSkinData.ResourceStrData <> nil)
    then
      Caption := CtrlSkinData.ResourceStrData.GetResStr('PRNDLG_SELECTION')
    else
      Caption := SP_PRNDLG_SELECTION;
    Enabled := bspoSelection in Options;
    TabStop := True;
  end;

  fromL := TspSkinStdLabel.Create(Self);

  with fromL do
  begin
    Parent := PrintRangeGroupBox;
    WordWrap := False;
    DefaultFont := DefaultLabelFont;
    UseSkinFont := Self.UseSkinFont;
    SkinData := CtrlSkinData;
    if (CtrlSkinData <> nil) and (CtrlSkinData.ResourceStrData <> nil)
    then
      Caption := CtrlSkinData.ResourceStrData.GetResStr('PRNDLG_FROM')
    else
      Caption := SP_PRNDLG_FROM;
    Left := RBPages.Left + RBPages.Width + 10;
    Top := RBPages.Top + RBPages.Height div 2 - Height div 2 - 1;
    Enabled := bspoPageNums in Options;
  end;

  FromPageEdit := TspSkinSpinEdit.Create(Self);
  with  FromPageEdit do
  begin
    Parent := PrintRangeGroupBox;
    MinValue := MinPage;
    MaxValue := MaxPage;
    Value := FromPage;
    Increment := 1;
    Left := fromL.Left + fromL.Width + 5;
    Top := RBPages.Top + RBPages.Height div 2 - Height div 2 - 1;
    Width := 50;
    SkinData := CtrlSkinData;
    Enabled := bspoPageNums in Options;
    OnChange := FromPageEditChange;
  end;

  ToL := TspSkinStdLabel.Create(Self);

  with ToL do
  begin
    Parent := PrintRangeGroupBox;
    WordWrap := False;
    DefaultFont := DefaultLabelFont;
    UseSkinFont := Self.UseSkinFont;
    SkinData := CtrlSkinData;
    if (CtrlSkinData <> nil) and (CtrlSkinData.ResourceStrData <> nil)
    then
      Caption := CtrlSkinData.ResourceStrData.GetResStr('PRNDLG_TO')
    else
      Caption := SP_PRNDLG_TO;
    Left := FromPageEdit.Left +FromPageEdit.Width + 5;
    Top := RBPages.Top + RBPages.Height div 2 - Height div 2 - 1;
    Enabled := bspoPageNums in Options;
  end;

  ToPageEdit := TspSkinSpinEdit.Create(Self);
  with  ToPageEdit do
  begin
    Parent := PrintRangeGroupBox;
    MinValue := MinPage;
    MaxValue := MaxPage;
    Value := ToPage;
    Increment := 1;
    Left := ToL.Left + ToL.Width + 5;
    Top := RBPages.Top + RBPages.Height div 2 - Height div 2 - 1;
    Width := 50;
    SkinData := CtrlSkinData;
    Enabled := bspoPageNums in Options;
    OnChange := ToPageEditChange;
  end;

  OldPrinterIndex := Printer.PrinterIndex;

  try
    if Form.ShowModal = mrOk
    then
      begin
        Result := True;
        FCollate := CollateCheckBox.Checked;
        FromPage := Round(FromPageEdit.Value);
        ToPage := Round(ToPageEdit.Value);
        Copies := Round(NumCopiesEdit.Value);
        if RBAll.Checked then PrintRange := bsprAllPages else
        if RBPages.Checked then PrintRange := bsprPageNums else
          PrintRange := bsprSelection;
        PrintToFile := PrintToFileCheckBox.Checked;   
      end
    else
      begin
        RestoreDocumentProperties;
        if Printer.PrinterIndex <> OldPrinterIndex
        then
          Printer.PrinterIndex := OldPrinterIndex;
        Result := False;
      end;
  finally
    Form.Free;
  end;

end;

procedure TspSkinPrintDialog.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (AComponent = FSD) then FSD := nil;
  if (Operation = opRemove) and (AComponent = FCtrlFSD) then FCtrlFSD := nil;
end;

procedure TspSkinPrintDialog.SetDefaultButtonFont(Value: TFont);
begin
  FDefaultButtonFont.Assign(Value);
end;

procedure TspSkinPrintDialog.SetDefaultLabelFont(Value: TFont);
begin
  FDefaultLabelFont.Assign(Value);
end;

procedure TspSkinPrintDialog.SetDefaultSelectFont(Value: TFont);
begin
  FDefaultSelectFont.Assign(Value);
end;

function TspSkinPrintDialog.GetTitle: string;
begin
  Result := FTitle;
end;

procedure TspSkinPrintDialog.SetTitle(const Value: string);
begin
  FTitle := Value;
end;


{ TspPaperInfo }

function TspPaperInfo.IsEqual(Source: TspPaperInfo): Boolean;
begin
  Result := (DMPaper = Source.DMPaper) and (FName = Source.Name) and
    EqPoints(Size, Source.Size);
end;

procedure TspPaperInfo.Assign(Source: TspPaperInfo);
begin
  FDMPaper := Source.FDMPaper;
  FName := Source.FName;
  FSize := Source.FSize;
end;

function TspPaperInfo.GetSize(Index: Integer): Integer;
begin
  if Index = 0
  then
    Result := FSize.X
  else
    Result := FSize.Y;
end;

procedure TspPaperInfo.SetSize(Index: Integer; Value: Integer);
begin
  if DMPaper < DMPAPER_USER then Exit;
  if Index = 0
  then
    FSize.X := Value
  else
    FSize.Y := Value;
end;

procedure GetPapers(APapers: TStrings);
const
  bsPaperNameLength = 64;
  bsPaperValueLength = SizeOf(Word);
  bsPaperSizeLength = SizeOf(TPoint);
type
  TspPaperSize = TPoint;
  TspPaperSizes = array[0..0] of TspPaperSize;
  PbsPaperSizes = ^TspPaperSizes;
  TspPaperValue = Word;
  TspPaperValues = array [0..0] of TspPaperValue;
  PbsPaperValues = ^TspPaperValues;
  TspPaperName = array[0..bsPaperNameLength - 1] of char;
  TspPaperNames = array [0..0] of TspPaperName;
  PbsPaperNames = ^TspPaperNames;
var
  APaperNames: PbsPaperNames;
  APaperValues: PbsPaperValues;
  APaperSizes: PbsPaperSizes;
  ACount: Integer;
  I: Integer;
  APaper: TspPaperInfo;
  ACapability: UINT;
  ASaveFirstDMPaper: TPoint;
  PrinterName, Driver, Port: array[0..79] of Char;
  DevModeHandle: THandle;
begin
  Printer.GetPrinter(PrinterName, Driver, Port, DevModeHandle);
  if APapers <> nil then
  try
    APapers.Clear;
    ACapability := DC_PAPERNAMES;
    ACount := WinSpool.DeviceCapabilities(PrinterName, Port, ACapability, nil, nil);
    if ACount > 0 then
      begin
        GetMem(APaperNames, ACount * Sizeof( TspPapername ));
        try
          if WinSpool.DeviceCapabilities(PrinterName, Port, ACapability, PChar(APaperNames), nil) <> -1 then
          begin
            ACapability := DC_PAPERS;
            GetMem(APaperValues, ACount * Sizeof( TspPaperValue ));
           try
              if WinSpool.DeviceCapabilities(PrinterName, Port, ACapability, PChar(APaperValues), nil) <> -1 then
              begin
                ACapability := DC_PAPERSIZE;
                GetMem(APaperSizes, bsPaperSizeLength * ACount);
                try
                  if WinSpool.DeviceCapabilities(PrinterName, Port, ACapability, PChar(APaperSizes), nil) <> -1 then
                  begin
                    for I := 0 to ACount - 1 do
                    begin
                      APaper := TspPaperInfo.Create;
                      with APaper do
                      begin
                        FSize := APaperSizes^[I];
                        FDMPaper :=  APaperValues^[I];
                        FName := APaperNames^[I];
                      end;
                      APapers.AddObject(APaper.Name, APaper);
                    end;
                  end;
                finally
                  FreeMem(APaperSizes, bsPaperSizeLength * ACount);
                end;
              end;
            finally
              FreeMem(APaperValues, bsPaperValueLength * ACount);
            end;
          end;
        finally
          FreeMem(APaperNames, bsPaperNameLength * ACount);
        end;
    end;
  except
    raise;
  end;
end;


 procedure GetBins(sl: TStrings);
 type
   TBinName      = array [0..23] of Char;
   TBinNameArray = array [0..0] of TBinName;
   PBinnameArray = ^TBinNameArray;
   TBinArray     = array [0..0] of Word;
   PBinArray     = ^TBinArray;
 var
   Device, Driver, Port: array [0..255] of Char;
   hDevMode: THandle;
   i, numBinNames, numBins, temp: Integer;
   pBinNames: PBinnameArray;
   pBins: PBinArray;
 begin
   Printer.GetPrinter(Device, Driver, Port, hDevmode);
   numBinNames := WinSpool.DeviceCapabilities(Device, Port, DC_BINNAMES, nil, nil);
   numBins     := WinSpool.DeviceCapabilities(Device, Port, DC_BINS, nil, nil);
   if numBins <> numBinNames then
   begin
     raise Exception.Create('DeviceCapabilities reports different number of bins and bin names!');
   end;
   if numBinNames > 0 then
   begin
     pBins := nil;
     GetMem(pBinNames, numBinNames * SizeOf(TBinname));
     GetMem(pBins, numBins * SizeOf(Word));
     try
       WinSpool.DeviceCapabilities(Device, Port, DC_BINNAMES, PChar(pBinNames), nil);
       WinSpool.DeviceCapabilities(Device, Port, DC_BINS, PChar(pBins), nil);
       sl.Clear;
       for i := 0 to numBinNames - 1 do
       begin
         temp := pBins^[i];
         sl.addObject(pBinNames^[i], TObject(temp));
       end;
     finally
       FreeMem(pBinNames);
       if pBins <> nil then
         FreeMem(pBins);
     end;
   end;
 end;

constructor TspSkinPrinterSetupDialog.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FTitle := 'Print setup';
  FGroupBoxTransparentMode := False;

  FAlphaBlend := False;
  FAlphaBlendAnimation := False;
  FAlphaBlendValue := 200;

  FButtonSkinDataName := 'button';
  FLabelSkinDataName  := 'stdlabel';
  FSelectSkinDataName := 'combobox';

  FDefaultLabelFont := TFont.Create;
  FDefaultButtonFont := TFont.Create;
  FDefaultSelectFont := TFont.Create;

  FUseSkinFont := True;

  with FDefaultLabelFont do
  begin
    Name := 'Tahoma';
    Style := [];
    Height := 13;
  end;

  with FDefaultButtonFont do
  begin
    Name := 'Tahoma';
    Style := [];
    Height := 13;
  end;

  with FDefaultSelectFont do
  begin
    Name := 'Tahoma';
    Style := [];
    Height := 13;
  end;

  Bins := TStringList.Create;

  Papers := TStringList.Create;

  StopCheck := False;
end;

destructor TspSkinPrinterSetupDialog.Destroy;
begin
  ClearPapersAndBins;
  Papers.Free;
  Bins.Free;
  FDefaultLabelFont.Free;
  FDefaultButtonFont.Free;
  FDefaultSelectFont.Free;
  inherited;
end;

procedure TspSkinPrinterSetupDialog.ClearPapersAndBins;
var
  I: Integer;
begin
  if Papers.Count = 0 then Exit;
  for I := 0 to Papers.Count - 1 do
    TspPaperInfo(Papers.Objects[I]).Free;
  Papers.Clear;
  Bins.Clear;  
end;

procedure TspSkinPrinterSetupDialog.SaveCurrentPaperAndBin;
var
  PPrinterDevMode: PDevMode;
  DevModeHandle: THandle;
  hPrinter: THandle;
  PrinterName, Driver, Port: array[0..79] of Char;
  I: Integer;
begin
  Printer.GetPrinter(PrinterName, Driver, Port, DevModeHandle);
  if not OpenPrinter(PrinterName, hPrinter, nil)
  then
    raise EPrinter.Create(SysErrorMessage(GetLastError ));
  PPrinterDevMode := GlobalLock(DevModeHandle);
  //
  I := SizeComboBox.ItemIndex;
  if I <> -1
  then
   PPrinterDevMode^.dmPaperSize := TspPaperInfo(Papers.Objects[I]).DMPaper;
  I := SourceComboBox.ItemIndex;
  if I <> -1
  then
    PPrinterDevMode^.dmDefaultSource := Integer(Bins.Objects[I]);
  //
  DocumentProperties(0, hPrinter, PrinterName, PPrinterDevMode^, PPrinterDevMode^, DM_OUT_BUFFER or DM_IN_BUFFER);
  Printer.SetPrinter(PrinterName, Driver, Port, DevModeHandle); // fixed
  GlobalUnlock(DevModeHandle);
  ClosePrinter(hPrinter);
end;

procedure TspSkinPrinterSetupDialog.LoadCurrentPaperAndBin;
var
  PPrinterDevMode: PDevMode;
  DevModeHandle: THandle;
  hPrinter: THandle;
  PrinterName, Driver, Port: array[0..79] of Char;
  dm_Size: Integer;
  dm_Source: Integer;
  I, J: Integer;
begin
  Printer.GetPrinter(PrinterName, Driver, Port, DevModeHandle);
  if not OpenPrinter(PrinterName, hPrinter, nil)
  then
    raise EPrinter.Create(SysErrorMessage(GetLastError ));
  PPrinterDevMode := GlobalLock(DevModeHandle);
  DocumentProperties(0, hPrinter, PrinterName, PPrinterDevMode^, PPrinterDevMode^, DM_OUT_BUFFER or DM_IN_BUFFER);
  dm_Size := PPrinterDevMode^.dmPaperSize;
  dm_Source := PPrinterDevMode^.dmDefaultSource;
  GlobalUnlock(DevModeHandle);
  ClosePrinter(hPrinter);
  //
  J := 0;
  for I := 0 to SizeComboBox.Items.Count - 1 do
  begin
    if TspPaperInfo(Papers.Objects[I]).DMPaper = dm_Size
    then
      begin
        J := I;
        Break;
      end;
  end;
  SizeComboBox.ItemIndex := J;
  //
  J := 0;
  for I := 0 to SourceComboBox.Items.Count - 1 do
  begin
    if Integer(Bins.Objects[I]) = dm_Source
    then
      begin
        J := I;
        Break;
      end;
  end;
  SourceComboBox.ItemIndex := J;
  //
end;

procedure TspSkinPrinterSetupDialog.LoadPapersAndBins;
begin
  ClearPapersAndBins;
  GetPapers(Papers);
  GetBins(Bins);

  StopCheck := True;

  SizeComboBox.Items.Assign(Papers);
  SourceComboBox.Items.Assign(Bins);
  LoadCurrentPaperAndBin;

  StopCheck := False;
end;

procedure TspSkinPrinterSetupDialog.PropertiesButtonClick(Sender: TObject);
begin
  CallDocumentPropertiesDialog(Form.Handle);
  StopCheck := True;
  if Printer.Orientation = poPortrait
  then
    RBPortrait.Checked := True
  else
    RBLandscape.Checked := True;
  LoadCurrentPaperAndBin;
  StopCheck := False;
end;

procedure TspSkinPrinterSetupDialog.PrinterComboBoxChange(Sender: TObject);
var
  S1, S2, S3, S4: String;
begin
  Printer.PrinterIndex := PrinterComboBox.ItemIndex;
  GetPrinterInfo(S1, S2, S3, S4);
  L1.Caption := S1;
  L2.Caption := S2;
  L3.Caption := S3;
  L4.Caption := S4;
  LoadPapersAndBins;
end;

procedure TspSkinPrinterSetupDialog.RBPortraitClick(Sender: TObject);
begin
  Printer.Orientation := poPortrait;
  OrientationImage.Picture.Bitmap.LoadFromResourceName(HInstance, 'SP_PORTRAIT')
end;

procedure TspSkinPrinterSetupDialog.RBLandScapeClick(Sender: TObject);
begin
  Printer.Orientation := poLandscape;
  OrientationImage.Picture.Bitmap.LoadFromResourceName(HInstance, 'SP_LANDSCAPE');
end;

procedure TspSkinPrinterSetupDialog.SizeComboBoxChange(Sender: TObject);
begin
  if StopCheck then Exit;
  SaveCurrentPaperAndBin
end;

procedure TspSkinPrinterSetupDialog.SourceComboBoxChange(Sender: TObject);
begin
  if StopCheck then Exit;
  SaveCurrentPaperAndBin
end;

function TspSkinPrinterSetupDialog.Execute;
var
  DSF: TspDynamicSkinForm;
  OldPrinterIndex: Integer;
  PrinterGroupBox: TspSkinGroupBox;
  PaperGroupBox: TspSkinGroupBox;
  OrientationGroupBox: TspSkinGroupBox;
  R: TRect;
  S1, S2, S3, S4: String;
  SkinMessage: TspSkinMessage;
  S: String;
begin
  if (Printer = nil) or (Printer.Printers.Count = 0)
  then
    begin
      SkinMessage := TspSkinMessage.Create(Self);
      SkinMessage.SkinData := Self.SkinData;
      SkinMessage.CtrlSkinData := Self.CtrlSkinData;
      if (SkinData <> nil) and (SkinData.ResourceStrData <> nil)
      then
        S:= SkinData.ResourceStrData.GetResStr('PRNDLG_WARNING')
      else
        S := SP_PRNDLG_WARNING;
      SkinMessage.MessageDlg(S, mtError, [mbOk], 0);
      SkinMessage.Free;
      Exit;
    end;

  Form := TForm.Create(Application);
  Form.BorderStyle := bsDialog;
  Form.Position := poScreenCenter;
  Form.Caption := FTitle;
  DSF := TspDynamicSkinForm.Create(Form);
  DSF.BorderIcons := [];
  DSF.SizeAble := False;
  DSF.SkinData := SkinData;
  DSF.MenusSkinData := CtrlSkinData;
  DSF.AlphaBlend := AlphaBlend;
  DSF.AlphaBlendAnimation := AlphaBlendAnimation;
  DSF.AlphaBlendValue := AlphaBlendValue;

  Form.ClientWidth :=  460;
  Form.ClientHeight := 340;

  PrinterGroupBox := TspSkinGroupBox.Create(Self);

  with PrinterGroupBox do
  begin
    Parent := Form;
    Left := 10;
    Top := 10;
    Width := Form.ClientWidth - 20;
    Height := 150;
    SkinData := CtrlSkinData;
    if (CtrlSkinData <> nil) and (CtrlSkinData.ResourceStrData <> nil)
    then
      Caption := CtrlSkinData.ResourceStrData.GetResStr('PRNDLG_PRINTER')
    else
      Caption := SP_PRNDLG_PRINTER;
    if FGroupBoxTransparentMode then TransparentMode := True;
  end;

  R := PrinterGroupBox.GetSkinClientRect;

  with TspSkinStdLabel.Create(Self) do
  begin
    Parent := PrinterGroupBox;
    Left := R.Left + 10;
    Top := R.Top + 10;
    WordWrap := False;
    DefaultFont := DefaultLabelFont;
    UseSkinFont := Self.UseSkinFont;
    SkinData := CtrlSkinData;
    if (CtrlSkinData <> nil) and (CtrlSkinData.ResourceStrData <> nil)
    then
      Caption := CtrlSkinData.ResourceStrData.GetResStr('PRNDLG_NAME')
    else
      Caption := SP_PRNDLG_NAME;
  end;

  PrinterCombobox := TspSkinCombobox.Create(Form);
  with PrinterCombobox do
  begin
    Parent := PrinterGroupBox;
    DefaultFont := DefaultComboboxFont;
    UseSkinFont := Self.UseSkinFont;
    Items.Assign(Printer.Printers);
    ItemIndex := Printer.PrinterIndex;
    SkinDataName := FSelectSkinDataName;
    SkinData := CtrlSkinData;
    OnChange := PrinterComboBoxChange;
    Top := R.Top + 7;
    Left := R.Left + 80;
    Width := RectWidth(R) - 180;
   end;

  with TspSkinButton.Create(Self) do
  begin
    Parent := PrinterGroupBox;
    Left := PrinterCombobox.Left + PrinterCombobox.Width + 10;
    Top := R.Top + 5;
    Width := 80;
    DefaultFont := DefaultButtonFont;
    UseSkinFont := Self.UseSkinFont;
    SkinData := CtrlSkinData;
    if (CtrlSkinData <> nil) and (CtrlSkinData.ResourceStrData <> nil)
    then
      Caption := CtrlSkinData.ResourceStrData.GetResStr('PRNDLG_PROPERTIES')
    else
      Caption := SP_PRNDLG_PROPERTIES;
    OnClick := PropertiesButtonClick;
    TabStop := True;
  end;

  with TspSkinStdLabel.Create(Self) do
  begin
    Parent := PrinterGroupBox;
    Left := R.Left + 10;
    Top := R.Top + 40;
    WordWrap := False;
    DefaultFont := DefaultLabelFont;
    UseSkinFont := Self.UseSkinFont;
    SkinData := CtrlSkinData;
    if (CtrlSkinData <> nil) and (CtrlSkinData.ResourceStrData <> nil)
    then
      Caption := CtrlSkinData.ResourceStrData.GetResStr('PRNDLG_STATUS')
    else
      Caption := SP_PRNDLG_STATUS;
  end;

  L1 := TspSkinStdLabel.Create(Self);
  with L1 do
  begin
    Parent := PrinterGroupBox;
    Left := R.Left + 80;
    Top := R.Top + 40;
    WordWrap := False;
    DefaultFont := DefaultLabelFont;
    UseSkinFont := Self.UseSkinFont;
    SkinData := CtrlSkinData;
    Caption := '';
  end;

  with TspSkinStdLabel.Create(Self) do
  begin
    Parent := PrinterGroupBox;
    Left := R.Left + 10;
    Top := R.Top + 60;
    WordWrap := False;
    DefaultFont := DefaultLabelFont;
    UseSkinFont := Self.UseSkinFont;
    SkinData := CtrlSkinData;
    if (CtrlSkinData <> nil) and (CtrlSkinData.ResourceStrData <> nil)
    then
      Caption := CtrlSkinData.ResourceStrData.GetResStr('PRNDLG_TYPE')
    else
      Caption := SP_PRNDLG_TYPE;
  end;

  L2 := TspSkinStdLabel.Create(Self);
  with L2 do
  begin
    Parent := PrinterGroupBox;
    Left := R.Left + 80;
    Top := R.Top + 60;
    WordWrap := False;
    DefaultFont := DefaultLabelFont;
    UseSkinFont := Self.UseSkinFont;
    SkinData := CtrlSkinData;
    Caption := '';
  end;


  with TspSkinStdLabel.Create(Self) do
  begin
    Parent := PrinterGroupBox;
    Left := R.Left + 10;
    Top := R.Top + 80;
    WordWrap := False;
    DefaultFont := DefaultLabelFont;
    UseSkinFont := Self.UseSkinFont;
    SkinData := CtrlSkinData;
    if (CtrlSkinData <> nil) and (CtrlSkinData.ResourceStrData <> nil)
    then
      Caption := CtrlSkinData.ResourceStrData.GetResStr('PRNDLG_WHERE')
    else
      Caption := SP_PRNDLG_WHERE;
  end;


  L3 := TspSkinStdLabel.Create(Self);
  with L3 do
  begin
    Parent := PrinterGroupBox;
    Left := R.Left + 80;
    Top := R.Top + 80;
    WordWrap := False;
    DefaultFont := DefaultLabelFont;
    UseSkinFont := Self.UseSkinFont;
    SkinData := CtrlSkinData;
    Caption := '';
  end;

  with TspSkinStdLabel.Create(Self) do
  begin
    Parent := PrinterGroupBox;
    Left := R.Left + 10;
    Top := R.Top + 100;
    WordWrap := False;
    DefaultFont := DefaultLabelFont;
    UseSkinFont := Self.UseSkinFont;
    SkinData := CtrlSkinData;
    if (CtrlSkinData <> nil) and (CtrlSkinData.ResourceStrData <> nil)
    then
      Caption := CtrlSkinData.ResourceStrData.GetResStr('PRNDLG_COMMENT')
    else
      Caption := SP_PRNDLG_COMMENT;
  end;

  L4 := TspSkinStdLabel.Create(Self);
  with L4 do
  begin
    Parent := PrinterGroupBox;
    Left := R.Left + 80;
    Top := R.Top + 100;
    WordWrap := False;
    DefaultFont := DefaultLabelFont;
    UseSkinFont := Self.UseSkinFont;
    SkinData := CtrlSkinData;
    Caption := '';
  end;

  GetPrinterInfo(S1, S2, S3, S4);
  L1.Caption := S1;
  L2.Caption := S2;
  L3.Caption := S3;
  L4.Caption := S4;

  PaperGroupBox := TspSkinGroupBox.Create(Self);

  with PaperGroupBox do
  begin
    Parent := Form;
    Left := 10;
    Top := PrinterGroupBox.Top + PrinterGroupBox.Height + 10;
    Width := (Form.ClientWidth - 20) div 2 + 30;
    Height := 120;
    SkinData := CtrlSkinData;
    if (CtrlSkinData <> nil) and (CtrlSkinData.ResourceStrData <> nil)
    then
      Caption := CtrlSkinData.ResourceStrData.GetResStr('PRNDLG_PAPER')
    else
      Caption := SP_PRNDLG_PAPER;
   if FGroupBoxTransparentMode then TransparentMode := True;
  end;

  OrientationGroupBox := TspSkinGroupBox.Create(Self);

  with OrientationGroupBox do
  begin
    Parent := Form;
    Left := PaperGroupBox.Left + PaperGroupBox.Width + 10;
    Top := PrinterGroupBox.Top + PrinterGroupBox.Height + 10;
    Width := (Form.ClientWidth - 20) div 2 - 40;
    Height := 120;
    SkinData := CtrlSkinData;
    if (CtrlSkinData <> nil) and (CtrlSkinData.ResourceStrData <> nil)
    then
      Caption := CtrlSkinData.ResourceStrData.GetResStr('PRNDLG_ORIENTATION')
    else
      Caption := SP_PRNDLG_ORIENTATION;
    if FGroupBoxTransparentMode then TransparentMode := True;  
  end;

  R := OrientationGroupBox.GetSkinClientRect;

  RBPortrait := TspSkinCheckRadioBox.Create(Self);
  with RBPortrait do
  begin
    GroupIndex := 1;
    Parent := OrientationGroupBox;
    Checked := Printer.Orientation = poPortrait;
    Left := R.Right - 100;
    Top := R.Top + 15;
    Width := 90;
    Radio := True;
    SkinDataName := 'radiobox';
    SkinData := CtrlSkinData;
    if (CtrlSkinData <> nil) and (CtrlSkinData.ResourceStrData <> nil)
    then
      Caption := CtrlSkinData.ResourceStrData.GetResStr('PRNDLG_PORTRAIT')
    else
      Caption := SP_PRNDLG_PORTRAIT;
    OnClick := RBPortraitClick;
    TabStop := True;
  end;

  RBLandScape := TspSkinCheckRadioBox.Create(Self);
  with RBLandScape do
  begin
    GroupIndex := 1;
    Parent := OrientationGroupBox;
    Checked := Printer.Orientation = poLandScape;
    Left := R.Right - 100;
    Top := R.Bottom - 45;
    Width := 90;
    Radio := True;
    SkinDataName := 'radiobox';
    SkinData := CtrlSkinData;
    if (CtrlSkinData <> nil) and (CtrlSkinData.ResourceStrData <> nil)
    then
      Caption := CtrlSkinData.ResourceStrData.GetResStr('PRNDLG_LANDSCAPE')
    else
      Caption := SP_PRNDLG_LANDSCAPE;
    OnClick := RBLandScapeClick;
    TabStop := True;
  end;

  OrientationImage := TImage.Create(Self);
  with OrientationImage do
  begin
    Top := R.Top + 30;
    Left := R.Left + 25;
    Parent := OrientationGroupBox;
    AutoSize := True;
    Transparent := True;
    if Printer.Orientation = poPortrait
    then
      Picture.Bitmap.LoadFromResourceName(HInstance, 'SP_PORTRAIT')
    else
      Picture.Bitmap.LoadFromResourceName(HInstance, 'SP_LANDSCAPE');
  end;

  with TspSkinStdLabel.Create(Self) do
  begin
    Parent := PaperGroupBox;
    Left := R.Left + 10;
    Top := R.Top + 20;
    WordWrap := False;
    DefaultFont := DefaultLabelFont;
    UseSkinFont := Self.UseSkinFont;
    SkinData := CtrlSkinData;
    if (CtrlSkinData <> nil) and (CtrlSkinData.ResourceStrData <> nil)
    then
      Caption := CtrlSkinData.ResourceStrData.GetResStr('PRNDLG_SIZE')
    else
      Caption := SP_PRNDLG_SIZE;
  end;

  with TspSkinStdLabel.Create(Self) do
  begin
    Parent := PaperGroupBox;
    Left := R.Left + 10;
    Top := R.Top + 65;
    WordWrap := False;
    DefaultFont := DefaultLabelFont;
    UseSkinFont := Self.UseSkinFont;
    SkinData := CtrlSkinData;
    if (CtrlSkinData <> nil) and (CtrlSkinData.ResourceStrData <> nil)
    then
      Caption := CtrlSkinData.ResourceStrData.GetResStr('PRNDLG_SOURCE')
    else
      Caption := SP_PRNDLG_SOURCE;
  end;

  SizeComboBox := TspSkinCombobox.Create(Form);
  with SizeComboBox do
  begin
    Parent := PaperGroupBox;
    DefaultFont := DefaultComboboxFont;
    UseSkinFont := Self.UseSkinFont;
    SkinDataName := FSelectSkinDataName;
    SkinData := CtrlSkinData;
    Top := R.Top + 17;
    Left := R.Left + 65;
    Width := 170;
    OnChange := SizeComboBoxChange;
   end;

  SourceComboBox := TspSkinCombobox.Create(Form);
  with SourceComboBox do
  begin
    Parent := PaperGroupBox;
    DefaultFont := DefaultComboboxFont;
    UseSkinFont := Self.UseSkinFont;
    SkinDataName := FSelectSkinDataName;
    SkinData := CtrlSkinData;
    Top := R.Top + 60;
    Left := R.Left + 65;
    Width := 170;
    OnChange := SourceComboBoxChange;
   end;

  //
  LoadPapersAndBins;
  //

  with TspSkinButton.Create(Form) do
  begin
    Parent := Form;
    DefaultFont := DefaultButtonFont;
    UseSkinFont := Self.UseSkinFont;
    if (CtrlSkinData <> nil) and (CtrlSkinData.ResourceStrData <> nil)
    then
      Caption := CtrlSkinData.ResourceStrData.GetResStr('MSG_BTN_OK')
    else
      Caption := SP_MSG_BTN_OK;
    ModalResult := mrOk;
    Default := True;
    SetBounds(Form.ClientWidth - 160,
              OrientationGroupBox.Top + OrientationGroupBox.Height + 10,
              70, 25);
    DefaultHeight := 25;
    SkinDataName := FButtonSkinDataName;
    SkinData := CtrlSkinData;
    TabStop := True;
  end;

  with TspSkinButton.Create(Form) do
  begin
    Parent := Form;
    DefaultFont := DefaultButtonFont;
    UseSkinFont := Self.UseSkinFont;
    if (CtrlSkinData <> nil) and (CtrlSkinData.ResourceStrData <> nil)
    then
      Caption := CtrlSkinData.ResourceStrData.GetResStr('MSG_BTN_CANCEL')
    else
      Caption := SP_MSG_BTN_CANCEL;
    ModalResult := mrCancel;
    Cancel := True;
    SetBounds(Form.ClientWidth - 80,
              OrientationGroupBox.Top + OrientationGroupBox.Height + 10,
              70, 25);
    SkinDataName := FButtonSkinDataName;
    SkinData := CtrlSkinData;
    Form.ClientHeight := Top + Height + 10;
    TabStop := True;
  end;
 
  OldPrinterIndex := Printer.PrinterIndex;

  try
    if Form.ShowModal = mrOk
    then
      begin
        Result := True;
      end
    else
      begin
        if Printer.PrinterIndex <> OldPrinterIndex
        then
          begin
            Printer.PrinterIndex := OldPrinterIndex;
            RestoreDocumentProperties;
          end;
        Result := False;
      end;
  finally
    Form.Free;
  end;

end;

procedure TspSkinPrinterSetupDialog.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (AComponent = FSD) then FSD := nil;
  if (Operation = opRemove) and (AComponent = FCtrlFSD) then FCtrlFSD := nil;
end;

procedure TspSkinPrinterSetupDialog.SetDefaultButtonFont(Value: TFont);
begin
  FDefaultButtonFont.Assign(Value);
end;

procedure TspSkinPrinterSetupDialog.SetDefaultLabelFont(Value: TFont);
begin
  FDefaultLabelFont.Assign(Value);
end;

procedure TspSkinPrinterSetupDialog.SetDefaultSelectFont(Value: TFont);
begin
  FDefaultSelectFont.Assign(Value);
end;

function TspSkinPrinterSetupDialog.GetTitle: string;
begin
  Result := FTitle;
end;

procedure TspSkinPrinterSetupDialog.SetTitle(const Value: string);
begin
  FTitle := Value;
end;

// TspSkinSmallPrinterDialog

constructor TspSkinSmallPrintDialog.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FTitle := 'Print setup';
  FGroupBoxTransparentMode := False;

  FAlphaBlend := False;
  FAlphaBlendAnimation := False;
  FAlphaBlendValue := 200;

  FButtonSkinDataName := 'button';
  FLabelSkinDataName  := 'stdlabel';
  FSelectSkinDataName := 'combobox';

  FDefaultLabelFont := TFont.Create;
  FDefaultButtonFont := TFont.Create;
  FDefaultSelectFont := TFont.Create;

  FUseSkinFont := True;

  with FDefaultLabelFont do
  begin
    Name := 'Tahoma';
    Style := [];
    Height := 13;
  end;

  with FDefaultButtonFont do
  begin
    Name := 'Tahoma';
    Style := [];
    Height := 13;
  end;

  with FDefaultSelectFont do
  begin
    Name := 'Tahoma';
    Style := [];
    Height := 13;
  end;
end;

destructor TspSkinSmallPrintDialog.Destroy;
begin
  FDefaultLabelFont.Free;
  FDefaultButtonFont.Free;
  FDefaultSelectFont.Free;
  inherited;
end;

procedure TspSkinSmallPrintDialog.PropertiesButtonClick(Sender: TObject);
begin
  CallDocumentPropertiesDialog(Form.Handle);
end;

procedure TspSkinSmallPrintDialog.PrinterComboBoxChange(Sender: TObject);
var
  S1, S2, S3, S4: String;
begin
  Printer.PrinterIndex := PrinterComboBox.ItemIndex;
  GetPrinterInfo(S1, S2, S3, S4);
  L1.Caption := S1;
  L2.Caption := S2;
  L3.Caption := S3;
  L4.Caption := S4;
end;

function TspSkinSmallPrintDialog.Execute;
var
  DSF: TspDynamicSkinForm;
  OldPrinterIndex: Integer;
  PrinterGroupBox: TspSkinGroupBox;
  R: TRect;
  S1, S2, S3, S4: String;
  SkinMessage: TspSkinMessage;
  S: String;
begin
  if (Printer = nil) or (Printer.Printers.Count = 0)
  then
    begin
      SkinMessage := TspSkinMessage.Create(Self);
      SkinMessage.SkinData := Self.SkinData;
      SkinMessage.CtrlSkinData := Self.CtrlSkinData;
      if (SkinData <> nil) and (SkinData.ResourceStrData <> nil)
      then
        S:= SkinData.ResourceStrData.GetResStr('PRNDLG_WARNING')
      else
        S := SP_PRNDLG_WARNING;
      SkinMessage.MessageDlg(S, mtError, [mbOk], 0);
      SkinMessage.Free;
      Exit;
    end;

  Form := TForm.Create(Application);
  Form.BorderStyle := bsDialog;
  Form.Position := poScreenCenter;
  Form.Caption := FTitle;
  DSF := TspDynamicSkinForm.Create(Form);
  DSF.BorderIcons := [];
  DSF.SkinData := SkinData;
  DSF.MenusSkinData := CtrlSkinData;
  DSF.AlphaBlend := AlphaBlend;
  DSF.AlphaBlendAnimation := AlphaBlendAnimation;
  DSF.AlphaBlendValue := AlphaBlendValue;
  DSF.SizeAble := False;

  Form.ClientWidth :=  460;
  Form.ClientHeight := 170;

  PrinterGroupBox := TspSkinGroupBox.Create(Self);

  with PrinterGroupBox do
  begin
    Parent := Form;
    Left := 10;
    Top := 10;
    Width := Form.ClientWidth - 20;
    Height := 150;
    SkinData := CtrlSkinData;
    if (CtrlSkinData <> nil) and (CtrlSkinData.ResourceStrData <> nil)
    then
      Caption := CtrlSkinData.ResourceStrData.GetResStr('PRNDLG_PRINTER')
    else
      Caption := SP_PRNDLG_PRINTER;
    if FGroupBoxTransparentMode then TransparentMode := True; 
  end;

  R := PrinterGroupBox.GetSkinClientRect;

  with TspSkinStdLabel.Create(Self) do
  begin
    Parent := PrinterGroupBox;
    Left := R.Left + 10;
    Top := R.Top + 10;
    WordWrap := False;
    DefaultFont := DefaultLabelFont;
    UseSkinFont := Self.UseSkinFont;
    SkinData := CtrlSkinData;
    if (CtrlSkinData <> nil) and (CtrlSkinData.ResourceStrData <> nil)
    then
      Caption := CtrlSkinData.ResourceStrData.GetResStr('PRNDLG_NAME')
    else
      Caption := SP_PRNDLG_NAME;
  end;

  PrinterCombobox := TspSkinCombobox.Create(Form);
  with PrinterCombobox do
  begin
    Parent := PrinterGroupBox;
    DefaultFont := DefaultComboboxFont;
    UseSkinFont := Self.UseSkinFont;
    Items.Assign(Printer.Printers);
    ItemIndex := Printer.PrinterIndex;
    SkinDataName := FSelectSkinDataName;
    SkinData := CtrlSkinData;
    OnChange := PrinterComboBoxChange;
    Top := R.Top + 7;
    Left := R.Left + 80;
    Width := RectWidth(R) - 180;
   end;

  with TspSkinButton.Create(Self) do
  begin
    Parent := PrinterGroupBox;
    Left := PrinterCombobox.Left + PrinterCombobox.Width + 10;
    Top := R.Top + 5;
    Width := 80;
    DefaultFont := DefaultButtonFont;
    UseSkinFont := Self.UseSkinFont;
    SkinData := CtrlSkinData;
    if (CtrlSkinData <> nil) and (CtrlSkinData.ResourceStrData <> nil)
    then
      Caption := CtrlSkinData.ResourceStrData.GetResStr('PRNDLG_PROPERTIES')
    else
      Caption := SP_PRNDLG_PROPERTIES;
    OnClick := PropertiesButtonClick;
    TabStop := True;
  end;

  with TspSkinStdLabel.Create(Self) do
  begin
    Parent := PrinterGroupBox;
    Left := R.Left + 10;
    Top := R.Top + 40;
    WordWrap := False;
    DefaultFont := DefaultLabelFont;
    UseSkinFont := Self.UseSkinFont;
    SkinData := CtrlSkinData;
    if (CtrlSkinData <> nil) and (CtrlSkinData.ResourceStrData <> nil)
    then
      Caption := CtrlSkinData.ResourceStrData.GetResStr('PRNDLG_STATUS')
    else
      Caption := SP_PRNDLG_STATUS;
  end;

  L1 := TspSkinStdLabel.Create(Self);
  with L1 do          
  begin
    Parent := PrinterGroupBox;
    Left := R.Left + 80;
    Top := R.Top + 40;
    WordWrap := False;
    DefaultFont := DefaultLabelFont;
    UseSkinFont := Self.UseSkinFont;
    SkinData := CtrlSkinData;
    Caption := '';
  end;

  with TspSkinStdLabel.Create(Self) do
  begin
    Parent := PrinterGroupBox;
    Left := R.Left + 10;
    Top := R.Top + 60;
    WordWrap := False;
    DefaultFont := DefaultLabelFont;
    UseSkinFont := Self.UseSkinFont;
    SkinData := CtrlSkinData;
    if (CtrlSkinData <> nil) and (CtrlSkinData.ResourceStrData <> nil)
    then
      Caption := CtrlSkinData.ResourceStrData.GetResStr('PRNDLG_TYPE')
    else
      Caption := SP_PRNDLG_TYPE;
  end;

  L2 := TspSkinStdLabel.Create(Self);
  with L2 do
  begin
    Parent := PrinterGroupBox;
    Left := R.Left + 80;
    Top := R.Top + 60;
    WordWrap := False;
    DefaultFont := DefaultLabelFont;
    UseSkinFont := Self.UseSkinFont;
    SkinData := CtrlSkinData;
    Caption := '';
  end;


  with TspSkinStdLabel.Create(Self) do
  begin
    Parent := PrinterGroupBox;
    Left := R.Left + 10;
    Top := R.Top + 80;
    WordWrap := False;
    DefaultFont := DefaultLabelFont;
    UseSkinFont := Self.UseSkinFont;
    SkinData := CtrlSkinData;
    if (CtrlSkinData <> nil) and (CtrlSkinData.ResourceStrData <> nil)
    then
      Caption := CtrlSkinData.ResourceStrData.GetResStr('PRNDLG_WHERE')
    else
      Caption := SP_PRNDLG_WHERE;
  end;


  L3 := TspSkinStdLabel.Create(Self);
  with L3 do
  begin
    Parent := PrinterGroupBox;
    Left := R.Left + 80;
    Top := R.Top + 80;
    WordWrap := False;
    DefaultFont := DefaultLabelFont;
    UseSkinFont := Self.UseSkinFont;
    SkinData := CtrlSkinData;
    Caption := '';
  end;

  with TspSkinStdLabel.Create(Self) do
  begin
    Parent := PrinterGroupBox;
    Left := R.Left + 10;
    Top := R.Top + 100;
    WordWrap := False;
    DefaultFont := DefaultLabelFont;
    UseSkinFont := Self.UseSkinFont;
    SkinData := CtrlSkinData;
    if (CtrlSkinData <> nil) and (CtrlSkinData.ResourceStrData <> nil)
    then
      Caption := CtrlSkinData.ResourceStrData.GetResStr('PRNDLG_COMMENT')
    else
      Caption := SP_PRNDLG_COMMENT;
  end;

  L4 := TspSkinStdLabel.Create(Self);
  with L4 do
  begin
    Parent := PrinterGroupBox;
    Left := R.Left + 80;
    Top := R.Top + 100;
    WordWrap := False;
    DefaultFont := DefaultLabelFont;
    UseSkinFont := Self.UseSkinFont;
    SkinData := CtrlSkinData;
    Caption := '';
  end;

  GetPrinterInfo(S1, S2, S3, S4);
  L1.Caption := S1;
  L2.Caption := S2;
  L3.Caption := S3;
  L4.Caption := S4;

  with TspSkinButton.Create(Form) do
  begin
    Parent := Form;
    DefaultFont := DefaultButtonFont;
    UseSkinFont := Self.UseSkinFont;
    if (CtrlSkinData <> nil) and (CtrlSkinData.ResourceStrData <> nil)
    then
      Caption := CtrlSkinData.ResourceStrData.GetResStr('MSG_BTN_OK')
    else
      Caption := SP_MSG_BTN_OK;
    ModalResult := mrOk;
    Default := True;
    SetBounds(Form.ClientWidth - 160,
              PrinterGroupBox.Top + PrinterGroupBox.Height + 10,
              70, 25);
    DefaultHeight := 25;
    SkinDataName := FButtonSkinDataName;
    SkinData := CtrlSkinData;
    TabStop := True;
  end;

  with TspSkinButton.Create(Form) do
  begin
    Parent := Form;
    DefaultFont := DefaultButtonFont;
    UseSkinFont := Self.UseSkinFont;
    if (CtrlSkinData <> nil) and (CtrlSkinData.ResourceStrData <> nil)
    then
      Caption := CtrlSkinData.ResourceStrData.GetResStr('MSG_BTN_CANCEL')
    else
      Caption := SP_MSG_BTN_CANCEL;
    ModalResult := mrCancel;
    Cancel := True;
    SetBounds(Form.ClientWidth - 80,
              PrinterGroupBox.Top + PrinterGroupBox.Height + 10,
              70, 25);
    SkinDataName := FButtonSkinDataName;
    SkinData := CtrlSkinData;
    Form.ClientHeight := Top + Height + 10;
    TabStop := True;
  end;
 
  OldPrinterIndex := Printer.PrinterIndex;

  try
    if Form.ShowModal = mrOk
    then
      begin
        Result := True;
      end
    else
      begin
        RestoreDocumentProperties;
        if Printer.PrinterIndex <> OldPrinterIndex
        then
          Printer.PrinterIndex := OldPrinterIndex;
        Result := False;
      end;
  finally
    Form.Free;
  end;

end;

procedure TspSkinSmallPrintDialog.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (AComponent = FSD) then FSD := nil;
  if (Operation = opRemove) and (AComponent = FCtrlFSD) then FCtrlFSD := nil;
end;

procedure TspSkinSmallPrintDialog.SetDefaultButtonFont(Value: TFont);
begin
  FDefaultButtonFont.Assign(Value);
end;

procedure TspSkinSmallPrintDialog.SetDefaultLabelFont(Value: TFont);
begin
  FDefaultLabelFont.Assign(Value);
end;

procedure TspSkinSmallPrintDialog.SetDefaultSelectFont(Value: TFont);
begin
  FDefaultSelectFont.Assign(Value);
end;

function TspSkinSmallPrintDialog.GetTitle: string;
begin
  Result := FTitle;
end;

procedure TspSkinSmallPrintDialog.SetTitle(const Value: string);
begin
  FTitle := Value;
end;

// TspSkinPageSetupDialog

function InchToMM(Inches: Double): Double;
begin
  Result := Inches * 25.4;
end;

function MMtoInch(MM: Double): Double;
begin
  Result := MM / 25.4;
end;

function MMtoInch2(MM: Double): Double;
begin
  Result := MM / 10;
  Result := Round(MMToInch(Result) * 1000) div 10;
end;

procedure GetPaperSizeInMM(var X, Y: Integer; PageWidth, PageHeight: Integer);
begin
  X := PageWidth * 10;
  Y := PageHeight * 10;
end;

procedure GetPaperSizeInInches(var X, Y: Integer; PageWidth, PageHeight: Integer);
begin
  GetPaperSizeInMM(X, Y, PageWidth, PageHeight);
  X := X div 10;
  Y := Y div 10;
  X := Round(MMToInch(X) * 1000) div 10;
  Y := Round(MMToInch(Y) * 1000) div 10;
end;

constructor TspSkinPageSetupDialog.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FTitle := 'Page setup';
  FGroupBoxTransparentMode := False;

  FAlphaBlend := False;
  FAlphaBlendAnimation := False;
  FAlphaBlendValue := 200;

  FButtonSkinDataName := 'button';
  FLabelSkinDataName  := 'stdlabel';
  FSelectSkinDataName := 'combobox';

  FDefaultLabelFont := TFont.Create;
  FDefaultButtonFont := TFont.Create;
  FDefaultSelectFont := TFont.Create;

  FUseSkinFont := True;

  with FDefaultLabelFont do
  begin
    Name := 'Tahoma';
    Style := [];
    Height := 13;
  end;

  with FDefaultButtonFont do
  begin
    Name := 'Tahoma';
    Style := [];
    Height := 13;
  end;

  with FDefaultSelectFont do
  begin
    Name := 'Tahoma';
    Style := [];
    Height := 13;
  end;

  Bins := TStringList.Create;

  Papers := TStringList.Create;

  StopCheck := False;

  FMinMarginLeft := 0;
  FMinMarginTop := 0;
  FMinMarginRight := 0;
  FMinMarginBottom := 0;

  FMaxMarginLeft := 0;
  FMaxMarginTop := 0;
  FMaxMarginRight := 0;
  FMaxMarginBottom := 0;

  FMarginLeft := 0;
  FMarginTop := 0;
  FMarginRight := 0;
  FMarginBottom := 0;
  FPageWidth := 0;
  FPageHeight := 0;
  FOptions := [];
end;

destructor TspSkinPageSetupDialog.Destroy;
begin
  ClearPapersAndBins;
  Papers.Free;
  Bins.Free;
  FDefaultLabelFont.Free;
  FDefaultButtonFont.Free;
  FDefaultSelectFont.Free;
  inherited;
end;

procedure TspSkinPageSetupDialog.LeftMEditChange(Sender: TObject);
begin
  if FUnits = sppmMillimeters
  then
    PagePreview.LeftMargin := Round(LeftMEdit.Value * 100)
  else
    PagePreview.LeftMargin := Round(InchToMM(LeftMEdit.Value) * 100);
  PagePreview.RePaint;
end;

procedure TspSkinPageSetupDialog.TopMEditChange(Sender: TObject);
begin
  if FUnits = sppmMillimeters
  then
    PagePreview.TopMargin := Round(TopMEdit.Value * 100)
  else
    PagePreview.TopMargin := Round(InchToMM(TopMEdit.Value) * 100);
  PagePreview.RePaint;
end;

procedure TspSkinPageSetupDialog.RightMEditChange(Sender: TObject);
begin
  if FUnits = sppmMillimeters
  then
    PagePreview.RightMargin :=  Round(RightMEdit.Value * 100)
  else
    PagePreview.RightMargin :=  Round(InchToMM(RightMEdit.Value) * 100);
  PagePreview.RePaint;
end;

procedure TspSkinPageSetupDialog.BottomMEditChange(Sender: TObject);
begin
  if FUnits = sppmMillimeters
  then
    PagePreview.BottomMargin :=  Round(BottomMEdit.Value * 100)
  else
    PagePreview.BottomMargin :=  Round(InchToMM(BottomMEdit.Value) * 100);
  PagePreview.RePaint;
end;

procedure TspSkinPageSetupDialog.ClearPapersAndBins;
var
  I: Integer;
begin
  if Papers.Count = 0 then Exit;
  for I := 0 to Papers.Count - 1 do
    TspPaperInfo(Papers.Objects[I]).Free;
  Papers.Clear;
  Bins.Clear;
end;

procedure TspSkinPageSetupDialog.SaveCurrentPaperAndBin;
var
  PPrinterDevMode: PDevMode;
  DevModeHandle: THandle;
  hPrinter: THandle;
  PrinterName, Driver, Port: array[0..79] of Char;
  I: Integer;
begin
  Printer.GetPrinter(PrinterName, Driver, Port, DevModeHandle);
  if not OpenPrinter(PrinterName, hPrinter, nil)
  then
    raise EPrinter.Create(SysErrorMessage(GetLastError ));
  PPrinterDevMode := GlobalLock(DevModeHandle);
  //
  I := SizeComboBox.ItemIndex;
  if I <> -1
  then
   PPrinterDevMode^.dmPaperSize := TspPaperInfo(Papers.Objects[I]).DMPaper;
  I := SourceComboBox.ItemIndex;
  if I <> -1
  then
    PPrinterDevMode^.dmDefaultSource := Integer(Bins.Objects[I]);
  //
  DocumentProperties(0, hPrinter, PrinterName, PPrinterDevMode^, PPrinterDevMode^, DM_OUT_BUFFER or DM_IN_BUFFER);
  GlobalUnlock(DevModeHandle);
  ClosePrinter(hPrinter);
end;

procedure TspSkinPageSetupDialog.LoadCurrentPaperAndBin;
var
  PPrinterDevMode: PDevMode;
  DevModeHandle: THandle;
  hPrinter: THandle;
  PrinterName, Driver, Port: array[0..79] of Char;
  dm_Size: Integer;
  dm_Source: Integer;
  I, J: Integer;
begin
  Printer.GetPrinter(PrinterName, Driver, Port, DevModeHandle);
  if not OpenPrinter(PrinterName, hPrinter, nil)
  then
    raise EPrinter.Create(SysErrorMessage(GetLastError ));
  PPrinterDevMode := GlobalLock(DevModeHandle);
  DocumentProperties(0, hPrinter, PrinterName, PPrinterDevMode^, PPrinterDevMode^, DM_OUT_BUFFER or DM_IN_BUFFER);
  dm_Size := PPrinterDevMode^.dmPaperSize;
  dm_Source := PPrinterDevMode^.dmDefaultSource;
  GlobalUnlock(DevModeHandle);
  ClosePrinter(hPrinter);
  //
  J := 0;
  for I := 0 to SizeComboBox.Items.Count - 1 do
  begin
    if TspPaperInfo(Papers.Objects[I]).DMPaper = dm_Size
    then
      begin
        J := I;
        Break;
      end;
  end;
  SizeComboBox.ItemIndex := J;
  //
  J := 0;
  for I := 0 to SourceComboBox.Items.Count - 1 do
  begin
    if Integer(Bins.Objects[I]) = dm_Source
    then
      begin
        J := I;
        Break;
      end;
  end;
  SourceComboBox.ItemIndex := J;
  //
  I := SizeComboBox.ItemIndex;
  if I <> -1
  then
    begin
      GetPaperSizeInMM(PagePreview.PageWidth, PagePreview.PageHeight,
                       TspPaperInfo(Papers.Objects[I]).Size.X,
                       TspPaperInfo(Papers.Objects[I]).Size.Y);

      if FUnits = sppmMillimeters
      then
        begin
          PagePreview.LeftMargin := Round(LeftMEdit.Value * 100);
          PagePreview.TopMargin := Round(TopMEdit.Value * 100);
          PagePreview.RightMargin := Round(RightMEdit.Value * 100);
          PagePreview.BottomMargin := Round(BottomMEdit.Value * 100);
        end
      else
        begin
          PagePreview.LeftMargin := Round(InchToMM(LeftMEdit.Value) * 100);
          PagePreview.TopMargin := Round(InchToMM(TopMEdit.Value) * 100);
          PagePreview.RightMargin := Round(InchToMM(RightMEdit.Value) * 100);
          PagePreview.BottomMargin := Round(InchToMM(BottomMEdit.Value) * 100);
        end;

      PagePreview.Repaint;
    end;
  //
end;

procedure TspSkinPageSetupDialog.LoadPapersAndBins;
begin
  ClearPapersAndBins;
  GetPapers(Papers);
  GetBins(Bins);

  StopCheck := True;

  SizeComboBox.Items.Assign(Papers);
  SourceComboBox.Items.Assign(Bins);
  LoadCurrentPaperAndBin;

  StopCheck := False;
end;

procedure TspSkinPageSetupDialog.RBPortraitClick(Sender: TObject);
begin
  Printer.Orientation := poPortrait;
  PagePreview.RePaint;
end;

procedure TspSkinPageSetupDialog.RBLandScapeClick(Sender: TObject);
begin
  Printer.Orientation := poLandscape;
  PagePreview.RePaint;
end;

procedure TspSkinPageSetupDialog.SizeComboBoxChange(Sender: TObject);
var
  I: Integer;
begin
  if StopCheck then Exit;
  SaveCurrentPaperAndBin;
  I := SizeComboBox.ItemIndex;
  if I <> -1
  then
    begin
      GetPaperSizeInMM(PagePreview.PageWidth, PagePreview.PageHeight,
                       TspPaperInfo(Papers.Objects[I]).Size.X,
                       TspPaperInfo(Papers.Objects[I]).Size.Y);
      PagePreview.Repaint;
    end;
end;

procedure TspSkinPageSetupDialog.SourceComboBoxChange(Sender: TObject);
begin
  if StopCheck then Exit;
  SaveCurrentPaperAndBin;
end;

procedure TspSkinPageSetupDialog.PrinterButtonClick(Sender: TObject);
var
  PD: TspSkinSmallPrintDialog;
  S1: String;
  PI: Integer;
begin
  PD := TspSkinSmallPrintDialog.Create(Self);
  PD.GroupBoxTransparentMode := GroupBoxTransparentMode;
  PD.SkinData := Self.SkinData;
  PD.CtrlSkinData := Self.CtrlSkinData;
  if (SkinData <> nil) and (SkinData.ResourceStrData <> nil)
  then
    S1 := SkinData.ResourceStrData.GetResStr('PRNDLG_PRINTER')
  else
    S1 := SP_PRNDLG_PRINTER;
  PD.Title := S1;
  PI := Printer.PrinterIndex;
  if PD.Execute and (PI <> Printer.PrinterIndex)
  then
    LoadPapersAndBins;
  PD.Free;
end;

function TspSkinPageSetupDialog.Execute;
var
  DSF: TspDynamicSkinForm;
  OldPrinterIndex: Integer;
  PrinterGroupBox: TspSkinGroupBox;
  PaperGroupBox: TspSkinGroupBox;
  OrientationGroupBox: TspSkinGroupBox;
  MarginsGroupBox: TspSkinGroupBox;
  R: TRect;
  S1, S2, S3, S4: String;
  SkinMessage: TspSkinMessage;
begin
  if (Printer = nil) or (Printer.Printers.Count = 0)
  then
    begin
      SkinMessage := TspSkinMessage.Create(Self);
      SkinMessage.SkinData := Self.SkinData;
      SkinMessage.CtrlSkinData := Self.CtrlSkinData;
      if (SkinData <> nil) and (SkinData.ResourceStrData <> nil)
      then
        S1 := SkinData.ResourceStrData.GetResStr('PRNDLG_WARNING')
      else
        S1 := SP_PRNDLG_WARNING;
      SkinMessage.MessageDlg(S1, mtError, [mbOk], 0);
      SkinMessage.Free;
      Exit;
    end;
  Form := TForm.Create(Application);
  Form.BorderStyle := bsDialog;
  Form.Position := poScreenCenter;
  Form.Caption := FTitle;
  DSF := TspDynamicSkinForm.Create(Form);
  DSF.BorderIcons := [];
  DSF.SkinData := SkinData;
  DSF.MenusSkinData := CtrlSkinData;
  DSF.AlphaBlend := AlphaBlend;
  DSF.AlphaBlendAnimation := AlphaBlendAnimation;
  DSF.AlphaBlendValue := AlphaBlendValue;
  DSF.SizeAble := False;

  Form.ClientWidth :=  390;
  Form.ClientHeight := 360;

  PagePreview := TspSkinPagePreview.Create(Self);
  with PagePreview do
  begin
    Parent := Form;
    Left := 10;
    Top :=  10;
    Width := Form.ClientWidth - 20;
    Height := 130;
    SkinData := CtrlSkinData;
    if (CtrlSkinData <> nil) and (CtrlSkinData.ResourceStrData <> nil)
    then
      Caption := CtrlSkinData.ResourceStrData.GetResStr('PRNDLG_PAPER')
    else
      Caption := SP_PRNDLG_PAPER;
    if FGroupBoxTransparentMode then TransparentMode := True;
  end;


  PaperGroupBox := TspSkinGroupBox.Create(Self);
  PaperGroupBox.Enabled := not (sppsoDisablePaper in Options);

  with PaperGroupBox do
  begin
    Parent := Form;
    Left := 10;
    Top :=  150;
    Width := Form.ClientWidth - 20;
    Height := 100;
    SkinData := CtrlSkinData;
    if (CtrlSkinData <> nil) and (CtrlSkinData.ResourceStrData <> nil)
    then
      Caption := CtrlSkinData.ResourceStrData.GetResStr('PRNDLG_PAPER')
    else
      Caption := SP_PRNDLG_PAPER;
    if FGroupBoxTransparentMode then TransparentMode := True;
  end;

  OrientationGroupBox := TspSkinGroupBox.Create(Self);
  OrientationGroupBox.Enabled := not (sppsoDisableOrientation in Options);

  with OrientationGroupBox do
  begin
    Parent := Form;
    Left := 10;
    Top := PaperGroupBox.Top + PaperGroupBox.Height + 10;
    Width := (Form.ClientWidth - 20) div 2 - 70;
    Height := 100;
    SkinData := CtrlSkinData;
    if (CtrlSkinData <> nil) and (CtrlSkinData.ResourceStrData <> nil)
    then
      Caption := CtrlSkinData.ResourceStrData.GetResStr('PRNDLG_ORIENTATION')
    else
      Caption := SP_PRNDLG_ORIENTATION;
    if FGroupBoxTransparentMode then TransparentMode := True;
  end;

  R := OrientationGroupBox.GetSkinClientRect;

  RBPortrait := TspSkinCheckRadioBox.Create(Self);
  with RBPortrait do
  begin
    GroupIndex := 1;
    Parent := OrientationGroupBox;
    Checked := Printer.Orientation = poPortrait;
    Left := 10;
    Top := R.Top + 10;
    Width := 90;
    Radio := True;
    SkinDataName := 'radiobox';
    SkinData := CtrlSkinData;
    if (CtrlSkinData <> nil) and (CtrlSkinData.ResourceStrData <> nil)
    then
      Caption := CtrlSkinData.ResourceStrData.GetResStr('PRNDLG_PORTRAIT')
    else
      Caption := SP_PRNDLG_PORTRAIT;
    OnClick := RBPortraitClick;
    TabStop := True;
  end;

  RBLandScape := TspSkinCheckRadioBox.Create(Self);
  with RBLandScape do
  begin
    GroupIndex := 1;
    Parent := OrientationGroupBox;
    Checked := Printer.Orientation = poLandScape;
    Left := 10;
    Top := R.Bottom - 35;
    Width := 90;
    Radio := True;
    SkinDataName := 'radiobox';
    SkinData := CtrlSkinData;
    if (CtrlSkinData <> nil) and (CtrlSkinData.ResourceStrData <> nil)
    then
      Caption := CtrlSkinData.ResourceStrData.GetResStr('PRNDLG_LANDSCAPE')
    else
      Caption := SP_PRNDLG_LANDSCAPE;
    OnClick := RBLandScapeClick;
    TabStop := True;
  end;

  with TspSkinStdLabel.Create(Self) do
  begin
    Parent := PaperGroupBox;
    Left := R.Left + 10;
    Top := R.Top + 10;
    WordWrap := False;
    DefaultFont := DefaultLabelFont;
    UseSkinFont := Self.UseSkinFont;
    SkinData := CtrlSkinData;
    if (CtrlSkinData <> nil) and (CtrlSkinData.ResourceStrData <> nil)
    then
      Caption := CtrlSkinData.ResourceStrData.GetResStr('PRNDLG_SIZE')
    else
      Caption := SP_PRNDLG_SIZE;
  end;

  with TspSkinStdLabel.Create(Self) do
  begin
    Parent := PaperGroupBox;
    Left := R.Left + 10;
    Top := R.Top + 47;
    WordWrap := False;
    DefaultFont := DefaultLabelFont;
    UseSkinFont := Self.UseSkinFont;
    SkinData := CtrlSkinData;
    if (CtrlSkinData <> nil) and (CtrlSkinData.ResourceStrData <> nil)
    then
      Caption := CtrlSkinData.ResourceStrData.GetResStr('PRNDLG_SOURCE')
    else
      Caption := SP_PRNDLG_SOURCE;
  end;

  SizeComboBox := TspSkinCombobox.Create(Form);
  with SizeComboBox do
  begin
    Parent := PaperGroupBox;
    DefaultFont := DefaultComboboxFont;
    UseSkinFont := Self.UseSkinFont;
    SkinDataName := FSelectSkinDataName;
    SkinData := CtrlSkinData;
    Top := R.Top + 7;
    Left := R.Left + 65;
    Width := PaperGroupBox.Width - 80;
    OnChange := SizeComboBoxChange;
   end;

  SourceComboBox := TspSkinCombobox.Create(Form);
  with SourceComboBox do
  begin
    Parent := PaperGroupBox;
    DefaultFont := DefaultComboboxFont;
    UseSkinFont := Self.UseSkinFont;
    SkinDataName := FSelectSkinDataName;
    SkinData := CtrlSkinData;
    Top := R.Top + 45;
    Left := R.Left + 65;
    Width := PaperGroupBox.Width - 80;
    OnChange := SourceComboBoxChange;
   end;

  MarginsGroupBox := TspSkinGroupBox.Create(Self);
  MarginsGroupBox.Enabled := not (sppsoDisableMargins in Options);

  with MarginsGroupBox do
  begin
    Parent := Form;
    Left := OrientationGroupBox.Left + OrientationGroupBox.Width + 10;
    Top := PaperGroupBox.Top + PaperGroupBox.Height + 10;
    Width := (Form.ClientWidth - 20) div 2 + 60;
    Height := 100;
    SkinData := CtrlSkinData;
    if (CtrlSkinData <> nil) and (CtrlSkinData.ResourceStrData <> nil)
    then
      begin
        if FUnits = sppmMillimeters
        then
          Caption := CtrlSkinData.ResourceStrData.GetResStr('PRNDLG_MARGINS')
        else
          Caption := CtrlSkinData.ResourceStrData.GetResStr('PRNDLG_MARGINS_INCHES');
      end
    else
      begin
        if FUnits = sppmMillimeters
        then
          Caption := SP_PRNDLG_MARGINS
        else
          Caption := SP_PRNDLG_MARGINS_INCHES;
      end;
    if FGroupBoxTransparentMode then TransparentMode := True;  
  end;


  with TspSkinStdLabel.Create(Self) do
  begin
    Parent := MarginsGroupBox;
    Left := R.Left + 10;
    Top := R.Top + 10;
    WordWrap := False;
    DefaultFont := DefaultLabelFont;
    UseSkinFont := Self.UseSkinFont;
    SkinData := CtrlSkinData;
    if (CtrlSkinData <> nil) and (CtrlSkinData.ResourceStrData <> nil)
    then
      Caption := CtrlSkinData.ResourceStrData.GetResStr('PRNDLG_LEFT')
    else
      Caption := SP_PRNDLG_LEFT;
  end;

  LeftMEdit := TspSkinSpinEdit.Create(Self);
  with  LeftMEdit do
  begin
    Parent := MarginsGroupBox;
    ValueType := vtFloat;
    Increment := 1;
    Left := R.Left + 50;
    Top := R.Top + 8;
    Width := 60;
    SkinData := CtrlSkinData;
    if FUnits = sppmMillimeters
    then
      begin
        MinValue := FMinMarginLeft / 100;
        MaxValue := FMaxMarginLeft / 100;
        Value := FMarginLeft / 100;
      end
    else
      begin
        MinValue := FMinMarginLeft / 1000;
        MaxValue := FMaxMarginLeft / 1000;
        Value := FMarginLeft / 1000;
      end;  
    OnChange := LeftMEditChange;
  end;

  with TspSkinStdLabel.Create(Self) do
  begin
    Parent := MarginsGroupBox;
    Left := LeftMEdit.Left + LeftMEdit.Width + 15;
    Top := R.Top + 10;
    WordWrap := False;
    DefaultFont := DefaultLabelFont;
    UseSkinFont := Self.UseSkinFont;
    SkinData := CtrlSkinData;
    if (CtrlSkinData <> nil) and (CtrlSkinData.ResourceStrData <> nil)
    then
      Caption := CtrlSkinData.ResourceStrData.GetResStr('PRNDLG_RIGHT')
    else
      Caption := SP_PRNDLG_RIGHT;
  end;

  RightMEdit := TspSkinSpinEdit.Create(Self);
  with  RightMEdit do
  begin
    Parent := MarginsGroupBox;
    ValueType := vtFloat;
    Increment := 1;
    Left := LeftMEdit.Left + LeftMEdit.Width + 55;
    Top := R.Top + 8;
    Width := 60;
    SkinData := CtrlSkinData;
    if FUnits = sppmMillimeters
    then
      begin
        MinValue := FMinMarginRight / 100;
        MaxValue := FMaxMarginRight / 100;
        Value := FMarginRight / 100;
      end  
    else
      begin
        MinValue := FMinMarginRight / 1000;
        MaxValue := FMaxMarginRight / 1000;
        Value := FMarginRight / 1000;
      end;  
    OnChange := RightMEditChange;
  end;

  with TspSkinStdLabel.Create(Self) do
  begin
    Parent := MarginsGroupBox;
    Left := R.Left + 10;
    Top := R.Top + 45;
    WordWrap := False;
    DefaultFont := DefaultLabelFont;
    UseSkinFont := Self.UseSkinFont;
    SkinData := CtrlSkinData;
    if (CtrlSkinData <> nil) and (CtrlSkinData.ResourceStrData <> nil)
    then
      Caption := CtrlSkinData.ResourceStrData.GetResStr('PRNDLG_TOP')
    else
      Caption := SP_PRNDLG_TOP;
  end;

  TopMEdit := TspSkinSpinEdit.Create(Self);
  with  TopMEdit do
  begin
    Parent := MarginsGroupBox;
    ValueType := vtFloat;
    Increment := 1;
    Left := R.Left + 50;
    Top := R.Top + 43;
    Width := 60;
    SkinData := CtrlSkinData;
    if FUnits = sppmMillimeters
    then
      begin
        MinValue := FMinMarginTop / 100;
        MaxValue := FMaxMarginTop / 100;
        Value := FMarginTop / 100;
      end
    else
      begin
        MinValue := FMinMarginTop / 1000;
        MaxValue := FMaxMarginTop / 1000;
        Value := FMarginTop / 1000;
      end;
    OnChange := TopMEditChange;
  end;

  with TspSkinStdLabel.Create(Self) do
  begin
    Parent := MarginsGroupBox;
    Left := LeftMEdit.Left + LeftMEdit.Width + 15;
    Top := R.Top + 45;
    WordWrap := False;
    DefaultFont := DefaultLabelFont;
    UseSkinFont := Self.UseSkinFont;
    SkinData := CtrlSkinData;
    if (CtrlSkinData <> nil) and (CtrlSkinData.ResourceStrData <> nil)
    then
      Caption := CtrlSkinData.ResourceStrData.GetResStr('PRNDLG_BOTTOM')
    else
      Caption := SP_PRNDLG_BOTTOM;
  end;

  BottomMEdit := TspSkinSpinEdit.Create(Self);
  with  BottomMEdit do
  begin
    Parent := MarginsGroupBox;
    ValueType := vtFloat;
    Increment := 1;
    Left := LeftMEdit.Left + LeftMEdit.Width + 55;
    Top := R.Top + 43;
    Width := 60;
    SkinData := CtrlSkinData;
    if FUnits = sppmMillimeters
    then
      begin
        MinValue := FMinMarginBottom / 100;
        MaxValue := FMaxMarginBottom / 100;
        Value := FMarginBottom / 100;
      end
    else
      begin
        MinValue := FMinMarginBottom / 1000;
        MaxValue := FMaxMarginBottom / 1000;
        Value := FMarginBottom / 1000;
      end;
    OnChange := BottomMEditChange;
  end;

  //
  LoadPapersAndBins;
  //

  with TspSkinButton.Create(Form) do
  begin
    Enabled := not (sppsoDisablePrinter in Options);
    Parent := Form;
    DefaultFont := DefaultButtonFont;
    UseSkinFont := Self.UseSkinFont;
    if (CtrlSkinData <> nil) and (CtrlSkinData.ResourceStrData <> nil)
    then
      Caption := CtrlSkinData.ResourceStrData.GetResStr('PRNDLG_PRINTER') + '...'
    else
      Caption := SP_PRNDLG_PRINTER + '...';
    SetBounds(10,
              OrientationGroupBox.Top + OrientationGroupBox.Height + 10,
              115, 25);
    DefaultHeight := 25;
    SkinDataName := FButtonSkinDataName;
    SkinData := CtrlSkinData;
    OnClick := PrinterButtonClick;
    TabStop := True;
  end;

  with TspSkinButton.Create(Form) do
  begin
    Parent := Form;
    DefaultFont := DefaultButtonFont;
    UseSkinFont := Self.UseSkinFont;
    if (CtrlSkinData <> nil) and (CtrlSkinData.ResourceStrData <> nil)
    then
      Caption := CtrlSkinData.ResourceStrData.GetResStr('MSG_BTN_OK')
    else
      Caption := SP_MSG_BTN_OK;
    ModalResult := mrOk;
    Default := True;
    SetBounds(Form.ClientWidth - 160,
              OrientationGroupBox.Top + OrientationGroupBox.Height + 10,
              70, 25);
    DefaultHeight := 25;
    SkinDataName := FButtonSkinDataName;
    SkinData := CtrlSkinData;
    TabStop := True;
  end;

  with TspSkinButton.Create(Form) do
  begin
    Parent := Form;
    DefaultFont := DefaultButtonFont;
    UseSkinFont := Self.UseSkinFont;
    if (CtrlSkinData <> nil) and (CtrlSkinData.ResourceStrData <> nil)
    then
      Caption := CtrlSkinData.ResourceStrData.GetResStr('MSG_BTN_CANCEL')
    else
      Caption := SP_MSG_BTN_CANCEL;
    ModalResult := mrCancel;
    Cancel := True;
    SetBounds(Form.ClientWidth - 80,
              OrientationGroupBox.Top + OrientationGroupBox.Height + 10,
              70, 25);
    SkinDataName := FButtonSkinDataName;
    SkinData := CtrlSkinData;
    Form.ClientHeight := Top + Height + 10;
    TabStop := True;
  end;

  OldPrinterIndex := Printer.PrinterIndex;

  try
    if Form.ShowModal = mrOk
    then
      begin
        Result := True;
        if FUnits =  sppmMillimeters
        then
          begin
            FMarginLeft := PagePreview.LeftMargin;
            FMarginTop := PagePreview.TopMargin;
            FMarginRight := PagePreview.RightMargin;
            FMarginBottom := PagePreview.BottomMargin;
            FPageWidth := PagePreview.PageWidth;
            FPageHeight := PagePreview.PageHeight;
          end
        else
          begin
            FMarginLeft := Round(MMToInch2(PagePreview.LeftMargin));
            FMarginTop := Round(MMToInch2(PagePreview.TopMargin));
            FMarginRight := Round(MMToInch2(PagePreview.RightMargin));
            FMarginBottom := Round(MMToInch2(PagePreview.BottomMargin));
            FPageWidth := Round(MMToInch2(PagePreview.PageWidth));
            FPageHeight := Round(MMToInch2(PagePreview.PageHeight));
          end;
      end
    else
      begin
        RestoreDocumentProperties;
        if Printer.PrinterIndex <> OldPrinterIndex
        then
          Printer.PrinterIndex := OldPrinterIndex;
        Result := False;
      end;
  finally
    Form.Free;
  end;

end;

procedure TspSkinPageSetupDialog.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (AComponent = FSD) then FSD := nil;
  if (Operation = opRemove) and (AComponent = FCtrlFSD) then FCtrlFSD := nil;
end;

procedure TspSkinPageSetupDialog.SetDefaultButtonFont(Value: TFont);
begin
  FDefaultButtonFont.Assign(Value);
end;

procedure TspSkinPageSetupDialog.SetDefaultLabelFont(Value: TFont);
begin
  FDefaultLabelFont.Assign(Value);
end;

procedure TspSkinPageSetupDialog.SetDefaultSelectFont(Value: TFont);
begin
  FDefaultSelectFont.Assign(Value);
end;

function TspSkinPageSetupDialog.GetTitle: string;
begin
  Result := FTitle;
end;

procedure TspSkinPageSetupDialog.SetTitle(const Value: string);
begin
  FTitle := Value;
end;

constructor TspSkinPagePreview.Create(AOwner: TComponent);
begin
  inherited;
  FForceBackground := False;
  PageWidth := 0;
  Pageheight := 0;
  LeftMargin := 0;
  TopMargin := 0;
  RightMargin := 0;
  BottomMargin := 0;
end;

procedure TspSkinPagePreview.DrawPaper(R: TRect; Cnvs: TCanvas);
var
  TempPageWidth,  TempPageHeight, 
  TempLeftMargin, TempTopMargin,
  TempRightMargin, TempBottomMargin: Integer;
  PR, TR: TRect;
  kf: Double;
begin
  if (PageWidth = 0) or (Pageheight = 0) then Exit;
  if Printer.Orientation = poPortrait
  then
    begin
      kf := RectHeight(R) / PageHeight;
      TempPageWidth  := Round(PageWidth * kf);
      TempPageheight  := Round(PageHeight * kf);
      TempLeftMargin := Round(LeftMargin * kf);
      TempTopMargin := Round(TopMargin * kf);
      TempRightMargin := Round(RightMargin * kf);
      TempBottomMargin := Round(BottomMargin * kf);
      PR := Rect(R.Left + RectWidth(R) div 2 - TempPageWidth div 2, R.Top,
                 R.Left + RectWidth(R) div 2 - TempPageWidth div 2 + TempPageWidth,
                 R.Top + TempPageHeight);
    end
  else
    begin
      kf := RectHeight(R) / PageHeight;
      TempPageWidth := Round(PageHeight * kf);
      TempPageHeight  := Round(PageWidth * kf);
      TempLeftMargin := Round(LeftMargin * kf);
      TempTopMargin := Round(TopMargin * kf);
      TempRightMargin := Round(RightMargin * kf);
      TempBottomMargin := Round(BottomMargin * kf);
      PR := Rect(R.Left + RectWidth(R) div 2 - TempPageWidth div 2,
                 R.Top + RectHeight(R) div 2 - TempPageHeight div 2,
                 R.Left + RectWidth(R) div 2 - TempPageWidth div 2 + TempPageWidth,
                 R.Top + RectHeight(R) div 2 - TempPageHeight div 2 + TempPageHeight);
    end;

  with Cnvs do
  begin
    Pen.Color := clBlack;
    Brush.Color := clWhite;
    Brush.Style := bsSolid;
    Rectangle(PR.Left, PR.Top, PR.Right, PR.Bottom);
    TR := PR;
    Inc(TR.Left, TempLeftMargin + 1);
    Inc(TR.Top, TempTopMargin + 1);
    Dec(TR.Right, TempRightMargin + 1);
    Dec(TR.Bottom, TempBottomMargin + 1);
    Pen.Color := clGray;
    Pen.Style := psDot;
    Brush.Color := $00F5F5F5;
    Brush.Style := bsBDiagonal;

    if TR.Left < PR.Left then TR.Left := PR.Left;
    if TR.Left > PR.Right then TR.Left := PR.Right;
    if TR.Right < PR.Left then TR.Right := PR.Left;
    if TR.Right > PR.Right then TR.Right := PR.Right;
    if TR.Top < PR.Top then TR.Top := PR.Top;
    if TR.Top > PR.Bottom then TR.Top := PR.Bottom;
    if TR.Bottom < PR.Top then TR.Bottom := PR.Top;
    if TR.Bottom > PR.Bottom then TR.Bottom := PR.Bottom;

    Rectangle(TR.Left, TR.Top, TR.Right, TR.Bottom);
  end;
  
end;

procedure TspSkinPagePreview.CreateControlDefaultImage(B: TBitMap);
var
  R: TRect;
begin
  inherited;
  R := GetSkinClientRect;
  InflateRect(R, -5, -5);
  DrawPaper(R, B.Canvas);
end;

procedure TspSkinPagePreview.CreateControlSkinImage(B: TBitMap);
var
  R: TRect;
begin
  inherited;
  R := GetSkinClientRect;
  InflateRect(R, -5, -5);
  DrawPaper(R, B.Canvas);
end;

procedure TspSkinPagePreview.PaintTransparent(C: TCanvas);
var
  R: TRect;
begin
  R := GetSkinClientRect;
  InflateRect(R, -5, -5);
  DrawPaper(R, C);
end;


end.




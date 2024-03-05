{*******************************************************************}
{                                                                   }
{       Almediadev Visual Component Library                         }
{       DynamicSkinForm                                             }
{       Version 5.86                                                }
{                                                                   }
{       Copyright (c) 2000-2004 Almediadev                          }
{       ALL RIGHTS RESERVED                                         }
{                                                                   }
{       Home:  http://www.almdev.com                                }
{       Support: support@almdev.com                                 }
{                                                                   }
{*******************************************************************}

unit spMessages;

interface

uses Windows, SysUtils, Messages, Classes, Graphics, Controls, Forms,
     DynamicSkinForm, SkinData, SkinCtrlss, Dialogs, StdCtrls, ExtCtrls;

type

  TspMessageForm = class(TForm)
  protected
    procedure HelpButtonClick(Sender: TObject);
  public
    DSF: TspDynamicSkinForm;
    Message: TspSkinStdLabel;
    constructor Create(AOwner: TComponent); override;
  end;

  TspSkinMessage = class(TComponent)
  protected
    FSD: TspSkinData;
    FCtrlFSD: TspSkinData;
    FButtonSkinDataName: String;
    FMessageLabelSkinDataName: String;
    FDefaultFont: TFont;
    FDefaultButtonFont: TFont;
    FUseSkinFont: Boolean;
    FAlphaBlend: Boolean;
    FAlphaBlendAnimation: Boolean;
    FAlphaBlendValue: Byte;
    procedure SetDefaultFont(Value: TFont);
    procedure SetDefaultButtonFont(Value: TFont);
    procedure Notification(AComponent: TComponent;  Operation: TOperation); override;
  public
    function MessageDlg(const Msg: string; DlgType: TMsgDlgType;
      Buttons: TMsgDlgButtons; HelpCtx: Longint): Integer;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property AlphaBlend: Boolean read FAlphaBlend write FAlphaBlend;
    property AlphaBlendAnimation: Boolean
      read FAlphaBlendAnimation write FAlphaBlendAnimation;
    property AlphaBlendValue: Byte read FAlphaBlendValue write FAlphaBlendValue;
    property SkinData: TspSkinData read FSD write FSD;
    property CtrlSkinData: TspSkinData read FCtrlFSD write FCtrlFSD;
    property ButtonSkinDataName: String
      read FButtonSkinDataName write FButtonSkinDataName;
    property MessageLabelSkinDataName: String
      read FMessageLabelSkinDataName write FMessageLabelSkinDataName;
    property DefaultFont: TFont read FDefaultFont write SetDefaultFont;
    property DefaultButtonFont: TFont read FDefaultButtonFont write SetDefaultButtonFont;
    property UseSkinFont: Boolean read FUseSkinFont write FUseSkinFont;
  end;

implementation
   Uses spConst;
var
  ButtonNames: array[TMsgDlgBtn] of string = (
    'Yes', 'No', 'OK', 'Cancel', 'Abort', 'Retry', 'Ignore', 'All', 'NoToAll',
    'YesToAll', 'Help');

  ButtonCaptions: array[TMsgDlgBtn] of string = (
    SP_MSG_BTN_YES, SP_MSG_BTN_NO, SP_MSG_BTN_OK, SP_MSG_BTN_CANCEL, SP_MSG_BTN_ABORT,
    SP_MSG_BTN_RETRY, SP_MSG_BTN_IGNORE, SP_MSG_BTN_ALL,
    SP_MSG_BTN_NOTOALL, SP_MSG_BTN_YESTOALL, SP_MSG_BTN_HELP);

  Captions: array[TMsgDlgType] of string = (SP_MSG_CAP_WARNING, SP_MSG_CAP_ERROR,
    SP_MSG_CAP_INFORMATION, SP_MSG_CAP_CONFIRM, '');

  ModalResults: array[TMsgDlgBtn] of Integer = (
    mrYes, mrNo, mrOk, mrCancel, mrAbort, mrRetry, mrIgnore, mrAll, mrNoToAll,
    mrYesToAll, 0);

  IconIDs: array[TMsgDlgType] of PChar = (IDI_EXCLAMATION, IDI_HAND,
    IDI_ASTERISK, IDI_QUESTION, nil);

const
   MSGFORMBUTTONWIDTH = 40;

 function GetButtonCaption(B: TMsgDlgBtn; ASkinData: TspSkinData): String;
begin
  if (ASkinData <> nil) and (ASkinData.ResourceStrData <> nil)
  then
    case B of
      mbYes: Result := ASkinData.ResourceStrData.GetResStr('MSG_BTN_YES');
      mbNo: Result := ASkinData.ResourceStrData.GetResStr('MSG_BTN_NO');
      mbOK: Result := ASkinData.ResourceStrData.GetResStr('MSG_BTN_OK');
      mbCancel: Result := ASkinData.ResourceStrData.GetResStr('MSG_BTN_CANCEL');
      mbAbort: Result := ASkinData.ResourceStrData.GetResStr('MSG_BTN_ABORT');
      mbRetry: Result := ASkinData.ResourceStrData.GetResStr('BS_MSG_BTN_RETRY');
      mbIgnore: Result := ASkinData.ResourceStrData.GetResStr('MSG_BTN_IGNORE');
      mbAll: Result := ASkinData.ResourceStrData.GetResStr('MSG_BTN_ALL');
      mbNoToAll: Result := ASkinData.ResourceStrData.GetResStr('MSG_BTN_NOTOALL');
      mbYesToAll: Result := ASkinData.ResourceStrData.GetResStr('MSG_BTN_YESTOALL');
      mbHelp: Result := ASkinData.ResourceStrData.GetResStr('MSG_BTN_HELP');
    end
  else
    Result := ButtonCaptions[B];
end;

function GetMsgCaption(DT: TMsgDlgType; ASkinData: TspSkinData): String;
begin
  if (ASkinData <> nil) and (ASkinData.ResourceStrData <> nil)
  then
    case DT of
      mtWarning: Result := ASkinData.ResourceStrData.GetResStr('MSG_CAP_WARNING');
      mtError: Result := ASkinData.ResourceStrData.GetResStr('MSG_CAP_ERROR');
      mtInformation: Result := ASkinData.ResourceStrData.GetResStr('MSG_CAP_INFORMATION');
      mtConfirmation: Result := ASkinData.ResourceStrData.GetResStr('MSG_CAP_CONFIRM');
      mtCustom: Result := '';
    end
  else
    Result := Captions[DT];
end;

function CreateMessageDialog(const Msg: string; DlgType: TMsgDlgType;
  Buttons: TMsgDlgButtons; ASkinData, ACtrlSkinData: TspSkinData;
  AButtonSkinDataName: String;  AMessageLabelSkinDataName: String;
  ADefaultFont: TFont; ADefaultButtonFont: TFont; AUseSkinFont: Boolean;
  AAlphaBlend, AAlphaBlendAnimation: Boolean; AAlphaBlendValue: Byte): TspMessageForm;
var
  BI, ButtonWidth,
  ButtonHeight, ButtonSpacing, ButtonCount, ButtonGroupWidth, X, Y: Integer;
  B, DefaultButton, CancelButton: TMsgDlgBtn;
  IconID: PChar;
begin
  Result := TspMessageForm.Create(Application);
  with Result do
  begin
    with DSF do
    begin
      SkinData := ASkinData;
      MenusSkinData := ACtrlSkinData;
      AlphaBlend := AAlphaBlend;
      AlphaBlendAnimation := AAlphaBlendAnimation;
      AlphaBlendValue := AAlphaBlendValue;
    end;

    ButtonWidth := 60;
    //
    if (ACtrlSkinData <> nil) and (not ACtrlSkinData.Empty)
    then
      begin
        BI := ACtrlSkinData.GetControlIndex(AButtonSkinDataName);
        if (BI <> -1) and
           (TspDataSkinControl(ACtrlSkinData.CtrlList.Items[BI]) is TspDataSkinButtonControl)
        then
          begin
            with TspDataSkinButtonControl(ACtrlSkinData.CtrlList.Items[BI]) do
             ButtonHeight := SkinRect.Bottom - SkinRect.Top;
          end
        else
          ButtonHeight := 25;
      end
    else
      ButtonHeight := 25;
    //
    ButtonSpacing := 10;

    ButtonCount := 0;
    for B := Low(TMsgDlgBtn) to High(TMsgDlgBtn) do
      if B in Buttons then Inc(ButtonCount);

    ButtonGroupWidth := 0;
    if ButtonCount <> 0 then
      ButtonGroupWidth := ButtonWidth * ButtonCount +
        ButtonSpacing * (ButtonCount - 1);

    Left := (Screen.Width div 2) - (Width div 2);
    Top := (Screen.Height div 2) - (Height div 2);
    if DlgType <> mtCustom
    then Caption := GetMsgCaption(DlgType, ACtrlSkinData)
    else Caption := Application.Title;

    // add label
    Result.Message := TspSkinStdLabel.Create(Result);
    with Result.Message do
    begin
      Font := ADefaultFont;
      DefaultFont := ADefaultFont;
      UseSkinFont := AUseSkinFont;
      SkinDataName := AMessageLabelSkinDataName;
      SkinData := ACtrlSkinData;
      Name := 'Message';
      Parent := Result;
      AutoSize := True;
      Caption := Msg;
      Left := 50;
      Top := 15;
      X := Left + Width;
    end;

    IconID := IconIDs[DlgType];
    with TImage.Create(Result) do
      begin
        Name := 'Image';
        Parent := Result;
        Picture.Icon.Handle := LoadIcon(0, IconID);
        Y := Result.Message.Top + Result.Message.Height div 2 - 16;
        if Y < 10 then Y := 10;
        SetBounds(5, Y, 32, 32);
      end;

    ClientHeight := 50 + ButtonHeight + Result.Message.Height;

    if ButtonGroupWidth < X
    then
      ClientWidth := X + 40
    else
      ClientWidth := ButtonGroupWidth + 40;

    if Width > Result.DSF.GetMaxWidth
    then
      Width := Result.DSF.GetMaxWidth
    else
    if Width < Result.DSF.GetMinWidth
    then
      Width := Result.DSF.GetMinWidth;

    // add buttons
    if mbOk in Buttons then DefaultButton := mbOk else
      if mbYes in Buttons then DefaultButton := mbYes else
        DefaultButton := mbRetry;
    if mbCancel in Buttons then CancelButton := mbCancel else
      if mbNo in Buttons then CancelButton := mbNo else
        CancelButton := mbOk;
    X := (ClientWidth - ButtonGroupWidth) div 2;
    for B := Low(TMsgDlgBtn) to High(TMsgDlgBtn) do
      if B in Buttons then
        with TspSkinButton.Create(Result) do
        begin
          Parent := Result;
          Name := ButtonNames[B];
          CanFocused := True;
          Caption := GetButtonCaption(B, ACtrlSkinData);
          ModalResult := ModalResults[B];
          if B = DefaultButton then Default := True;
          if B = CancelButton then Cancel := True;
          DefaultHeight := ButtonHeight;
          SetBounds(X, Result.ClientHeight - ButtonHeight - 10,
            ButtonWidth, ButtonHeight);
          DefaultFont := ADefaultButtonFont;
          UseSkinFont := AUseSkinFont;
          Inc(X, ButtonWidth + ButtonSpacing);
          if B = mbHelp then
            OnClick := Result.HelpButtonClick;
          SkinDataName := AButtonSkinDataName;
          SkinData := ACtrlSkinData;
        end;
  end;
end;

constructor TspMessageForm.Create(AOwner: TComponent);
begin
  inherited CreateNew(AOwner);
  Position := poScreenCenter;
  BorderStyle := bsDialog;
  KeyPreview := True;
  DSF := TspDynamicSkinForm.Create(Self);
  DSF.BorderIcons := [];
  DSF.SizeAble := False;
end;

procedure TspMessageForm.HelpButtonClick(Sender: TObject);
begin
  Application.HelpContext(HelpContext);
end;

constructor TspSkinMessage.Create;
begin
  inherited Create(AOwner);
  FAlphaBlend := False;
  FAlphaBlendAnimation := False;
  FAlphaBlendValue := 200;
  FButtonSkinDataName := 'button';
  FMessageLabelSkinDataName := 'stdlabel';
  FDefaultFont := TFont.Create;
  FDefaultButtonFont := TFont.Create;
  FUseSkinFont := True;
  with FDefaultFont do
  begin
    Name := 'Arial';
    Style := [];
    Height := 14;
  end;
  with FDefaultButtonFont do
  begin
    Name := 'Arial';
    Style := [];
    Height := 14;
  end;
end;

destructor TspSkinMessage.Destroy;
begin
  FDefaultFont.Free;
  FDefaultButtonFont.Free;
  inherited;
end;

procedure TspSkinMessage.SetDefaultButtonFont;
begin
  FDefaultButtonFont.Assign(Value);
end;

function TspSkinMessage.MessageDlg;
begin
  with CreateMessageDialog(Msg, DlgType, Buttons,
       FSD, FCtrlFSD, FButtonSkinDataName,
       FMessageLabelSkinDataName, FDefaultFont, FDefaultButtonFont, FUseSkinFont,
       FAlphaBlend, FAlphaBlendAnimation, FAlphaBlendValue) do
    try
      Result := ShowModal;
    finally
      Free;
    end;
end;

procedure TspSkinMessage.SetDefaultFont;
begin
  FDefaultFont.Assign(Value);
end;

procedure TspSkinMessage.Notification;
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (AComponent = FSD) then FSD := nil;
  if (Operation = opRemove) and (AComponent = FCtrlFSD) then FCtrlFSD := nil;
end;

end.

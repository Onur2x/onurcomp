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

unit spMessages;

{$WARNINGS OFF}
{$HINTS OFF}

{$IFDEF VER230}
{$DEFINE VER200}
{$ENDIF}

{$IFDEF VER220}
{$DEFINE VER200}
{$ENDIF}

{$IFDEF VER210}
{$DEFINE VER200}
{$ENDIF}

//{$DEFINE TNTUNICODE}

interface

uses Windows, SysUtils, Messages, Classes, Graphics, Controls, Forms,
     DynamicSkinForm, SkinData, SkinCtrls, Dialogs, StdCtrls, ExtCtrls,
     ImgList {$IFDEF TNTUNICODE}, TntStdCtrls {$ENDIF};
type

  TspMessageSetShowPosEvent = procedure (var AX, AY: Integer; AWidth, AHeight: Integer) of object;
  
  TspMessageForm = class(TForm)
  protected
    procedure HelpButtonClick(Sender: TObject);
  public
    DSF: TspDynamicSkinForm;
    DisplayCheckBox: TspSkinCheckRadioBox;
    {$IFDEF TNTUNICODE}
    WideMessage: TTntLabel;
    {$ENDIF}
    Message: TspSkinStdLabel;
    constructor CreateEx(AOwner: TComponent; X, Y: Integer);
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
    FShowAgainFlag: Boolean;
    FShowAgainFlagValue: Boolean;
    FOnSetShowPos: TspMessageSetShowPosEvent;
    procedure SetDefaultFont(Value: TFont);
    procedure SetDefaultButtonFont(Value: TFont);
    procedure Notification(AComponent: TComponent;  Operation: TOperation); override;
  public

     // messages with wide string
    function WideMessageDlg(const Msg: WideString; DlgType: TMsgDlgType;
      Buttons: TMsgDlgButtons; HelpCtx: Longint): Integer;

    function WideMessageDlgPos(const Msg: WideString; DlgType: TMsgDlgType;
      Buttons: TMsgDlgButtons; HelpCtx: Longint; X, Y: Integer): Integer;
    //

    function MessageDlg(const Msg: string; DlgType: TMsgDlgType;
      Buttons: TMsgDlgButtons; HelpCtx: Longint): Integer;

    function MessageDlgPos(const Msg: string; DlgType: TMsgDlgType;
      Buttons: TMsgDlgButtons; HelpCtx: Longint; X, Y: Integer): Integer;

    function MessageDlgHelp(const Msg: string; DlgType: TMsgDlgType;
      Buttons: TMsgDlgButtons; HelpCtx: Longint; const HelpFileName: string): Integer;
              
    function MessageDlg2(const Msg: string; ACaption: String;
      DlgType: TMsgDlgType;
      Buttons: TMsgDlgButtons; HelpCtx: Longint): Integer;

    function MessageDlgHelp2(const Msg: string; ACaption: String;
      DlgType: TMsgDlgType;
      Buttons: TMsgDlgButtons; HelpCtx: Longint; const HelpFileName: string): Integer;

    function CustomMessageDlg(const Msg: string;
      ACaption: String; AImages: TCustomImageList; AImageIndex: Integer;
      Buttons: TMsgDlgButtons; HelpCtx: Longint): Integer;

     function CustomMessageDlgPos(const Msg: string;
      ACaption: String; AImages: TCustomImageList; AImageIndex: Integer;
      Buttons: TMsgDlgButtons; HelpCtx: Longint; X, Y: Integer): Integer;


    function CustomMessageDlgHelp(const Msg: string;
      ACaption: String; AImages: TCustomImageList; AImageIndex: Integer;
      Buttons: TMsgDlgButtons; HelpCtx: Longint; const HelpFileName: string): Integer;

    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property ShowAgainFlag: Boolean read FShowAgainFlag write FShowAgainFlag;
    property ShowAgainFlagValue: Boolean
      read FShowAgainFlagValue write FShowAgainFlagValue;
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
    property OnSetShowPos: TspMessageSetShowPosEvent
       read FOnSetShowPos write FOnSetShowPos;
  end;

implementation
   Uses spConst;
var
  {$IFNDEF VER200}
  ButtonNames: array[TMsgDlgBtn] of string = (
    'Yes', 'No', 'OK', 'Cancel', 'Abort', 'Retry', 'Ignore', 'All', 'NoToAll',
    'YesToAll', 'Help');
  {$ELSE}
  ButtonNames: array[TMsgDlgBtn] of string = (
    'Yes', 'No', 'OK', 'Cancel', 'Abort', 'Retry', 'Ignore', 'All', 'NoToAll',
    'YesToAll', 'Help', 'Close');
  {$ENDIF}

  {$IFNDEF VER200}
  ButtonCaptions: array[TMsgDlgBtn] of string = (
    SP_MSG_BTN_YES, SP_MSG_BTN_NO, SP_MSG_BTN_OK, SP_MSG_BTN_CANCEL, SP_MSG_BTN_ABORT,
    SP_MSG_BTN_RETRY, SP_MSG_BTN_IGNORE, SP_MSG_BTN_ALL,
    SP_MSG_BTN_NOTOALL, SP_MSG_BTN_YESTOALL, SP_MSG_BTN_HELP);
  {$ELSE}
  ButtonCaptions: array[TMsgDlgBtn] of string = (
    SP_MSG_BTN_YES, SP_MSG_BTN_NO, SP_MSG_BTN_OK, SP_MSG_BTN_CANCEL, SP_MSG_BTN_ABORT,
    SP_MSG_BTN_RETRY, SP_MSG_BTN_IGNORE, SP_MSG_BTN_ALL,
    SP_MSG_BTN_NOTOALL, SP_MSG_BTN_YESTOALL, SP_MSG_BTN_HELP, SP_MSG_BTN_CLOSE);
  {$ENDIF}

  Captions: array[TMsgDlgType] of string = (SP_MSG_CAP_WARNING, SP_MSG_CAP_ERROR,
    SP_MSG_CAP_INFORMATION, SP_MSG_CAP_CONFIRM, '');

  {$IFNDEF VER200}
  ModalResults: array[TMsgDlgBtn] of Integer = (
    mrYes, mrNo, mrOk, mrCancel, mrAbort, mrRetry, mrIgnore, mrAll, mrNoToAll,
    mrYesToAll, 0);
  {$ELSE}
  ModalResults: array[TMsgDlgBtn] of Integer = (
    mrYes, mrNo, mrOk, mrCancel, mrAbort, mrRetry, mrIgnore, mrAll, mrNoToAll,
    mrYesToAll, 0, mrClose);
  {$ENDIF}

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
      mbRetry: Result := ASkinData.ResourceStrData.GetResStr('MSG_BTN_RETRY');
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


function CreateCustomMessageDialog(const Msg: string; ACaption: String;
  AImageList: TCustomImageList; AImageIndex: Integer;
  Buttons: TMsgDlgButtons; ASkinData, ACtrlSkinData: TspSkinData;
  AButtonSkinDataName: String;  AMessageLabelSkinDataName: String;
  ADefaultFont: TFont; ADefaultButtonFont: TFont; AUseSkinFont: Boolean;
  AAlphaBlend, AAlphaBlendAnimation: Boolean; AAlphaBlendValue: Byte;
  AShowAgainFlag, AShowAgainFlagValue: Boolean;  MX, MY: Integer): TspMessageForm;
var
  BI, ButtonWidth,
  ButtonHeight, ButtonSpacing, ButtonCount, ButtonGroupWidth, X, Y: Integer;
  B, DefaultButton, CancelButton: TMsgDlgBtn;
  IconID: PChar;
  W: Integer;
begin
  Result := TspMessageForm.CreateEx(Application, MX, MY);
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

    ButtonWidth := 70;
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

    Caption := ACaption;

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

    if (AImageList <> nil) and (AImageIndex >= 0) and
       (AImageIndex <= AImageList.Count - 1)
    then
     with TImage.Create(Result) do
      begin
        Transparent := True;
        Width := AImageList.Width;
        Height := AImageList.Height;
        Name := 'Image';
        Parent := Result;
        AImageList.GetIcon(AImageIndex, Picture.Icon);
        Y := Result.Message.Top + Result.Message.Height div 2 - 16;
        Left := 5;
        Top := Y;
      end;

    ClientHeight := 50 + ButtonHeight + Result.Message.Height;

    if ButtonGroupWidth < X
    then
      ClientWidth := X + 40
    else
      ClientWidth := ButtonGroupWidth + 40;


    // "Do not display this message again" flag

    if AShowAgainFlag
    then
      begin
        ClientHeight := ClientHeight + 40;
        Result.DisplayCheckBox := TspSkinCheckRadioBox.Create(Result);
        with Result.DisplayCheckBox do
        begin
          Name := 'checkbox';
          DefaultHeight := 30;
          Checked := not AShowAgainFlagValue;
          Parent := Result;
          DefaultFont := ADefaultFont;
          UseSkinFont := AUseSKinFont;
          SkinData := ACtrlSkinData;
          Y := Result.ClientHeight - ButtonHeight - 50;
          if (ACtrlSkinData <> nil) and (ACtrlSkinData.ResourceStrData <> nil)
          then
            begin
              Caption := ACtrlSkinData.ResourceStrData.GetResStr('MSG_CAP_SHOWFLAG');
              if Caption = '' then Caption := SP_MSG_CAP_SHOWFLAG;
            end
          else
            Caption := SP_MSG_CAP_SHOWFLAG;
          if (FIndex <> -1) and UseSkinFont
          then
            begin
              Result.Canvas.Font.Name := FontName;
              Result.Canvas.Font.Height := FontHeight;
            end
          else
            Result.Canvas.Font.Assign(ADefaultFont);
          W := Result.Canvas.TextWidth(Caption);
          W := W + 30;
          if Result.ClientWidth < W + 30 then Result.ClientWidth := W + 30;
          SetBounds(5, Y, W + 25, DefaultHeight);
        end;
      end;


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

function CreateMessageDialog(const Msg: string; DlgType: TMsgDlgType;
  Buttons: TMsgDlgButtons; ASkinData, ACtrlSkinData: TspSkinData;
  AButtonSkinDataName: String;  AMessageLabelSkinDataName: String;
  ADefaultFont: TFont; ADefaultButtonFont: TFont; AUseSkinFont: Boolean;
  AAlphaBlend, AAlphaBlendAnimation: Boolean; AAlphaBlendValue: Byte;
  AShowAgainFlag, AShowAgainFlagValue: Boolean;  MX, MY: Integer): TspMessageForm;
var
  BI, ButtonWidth,
  ButtonHeight, ButtonSpacing, ButtonCount, ButtonGroupWidth, X, Y: Integer;
  B, DefaultButton, CancelButton: TMsgDlgBtn;
  IconID: PChar;
  W: Integer;
begin
  Result := TspMessageForm.CreateEx(Application, MX, MY);
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

    ButtonWidth := 70;
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


    // "Do not display this message again" flag

    if AShowAgainFlag
    then
      begin
        ClientHeight := ClientHeight + 40;
        Result.DisplayCheckBox := TspSkinCheckRadioBox.Create(Result);
        with Result.DisplayCheckBox do
        begin
          Name := 'checkbox';
          DefaultHeight := 30;
          Checked := not AShowAgainFlagValue;
          Parent := Result;
          DefaultFont := ADefaultFont;
          UseSkinFont := AUseSKinFont;
          SkinData := ACtrlSkinData;
          Y := Result.ClientHeight - ButtonHeight - 50;
          if (ACtrlSkinData <> nil) and (ACtrlSkinData.ResourceStrData <> nil)
          then
            begin
              Caption := ACtrlSkinData.ResourceStrData.GetResStr('MSG_CAP_SHOWFLAG');
              if Caption = '' then Caption := SP_MSG_CAP_SHOWFLAG;
            end
          else
            Caption := SP_MSG_CAP_SHOWFLAG;
          if (FIndex <> -1) and UseSkinFont
          then
            begin
              Result.Canvas.Font.Name := FontName;
              Result.Canvas.Font.Height := FontHeight;
            end
          else
            Result.Canvas.Font.Assign(ADefaultFont);
          W := Result.Canvas.TextWidth(Caption);
          W := W + 30;
          if Result.ClientWidth < W + 30 then Result.ClientWidth := W + 30;
          SetBounds(5, Y, W + 25, DefaultHeight);
        end;
      end;

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

function CreateWideMessageDialog(const Msg: WideString; DlgType: TMsgDlgType;
  Buttons: TMsgDlgButtons; ASkinData, ACtrlSkinData: TspSkinData;
  AButtonSkinDataName: String;  AMessageLabelSkinDataName: String;
  ADefaultFont: TFont; ADefaultButtonFont: TFont; AUseSkinFont: Boolean;
  AAlphaBlend, AAlphaBlendAnimation: Boolean; AAlphaBlendValue: Byte;
  MX, MY: Integer): TspMessageForm;
var
  BI, ButtonWidth,
  ButtonHeight, ButtonSpacing, ButtonCount, ButtonGroupWidth, X, Y: Integer;
  B, DefaultButton, CancelButton: TMsgDlgBtn;
  IconID: PChar;
  W: Integer;
begin
  Result := TspMessageForm.CreateEx(Application, MX, MY);
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

    ButtonWidth := 70;
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

    if DlgType <> mtCustom
    then Caption := GetMsgCaption(DlgType, ACtrlSkinData)
    else Caption := Application.Title;

     // message text

    {$IFDEF TNTUNICODE}
    Result.WideMessage := TTNTLabel.Create(Result);
    with Result.WideMessage do
    begin
      Transparent := True;
      Font := ADefaultFont;
      if (ACtrlSkinData <> nil) and not ACtrlSkinData.Empty
      then
        Font.Color := ACtrlSkinData.SkinColors.cBtnText;
      Name := 'Message';
      Parent := Result;
      AutoSize := True;
      Caption := Msg;
      Left := 50;
      Top := 15;
      X := Left + Width;
    end;
    {$ELSE}
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
    {$ENDIF}
    
    IconID := IconIDs[DlgType];
    with TImage.Create(Result) do
      begin
        Name := 'Image';
        Parent := Result;
        Picture.Icon.Handle := LoadIcon(0, IconID);
        {$IFDEF TNTUNICODE}
        Y := Result.WideMessage.Top + Result.WideMessage.Height div 2 - 16;
        {$ELSE}
        Y := Result.Message.Top + Result.Message.Height div 2 - 16;
        {$ENDIF}
        if Y < 10 then Y := 10;
        SetBounds(5, Y, 32, 32);
      end;

    {$IFDEF TNTUNICODE}
     ClientHeight := 50 + ButtonHeight + Result.WideMessage.Height;
    {$ELSE}
     ClientHeight := 50 + ButtonHeight + Result.Message.Height;
    {$ENDIF}

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

function CreateMessageDialog2(const Msg: string; ACaption: String;
  DlgType: TMsgDlgType;
  Buttons: TMsgDlgButtons; ASkinData, ACtrlSkinData: TspSkinData;
  AButtonSkinDataName: String;  AMessageLabelSkinDataName: String;
  ADefaultFont: TFont; ADefaultButtonFont: TFont; AUseSkinFont: Boolean;
  AAlphaBlend, AAlphaBlendAnimation: Boolean; AAlphaBlendValue: Byte;
  AShowAgainFlag, AShowAgainFlagValue: Boolean; MX, MY: Integer): TspMessageForm;
var
  BI, ButtonWidth,
  ButtonHeight, ButtonSpacing, ButtonCount, ButtonGroupWidth, X, Y: Integer;
  B, DefaultButton, CancelButton: TMsgDlgBtn;
  IconID: PChar;
  W: Integer;
begin
  Result := TspMessageForm.CreateEx(Application, MX, MY);
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

    ButtonWidth := 70;
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

    Caption := ACaption;

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


    // "Do not display this message again" flag

    if AShowAgainFlag
    then
      begin
        ClientHeight := ClientHeight + 40;
        Result.DisplayCheckBox := TspSkinCheckRadioBox.Create(Result);
        with Result.DisplayCheckBox do
        begin
          Name := 'checkbox';
          DefaultHeight := 30;
          Checked := not AShowAgainFlagValue;
          Parent := Result;
          DefaultFont := ADefaultFont;
          UseSkinFont := AUseSKinFont;
          SkinData := ACtrlSkinData;
          Y := Result.ClientHeight - ButtonHeight - 50;
          if (ACtrlSkinData <> nil) and (ACtrlSkinData.ResourceStrData <> nil)
          then
            begin
              Caption := ACtrlSkinData.ResourceStrData.GetResStr('MSG_CAP_SHOWFLAG');
              if Caption = '' then Caption := SP_MSG_CAP_SHOWFLAG;
            end
          else
            Caption := SP_MSG_CAP_SHOWFLAG;
          if (FIndex <> -1) and UseSkinFont
          then
            begin
              Result.Canvas.Font.Name := FontName;
              Result.Canvas.Font.Height := FontHeight;
            end
          else
            Result.Canvas.Font.Assign(ADefaultFont);
          W := Result.Canvas.TextWidth(Caption);
          W := W + 30;
          if Result.ClientWidth < W + 30 then Result.ClientWidth := W + 30;
          SetBounds(5, Y, W + 25, DefaultHeight);
        end;
      end;

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

constructor TspMessageForm.CreateEx(AOwner: TComponent; X, Y: Integer);
begin
  inherited CreateNew(AOwner);
  DisplayCheckBox := nil;
  BorderStyle := bsDialog;
  KeyPreview := True;
  if X < -10000
  then
    Self.Position := poScreenCenter
  else
    begin
      Self.Position := poDesigned;
      Self.Left := X;
      Self.Top := Y;
    end;
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
  FShowAgainFlag := False;
  FShowAgainFlagValue := False;
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

function TspSkinMessage.CustomMessageDlgHelp;
begin
  with CreateCustomMessageDialog(Msg, ACaption, AImages, AImageIndex, Buttons,
       FSD, FCtrlFSD, FButtonSkinDataName,
       FMessageLabelSkinDataName, FDefaultFont, FDefaultButtonFont, FUseSkinFont,
       FAlphaBlend, FAlphaBlendAnimation, FAlphaBlendValue, FShowAgainFlag, FShowAgainFlagValue,
       -10001, -10001) do
  begin
    try
      HelpContext := HelpCtx;
      HelpFile := HelpFileName;
      Result := ShowModal;
    finally
      if DisplayCheckBox <> nil
      then
        begin
          Self.ShowAgainFlagValue := not DisplayCheckBox.Checked;
        end;
      Free;
    end;
  end;
end;


function TspSkinMessage.CustomMessageDlgPos(const Msg: string;
      ACaption: String; AImages: TCustomImageList; AImageIndex: Integer;
      Buttons: TMsgDlgButtons; HelpCtx: Longint; X, Y: Integer): Integer;
var
  FX, FY: Integer;
begin
  with CreateCustomMessageDialog(Msg, ACaption, AImages, AImageIndex, Buttons,
       FSD, FCtrlFSD, FButtonSkinDataName,
       FMessageLabelSkinDataName, FDefaultFont, FDefaultButtonFont, FUseSkinFont,
       FAlphaBlend, FAlphaBlendAnimation, FAlphaBlendValue, FShowAgainFlag, FShowAgainFlagValue,
       X, Y) do
    try
      HelpContext := HelpCtx;
      if Assigned(FOnSetShowPos)
      then
        begin
          FX := Left;
          FY := Top;
          FOnSetShowPos(FX, FY, Width, Height);
          Left := FX;
          Top := FY;
        end;
      Result := ShowModal;
    finally
      if DisplayCheckBox <> nil
      then
        begin
          Self.ShowAgainFlagValue := not DisplayCheckBox.Checked;
        end;
      Free;
    end;
end;

function TspSkinMessage.CustomMessageDlg;
begin
  with CreateCustomMessageDialog(Msg, ACaption, AImages, AImageIndex, Buttons,
       FSD, FCtrlFSD, FButtonSkinDataName,
       FMessageLabelSkinDataName, FDefaultFont, FDefaultButtonFont, FUseSkinFont,
       FAlphaBlend, FAlphaBlendAnimation, FAlphaBlendValue, FShowAgainFlag, FShowAgainFlagValue,
       -10001, -10001) do
    try
      HelpContext := HelpCtx;
      Result := ShowModal;
    finally
      if DisplayCheckBox <> nil
      then
        begin
          Self.ShowAgainFlagValue := not DisplayCheckBox.Checked;
        end;
      Free;
    end;
end;

function TspSkinMessage.MessageDlg2;
begin
  with CreateMessageDialog2(Msg, ACaption, DlgType, Buttons,
       FSD, FCtrlFSD, FButtonSkinDataName,
       FMessageLabelSkinDataName, FDefaultFont, FDefaultButtonFont, FUseSkinFont,
       FAlphaBlend, FAlphaBlendAnimation, FAlphaBlendValue, FShowAgainFlag, FShowAgainFlagValue,
       -10001, -10001) do
    try
      HelpContext := HelpCtx;
      Result := ShowModal;
    finally
      if DisplayCheckBox <> nil
      then
        begin
          Self.ShowAgainFlagValue := not DisplayCheckBox.Checked;
        end;
      Free;
    end;
end;


function TspSkinMessage.MessageDlgHelp2;
begin
  with CreateMessageDialog2(Msg, ACaption, DlgType, Buttons,
       FSD, FCtrlFSD, FButtonSkinDataName,
       FMessageLabelSkinDataName, FDefaultFont, FDefaultButtonFont, FUseSkinFont,
       FAlphaBlend, FAlphaBlendAnimation, FAlphaBlendValue, FShowAgainFlag, FShowAgainFlagValue,
       -10001, -10001) do
  begin
    try
      HelpContext := HelpCtx;
      HelpFile := HelpFileName;
      Result := ShowModal;
    finally
      if DisplayCheckBox <> nil
      then
        begin
          Self.ShowAgainFlagValue := not DisplayCheckBox.Checked;
        end;
      Free;
    end;
  end;
end;


function TspSkinMessage.MessageDlgPos(const Msg: string; DlgType: TMsgDlgType;
      Buttons: TMsgDlgButtons; HelpCtx: Longint; X, Y: Integer): Integer;
var
  FX, FY: Integer;
begin
   with CreateMessageDialog(Msg, DlgType, Buttons,
       FSD, FCtrlFSD, FButtonSkinDataName,
       FMessageLabelSkinDataName, FDefaultFont, FDefaultButtonFont, FUseSkinFont,
       FAlphaBlend, FAlphaBlendAnimation, FAlphaBlendValue, FShowAgainFlag, FShowAgainFlagValue,
       X, Y) do
    try
      HelpContext := HelpCtx;
      if Assigned(FOnSetShowPos)
      then
        begin
          FX := Left;
          FY := Top;
          FOnSetShowPos(FX, FY, Width, Height);
          Left := FX;
          Top := FY;
        end;
      Result := ShowModal;
    finally
      if DisplayCheckBox <> nil
      then
        begin
          Self.ShowAgainFlagValue := not DisplayCheckBox.Checked;
        end;
      Free;
    end;
end;

function TspSkinMessage.WideMessageDlgPos;
begin
   with CreateWideMessageDialog(Msg, DlgType, Buttons,
       FSD, FCtrlFSD, FButtonSkinDataName,
       FMessageLabelSkinDataName, FDefaultFont, FDefaultButtonFont, FUseSkinFont,
       FAlphaBlend, FAlphaBlendAnimation, FAlphaBlendValue,
       X, Y) do
    try
      HelpContext := HelpCtx;
      Result := ShowModal;
    finally
      Free;
    end;
end;

function TspSkinMessage.WideMessageDlg;
begin
  with CreateWideMessageDialog(Msg, DlgType, Buttons,
       FSD, FCtrlFSD, FButtonSkinDataName,
       FMessageLabelSkinDataName, FDefaultFont, FDefaultButtonFont, FUseSkinFont,
       FAlphaBlend, FAlphaBlendAnimation, FAlphaBlendValue,
       -10001, -10001) do
  begin
    try
      HelpContext := HelpCtx;
      Result := ShowModal;
    finally
      Free;
    end;
  end;
end;


function TspSkinMessage.MessageDlg;
begin
  with CreateMessageDialog(Msg, DlgType, Buttons,
       FSD, FCtrlFSD, FButtonSkinDataName,
       FMessageLabelSkinDataName, FDefaultFont, FDefaultButtonFont, FUseSkinFont,
       FAlphaBlend, FAlphaBlendAnimation, FAlphaBlendValue, FShowAgainFlag, FShowAgainFlagValue,
       -10001, -10001) do
    try
      HelpContext := HelpCtx;
      Result := ShowModal;
    finally
      if DisplayCheckBox <> nil
      then
        begin
          Self.ShowAgainFlagValue := not DisplayCheckBox.Checked;
        end;
      Free;
    end;
end;


function TspSkinMessage.MessageDlgHelp;
begin
  with CreateMessageDialog(Msg, DlgType, Buttons,
       FSD, FCtrlFSD, FButtonSkinDataName,
       FMessageLabelSkinDataName, FDefaultFont, FDefaultButtonFont, FUseSkinFont,
       FAlphaBlend, FAlphaBlendAnimation, FAlphaBlendValue, FShowAgainFlag, FShowAgainFlagValue,
       -10001, -10001) do
  begin
    try
      HelpContext := HelpCtx;
      HelpFile := HelpFileName;
      Result := ShowModal;
    finally
      if DisplayCheckBox <> nil
      then
        begin
          Self.ShowAgainFlagValue := not DisplayCheckBox.Checked;
        end;
      Free;
    end;
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


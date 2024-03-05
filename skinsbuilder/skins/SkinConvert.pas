
{*******************************************************************}
{                                                                   }
{       SkinEngine                                                  }
{       Version 1                                                   }
{                                                                   }
{       Copyright (c) 1998-2003 Evgeny Kryukov                      }
{       ALL RIGHTS RESERVED                                         }
{                                                                   }
{   The entire contents of this file is protected by                }
{   International Copyright Laws. Unauthorized reproduction,        }
{   reverse-engineering, and distribution of all or any portion of  }
{   the code contained in this file is strictly prohibited and may  }
{   result in severe civil and criminal penalties and will be       }
{   prosecuted to the maximum extent possible under the law.        }
{                                                                   }
{   RESTRICTIONS                                                    }
{                                                                   }
{   THE SOURCE CODE CONTAINED WITHIN THIS FILE AND ALL RELATED      }
{   FILES OR ANY PORTION OF ITS CONTENTS SHALL AT NO TIME BE        }
{   COPIED, TRANSFERRED, SOLD, DISTRIBUTED, OR OTHERWISE MADE       }
{   AVAILABLE TO OTHER INDIVIDUALS WITHOUT KS DEVELOPMENT WRITTEN   }
{   CONSENT AND PERMISSION FROM KS DEVELOPMENT.                     }
{                                                                   }
{   CONSULT THE END USER LICENSE AGREEMENT FOR INFORMATION ON       }
{   ADDITIONAL RESTRICTIONS.                                        }
{                                                                   }
{   DISTRIBUTION OF THIS FILE IS NOT ALLOWED!                       }
{                                                                   }
{       Home:  http://www.ksdev.com                                 }
{       Support: support@ksdev.com                                  }
{       Questions: faq@ksdev.com                                    }
{                                                                   }
{*******************************************************************}
{
 $Id: SkinConvert.pas,v 1.2 2003/03/22 17:10:07 evgeny Exp $                                                            
}

unit SkinConvert;

{$I KSSKIN.INC}

interface

uses SysUtils, Windows, Messages, Classes, Graphics, Controls, Forms, StdCtrls,
  KSHook, SkinConst, SkinSource, SkinEngine, Dialogs, Menus, SkinButton, Buttons,
  ComCtrls, SkinCtrls, SkinProgBar, ExtCtrls;

type

{ TscSkinConvert }

  TscSkinConvert = class(TComponent)
  private
    FSkinEngine: TscSkinEngine;
    FBeginConvert: boolean;
    // Internal
    Form: TCustomForm;
     procedure SetSkinEngine(const Value: TscSkinEngine);
    procedure SetBeginConvert(const Value: boolean);
    // Converters
    function ButtonConvert(Value: TButton): TComponent;
    procedure SpeedButtonConvert(Value: TSpeedButton);
    procedure BitBtnConvert(Value: TBitBtn);
    procedure ProgressBarConvert(Value: TProgressBar);
    procedure CheckBoxConvert(Value: TCheckBox);
    procedure RadioButtonConvert(Value: TRadioButton);
    procedure PanelConvert(Value: TPanel);
    procedure PopupMenuConvert(Value: TPopupMenu);
    procedure Convert;
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
  published
    property SkinEngine: TscSkinEngine read FSkinEngine write SetSkinEngine;
    property BeginConvert: boolean read FBeginConvert write SetBeginConvert;
  end;

procedure Register;

implementation {===============================================================}

uses SkinConvertForm;



{ TscSkinConvert }

procedure TscSkinConvert.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited;
  if (Operation = opRemove) and (AComponent = FSkinEngine) then
    FSkinEngine := nil;
end;

procedure TscSkinConvert.SetBeginConvert(const Value: boolean);
begin
  FBeginConvert := Value;
end;

procedure TscSkinConvert.SetSkinEngine(const Value: TscSkinEngine);
begin
  FSkinEngine := Value;
end;

function TscSkinConvert.ButtonConvert(Value: TButton): TComponent;
var
  SkinValue: TscButton;
  Name: string;
begin
  SkinValue := TscButton.Create(Form);
  SkinValue.BoundsRect := Value.BoundsRect;
  SkinValue.Parent := Value.Parent;
  SkinValue.Action := Value.Action;
  SkinValue.Anchors := Value.Anchors;
  SkinValue.BiDiMode := Value.BiDiMode;
  SkinValue.Cancel := Value.Cancel;
  SkinValue.Caption := Value.Caption;
  SkinValue.Constraints.Assign(Value.Constraints);
  SkinValue.Cursor := Value.Cursor;
  SkinValue.Default := Value.Default;
  SkinValue.DragCursor := Value.DragCursor;
  SkinValue.DragKind := Value.DragKind;
  SkinValue.DragMode := Value.DragMode;
  SkinValue.Enabled := Value.Enabled;
  SkinValue.Font.Assign(Value.Font);
  SkinValue.HelpContext := Value.HelpContext;
  SkinValue.Hint := Value.Hint;
  SkinValue.ModalResult := Value.ModalResult;
  SkinValue.ParentBiDiMode := Value.ParentBiDiMode;
  SkinValue.ParentShowHint := Value.ParentShowHint;
  SkinValue.ParentFont := Value.ParentFont;
  SkinValue.PopupMenu := Value.PopupMenu;
  SkinValue.ShowHint := Value.ShowHint;
  SkinValue.TabOrder := Value.TabOrder;
  SkinValue.Tag := Value.Tag;
  SkinValue.Visible := Value.Visible;
  SkinValue.SkinEngine := SkinEngine;
  // Events
  SkinValue.OnClick := Value.OnClick;
  SkinValue.OnDragDrop := Value.OnDragDrop;
  SkinValue.OnDragOver := Value.OnDragOver;
  SkinValue.OnEndDock := Value.OnEndDock;
  SkinValue.OnEndDrag := Value.OnEndDrag;
  SkinValue.OnEnter := Value.OnEnter;
  SkinValue.OnClick := Value.OnClick;
  SkinValue.OnKeyDown := Value.OnKeyDown;
  SkinValue.OnKeyPress := Value.OnKeyPress;
  SkinValue.OnKeyUp := Value.OnKeyUp;
  SkinValue.OnMouseDown := Value.OnMouseDown;
  SkinValue.OnMouseMove := Value.OnMouseMove;
  SkinValue.OnMouseUp := Value.OnMouseUp;
  SkinValue.OnStartDock := Value.OnStartDock;
  SkinValue.OnStartDrag := Value.OnStartDrag;

  Name := Value.Name;
  Value.Free;
  SkinValue.Name := Name;
  Result := SkinValue;
end;

procedure TscSkinConvert.BitBtnConvert(Value: TBitBtn);
var
  SkinValue: TscButton;
  Name: string;
begin
  SkinValue := TscButton.Create(Form);
  SkinValue.BoundsRect := Value.BoundsRect;
  SkinValue.Parent := Value.Parent;
  SkinValue.Action := Value.Action;
  SkinValue.BiDiMode := Value.BiDiMode;
  SkinValue.Constraints.Assign(Value.Constraints);
  SkinValue.Font.Assign(Value.Font);
  SkinValue.Cursor := Value.Cursor;
  SkinValue.DragCursor := Value.DragCursor;
  SkinValue.DragKind := Value.DragKind;
  SkinValue.DragMode := Value.DragMode;
  SkinValue.Enabled := Value.Enabled;
  SkinValue.HelpContext := Value.HelpContext;
  SkinValue.Hint := Value.Hint;
  SkinValue.ModalResult := Value.ModalResult;
  SkinValue.ParentBiDiMode := Value.ParentBiDiMode;
  SkinValue.ParentShowHint := Value.ParentShowHint;
  SkinValue.ParentFont := Value.ParentFont;
  SkinValue.PopupMenu := Value.PopupMenu;
  SkinValue.ShowHint := Value.ShowHint;
  SkinValue.TabOrder := Value.TabOrder;
  SkinValue.Tag := Value.Tag;
  SkinValue.Cancel := Value.Cancel;
  SkinValue.Caption := Value.Caption;
  SkinValue.Visible := true;
  SkinValue.SkinEngine := SkinEngine;
  SkinValue.Anchors := Value.Anchors;
  // bitbtns
  SkinValue.Glyph.Assign(Value.Glyph);
  SkinValue.Kind := Value.Kind;
  SkinValue.Layout := Value.Layout;
  SkinValue.NumGlyphs := Value.NumGlyphs;
  SkinValue.Spacing := Value.Spacing;
  // Events
  SkinValue.OnClick := Value.OnClick;
  SkinValue.OnDragDrop := Value.OnDragDrop;
  SkinValue.OnDragOver := Value.OnDragOver;
  SkinValue.OnEndDock := Value.OnEndDock;
  SkinValue.OnEndDrag := Value.OnEndDrag;
  SkinValue.OnEnter := Value.OnEnter;
  SkinValue.OnClick := Value.OnClick;
  SkinValue.OnKeyDown := Value.OnKeyDown;
  SkinValue.OnKeyPress := Value.OnKeyPress;
  SkinValue.OnKeyUp := Value.OnKeyUp;
  SkinValue.OnMouseDown := Value.OnMouseDown;
  SkinValue.OnMouseMove := Value.OnMouseMove;
  SkinValue.OnMouseUp := Value.OnMouseUp;
  SkinValue.OnStartDock := Value.OnStartDock;
  SkinValue.OnStartDrag := Value.OnStartDrag;

  Name := Value.Name;
  Value.Free;
  SkinValue.Name := Name;
end;

procedure TscSkinConvert.SpeedButtonConvert(Value: TSpeedButton);
var
  SkinValue: TscSpeedButton;
  Name: string;
begin
  SkinValue := TscSpeedButton.Create(Form);
  SkinValue.Parent := Value.Parent;
  SkinValue.Caption := Value.Caption;
  SkinValue.BoundsRect := Value.BoundsRect;
  SkinValue.Visible := true;
  SkinValue.Down := Value.Down;
  SkinValue.Enabled := Value.Enabled;
  SkinValue.AllowAllUp := Value.AllowAllUp;
  SkinValue.SkinEngine := SkinEngine;
  SkinValue.Action := Value.Action;
  SkinValue.BiDiMode := Value.BiDiMode;
  SkinValue.Constraints.Assign(Value.Constraints);
  SkinValue.Font.Assign(Value.Font);
  SkinValue.Cursor := Value.Cursor;
  SkinValue.Enabled := Value.Enabled;
  SkinValue.Hint := Value.Hint;
  SkinValue.ParentBiDiMode := Value.ParentBiDiMode;
  SkinValue.ParentShowHint := Value.ParentShowHint;
  SkinValue.ParentFont := Value.ParentFont;
  SkinValue.PopupMenu := Value.PopupMenu;
  SkinValue.ShowHint := Value.ShowHint;
  SkinValue.Tag := Value.Tag;
  SkinValue.Anchors := Value.Anchors;
  // SpeedButton
  SkinValue.AllowAllUp := Value.AllowAllUp;
  SkinValue.GroupIndex := Value.GroupIndex;
  SkinValue.Glyph.Assign(Value.Glyph);
  SkinValue.Layout := Value.Layout;
  SkinValue.NumGlyphs := Value.NumGlyphs;
  SkinValue.Spacing := Value.Spacing;
  SkinValue.Transparent := Value.Transparent;
  // Events
  SkinValue.OnClick := Value.OnClick;
  SkinValue.OnMouseDown := Value.OnMouseDown;
  SkinValue.OnMouseMove := Value.OnMouseMove;
  SkinValue.OnMouseUp := Value.OnMouseUp;

  Name := Value.Name;
  Value.Free;
  SkinValue.Name := Name;
end;

procedure TscSkinConvert.CheckBoxConvert(Value: TCheckBox);
var
  SkinValue: TscCheckBox;
  Name: string;
begin
  SkinValue := TscCheckBox.Create(Form);
  SkinValue.Anchors := Value.Anchors;
  SkinValue.Parent := Value.Parent;
  SkinValue.Caption := Value.Caption;
  SkinValue.BoundsRect := Value.BoundsRect;
  SkinValue.Visible := true;
  SkinValue.Checked := Value.Checked;
  SkinValue.State := Value.State;
  SkinValue.Enabled := Value.Enabled;
  SkinValue.SkinEngine := SkinEngine;
  SkinValue.BiDiMode := Value.BiDiMode;
  SkinValue.Constraints.Assign(Value.Constraints);
  SkinValue.Font.Assign(Value.Font);
  SkinValue.Cursor := Value.Cursor;
  SkinValue.Enabled := Value.Enabled;
  SkinValue.Hint := Value.Hint;
  SkinValue.ParentFont := Value.ParentFont;
  SkinValue.PopupMenu := Value.PopupMenu;
  SkinValue.ShowHint := Value.ShowHint;
  SkinValue.Tag := Value.Tag;
  // Events
  SkinValue.OnClick := Value.OnClick;
  SkinValue.OnMouseDown := Value.OnMouseDown;
  SkinValue.OnMouseMove := Value.OnMouseMove;
  SkinValue.OnMouseUp := Value.OnMouseUp;

  Name := Value.Name;
  Value.Free;
  SkinValue.Name := Name;
end;

procedure TscSkinConvert.RadioButtonConvert(Value: TRadioButton);
var
  SkinValue: TscRadioButton;
  Name: string;
begin
  SkinValue := TscRadioButton.Create(Form);
  SkinValue.Anchors := Value.Anchors;
  SkinValue.Parent := Value.Parent;
  SkinValue.Caption := Value.Caption;
  SkinValue.BoundsRect := Value.BoundsRect;
  SkinValue.Visible := true;
  SkinValue.Checked := Value.Checked;
  SkinValue.Enabled := Value.Enabled;
  SkinValue.SkinEngine := SkinEngine;
  SkinValue.BiDiMode := Value.BiDiMode;
  SkinValue.Constraints.Assign(Value.Constraints);
  SkinValue.Font.Assign(Value.Font);
  SkinValue.Cursor := Value.Cursor;
  SkinValue.Enabled := Value.Enabled;
  SkinValue.Hint := Value.Hint;
  SkinValue.ParentFont := Value.ParentFont;
  SkinValue.PopupMenu := Value.PopupMenu;
  SkinValue.ShowHint := Value.ShowHint;
  SkinValue.Tag := Value.Tag;
  // Events
  SkinValue.OnClick := Value.OnClick;
  SkinValue.OnMouseDown := Value.OnMouseDown;
  SkinValue.OnMouseMove := Value.OnMouseMove;
  SkinValue.OnMouseUp := Value.OnMouseUp;

  Name := Value.Name;
  Value.Free;
  SkinValue.Name := Name;
end;

procedure TscSkinConvert.ProgressBarConvert(Value: TProgressBar);
var
  SkinValue: TscProgressBar;
  Name: string;
begin
  SkinValue := TscProgressBar.Create(Form);
  SkinValue.Parent := Value.Parent;
  SkinValue.Constraints.Assign(Value.Constraints);
  SkinValue.Cursor := Value.Cursor;
  SkinValue.Enabled := Value.Enabled;
  SkinValue.Hint := Value.Hint;
  SkinValue.PopupMenu := Value.PopupMenu;
  SkinValue.ShowHint := Value.ShowHint;
  SkinValue.Tag := Value.Tag;
  SkinValue.BoundsRect := Value.BoundsRect;
  SkinValue.Visible := true;
  SkinValue.SkinEngine := SkinEngine;
  SkinValue.Min := Value.Min;
  SkinValue.Max := Value.Max;
  SkinValue.Position := Value.Position;
  // Events

  Name := Value.Name;
  Value.Free;
  SkinValue.Name := Name;
end;

procedure TscSkinConvert.PanelConvert(Value: TPanel);
var
  SkinValue: TscPanel;
  Caption, Name: string;
  i: integer;
begin
  SkinValue := TscPanel.Create(Form);
  SkinValue.BoundsRect := Value.BoundsRect;
  SkinValue.Parent := Value.Parent;
  SkinValue.Align := Value.Align;
  SkinValue.Action := Value.Action;
  SkinValue.Anchors := Value.Anchors;
  SkinValue.BiDiMode := Value.BiDiMode;
  SkinValue.Constraints.Assign(Value.Constraints);
  SkinValue.Cursor := Value.Cursor;
  SkinValue.DragCursor := Value.DragCursor;
  SkinValue.DragKind := Value.DragKind;
  SkinValue.DragMode := Value.DragMode;
  SkinValue.Enabled := Value.Enabled;
  SkinValue.Font.Assign(Value.Font);
  SkinValue.HelpContext := Value.HelpContext;
  SkinValue.Hint := Value.Hint;
  SkinValue.ParentBiDiMode := Value.ParentBiDiMode;
  SkinValue.ParentShowHint := Value.ParentShowHint;
  SkinValue.ParentFont := Value.ParentFont;
  SkinValue.PopupMenu := Value.PopupMenu;
  SkinValue.ShowHint := Value.ShowHint;
  SkinValue.TabOrder := Value.TabOrder;
  SkinValue.TabStop := Value.TabStop;
  SkinValue.Tag := Value.Tag;
  SkinValue.Visible := Value.Visible;
  SkinValue.SkinEngine := SkinEngine;
  // Events
  SkinValue.OnClick := Value.OnClick;
  SkinValue.OnDragDrop := Value.OnDragDrop;
  SkinValue.OnDragOver := Value.OnDragOver;
  SkinValue.OnEndDock := Value.OnEndDock;
  SkinValue.OnEndDrag := Value.OnEndDrag;
  SkinValue.OnEnter := Value.OnEnter;
  SkinValue.OnClick := Value.OnClick;
  SkinValue.OnMouseDown := Value.OnMouseDown;
  SkinValue.OnMouseMove := Value.OnMouseMove;
  SkinValue.OnMouseUp := Value.OnMouseUp;
  // Add child
  for i := 0 to Form.ComponentCount-1 do
    if (Form.Components[i] is TControl) and
       ((Form.Components[i] as TControl).Parent = Value)
    then
      (Form.Components[i] as TControl).Parent := SkinValue;
  // Remove old
  Name := Value.Name;
  Caption := Value.Caption;
  Value.Free;
  SkinValue.Name := Name;
  SkinValue.Caption := Caption;
end;

procedure TscSkinConvert.PopupMenuConvert(Value: TPopupMenu);
const
  IBreaks: array[TMenuBreak] of Longint = (MFT_STRING, MFT_MENUBREAK, MFT_MENUBARBREAK);

 procedure AddMenuItem(Items: TMenuItem; AddItems: TMenuItem);
 var
   Item: TMenuItem;
   i: integer;
 begin
   for i := 0 to AddItems.Count-1 do
   begin
     with AddItems[i] do
       Item := NewItem(Caption, ShortCut, Checked, Enabled, OnClick,
         HelpContext, 'sm'+Name);
     Item.Bitmap := AddItems[i].Bitmap;
     Item.ImageIndex := AddItems[i].ImageIndex;
     // Create sub menu
     if AddItems[i].Count > 0 then
       AddMenuItem(Item, AddItems[i]);
     Items.Add(Item);
   end;
 end;
var
  SkinValue: TscPopupMenu;
  Name: string;
//  i: integer;
begin
  SkinValue := TscPopupMenu.Create(Form);
  SkinValue.Alignment := Value.Alignment;
  {$IFDEF KS_D5 or KS_CB5}
  SkinValue.AutoHotkeys := Value.AutoHotkeys;
  SkinValue.AutoLineReduction := Value.AutoLineReduction;
  SkinValue.MenuAnimation := [];
  {$ENDIF}
  SkinValue.AutoPopup := Value.AutoPopup;
  SkinValue.BiDiMode := Value.BiDiMode;
  SkinValue.HelpContext := Value.HelpContext;
  SkinValue.Images := Value.Images;
  AddMenuItem(SkinValue.Items, Value.Items);
  SkinValue.OwnerDraw := true;
  SkinValue.ParentBiDiMode := Value.ParentBiDiMode;
  SkinValue.Tag := Value.Tag;
  SkinValue.TrackButton := Value.TrackButton;
  SkinValue.SkinEngine := SkinEngine;
  // Events
  SkinValue.OnPopup := Value.OnPopup;
  SkinValue.OnChange := Value.OnChange;

  // Set PopupMenu property for components
  if Form is TForm then
    if (Form as TForm).PopupMenu = Value then
      (Form as TForm).PopupMenu := SkinValue;
{  for i := 0 to Form.ComponentCount-1 do
    if (Form.Components[i] is TControl) and
       ((Form.Components[i] as TControl).PopupMenu = Value)
    then
      (Form.Components[i] as TControl).PopupMenu := SkinValue;}
  // Remove old
  Name := Value.Name;
  Value.Free;
  SkinValue.Name := Name;
end;

procedure TscSkinConvert.Convert;
var
  Comp: TComponent;
  CompList: TList;
  i: integer;
  ConvForm: TConvForm;
begin
  ConvForm := TConvForm.Create(nil);
  try
    if ConvForm.ShowModal = mrOk then
    begin
      // Convert
      CompList := TList.Create;
      try
        for i := 0 to Form.ComponentCount-1 do
          CompList.Add(Form.Components[i]);
        for i := 0 to CompList.Count-1 do
        begin
          Comp := CompList[i];
          try
            if (Comp.ClassName = 'TButton') and
               (ConvForm.CompList.Checked[0]) then
              ButtonConvert(TButton(Comp));
            if (Comp.ClassName = 'TBitBtn') and
               (ConvForm.CompList.Checked[1])  then
              BitBtnConvert(TBitBtn(Comp));
            if (Comp.ClassName = 'TSpeedButton') and
               (ConvForm.CompList.Checked[2])  then
              SpeedButtonConvert(TSpeedButton(Comp));
            if (Comp.ClassName = 'TProgressBar') and
               (ConvForm.CompList.Checked[3])  then
              ProgressBarConvert(TProgressBar(Comp));
            if (Comp.ClassName = 'TPopupMenu') and
               (ConvForm.CompList.Checked[4])  then
              PopupMenuConvert(TPopupMenu(Comp));
            if (Comp.ClassName = 'TCheckBox') and
               (ConvForm.CompList.Checked[5])  then
              CheckBoxConvert(TCheckBox(Comp));
            if (Comp.ClassName = 'TRadioButton') and
               (ConvForm.CompList.Checked[6])  then
              RadioButtonConvert(TRadioButton(Comp));
            if (Comp.ClassName = 'TPanel') and
               (ConvForm.CompList.Checked[7])  then
              PanelConvert(TPanel(Comp));
                    except
          end;
        end;
      finally
        CompList.Free;
      end;
      MessageDlg('Convert complete. Please, remove TscSkinConvert component'+
        ' from from.', mtInformation, [mbOk], 0);
    end;
  finally
    ConvForm.Free;
  end;
end;

procedure Register;
begin
  RegisterComponents('FreeSkinEngine', [TscSkinConvert]);

end;

end.

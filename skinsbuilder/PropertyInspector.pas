{ Component "PropertyInspector V1.0" is a non-visual component for viewing
  properties of every TControl at runtime. Works on all application forms.
  Can be controlled by mouse/keyboard or program.

  Udo Juerss
  57078 Siegen, Germany
  April 1999

  e-mail: ujhs@aol.com

  Only three properties:

  StayOnTop: Bool;           Formstyle for the property form.

  UpdateInterval: Cardinal;  Interval of property updates.

  OnChange: TControlChange;  enables to retrieve the component on witch the
                             mouse moves. (only in unlocked state)


  How to do: 1. Put a component "PropertyInspector" on your form.
             2. Set "UpdateInterval" and "StayOnTop" for your needs.
             3. Start application.
             4. Move the mouse over the control you want to retrieve.
             5. Press "F12" to lock the control.

             Now the properties of the selected control are updated at the
             "UpdateInterval" rate.

             Press "F11" to toggle show/hide the PropertyForm.
             Press "F12" to toggle lock/unlock the controlselect.

             If you wnat to view a property like "Width" witch is located at
             the end of the listbox, then you can select an item above "Width".
             This item gets the TopIndex for all next updates - so you must not
             scroll every time.

  Hints: "PropertyInspector" can be controlled by program with public methods:

                procedure Lock(State: Bool);
                procedure SetControl(AControl: TControl);
                procedure Update(Sender: TObject);

         Example:
         Call once at program startup: PropertyInspector1.Lock(True)
         (this disables mouseselect ["F12" selects again])
         Select the control to inspect: PropertyInspector1.SetControl(Button1);
         Whereever you want: PropertyInspector1.Update(nil); or
                             PropertyInspector1.Update(Self);

         If you call Update(Self) then program stops after property update and
         waits until "VK_WAIT" key is pressed. While in waitstate the cursor
         is set to hourglass to signal this state.

         Update(nil) does not wait after property update.

         It´s easy to change control-keys for locking, showing and waiting by
         assigning other VK_xxx codes to VK_LOCK, VK_SHOW and VK_WAIT.

         Limits in this version: no subclassing and no methodretrieve.
}

unit
  PropertyInspector;

interface
{------------------------------------------------------------------------------}

uses
  Windows,Messages,Classes,Forms,Dialogs,Controls,StdCtrls,ExtCtrls, SysUtils, Variants, Graphics;
{------------------------------------------------------------------------------}

const
  VK_LOCK = VK_F12;
  VK_SHOW = VK_F11;
  VK_WAIT = VK_SPACE;
{------------------------------------------------------------------------------}

type
  TPropertyForm = class(TForm)
  public
    ListBox: TListBox;
    constructor CreateNew(AOwner: TComponent; Dummy: Integer = 0); override;
    destructor Destroy; override;
    procedure OnListBoxClick(Sender: TObject);
  end;

  TControlChange = procedure(Sender: TObject; Ctrl: TControl) of object;

  TPropertyInspector = class(TComponent)
  private
    FPropForm: TPropertyForm;
    FTimer: TTimer;
    FStayOnTop: Bool;
    FUpdateInterval: Cardinal;
    FOnChange: TControlChange;
  protected
    procedure SetStayOnTop(Value: Bool);
    procedure SetUpdateInterval(Value: Cardinal);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Lock(State: Bool);
    procedure SetControl(AControl: TControl);
    procedure Update(Sender: TObject);
  published
    property StayOnTop: Bool read FStayOnTop write SetStayOnTop;
    property UpdateInterval: Cardinal read FUpdateInterval write SetUpdateInterval;
    property OnChange: TControlChange read FOnChange write FOnChange;
  end;
{------------------------------------------------------------------------------}

procedure Register;
procedure GetProperties(Comp: TComponent; List: TStrings);
{------------------------------------------------------------------------------}

implementation
{------------------------------------------------------------------------------}

uses
 TypInfo;
{------------------------------------------------------------------------------}

const
  tkProps = [tkUnknown,tkInteger,tkChar,tkEnumeration,tkFloat,tkString,tkSet,
             tkClass,tkMethod,tkWChar,tkLString,tkWString,tkVariant];
{------------------------------------------------------------------------------}

var
  ParentForm: TCustomForm;
  PropForm: TPropertyForm;
  MouseHandle: HHook;
  KeyHandle: HHook;
  Locked: Bool;
  FindBusy: Bool;
  TopItem: Integer;
  MousePt: TPoint;
  FControl: TControl;
  VControl: TControl;
  ChildVControl: TControl;
  PropInspector: TPropertyInspector;
{------------------------------------------------------------------------------}

{
function FindSubcontrolAtPos(AControl: TControl; AScreenPos, AClientPos: TPoint): TControl;
var
  i: Integer;
  C: TControl;
begin
  Result := nil;
  C := AControl;
  if (C=nil) or not C.Visible or not TRect.Create(C.Left, C.Top, C.Left+C.Width, C.Top+C.Height).Contains(AClientPos) then
    Exit;
  Result := AControl;
  if AControl is TWinControl then
    for i := 0 to TWinControl(AControl).ControlCount-1 do
    begin
      C := FindSubcontrolAtPos(TWinControl(AControl).Controls[i], AScreenPos, AControl.ScreenToClient(AScreenPos));
      if C<>nil then
        Result := C;
    end;
end;

function FindControlAtPos(AScreenPos: TPoint): TControl;
var
  i: Integer;
  f,m: TCustomForm;
  p: TPoint;
  r: TRect;
begin
  Result := nil;
  for i := Screen.FormCount-1 downto 0 do
    begin
      f := Screen.Forms[i];
      if f.Visible and (f.Parent=nil) and (f.FormStyle<>fsMDIChild) and
        TRect.Create(f.Left, f.Top, f.Left+f.Width, f.Top+f.Height).Contains(AScreenPos)
      then
        Result := f;
    end;
  Result := FindSubcontrolAtPos(Result, AScreenPos, AScreenPos);
  if (Result is TForm) and (TForm(Result).ClientHandle<>0) then
  begin
    Windows.GetWindowRect(TForm(Result).ClientHandle, r);
    p := TPoint.Create(AScreenPos.X-r.Left, AScreenPos.Y-r.Top);
    m := nil;
    for i := TForm(Result).MDIChildCount-1 downto 0 do
    begin
      f := TForm(Result).MDIChildren[i];
      if TRect.Create(f.Left, f.Top, f.Left+f.Width, f.Top+f.Height).Contains(p) then
        m := f;
    end;
    if m<>nil then
      Result := FindSubcontrolAtPos(m, AScreenPos, p);
  end;
end;

function MouseHookCallBack(Code: Integer; Msg: WPARAM; Mouse: LPARAM): LRESULT; stdcall;
begin
  if (Code >= 0) and not Locked then
  begin
    ParentForm:=Screen.ActiveCustomForm;
    if Assigned(ParentForm) then
    begin
      if not FindBusy then
      begin
        FindBusy:=True;
        if (Msg = WM_MOUSEMOVE) or (Msg = WM_NCMOUSEMOVE) then
        begin
          MousePt:=PMouseHookStruct(Mouse)^.Pt;
          MousePt:=ParentForm.ScreenToClient(MousePt);
        end
        else
        begin
          GetCursorPos(MousePt);
          MousePt:=ParentForm.ScreenToClient(MousePt);
        end;
        VControl:=ParentForm.ControlAtPos(MousePt,False);
        if (VControl = nil) then
        begin
          MousePt:=ParentForm.ClientToScreen(MousePt);
          VControl:=FindControlAtPos(MousePt);
          if (VControl <> nil) and (VControl <> ParentForm) then
          begin
            MousePt:=VControl.ScreenToClient(MousePt);
            ChildVControl:=TWinControl(VControl).ControlAtPos(MousePt,False);
            if (ChildVControl <> nil) then VControl:=ChildVControl;
          end;
        end;
        if (FControl <> VControl) and (VControl <> PropInspector.FPropForm)
          and (VControl <> PropInspector.FPropForm.ListBox) then
        begin
          if Assigned(PropInspector) then PropInspector.Update(nil);
          if Assigned(PropInspector.FOnChange) then PropInspector.FOnChange(nil,VControl);
          FControl:=VControl;
        end;
        FindBusy:=False;
      end;
    end;
  end;
  Result:=CallNextHookEx(MouseHandle,Code,Msg,Mouse);
end;
{------------------------------------------------------------------------------}

function KeyHookCallBack(Code: Integer; VK: WPARAM; Key: LPARAM): LRESULT; stdcall;
begin
  if Code >= 0 then
  begin
    if Assigned(PropInspector) and (VK = VK_LOCK) and (HiWord(Key) and KF_UP = 0) then
    begin
      Locked:=not Locked;
      if Locked then PropInspector.FTimer.Enabled:=True
        else PropInspector.FTimer.Enabled:=False;
    end;    
    if (VK = VK_SHOW) and (HiWord(Key) and KF_UP = 0) and Assigned(PropForm) then
      PropForm.Visible:=not PropForm.Visible;
  end;
  Result:=CallNextHookEx(KeyHandle,Code,VK,Key);
end;
{------------------------------------------------------------------------------}
}
constructor TPropertyInspector.Create(AOwner: TComponent);
var
  AppName: array[0..127] of Char;
  HModule: THandle;
begin
  inherited;
  FPropForm:=TPropertyForm.CreateNew(nil);
  PropForm:=FPropForm;

  FTimer:=TTimer.Create(nil);
  FTimer.Enabled:=False;
  FTimer.OnTimer:=@Update;
  FTimer.Interval:=50;

  FUpdateInterval:=50;
  StayOnTop:=True;
  PropInspector:=Self;
  MouseHandle:=0;
  KeyHandle:=0;
  Locked:=False;
  FPropForm.Show;

 { if not (csDesigning in ComponentState) then
  begin
    if GetModuleFileName(HInstance,AppName,Pred(SizeOf(AppName))) > 0 then
    begin
      HModule:=GetModuleHandle(AppName);
      if HModule > 0 then
      begin
        MouseHandle:=SetWindowsHookEx(WH_MOUSE,@MouseHookCallBack,HModule,GetCurrentThreadID);
        KeyHandle:=SetWindowsHookEx(WH_KEYBOARD,@KeyHookCallBack,HModule,GetCurrentThreadID);
        FPropForm.Show;
      end;
    end;
    if (MouseHandle = 0) or (KeyHandle = 0) then ShowMessage('Threadhook failed!');
  end;
  }
end;
{------------------------------------------------------------------------------}

destructor TPropertyInspector.Destroy;
begin
  FPropForm.Free;
  FTimer.Free;
  if MouseHandle <> 0 then UnhookWindowsHookEx(MouseHandle);
  if KeyHandle <> 0 then UnhookWindowsHookEx(KeyHandle);
  ParentForm:=nil;
  PropForm:=nil;
  inherited;
end;
{------------------------------------------------------------------------------}

procedure TPropertyInspector.SetStayOnTop(Value: Bool);
begin
  if Value <> FStayOnTop then
  begin
    FStayOnTop:=Value;
    if Assigned(FPropForm) then if Value then FPropForm.FormStyle:=fsStayOnTop
      else FPropForm.FormStyle:=fsNormal;
  end;
end;
{------------------------------------------------------------------------------}

procedure TPropertyInspector.SetUpdateInterval(Value: Cardinal);
begin
  if Value > 9 then
  begin
    FUpdateInterval:=Value;
    FTimer.Interval:=Value;
  end;
end;
{------------------------------------------------------------------------------}

procedure TPropertyInspector.Update(Sender: TObject);
var
  Cursor: TCursor;
begin
  if Assigned(PropForm) then
  begin
    FPropForm.ListBox.Items.BeginUpdate;
    GetProperties(VControl,PropInspector.FPropForm.ListBox.Items);
    FPropForm.ListBox.TopIndex:=TopItem;
    FPropForm.ListBox.Items.EndUpdate;
  end;
  if Assigned(Sender) and not (TObject(Sender) is TTimer) then
  begin
    Cursor:=Screen.Cursor;
    Screen.Cursor:=crHourGlass;
    repeat until GetAsyncKeyState(VK_WAIT) and KF_UP = KF_UP;
    Screen.Cursor:=Cursor;
  end;
end;
{------------------------------------------------------------------------------}

procedure TPropertyInspector.Lock(State: Bool);
begin
  Locked:=State;
end;
{------------------------------------------------------------------------------}

procedure TPropertyInspector.SetControl(AControl: TControl);
begin
  if Assigned(AControl) then VControl:=AControl; //Update(Self);
end;
{------------------------------------------------------------------------------}

function EnumName(Value: LongInt; Info: PTypeInfo): string;
var
  Data: PTypeData;
begin
  Data:=GetTypeData(Info);
  if (Value < Data^.MinValue) or (Value > Data^.MaxValue) then Value:=Data^.MinValue;
  Result:=GetEnumName(Info,Value);
end;
{------------------------------------------------------------------------------}

function SetToString(const SetValue; Info: PTypeInfo): string;
var
  MaskValue,I: LongInt;
  Data,CompData: PTypeData;
  CompInfo: PTypeInfo;
begin
  Data:=GetTypeData(Info);
  CompInfo:=@Data^.CompType^;
  CompData:=GetTypeData(CompInfo);
  MaskValue:=LongInt(SetValue);
  Result:='[';
  for I:=CompData^.MinValue to CompData^.MaxValue do
  begin
    if (MaskValue and 1) <> 0 then Result:=Result + EnumName(I,CompInfo) + ',';
    MaskValue:=MaskValue shr 1;
  end;
  if Result[Length(Result)] = ',' then Delete(Result,Length(Result),1);
  Result:=Result + ']';
end;
{------------------------------------------------------------------------------}

function GetPropAsString(Obj: TObject; Info: PPropInfo): ansistring;
var
  Count,I: Integer;
  IntVal: LongInt;
  PropList: PPropList;
begin
  Result:='';
  Count:=GetPropList(Obj.ClassInfo,tkProps,nil);
  if Count < 1 then Exit;
  GetMem(PropList,Count * SizeOf(PPropInfo));
  try
    GetPropList(Obj.ClassInfo,tkProps,PropList);
    for I:=0 to Pred(Count) do with PropList^[I]^ do
      if (Info = nil) or (UpperCase(Name) = UpperCase(Info^.Name)) then
      begin
        case PropType^.Kind of
          tkUnknown     : Result:='';
          tkInteger     : begin
                            IntVal:=LongInt(GetOrdProp(Obj,PropList^[I]));
                            if (PropType^.Name = 'TColor') and
                               ColorToIdent(IntVal,Result) then
                            else
                              if (PropType^.Name = 'TCursor') and
                                 CursorToIdent(IntVal,Result) then
                              else Result:=IntToStr(IntVal);
                          end;
          tkChar        : Result:=Chr(GetOrdProp(Obj,PropList^[I]));
          tkEnumeration : begin
                            IntVal:=LongInt(GetOrdProp(Obj,PropList^[I]));
                            if (PropType^.Name = 'Boolean') then
                              if IntVal = 1 then Result:='True' else Result:='False'
                            else
                              Result:=EnumName(IntVal,PropList^[I]^.PropType);
                          end;
          tkFloat       : Result:=FloatToStr(GetFloatProp(Obj,PropList^[I]));
          tkString      : Result:=GetStrProp(Obj,PropList^[I]);
          tkSet         : begin
                            IntVal:=LongInt(GetOrdProp(Obj,PropList^[I]));
                            Result:=SetToString(IntVal,PropList^[I]^.PropType);
                          end;
          tkLString     : Result:=GetStrProp(Obj,PropList^[I]);
          end;
      end;
  finally
    FreeMem(PropList,Count * SizeOf(PPropInfo));
  end;
end;
{------------------------------------------------------------------------------}

procedure GetProperties(Comp: TComponent; List: TStrings);
var
  I,PropItems: Integer;
  PropList: PPropList;
  PropInfo: PPropInfo;
begin
  if not Assigned(Comp) or not Assigned(List) then Exit;
  List.Clear;
  List.Add(Comp.Name + ': ' + Comp.ClassName);
  try
    PropItems:=GetPropList(Comp.ClassInfo,tkProperties,nil);
    for I:=1 to PropItems do List.Add(' ');
    if PropItems = 0 then Exit;
    GetMem(PropList,PropItems * SizeOf(PPropInfo));
    try
      GetPropList(Comp.ClassInfo,tkProperties,PropList);
      for I:=0 to Pred(PropItems) do
      begin
        PropInfo:=GetPropInfo(Comp.ClassInfo,PropList^[I]^.Name);
        if I < Pred(List.Count) then
          List[Succ(I)]:=PropList^[I]^.Name + ': ' + GetPropAsString(Comp,PropInfo);
      end;
    finally
      FreeMem(PropList,PropItems * SizeOf(PPropInfo));
    end;
  finally
  end;
end;
{------------------------------------------------------------------------------}

procedure Register;
begin
  RegisterComponents('Udo',[TPropertyInspector]);
end;
{------------------------------------------------------------------------------}

constructor TPropertyForm.CreateNew(AOwner: TComponent; Dummy: Integer = 0);
begin
  inherited;
  SetBounds(0,0,150,400);
  BorderStyle:=bsSizeToolWin;
  ListBox:=TListBox.Create(Self);
  ListBox.Parent:=Self;
  ListBox.Align:=alClient;
  ListBox.OnClick:=@OnListBoxClick;
  Caption:='PropertyInspector';
end;
{------------------------------------------------------------------------------}

destructor TPropertyForm.Destroy;
begin
  ListBox.Free;
  inherited;
end;
{------------------------------------------------------------------------------}

procedure TPropertyForm.OnListBoxClick(Sender: TObject);
begin
  TopItem:=ListBox.ItemIndex;
end;
{------------------------------------------------------------------------------}

initialization
end.


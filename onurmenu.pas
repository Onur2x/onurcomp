unit onurmenu;

{$mode objfpc}{$H+}


interface

uses
  Classes,  Controls, Graphics,BGRABitmap, BGRABitmapTypes, onurctrl,  Menus, types, LCLType;

type

    TONURMainMenu = class(TMainMenu)
    private
      falpha: byte;
      FSkindata: TONURImg;
      Fnormal,fselected,Fline: TONURCUSTOMCROP;

      bgresim:TBGRABitmap;

      procedure SetAlpha(AValue: byte);
      procedure Drawitem(Sender: TObject; ACanvas: TCanvas;
      ARect: TRect; AState: TOwnerDrawState);
      procedure Measureitem(Sender: TObject; ACanvas: TCanvas;
      var AWidth, AHeight: Integer);
    protected
      procedure SetSkindata(Aimg: TONURImg);
    public
      skinname:string;
      Customcroplist: TFPList;//TList;
      constructor Create(Aowner: TComponent); override;
      destructor Destroy; override;
    published
      property Skindata : TONURImg read FSkindata write SetSkindata;

      property Alpha :byte read falpha write SetAlpha;
      property OnChange;
    end;

    { TONURPopupMenu }

    TONURPopupMenu = class(TPopupMenu)
    private
      falpha: byte;
      FSkindata: TONURImg;
      Fnormal,fselected,Fline: TONURCUSTOMCROP;

      bgresim:TBGRABitmap;

      procedure SetAlpha(AValue: byte);
      procedure DrawPopup(Sender: TObject; ACanvas: TCanvas;
      ARect: TRect; AState: TOwnerDrawState);
    protected
      procedure SetSkindata(Aimg: TONURImg);
    public
      skinname:string;
      Customcroplist: TFPList;//TList;
      constructor Create(Aowner: TComponent); override;
      destructor Destroy; override;
    published
      property Skindata : TONURImg read FSkindata write SetSkindata;

      property Alpha :byte read falpha write SetAlpha;
      property Alignment;
      property AutoPopup;
      property HelpContext;
      property TrackButton;
      property OnPopup;
      property OnClose;
    end;

procedure Register;



implementation

uses SysUtils;

procedure Register;
begin
  RegisterComponents('ONUR', [TONURPopupMenu,TONURMainMenu]);

end;

procedure TONURMainMenu.SetAlpha(AValue:byte);
begin
  if falpha=AValue then Exit;
  falpha:=AValue;
end;


procedure TONURMainMenu.Measureitem(Sender:TObject;ACanvas:TCanvas;var AWidth,
  AHeight:Integer);
begin
//  bgresim.SetSize(0, 0);
//  bgresim.SetSize( AWidth+5, AHeight+5);
end;

procedure TONURMainMenu.Drawitem(Sender:TObject;ACanvas:TCanvas;ARect:TRect;
  AState:TOwnerDrawState);
begin

  if (Skindata <> nil) and not (csDesigning in ComponentState) then
  begin
    // InflateRect(Arect,10,0);
   //   bgresim.SetSize(0, 0);
    //  bgresim.SetSize(ARect.Width+5, (ARect.Height*items.Count)+5);
      bgresim.SetSize((ARect.Width*items.Count)+5, (ARect.Height*items.Count)+5);


    // DrawPartnormalBGRABitmap(fnormal.Croprect,bgresim,self.skindata,ARect,255);


      if  AState * [odSelected, odFocused]=[] then
       DrawPartnormalBGRABitmap(fselected.Croprect,bgresim,self.skindata,ARect,255)
      else
       DrawPartnormalBGRABitmap(fnormal.Croprect,bgresim,self.skindata,ARect,255);



      if (TMenuItem(Sender).Caption <> '-') then
      begin
        if  AState * [odSelected, odFocused]=[] then
          bgresim.TextOut(ARect.Left + 15, ARect.Top, TMenuItem(Sender).Caption,colortobgra(fselected.Fontcolor))
        else
          bgresim.TextOut(ARect.Left + 15, ARect.Top, TMenuItem(Sender).Caption,colortobgra(fnormal.Fontcolor));
      end else
      begin
        if  AState * [odSelected, odFocused]=[] then
          bgresim.TextOut(ARect.Left + 15, ARect.Top, TMenuItem(Sender).Caption,colortobgra(fselected.Fontcolor))
        else
          bgresim.TextOut(ARect.Left + 15, ARect.Top, TMenuItem(Sender).Caption,colortobgra(fnormal.Fontcolor));
      end;

      bgresim.Draw(ACanvas,0,0,false);

     // bgresim.SaveToFile('C:\lazarus\components\paketler\ONUR\onurcomp\backup\aa.png');


  end else
  begin

     if  AState * [odSelected, odFocused]=[] then
      ACanvas.Brush.Color:=clblue
     else
      ACanvas.Brush.Color:=clActiveBorder;

     ACanvas.FillRect(ARect);

     ACanvas.Pen.Width   := 0;
     ACanvas.Brush.Style := bsClear;

      if (TMenuItem(Sender).Caption <> '-') then
      begin
        if  AState * [odSelected, odFocused]=[] then
          ACanvas.TextOut(ARect.Left + 5, ARect.Top, TMenuItem(Sender).Caption)
        else
          ACanvas.TextOut(ARect.Left + 5, ARect.Top, TMenuItem(Sender).Caption);
      end else
      begin
        if  AState * [odSelected, odFocused]=[] then
          ACanvas.TextOut(ARect.Left + 5, ARect.Top, TMenuItem(Sender).Caption)
        else
          ACanvas.TextOut(ARect.Left + 5, ARect.Top, TMenuItem(Sender).Caption);
      end;
  end;
end;



procedure TONURMainMenu.SetSkindata(Aimg:TONURImg);
begin
  if Aimg <> nil then
  begin
    FSkindata := Aimg;
    Skindata.ReadskinsComp(self);
  end
  else
  begin
    FSkindata := nil;
  end;
end;

constructor TONURMainMenu.Create(Aowner:TComponent);
begin
  inherited Create(Aowner);
  Customcroplist  := TFPList.Create;//TList.Create;
  bgresim         := TBGRABitmap.Create;
  skinname        := 'mainmenu';
  Fnormal         := TONURCUSTOMCROP.Create('NORMAL');
  fselected       := TONURCUSTOMCROP.Create('SELECTED');
  Fline           := TONURCUSTOMCROP.Create('LINE');
  Customcroplist.Add(Fnormal);
  Customcroplist.Add(fselected);
  Customcroplist.Add(Fline);
  OwnerDraw       := True;
  self.OnDrawItem := @Drawitem;
  self.OnMeasureItem := @Measureitem;
end;

destructor TONURMainMenu.Destroy;
var
  i:byte;
begin
  for i:=0 to Customcroplist.Count-1 do
  TONURCUSTOMCROP(Customcroplist.Items[i]).free;

  Customcroplist.Clear;
  FreeAndNil(Customcroplist);

  if Assigned(bgresim) then  FreeAndNil(bgresim);

  inherited Destroy;
end;


{ TONURPopupMenu }

procedure TONURPopupMenu.SetAlpha(AValue: byte);
begin
  if falpha=AValue then Exit;
  falpha:=AValue;

end;



procedure TONURPopupMenu.DrawPopup(Sender: TObject; ACanvas: TCanvas;
  ARect: TRect; AState: TOwnerDrawState);
//var
// i:Integer;
//Re:TRect;
begin
  bgresim.SetSize(0, 0);
  bgresim.SetSize( (ARect.Width)+5, (ARect.Height*items.Count)+5);



  if (Skindata <> nil) and not (csDesigning in ComponentState) then
  begin

      ACanvas.Pen.Width   := 0;
      ACanvas.Brush.Style := bsClear;

      if  AState * [odSelected, odFocused]=[] then
       DrawPartnormalBGRABitmap(fselected.Croprect,bgresim,self.skindata,ARect,255)
      else
       DrawPartnormalBGRABitmap(fnormal.Croprect,bgresim,self.skindata,ARect,255);




      if (TMenuItem(Sender).Caption <> '-') then
      begin
        if  AState * [odSelected, odFocused]=[] then
          bgresim.TextOut(ARect.Left + 5, ARect.Top, TMenuItem(Sender).Caption,colortobgra(fselected.Fontcolor))
        else
          bgresim.TextOut(ARect.Left + 5, ARect.Top, TMenuItem(Sender).Caption,colortobgra(fnormal.Fontcolor));
      end else
      begin
        if  AState * [odSelected, odFocused]=[] then
          bgresim.TextOut(ARect.Left + 5, ARect.Top, TMenuItem(Sender).Caption,colortobgra(fselected.Fontcolor))
        else
          bgresim.TextOut(ARect.Left + 5, ARect.Top, TMenuItem(Sender).Caption,colortobgra(fnormal.Fontcolor));
      end;

      bgresim.Draw(ACanvas,0,0,false);

  end;
end;

procedure TONURPopupMenu.SetSkindata(Aimg: TONURImg);
begin
  if Aimg <> nil then
  begin
    FSkindata := Aimg;
    Skindata.ReadskinsComp(self);
  end
  else
  begin
    FSkindata := nil;
  end;
end;






constructor TONURPopupMenu.Create(Aowner: TComponent);
begin
  inherited Create(Aowner);
  Customcroplist := TFPList.Create;//TList.Create;
  bgresim          := TBGRABitmap.Create;
  skinname       := 'popupmenu';
  Fnormal        := TONURCUSTOMCROP.Create('NORMAL');
  fselected      := TONURCUSTOMCROP.Create('SELECTED');
  Fline          := TONURCUSTOMCROP.Create('LINE');
  Customcroplist.Add(Fnormal);
  Customcroplist.Add(fselected);
  Customcroplist.Add(Fline);
  OwnerDraw := True;
  self.OnDrawItem:=@DrawPopup;

end;

destructor TONURPopupMenu.Destroy;
var
  i:byte;
begin
  for i:=0 to Customcroplist.Count-1 do
  TONURCUSTOMCROP(Customcroplist.Items[i]).free;

  Customcroplist.Clear;
  FreeAndNil(Customcroplist);

  if Assigned(bgresim) then  FreeAndNil(bgresim);

  inherited Destroy;
end;






end.

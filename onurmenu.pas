unit onurmenu;

{$mode objfpc}{$H+}


interface

uses
  Classes,  Controls, Graphics,BGRABitmap, BGRABitmapTypes, onurctrl,  Menus, types, LCLType;
//  Windows, Classes,Controls, Graphics,BGRABitmap, BGRABitmapTypes, onurctrl,Menus,types,LCLType;

type

    { TONURPopupMenu }

    TONURPopupMenu = class(TPopupMenu)
    private
      falpha: byte;
      FSkindata: TONURImg;
      Fnormal,fselected,Fline: TONURCUSTOMCROP;

      resim:TBGRABitmap;

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

   //   procedure paint; override;
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

uses SysUtils,BGRATransform;

procedure Register;
begin
  RegisterComponents('ONUR', [TONURPopupMenu]);

end;


{ TONURPopupMenu }

procedure TONURPopupMenu.SetAlpha(AValue: byte);
begin
  if falpha=AValue then Exit;
  falpha:=AValue;

end;

procedure TONURPopupMenu.DrawPopup(Sender: TObject; ACanvas: TCanvas;
  ARect: TRect; AState: TOwnerDrawState);
var
// i:Integer;
Re:TRect;
begin
  resim.SetSize(0, 0);
  resim.SetSize(ARect.Width+5, (ARect.Height*items.Count)+5);
  re:=ARect;

  if (Skindata <> nil) and not (csDesigning in ComponentState) then
  begin
    // for i:=0 to Items.Count-1 do
  //   begin
     // resim.Fill(BGRAPixelTransparent);
     // if odSelected in AState then

   //  ACanvas.Draw(ARect.left,ARect.top,resim.Bitmap);
      ACanvas.Pen.Width:=0;
     // InflateRect(ARect, 5,10);

     ACanvas.Brush.Style := bsClear;

      if  AState * [odSelected, odFocused]=[] then
       DrawPartnormalBGRABitmap(fselected.Croprect,resim,self.skindata,re,255)
      else
       DrawPartnormalBGRABitmap(fnormal.Croprect,resim,self.skindata,re,255);
   //   Resim.SaveToFile('C:\lazarus\components\paketler\ONUR\onurcomp\popup.png');
      //resim.Draw(ACanvas,0,0,false);
      //writeln('ok');
     // ACanvas.GradientFill(ARect, clSkyBlue, clWhite, gdHorizontal);
    //  end;


      if (TMenuItem(Sender).Caption <> '-') then
      begin
     // if odSelected in AState then
        if  AState * [odSelected, odFocused]=[] then
         // DrawPartnormal(fnormal.Croprect, self.Skindata.Fimage,resim,ARect, alpha)
          resim.TextOut(re.Left + 5, re.Top, TMenuItem(Sender).Caption,colortobgra(fselected.Fontcolor))
        else
          resim.TextOut(re.Left + 5, re.Top, TMenuItem(Sender).Caption,colortobgra(fnormal.Fontcolor));
      end else
      begin
        if  AState * [odSelected, odFocused]=[] then
         // DrawPartnormal(fnormal.Croprect, self.Skindata.Fimage,resim,ARect, alpha)
          resim.TextOut(re.Left + 5, re.Top, TMenuItem(Sender).Caption,colortobgra(fselected.Fontcolor))
        else
          resim.TextOut(re.Left + 5, re.Top, TMenuItem(Sender).Caption,colortobgra(fnormal.Fontcolor));
      end;

      resim.Draw(ACanvas,0,0,false);
   //  end;
 //    Resim.SaveToFile('C:\lazarus\components\paketler\ONUR\onurcomp\popup.png');
    // writeln(fnormal.Croprect.Width,'   ',fselected.Croprect.Width);
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
  resim          := TBGRABitmap.Create;
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

  if Assigned(resim) then  FreeAndNil(resim);

  inherited Destroy;
end;


 {

procedure TONURProgressBar.paint;
var

  DBAR: TRect;
begin

  if not Visible then Exit;

  resim.SetSize(0, 0);
  resim.SetSize(self.ClientWidth, Self.ClientHeight);

  if (Skindata <> nil) and not (csDesigning in ComponentState) then
  begin

    if self.Kind = oHorizontal then
     DBAR := Rect(0,0 , (fposition * self.ClientWidth) div fmax, self.ClientHeight)
    else
     DBAR := Rect(0, 0 ,self.ClientWidth, (fposition * self.ClientHeight) div fmax);

     // DRAW CENTER
    // if self.Kind = oHorizontal then
    // DrawPartstrechRegion(FCenter.Croprect, Self, self.ClientWidth-(Fleft.Width+FRight.Width), self.ClientHeight -(Ftop.Height + Fbottom.Height), FCenter.Targetrect, alpha)
    // else
     DrawPartstrechRegion(FCenter.Croprect, Self,FCenter.Targetrect.Width,FCenter.Targetrect.Height, FCenter.Targetrect, alpha);

      DrawPartnormal(Fbar.Croprect, self, DBAR, alpha); //bar
      DrawPartnormal(Ftop.Croprect,self,ftop.Targetrect,alpha);
      DrawPartnormal(fbottom.Croprect,self,fbottom.Targetrect,alpha);
      DrawPartnormal(Fleft.Croprect, Self,Fleft.Targetrect, alpha);
      DrawPartnormal(FRight.Croprect, Self,FRight.Targetrect, alpha);
  end
  else
  begin
    resim.Fill(BGRA(190, 208, 190,alpha), dmSet);
  end;

  Captionvisible := FCaptonvisible;
  inherited paint;
end;

 }




end.

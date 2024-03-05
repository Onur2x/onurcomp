unit SkinCanvasCopy;

interface
//----------------------------------------------------------------
uses  Classes,Graphics,types;
//----------------------------------------------------------------
procedure CanvasMaskCopy(Src:TCanvas;Rct:TRect;Dst:TCanvas;Pnt:TPoint;Col:TColor);
procedure CanvasMaskColorCopy(Src:TCanvas;Rct:TRect;Dst:TCanvas;Pnt:TPoint;TransCol,Col:TColor);
procedure CanvasSmoothCopy(Src:TCanvas;Rs:TRect;Dst:TCanvas;Rd:TRect);
//----------------------------------------------------------------
implementation
//----------------------------------------------------------------
procedure CanvasMaskCopy(Src:TCanvas;Rct:TRect;Dst:TCanvas;Pnt:TPoint;Col:TColor);
var     //xs1,ys1,xs2,ys2,xd1,yd1,xd2,yd2:integer;
        xs,ys,xd,yd:integer;
        c:TColor;
begin
        xd:=Pnt.X;
        for xs:=Rct.Left to Rct.Right do
        begin
                yd:=Pnt.Y;
                for ys:=Rct.Top to Rct.Bottom do
                begin
                        c:=Src.Pixels[xs,ys];
                        if c<>Col then
                                Dst.Pixels[xd,yd]:=c;
                        inc(yd);
                end;
                inc(xd);
        end;
end;
//----------------------------------------------------------------
procedure CanvasMaskColorCopy(Src:TCanvas;Rct:TRect;Dst:TCanvas;Pnt:TPoint;TransCol,Col:TColor);
var     //xs1,ys1,xs2,ys2,xd1,yd1,xd2,yd2:integer;
        xs,ys,xd,yd:integer;
        c:TColor;
begin
        xd:=Pnt.X;
        for xs:=Rct.Left to Rct.Right do
        begin
                yd:=Pnt.Y;
                for ys:=Rct.Top to Rct.Bottom do
                begin
                        c:=Src.Pixels[xs,ys];
                        if c<>TransCol then
                                Dst.Pixels[xd,yd]:=Col;
                        inc(yd);
                end;
                inc(xd);
        end;
end;
//----------------------------------------------------------------
procedure CanvasSmoothCopy(Src:TCanvas;Rs:TRect;Dst:TCanvas;Rd:TRect);
begin
        Dst.CopyRect(RD,Src,Rs); 
end;
//----------------------------------------------------------------
end.

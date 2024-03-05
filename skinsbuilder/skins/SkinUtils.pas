
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
{                                                                   }
{*******************************************************************}
{
 $Id: SkinUtils.pas,v 1.1.1.1 2003/03/21 12:12:44 evgeny Exp $                                                            
}

unit SkinUtils;

interface

{$I KSSKIN.INC}

uses Windows, Messages, SysUtils, Classes, Controls, Forms, Menus, Graphics,
     StdCtrls, ExtCtrls;

{ strings }

function GetToken(var S: string): string;

{ graphics }

procedure PaintBackground(Control: TWinControl; Canvas: TCanvas);
procedure PaintBackgroundEx(Control: TWinControl; DC: HDC);

implementation {===============================================================}

{ strings }

function GetToken(var S: string): string;
var
  i: byte;
  CopyS: string;
begin
  Result := '';
  CopyS := S;
  for i := 1 to Length(CopyS) do
  begin
    Delete(S, 1, 1);
    if CopyS[i] in [',', ' ', '(', ')', ';'] then Break;
    Result := Result + CopyS[i];
  end;
  Trim(Result);
  Trim(S);
end;

{ graphics }

type
  TParentControl = class(TWinControl);

procedure PaintBackground(Control: TWinControl; Canvas: TCanvas);
var
  B: TBitmap;
begin
  if Assigned(Control) and Assigned(Control.Parent) then
  begin
    B := TBitmap.Create;
    try
      B.Width := TParentControl(Control.Parent).Width;
      B.Height := TParentControl(Control.Parent).Height;

      SendMessage(Control.Parent.Handle, WM_ERASEBKGND, B.Canvas.Handle, 0);
      TParentControl(Control.Parent).PaintControls(B.Canvas.Handle, nil);

      { Paint to DC }
      Canvas.Draw(-Control.Left, -Control.Top, B); 
    finally
      B.Free;
    end;
  end;
end;

procedure PaintBackgroundEx(Control: TWinControl; DC: HDC);
var
  Canvas: TCanvas;
  SaveIndex: integer;
begin
  SaveIndex := SaveDC(DC);
  try
    Canvas := TCanvas.Create;
    try
      Canvas.Handle := DC;
      PaintBackground(Control, Canvas);
      Canvas.Handle := 0;
    finally
      Canvas.Free;
    end;
  finally
    RestoreDC(DC, SaveIndex);
  end;
end;


end.

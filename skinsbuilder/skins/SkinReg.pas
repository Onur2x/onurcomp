
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
 $Id: SkinReg.pas,v 1.2 2003/03/22 17:10:07 evgeny Exp $                                                            
}

unit SkinReg;

{$I KSSKIN.INC}

interface

uses SysUtils, Windows, Messages, Classes, Graphics, Controls,
     Forms, StdCtrls, Dialogs;

procedure Register;

implementation {===============================================================}

{$R skinreg.dcr}

uses
  SkinConst, SkinSource, SkinEngine, SkinProgBar, SkinButton, SkinCtrls,
  SkinPageCtrl;


procedure Register;
begin
  RegisterComponents('FreeSkinEngine', [TscSkinEngine]);
  RegisterComponents('FreeSkinEngine', [TscSkinStore]);
  RegisterComponents('FreeSkinEngine', [TscPopupMenu]);
  RegisterComponents('FreeSkinEngine', [TscProgressBar]);
  RegisterComponents('FreeSkinEngine', [TscSpeedButton, TscButton]);
  RegisterComponents('FreeSkinEngine', [TscCheckBox, TscRadioButton]);
  RegisterComponents('FreeSkinEngine', [TscPanel]);
  RegisterComponents('FreeSkinEngine', [TscPageControl]);
  RegisterComponents('FreeSkinEngine', [TscTabControl]);
end;

end.

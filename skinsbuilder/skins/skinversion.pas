
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
 $Id: skinversion.pas,v 1.3 2003/03/22 17:10:07 evgeny Exp $                                                            
}
unit SkinVersion;

{$I ksskin.inc}
{$T-,W-,X+,P+}

interface

const
  scSkinVersion = '1.0.0';
  scSkinVersionPropText = 'FreeSkinEngine version ' + scSkinVersion;

type
  TSeSkinVersion = type string;

const
  Sig: PChar = '- ' + scSkinVersionPropText +
    {$IFDEF KS_CBUILDER4} ' - CB4 - ' + {$ENDIF}
    {$IFDEF KS_DELPHI4} ' - D4 - '+ {$ENDIF}
    {$IFDEF KS_CBUILDER5} ' - CB5 - '+ {$ENDIF}
    {$IFDEF KS_DELPHI5} ' - D5 - '+ {$ENDIF}
    {$IFDEF KS_CBUILDER6} ' - CB6 - '+ {$ENDIF}
    {$IFDEF KS_DELPHI6} ' - D6 - '+ {$ENDIF}
    {$IFDEF KS_CBUILDER6} ' - CB7 - '+ {$ENDIF}
    {$IFDEF KS_DELPHI6} ' - D7 - '+ {$ENDIF}
    'Copyright (C) 1998-2003 by Evgeny Kryukov -';

procedure ShowVersion;

implementation {===============================================================}

uses Forms, Dialogs, SysUtils; 

procedure ShowVersion;
const
  AboutText =
    '%s'#13#10 +
    'Copyright (C) 2001-2002 by Evgeny Kryukov'#13#10 +
    'For conditions of distribution and use, see LICENSE.TXT.'#13#10 +
    #13#10 +
    'Visit our web site for the latest versions of SkinEngine:'#13#10 +
    'http://www.ksdev.com/';
begin
  MessageDlg(Format(AboutText, [scSkinVersionPropText]), mtInformation, [mbOK], 0);
end;

initialization
  Sig := Sig;
end.

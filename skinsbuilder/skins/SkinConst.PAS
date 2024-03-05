
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
 $Id: SkinConst.PAS,v 1.1.1.1 2003/03/21 12:12:44 evgeny Exp $                                                            
}

unit SkinConst;

interface

{$I KSSKIN.INC}

uses Controls, Messages;

resourcestring

  KS_SOKButton = 'OK';
  KS_SCancelButton = 'Cancel';
  KS_SYesButton = '&Yes';
  KS_SNoButton = '&No';
  KS_SHelpButton = '&Help';
  KS_SCloseButton = '&Close';
  KS_SIgnoreButton = '&Ignore';
  KS_SRetryButton = '&Retry';
  KS_SAbortButton = 'Abort';
  KS_SAllButton = '&All';

const

  SRollup = 'Rollu&p';

{$IFNDEF KS_D5} { Win2K and Win98 extentions }
  {$IFNDEF KS_CB5}
  TPM_NOANIMATION     = $4000;
  DT_HIDEPREFIX = $00100000;
  {$ENDIF}
{$ENDIF}

  CM_RECREATEWINDOW  = CM_BASE + 82;
  CM_DESTROYHOOK     = CM_BASE + 83;

  TransColor = $FF00FF;

  WM_DRAWSKIN   = WM_USER + 109;

  WM_ROLLUP     = WM_USER + 105;
  WM_STAYONTOP  = WM_USER + 106;

  WM_TRACKSKINPOPUPMENU = WM_USER + 107;
  WM_TRACKSYSTEMMENU = WM_USER + 108;

  WM_SKINCHANGE = WM_USER + 109;

  WM_SKINSYSCOMMAND = WM_USER + 111;

  WM_SKINMAINMENUCHANGED = WM_USER + 112;

implementation {===============================================================}

end.

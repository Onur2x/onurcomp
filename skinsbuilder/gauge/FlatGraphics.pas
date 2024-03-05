unit FlatGraphics;

{***************************************************************}
{  FlatStyle Graphics Unit                                      }
{  Copyright ©1999 Lloyd Kinsella.                              }
{                                                               }
{  FlatStyle is Copyright ©1998-99 Maik Porkert.                }
{***************************************************************}

interface

{ Color Constants }

uses SysUtils, Graphics;

{ NOTE: All Colors have the 'ec' prefix which means Encarta Color }

const
 { Standard Encarta & FlatStyle Color Constants }
 ecDarkBlue = TColor($00996633);
 ecBlue = TColor($00CF9030);
 ecLightBlue = TColor($00CFB78F);

 ecDarkRed = TColor($00302794);
 ecRed = TColor($005F58B0);
 ecLightRed = TColor($006963B6);

 ecDarkGreen = TColor($00385937);
 ecGreen = TColor($00518150);
 ecLightGreen = TColor($0093CAB1);

 ecDarkYellow = TColor($004EB6CF);
 ecYellow = TColor($0057D1FF);
 ecLightYellow = TColor($00B3F8FF);

 ecDarkBrown = $00394D4D;
 ecBrown = $00555E66;
 ecLightBrown = $00829AA2;

 ecDarkKaki = $00D3D3D3;
 ecKaki = $00C8D7D7;
 ecLightKaki = $00E0E9EF;

 { Encarta & FlatStyle Interface Color Constants }
 ecBtnHighlight = clWhite;
 ecBtnShadow = clBlack;
 ecBtnFace = ecLightKaki;
 ecBtnFaceDown = ecKaki;

 ecFocused = clWhite;

 ecScrollbar = ecLightKaki;
 ecScrollbarThumb = ecLightBrown;

 ecBackground = clWhite;

 ecHint = ecYellow;
 ecHintArrow = clBlack;

 ecDot = clBlack;
 ecTick = clBlack;

 ecMenuBorder = ecDarkBrown;
 ecMenu = clBlack;
 ecMenuSelected = ecDarkYellow;

 ecProgressBlock = ecBlue;
 ecUnselectedTab = ecBlue;

 ecSelection = clNavy;

 ecCaption = clBlack;
 ecCaptionText = clWhite;

implementation

end.

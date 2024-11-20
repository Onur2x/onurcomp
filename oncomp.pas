unit oncomp;



{$mode objfpc}{$H+}
//{$mode delphi}
{$R onres.res}

interface

uses
  Windows, SysUtils, LMessages, Forms, LCLType, LCLIntf,Classes, StdCtrls, LazMethodList,
  Controls, Graphics, ExtCtrls, maskedit, BGRABitmap, BGRABitmapTypes, Calendar,Dialogs;




const
   s_invalid_date = 'Invalid Date: ';
   s_invalid_integer = 'Invalid Integer';

//  s_invalid_date = 'Geçersiz Tarih: ';
//  s_invalid_integer = 'Geçersiz Sayı';
  NullDate: TDateTime = 0;


implementation

uses CalendarPopup, BGRAPath, IniFiles,onurbutton,onuredit;

end.

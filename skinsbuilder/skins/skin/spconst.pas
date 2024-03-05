{*******************************************************************}
{                                                                   }
{       Almediadev Visual Component Library                         }
{       DynamicSkinForm                                             }
{       Version 12.55                                               }
{                                                                   }
{       Copyright (c) 2000-2012 Almediadev                          }
{       ALL RIGHTS RESERVED                                         }
{                                                                   }
{       Home:  http://www.almdev.com                                }
{       Support: support@almdev.com                                 }
{                                                                   }
{*******************************************************************}

unit spconst;

interface

resourcestring

  SP_MI_MINCAPTION = 'Mi&nimize';
  SP_MI_MAXCAPTION = 'Ma&ximize';
  SP_MI_CLOSECAPTION = '&Close';
  SP_MI_RESTORECAPTION = '&Restore';
  SP_MI_MINTOTRAYCAPTION = 'Minimize to &Tray';
  SP_MI_ROLLUPCAPTION = 'Ro&llUp';

  SP_MINBUTTON_HINT = 'Minimize';
  SP_MAXBUTTON_HINT = 'Maximize';
  SP_CLOSEBUTTON_HINT = 'Close';
  SP_TRAYBUTTON_HINT = 'Minimize to Tray';
  SP_ROLLUPBUTTON_HINT = 'Roll Up';
  SP_MENUBUTTON_HINT = 'System menu';
  SP_RESTORE_HINT = 'Restore';

  SP_Edit_Undo = 'Undo';
  SP_Edit_Copy = 'Copy';
  SP_Edit_Cut = 'Cut';
  SP_Edit_Paste = 'Paste';
  SP_Edit_Delete = 'Delete';
  SP_Edit_SelectAll = 'Select All';

  SP_MSG_BTN_YES = '&Yes';
  SP_MSG_BTN_NO = '&No';
  SP_MSG_BTN_OK = 'OK';
  SP_MSG_BTN_CLOSE = 'Close';
  SP_MSG_BTN_CANCEL = 'Cancel';
  SP_MSG_BTN_ABORT = '&Abort';
  SP_MSG_BTN_RETRY = '&Retry';
  SP_MSG_BTN_IGNORE = '&Ignore';
  SP_MSG_BTN_ALL = '&All';
  SP_MSG_BTN_NOTOALL = 'N&oToAll';
  SP_MSG_BTN_YESTOALL = '&YesToAll';
  SP_MSG_BTN_HELP = '&Help';
  SP_MSG_BTN_OPEN = '&Open';
  SP_MSG_BTN_SAVE = '&Save';

  SP_MSG_BTN_BACK_HINT = 'Go To Last Folder Visited';
  SP_MSG_BTN_UP_HINT = 'Up One Level';
  SP_MSG_BTN_NEWFOLDER_HINT = 'Create New Folder';
  SP_MSG_BTN_VIEWMENU_HINT = 'View Menu';
  SP_MSG_BTN_STRETCH_HINT = 'Stretch Picture';

  SP_MSG_FILENAME = 'File name:';
  SP_MSG_FILETYPE = 'File type:';
  SP_MSG_NEWFOLDER = 'New Folder';
  SP_MSG_LV_DETAILS = 'Details';
  SP_MSG_LV_ICON = 'Large icons';
  SP_MSG_LV_SMALLICON = 'Small icons';
  SP_MSG_LV_LIST = 'List';
  SP_MSG_PREVIEWSKIN = 'Preview';
  SP_MSG_PREVIEWBUTTON = 'Button';
  SP_MSG_OVERWRITE = 'Do you want to overwrite old file?';


  SP_MSG_CAP_WARNING = 'Warning';
  SP_MSG_CAP_ERROR = 'Error';
  SP_MSG_CAP_INFORMATION = 'Information';
  SP_MSG_CAP_CONFIRM = 'Confirm';
  SP_MSG_CAP_SHOWFLAG = 'Do not display this message again';

  SP_CALC_CAP = 'Calculator';
  SP_ERROR = 'Error';

  SP_COLORGRID_CAP = 'Basic colors';
  SP_CUSTOMCOLORGRID_CAP = 'Custom colors';
  SP_ADDCUSTOMCOLORBUTTON_CAP = 'Add to Custom Colors';

  SP_FONTDLG_COLOR = 'Color:';
  SP_FONTDLG_NAME = 'Name:';
  SP_FONTDLG_SIZE = 'Size:';
  SP_FONTDLG_HEIGHT = 'Height:';
  SP_FONTDLG_EXAMPLE = 'Example:';
  SP_FONTDLG_STYLE = 'Style:';
  SP_FONTDLG_SCRIPT = 'Script:';

  SP_NODISKINDRIVE = 'There is no disk in Drive or Drive is not ready';
  SP_NOVALIDDRIVEID = 'Not a valid Drive ID';

  SP_FLV_LOOKIN = 'Look in: ';
  SP_FLV_NAME = 'Name';
  SP_FLV_SIZE = 'Size';
  SP_FLV_TYPE = 'Type';
  SP_FLV_MODIFIED = 'Modified';
  SP_FLV_ATTRIBUTES = 'Attributes';
  SP_FLV_DISKSIZE = 'Disk Size';
  SP_FLV_FREESPACE = 'Free Space';


  SP_PRNSTATUS_Paused = 'Paused';
  SP_PRNSTATUS_PendingDeletion = 'Pending Deletion';
  SP_PRNSTATUS_Busy = 'Busy';
  SP_PRNSTATUS_DoorOpen = 'Door Open';
  SP_PRNSTATUS_Error = 'Error';
  SP_PRNSTATUS_Initializing = 'Initializing';
  SP_PRNSTATUS_IOActive = 'IO Active';
  SP_PRNSTATUS_ManualFeed = 'Manual Feed';
  SP_PRNSTATUS_NoToner = 'No Toner';
  SP_PRNSTATUS_NotAvailable = 'Not Available';
  SP_PRNSTATUS_OFFLine = 'Offline';
  SP_PRNSTATUS_OutOfMemory = 'Out of Memory';
  SP_PRNSTATUS_OutBinFull = 'Output Bin Full';
  SP_PRNSTATUS_PagePunt = 'Page Punt';
  SP_PRNSTATUS_PaperJam = 'Paper Jam';
  SP_PRNSTATUS_PaperOut = 'Paper Out';
  SP_PRNSTATUS_PaperProblem = 'Paper Problem';
  SP_PRNSTATUS_Printing = 'Printing';
  SP_PRNSTATUS_Processing = 'Processing';
  SP_PRNSTATUS_TonerLow = 'Toner Low';
  SP_PRNSTATUS_UserIntervention = 'User Intervention';
  SP_PRNSTATUS_Waiting = 'Waiting';
  SP_PRNSTATUS_WarningUp = 'Warming Up';
  SP_PRNSTATUS_Ready = 'Ready';
  SP_PRNSTATUS_PrintingAndWaiting = 'Printing: %d document(s) waiting';
  SP_PRNDLG_PRINTER = 'Printer';
  SP_PRNDLG_NAME = 'Name:';
  SP_PRNDLG_PROPERTIES = 'Properties...';
  SP_PRNDLG_STATUS = 'Status:';
  SP_PRNDLG_TYPE = 'Type:';
  SP_PRNDLG_WHERE = 'Where:';
  SP_PRNDLG_COMMENT = 'Comment:';
  SP_PRNDLG_PRINTRANGE = 'Print range';
  SP_PRNDLG_COPIES = 'Copies';
  SP_PRNDLG_NUMCOPIES = 'Number of copies:';
  SP_PRNDLG_COLLATE = 'Collate';
  SP_PRNDLG_ALL = 'All';
  SP_PRNDLG_PAGES = 'Pages';
  SP_PRNDLG_SELECTION = 'Selection';
  SP_PRNDLG_FROM = 'from:';
  SP_PRNDLG_TO = 'to:';
  SP_PRNDLG_PRINTTOFILE = 'Print to file';
  SP_PRNDLG_ORIENTATION = 'Orientation';
  SP_PRNDLG_PAPER = 'Paper';
  SP_PRNDLG_PORTRAIT = 'Portrait';
  SP_PRNDLG_LANDSCAPE = 'Landscape';
  SP_PRNDLG_SOURCE = 'Source:';
  SP_PRNDLG_SIZE = 'Size:';
  SP_PRNDLG_MARGINS = 'Margins (millimeters)';
  SP_PRNDLG_MARGINS_INCHES = 'Margins (inches)';
  SP_PRNDLG_LEFT = 'Left:';
  SP_PRNDLG_RIGHT = 'Right:';
  SP_PRNDLG_TOP = 'Top:';
  SP_PRNDLG_BOTTOM = 'Bottom:';
  SP_PRNDLG_WARNING = 'There are no printers in your system!';

  SP_FIND_NEXT = 'Find next';
  SP_FIND_WHAT = 'Find what:';
  SP_FIND_DIRECTION = 'Direction';
  SP_FIND_DIRECTIONUP = 'Up';
  SP_FIND_DIRECTIONDOWN = 'Down';
  SP_FIND_MATCH_CASE = 'Match case';
  SP_FIND_MATCH_WHOLE_WORD_ONLY = 'Match whole word only';
  SP_FIND_REPLACE_WITH = 'Replace with:';
  SP_FIND_REPLACE = 'Replace';
  SP_FIND_REPLACE_All = 'Replace All';

  
  SP_MORECOLORS = 'More colors...';
  SP_AUTOCOLOR = 'Automatic';
  SP_CUSTOMCOLOR = 'Custom...';

  SP_DBNAV_FIRST_HINT = 'FirstRecord';
  SP_DBNAV_PRIOR_HINT = 'PriorRecord';
  SP_DBNAV_NEXT_HINT = 'NextRecord';
  SP_DBNAV_LAST_HINT = 'LastRecord';
  SP_DBNAV_INSERT_HINT = 'InsertRecord';
  SP_DBNAV_DELETE_HINT = 'DeleteRecord';
  SP_DBNAV_EDIT_HINT = 'EditRecord';
  SP_DBNAV_POST_HINT = 'PostEdit';
  SP_DBNAV_CANCEL_HINT = 'CancelEdit';
  SP_DBNAV_REFRESH_HINT = 'RefreshRecord';

  SP_DB_DELETE_QUESTION = 'Delete record?';
  SP_DB_MULTIPLEDELETE_QUESTION = 'Delete all selected records?';

  SP_DBNAV_FIRST = 'FIRST';
  SP_DBNAV_PRIOR = 'PRIOR';
  SP_DBNAV_NEXT = 'NEXT';
  SP_DBNAV_LAST = 'LAST';
  SP_DBNAV_INSERT = 'INSERT';
  SP_DBNAV_DELETE = 'DELETE';
  SP_DBNAV_EDIT = 'EDIT';
  SP_DBNAV_POST = 'POST';
  SP_DBNAV_CANCEL = 'CANCEL';
  SP_DBNAV_REFRESH = 'REFRESH';

implementation

end.


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
 $Id: SkinSound.pas,v 1.1.1.1 2003/03/21 12:12:44 evgeny Exp $                                                            
}

unit SkinSound;

{$I KSSKIN.INC}

{$P+,S-,W-,R-}

interface

uses
  Classes, SysUtils, Windows;

type

  TscSound = class(TPersistent)
  private
    FCount: integer;
    FModified: Boolean;
    FName: string;
    procedure SetModified(Value: Boolean);
  protected
    procedure ReadData(Stream: TStream);
    procedure WriteData(Stream: TStream);
    procedure DefineProperties(Filer: TFiler); override;
    function GetEmpty: boolean; virtual; abstract;
  public
    constructor Create; virtual;
    destructor Destroy; override;
    procedure FreeSound;
    function GetCopy: TscSound;
    procedure Play; virtual; abstract;
    procedure LoadFromFile(const Filename: string); virtual; abstract;
    procedure SaveToFile(const Filename: string); virtual; abstract;
    procedure LoadFromStream(Stream: TStream); virtual; abstract;
    procedure SaveToStream(Stream: TStream); virtual; abstract;
    property Empty: Boolean read GetEmpty;
    property Modified: Boolean read FModified write SetModified;
    property Name: string read FName write FName;
  end;

  TscWave = class(TscSound)
  private
    FWaveData: TMemoryStream;
  protected
    function GetEmpty: Boolean; override;
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure Play; override;
    procedure Assign(Source: TPersistent); override;
    procedure LoadFromFile(const Filename: string); override;
    procedure SaveToFile(const Filename: string); override;
    procedure LoadFromStream(Stream: TStream); override;
    procedure SaveToStream(Stream: TStream); override;
    property Empty;
    property Modified;
  end;

implementation {===============================================================}

uses MMSystem;

{ TscSound }

constructor TscSound.Create;
begin
  inherited Create;
  FCount := 1;
end;

destructor TscSound.Destroy;
begin
  inherited Destroy;
end;

procedure TscSound.FreeSound;
begin
  Dec(FCount);
  if FCount = 0 then
    Free;
end;

function TscSound.GetCopy: TscSound;
begin
  Inc(FCount);
  Result := Self;
end;

procedure TscSound.DefineProperties(Filer: TFiler);
begin
  Filer.DefineBinaryProperty('Data', ReadData, WriteData, not Empty);
end;

procedure TscSound.SetModified(Value: Boolean);
begin
  FModified := Value;
end;

procedure TscSound.ReadData(Stream: TStream);
begin
  LoadFromStream(Stream);
end;

procedure TscSound.WriteData(Stream: TStream);
begin
  SaveToStream(Stream);
end;

{ TscWave }

constructor TscWave.Create;
begin
  inherited Create;
  FWaveData := TMemoryStream.Create;
end;

destructor TscWave.Destroy;
begin
  sndPlaySound(nil, 0);
  FWaveData.Free;
  inherited Destroy;
end;

function TscWave.GetEmpty;
begin
  Result := FWaveData = nil;
end;

procedure TscWave.Assign(Source: TPersistent);
begin
  if (Source = nil) or (Source is TscWave) then
  begin
    if Source <> nil then
      FWaveData := TscWave(Source).FWaveData;
    FModified := true;
    Exit;
  end;
  inherited Assign(Source);
end;

procedure TscWave.LoadFromFile(const Filename: string);
var
  Stream: TStream;
begin
  Stream := TFileStream.Create(Filename, fmOpenRead);
  try
    FWaveData.SetSize(Stream.Size);
    Stream.ReadBuffer(FWaveData.Memory^, Stream.Size);
    FModified := true;
  finally
    Stream.Free;
  end;
end;

procedure TscWave.SaveToFile(const Filename: string);
var
  Stream: TStream;
begin
  Stream := TFileStream.Create(Filename, fmCreate);
  try
    Stream.WriteBuffer(FWaveData.Memory^, FWaveData.Size);
  finally
    Stream.Free;
  end;
end;

procedure TscWave.LoadFromStream(Stream: TStream);
var
  S: integer;
begin
  Stream.Read(S, SizeOf(S));
  FWaveData.SetSize(S);
  Stream.ReadBuffer(FWaveData.Memory^, FWaveData.Size);
  FModified := true;
end;

procedure TscWave.SaveToStream(Stream: TStream);
var
  S: integer;
begin
  S := FWaveData.Size;
  Stream.Write(S, SizeOf(S));
  Stream.WriteBuffer(FWaveData.Memory^, FWaveData.Size);
end;

procedure TscWave.Play;
begin
  // play
  try
    sndPlaySound(FWaveData.Memory, SND_MEMORY or SND_ASYNC);
  finally
  end;
end;

end.

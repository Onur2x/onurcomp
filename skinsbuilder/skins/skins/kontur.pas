unit kontur;

//{$I KSSKIN.INC}
{$WEAKPACKAGEUNIT ON}

interface

uses
  Windows;

type

  TksCounter = class
  private
    FFrequency: Int64;
    FStart: Int64;
    FStop: Int64;
    FCounting: Boolean;
    FElapsedTime: Single;
  public
    constructor Create;
    procedure Start;
    function Stop: Single;
    property ElapsedTime: Single read FElapsedTime;
    property Counting: Boolean read FCounting;
  end;

procedure StartCount(var Counter: TksCounter);
function StopCount(var Counter: TksCounter): Single;

implementation {===============================================================}

uses
  SysUtils;

constructor TksCounter.Create;
begin
  inherited Create;
  if QueryPerformanceFrequency(FFrequency) then
  begin
    FCounting := False;
    FElapsedTime := 0;
  end;
end;

procedure TksCounter.Start;
begin
  FCounting := True;
  FElapsedTime := 0;
  QueryPerformanceCounter(FStart);
end;

function TksCounter.Stop: Single;
begin
  QueryPerformanceCounter(FStop);
  FCounting := False;
  FElapsedTime := (FStop - FStart) / FFrequency;
  Result := FElapsedTime;
end;

procedure StartCount(var Counter: TksCounter);
begin
  Counter := TksCounter.Create;
  Counter.Start;
end;

function StopCount(var Counter: TksCounter): Single;
begin
  Result := 0.0;
  if Counter <> nil then
  begin
    Result := Counter.Stop;
    Counter.Free;
    Counter := nil;
  end;
end;

end. 

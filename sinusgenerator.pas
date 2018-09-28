unit SinusGenerator;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs;

type
  
  { TSinusGenerator }

  TSinusGenerator = class(TComponent)
  private
    FAmplitude: Extended;
    FFrequency: Extended;
    FResolution: Extended;
    FTime: Extended;
    FValue: Extended;
    IsFirst: Boolean;
    procedure SetAmplitude(AValue: Extended);
    procedure SetFrequency(AValue: Extended);
  protected

  public
    constructor Create(AnOwner: TComponent); override;
    procedure First;
    procedure Next;
    property Time: Extended read FTime;
    property Value: Extended read FValue;
  published
    property Amplitude: Extended read FAmplitude write SetAmplitude;
    property Frequency: Extended read FFrequency write SetFrequency;
    property Resolution: Extended read FResolution write FResolution;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Computer',[TSinusGenerator]);
end;

{ TSinusGenerator }

procedure TSinusGenerator.SetAmplitude(AValue: Extended);
begin
  if FAmplitude=AValue then Exit;
  FAmplitude:=AValue;
  First
end;

procedure TSinusGenerator.SetFrequency(AValue: Extended);
begin
  if FFrequency=AValue then Exit;
  FFrequency:=AValue;
  First
end;

constructor TSinusGenerator.Create(AnOwner: TComponent);
begin
  inherited Create(AnOwner);
  First;
end;

procedure TSinusGenerator.First;
begin
  FTime := 0;
  FValue := 0;
  IsFirst := True;
end;

procedure TSinusGenerator.Next;
begin
  if IsFirst then begin
    FTime := 0;
    FValue := 0;
    IsFirst := False
  end
  else begin
    {FTime := FTime + Resolution;
    FValue := FValue - 2 * Pi * Frequency * FValue * Sqr(Resolution); }
  end;
end;

end.

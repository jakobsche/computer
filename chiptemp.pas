{
 /***************************************************************************
                                   chiptemp.pas
                                   ------------


 ***************************************************************************/

 *****************************************************************************
  This file is part of the Lazarus packages by Andreas Jakobsche

  See the file COPYING.modifiedLGPL.txt, included in this distribution,
  for details about the license.
 *****************************************************************************
}
unit ChipTemp;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

type

  TChipTempSensor = class;

  { TTripPoint }

  TTripPoint = class(TComponent)
  private
    FId: Integer;
    function GetSensor: TChipTempSensor;
    function GetTemperature: Extended;
    function GetType: string;
  public
    property Temperature: Extended read GetTemperature;
    property TPType: string read GetType;
    property Sensor: TChipTempSensor read GetSensor;
  published
    property Id: Integer read FId write FId;
  end;

  { TTripPointDescriptions }

  TTripPointDescriptions = class(TStrings)
  private
    FSensor: TChipTempSensor;
    property Sensor: TChipTempSensor read FSensor write FSensor;
  protected
    function Get(Index: Integer): string; override;
    function GetCount: Integer; override;
  end;

  { TChipTempSensor }

  TChipTempSensor = class(TComponent)
  private
    { Private declarations }
    FId: Integer;
    FTripPointDescriptions: TTripPointDescriptions;
    function GetBaseDir: string;
    function GetSensorType: string;
    function GetTemperature: Extended;
    function GetTripPointDescriptions: TStrings;
    function GetTripPoints(I: Integer): TTripPoint;
    procedure SetTripPointDescriptions(const AValue: TStrings);
    property BaseDir: string read GetBaseDir;
  protected
    { Protected declarations }
  public
    { Public declarations }
    destructor Destroy; override;
    property SensorType: string read GetSensorType;
    property Temperature: Extended read GetTemperature;
    property TripPointDescriptions: TStrings read GetTripPointDescriptions;
    property TripPoints[I: Integer]: TTripPoint read GetTripPoints;
  published
    { Published declarations }
    property Id: Integer read FId write FId;
  end;

  { TChipTempSensors }

  TChipTempSensors = class(TComponent)
  private
    FSensorList: TList;
    function GetSensorCount: Integer;
    function GetSensorList: TList;
    function GetSensors(I: Integer): TChipTempSensor;
    procedure Update;
    property SensorList: TList read GetSensorList;
  public
    destructor Destroy; override;
    property SensorCount: Integer read GetSensorCount;
    property Sensors[I: Integer]: TChipTempSensor read GetSensors;
  end;

procedure Register;

implementation

uses sysfs, Patch;

function GetChipTempSensorBaseDir(I: Integer; var Dir: string): Boolean;
begin
  Dir := Format('/sys/class/thermal/thermal_zone%d', [I]);
  Result := DirectoryExists(Dir)
end;

{ TChipTempSensors }

function TChipTempSensors.GetSensorList: TList;
begin
  if not Assigned(FSensorList) then FSensorList := TList.Create;
  Result := FSensorList
end;

function TChipTempSensors.GetSensorCount: Integer;
begin
  Update;
  Result := Sensorlist.Count
end;

function TChipTempSensors.GetSensors(I: Integer): TChipTempSensor;
begin
  Pointer(Result) := SensorList[I]
end;

procedure TChipTempSensors.Update;
var
  i: Integer;
  Sensor: TChipTempSensor;
  Dir: string;
begin
  i := 0;
  while i < SensorList.Count do
    if GetChipTempSensorBaseDir(i, Dir) then Inc(i)
    else begin
      TChipTempSensor(SensorList[i]).Free;
      SensorList.Delete(i)
    end;
  while GetChipTempSensorBaseDir(i, Dir) do begin
    Sensor := TChipTempSensor.Create(Self);
    Sensor.Id := i;
    SensorList.Add(Sensor);
    Inc(i)
  end;
end;

destructor TChipTempSensors.Destroy;
begin
  FSensorList.Free;
  inherited Destroy;
end;

{ TTripPointDescriptions }

function TTripPointDescriptions.Get(Index: Integer): string;
begin
  Result := Format('%s: %g °C', [Sensor.TripPoints[Index].TPType,
    Sensor.TripPoints[Index].Temperature])
end;

function TTripPointDescriptions.GetCount: Integer;
var
  x: Extended;
  i: Integer;
begin
  i := 0;
  repeat
    try
      x := Sensor.TripPoints[i].Temperature;
      Inc(i)
    except
      on Exception do begin
        Result := i;
        Exit
      end;
    end
  until False;
  Result := 0;
end;

{ TTripPoint }

function TTripPoint.GetSensor: TChipTempSensor;
begin
  Result := Owner as TChipTempSensor
end;

function TTripPoint.GetTemperature: Extended;
begin
  Result := GetIntAttribute(BuildFileName(Sensor.BaseDir,
    Format('trip_point_%d_temp', [FId]))) / 1000
end;

function TTripPoint.GetType: string;
begin
  Result := GetAttribute(BuildFileName(Sensor.BaseDir,
    Format('trip_point_%d_type', [FId])))
end;

function TChipTempSensor.GetBaseDir: string;
begin
  GetChipTempSensorBaseDir(FId, Result)
  {:= Format('/sys/class/thermal/thermal_zone%d', [FId])}
end;

function TChipTempSensor.GetSensorType: string;
begin
  Result := GetAttribute(BuildFileName(BaseDir, 'type'))
end;

function TChipTempSensor.GetTemperature: Extended;
begin
  Result := GetIntAttribute(BuildFileName(BaseDir, 'temp')) / 1000;
end;

function TChipTempSensor.GetTripPointDescriptions: TStrings;
begin
  if not Assigned(FTripPointDescriptions) then begin
    FTripPointDescriptions := TTripPointDescriptions.Create;
    FTripPointDescriptions.Sensor := Self
  end;
  Result := FTripPointDescriptions
end;

function TChipTempSensor.GetTripPoints(I: Integer): TTripPoint;
var
  j: Integer;
begin
  for j := 0 to ComponentCount - 1 do
    if Components[j] is TTripPoint then
      if (Components[j] as TTripPoint).Id = I then begin
        Result := Components[j] as TTripPoint;
        Exit
      end;
  Result := TTripPoint.Create(Self);
  Result.Id := I
end;

procedure TChipTempSensor.SetTripPointDescriptions(const AValue: TStrings);
begin
  AValue.Assign(GetTripPointdescriptions)
end;

destructor TChipTempSensor.Destroy;
begin
  FTripPointDescriptions.Free;
  inherited Destroy;
end;

procedure Register;
begin
  RegisterComponents('Hardware',[TChipTempSensor, TChipTempSensors]);
end;

end.

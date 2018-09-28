unit SerComm;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

type

  TAbstractSerialComm = class(TComponent)
  protected
    function GetPortSize: Word; virtual; abstract;
    property PortSize: Word read GetPortSize;
  end;

  { TUART }

  TUART = class(TAbstractSerialComm)
  private
    FBaseAddress: Word;
    function GetBaseAdress: Word;
    function GetData: Byte;
    procedure SetBaseAddress(AValue: Word);
    procedure SetData(AValue: Byte);
  private
    property BaseAddress: Word read GetBaseAdress write SetBaseAddress;
    property Data: Byte read GetData write SetData;
  protected
  public
  published
  end;

var
  SerialDeviceList: TStringList;

implementation

uses Ports;

{$IFDEF Linux}
  function ioperm(from: Cardinal; num: Cardinal; turn_on: Integer): Integer; cdecl; external 'libc';
{$ENDIF}

var
  R: TUniCodeSearchRec;

{ TUART }

function TUART.GetBaseAdress: Word;
begin
  Result := FBaseAddress
end;

function TUART.GetData: Byte;
begin
  Result := Port[BaseAddress]
end;

procedure TUART.SetBaseAddress(AValue: Word);
begin
  if FBaseAddress <> 0 then IOPerm(FBaseAddress, 8, 0);
  FBaseAddress := AValue;
  IOPerm(FBaseAddress, 8, 1)
end;

procedure TUART.SetData(AValue: Byte);
begin
  Port[BaseAddress] := AValue
end;

initialization

SerialDeviceList := TStringList.Create;
if FindFirst('/sys/class/tty/*', 0, R) = 0 then begin
    if (R.Name = '.') or (R.Name = '..') then
      while FindNext(R) = 0 do begin
        if (R.Name = '.') or (R.Name = '..') then Continue;
        if FileExists(Format('/sys/class/tty/%s/device/driver', [R.Name])) then
          if {Zugriff möglich?} True then SerialDeviceList.Add(R.Name);
      end;
    FindClose(R)
end;

end.


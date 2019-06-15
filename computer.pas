{ This file was automatically created by Lazarus. Do not edit!
  This source is only used to compile and install the package.
 }

unit computer;

interface

uses
  ChipTemp, SysFS, LEDView, Retain, SinusGenerator, LazarusPackageIntf;

implementation

procedure Register;
begin
  RegisterUnit('ChipTemp', @ChipTemp.Register);
  RegisterUnit('LEDView', @LEDView.Register);
  RegisterUnit('SinusGenerator', @SinusGenerator.Register);
end;

initialization
  RegisterPackage('computer', @Register);
end.

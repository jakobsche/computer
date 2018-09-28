{
 /***************************************************************************
                                   sysfs.pas
                                   ---------


 ***************************************************************************/

 *****************************************************************************
  This file is part of the Lazarus packages by Andreas Jakobsche

  See the file COPYING.modifiedLGPL.txt, included in this distribution,
  for details about the license.
 *****************************************************************************
}
unit SysFS;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils; 

function GetAttribute(AttributeFileName: string): string;

function GetBooleanAttribute(AttributeFileName: string): Boolean;

function GetIntAttribute(AttributeFileName: string): Longint;

procedure SetAttribute(AttributeFileName: string; Value: Longint); overload;

procedure SetAttribute(AttributeFileName: string; Value: string); overload;

procedure SetAttribute(AttributeFileName: string; Value: Boolean); overload;

type
  TGetIntFunc = function (AttrobuteFileName: string): Longint;

implementation

function GetIntAttribute(AttributeFileName: string): Longint;
var F: TextFile;
begin
  AssignFile(F, AttributeFileName);
  Reset(F);
  Read(F, Result);
  CloseFile(F)
end;

function GetAttribute(AttributeFileName: string): string;
var F: TextFile;
begin
  AssignFile(F, AttributeFileName);
  Reset(F);
  Read(F, Result);
  CloseFile(F)
end;

function GetBooleanAttribute(AttributeFileName: string): Boolean;
begin
  Result := GetIntAttribute(AttributeFileName) <> 0
end;

function GetAttribute(AttributeFileName: string): Boolean;
begin
  Result := GetBooleanAttribute(AttributeFileName)
end;

procedure SetAttribute(AttributeFileName: string; Value: Longint);
var F: TextFile;
begin
  AssignFile(F, AttributeFileName);
  Rewrite(F);
  Write(F, Value);
  CloseFile(F)
end;

procedure SetAttribute(AttributeFileName: string; Value: string);
var F: TextFile;
begin
  AssignFile(F, AttributeFileName);
  Rewrite(F);
  Write(F, Value);
  CloseFile(F)
end;

procedure SetAttribute(AttributeFileName: string; Value: Boolean);
begin
  if Value then SetAttribute(AttributeFilename, 1)
  else SetAttribute(AttributeFileName, 0)
end;

end.


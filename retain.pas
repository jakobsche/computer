{
 /***************************************************************************
                                   retain.pas
                                   ----------


 ***************************************************************************/

 *****************************************************************************
  This file is part of the Lazarus packages by Andreas Jakobsche

  See the file COPYING.modifiedLGPL.txt, included in this distribution,
  for details about the license.
 *****************************************************************************
}
unit Retain;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs;

type
  TRetainData = class(TComponent)
  private
    { Private declarations }
    FHasChanged: Boolean;
    {Stream: TFileStream;}
    function GetFileName: string;
    property FileName: string read GetFileName;
  protected
    { Protected declarations }
    procedure LoadFromFile; virtual;
    procedure SaveToFile; virtual;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    procedure BeforeDestruction; override;
    procedure Update; virtual;
    property HasChanged: Boolean read FHasChanged write FHasChanged;
  published
    { Published declarations }
  end;

procedure Register;

implementation

uses Patch, Streaming2;

function TRetainData.GetFileName: string;
var
  Dir: string;
begin
  Dir := BuildFileName(GetEnvironmentVariable('HOME'), '.config');
  ForceDirectories(Dir);
  Result := ChangeFileExt(BuildFileName(Dir, ExtractFileName(Application.ExeName)), '.db');
end;

type TTestException = class(Exception) end;

procedure TRetainData.LoadFromFile;
var S: TFileStream;
begin
  try
    S := TFileStream.Create(FileName, fmOpenRead);
    try
      ReadBinaryFromStream(S, TComponent(Self))
    finally
      S.Free
    end;
  except
    {on EAccessViolation do;}
    on Exception do raise;
  end;
end;

procedure TRetainData.SaveToFile;
var S: TFileStream;
begin
  S := TFileStream.Create(FileName, fmCreate);
  try
    WriteBinaryToStream(S, Self);
    HasChanged := False
  finally
    S.Free
  end;
end;

constructor TRetainData.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  if FileExists(FileName) then LoadFromFile
  else Update;
end;

procedure TRetainData.BeforeDestruction;
begin
  if HasChanged then SaveToFile;
  inherited
end;

procedure TRetainData.Update;
begin

end;

procedure Register;
begin
  RegisterComponents('Hardware',[TRetainData]);
end;

initialization

RegisterForStreaming(TRetainData);

end.

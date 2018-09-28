{
 /***************************************************************************
                                   ledview.pas
                                   -----------


 ***************************************************************************/

 *****************************************************************************
  This file is part of the Lazarus packages by Andreas Jakobsche

  See the file COPYING.modifiedLGPL.txt, included in this distribution,
  for details about the license.
 *****************************************************************************
}
unit LEDView;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, ExtCtrls, StdCtrls, Controls, Graphics, Dialogs;

type

  TLabelPosition = (lpLeft, lpRight);

  { TLEDView }

  TLEDView = class(TWinControl)
  private
    FLEDShape: TShape;
    function GetLEDShape: TShape;
  private
    FLabelPosition: TLabelPosition;
    { Private declarations }
    FLEDLabel: TLabel;
    FLEDOffColor, FLEDOnColor: TColor;
    FValue: Boolean;
    function GetCaption: string;
    procedure SetCaption(Value: string);
    function GetLEDLabel: TLabel;
    procedure SetLabelPosition(AValue: TLabelPosition);
    procedure SetValue(AValue: Boolean);
    property LEDShape: TShape read GetLEDShape;
    property LEDLabel: TLabel read GetLEDLabel;
  protected
    { Protected declarations }
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
  published
    { Published declarations }
    property Caption: string read GetCaption write SetCaption;
    property LEDOffColor: TColor read FLEDOffColor write FLEDOffColor;
    property LEDOnColor: TColor read FLEDOnColor write FLEDOnColor;
    property LabelPosition: TLabelPosition read FLabelPosition write SetLabelPosition;
    property Value: Boolean read FValue write SetValue;
  end;

procedure Register;

implementation

function TLEDView.GetLEDShape: TShape;
begin
  if not Assigned(FLEDShape) then begin
    FLEDShape := TShape.Create(Self);
    FLEDShape.Parent := Self;
    FLEDShape.Align := alRight;
  end;
end;

function TLEDView.GetCaption: string;
begin
  Result := LEDLabel.Caption
end;

procedure TLEDView.SetCaption(Value: string);
begin
  LEDLabel.Caption := Value
end;

function TLEDView.GetLEDLabel: TLabel;
begin
  if not Assigned(FLEDLabel) then begin
    FLEDLabel := TLabel.Create(Self);
    FLEDLabel.Parent := Self;
    with FLEDLabel do begin
      Left := 0;
      Top := 0;
    end;
  end;
  Result := FLEDLabel
end;

procedure TLEDView.SetLabelPosition(AValue: TLabelPosition);
begin
  if FLabelPosition=AValue then Exit;
  FLabelPosition:=AValue;
end;

procedure TLEDView.SetValue(AValue: Boolean);
begin
  if FValue=AValue then Exit;
  FValue:=AValue;
end;

constructor TLEDView.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Caption := Name;
  LEDOffColor := clBlack;
  LEDOnColor := clGreen;
  Width :=  32;
  Height := 32
end;

procedure Register;
begin
  RegisterComponents('Hardware',[TLEDView]);
end;

end.

unit SalesFunnel;

{$mode objfpc}{$H+}

interface

uses
  ComponentManagerUnit,
  IniFiles, Classes, SysUtils, FileUtil, TAGraph, TASeries, TAChartUtils, Forms,
  Controls, Graphics, Dialogs;

type

  { TForm3 }

  TForm3 = class(TForm)
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  Form3: TForm3;
  ComponentManager: TComponentManager;

implementation

{$R *.lfm}

{ TForm3 }

procedure TForm3.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  ComponentManager:=TComponentManager.Create();
  ComponentManager.CloseEverything(self);
end;

procedure TForm3.FormCreate(Sender: TObject);
begin
  ComponentManager:=TComponentManager.Create();
  ComponentManager.PutEverything(self);
end;

end.


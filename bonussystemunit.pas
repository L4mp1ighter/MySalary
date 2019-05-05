unit BonusSystemUnit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Grids;

type

  { TBonusSystem }

  TBonusSystem = class(TForm)
    StringGrid1: TStringGrid;
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  BonusSystem: TBonusSystem;

implementation

{$R *.lfm}

end.


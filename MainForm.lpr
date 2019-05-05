program MainForm;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, tachartlazaruspkg, MainFormUnit, PaymentsUnit, ComponentManagerUnit,
  SalesFunnel, BonusSystemUnit, ConsultationsUnit, SettingsUnit
  { you can add units after this };

{$R *.res}

begin
  RequireDerivedFormResource:=True;
  Application.Initialize;
  Application.CreateForm(TMyEFSalary, MyEFSalary);
  Application.Run;
end.


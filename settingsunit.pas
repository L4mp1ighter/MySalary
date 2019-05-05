unit SettingsUnit;

{$mode objfpc}{$H+}

interface

uses
  IniFiles, Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls;

type

  { TSettings }

  TSettings = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  Settings: TSettings;
  Ini: TIniFile;

implementation

{$R *.lfm}

{ TSettings }

procedure TSettings.Button1Click(Sender: TObject);
var NST: Integer;
var NRT, GrSl: Real;
begin
  Ini:=TIniFile.Create('D:\MyEFSalary\res.ini');
  //Считываем необходимые для расчёта значения из .ini-файла
  GrSl:=Ini.ReadFloat('MAINFORM', 'GrSl', 0);
  NRT:=Ini.ReadFloat('MAINFORM', 'NRT', 0);
  NST:=Ini.ReadInteger('MAINFORM', 'NST', 0);
  //Записываем в файл новые значения
  if(Edit1.Text<>'0') then Ini.WriteFloat('MAINFORM', 'NRT', StrToFloat(Edit1.Text));
  if(Edit2.Text<>'0') then Ini.WriteInteger('MAINFORM', 'NST', StrToInt(Edit2.Text));
  if(Edit3.Text<>'0') then Ini.WriteFloat('MAINFORM', 'GrSl', StrToFloat(Edit3.Text));
end;

procedure TSettings.Button2Click(Sender: TObject);
var NRT, AmM, RefM: Real;
var Cons, NST, AmS, RefS, KPI, PLST, PLM, Month: Integer;
begin
  Ini:=TIniFile.Create('D:\MyEFSalary\res.ini');
  //Считываем необходимые для расчёта значения из .ini-файла
  Cons:=Ini.ReadInteger('MAINFORM', 'Cons', 0);
  AmM:=Ini.ReadFloat('MAINFORM', 'AmM', 0);
  NRT:=Ini.ReadFloat('MAINFORM', 'NRT', 0);
  RefM:=Ini.ReadFloat('MAINFORM', 'RefM', 0);
  NST:=Ini.ReadInteger('MAINFORM', 'NST', 0);
  AmS:=Ini.ReadInteger('MAINFORM', 'AmS', 0);
  RefS:=Ini.ReadInteger('MAINFORM', 'RefS', 0);
  //Производим статистические расчёты
  KPI:=Round(Cons*100/(AmS-RefS));
  PLST:=Round((AmS-RefS)*100/NST);
  PLM:=Round((AmM-RefM)*100/NRT);
  //Пишем новые значения в файл
  Month:=Ini.ReadInteger('STAT', 'MOUNTH', 0);
  Ini.WriteInteger('STAT', 'MOUNTH', Month+1);
  Ini.WriteInteger('KPI', 'KPI'+IntToStr(Month), KPI);
  Ini.WriteInteger('PLANSTUD', 'PLST'+IntToStr(Month), PLST);
  Ini.WriteInteger('PLANMON', 'PLM'+IntToStr(Month), PLM);
end;

end.


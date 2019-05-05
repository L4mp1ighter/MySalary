unit ConsultationsUnit;

{$mode objfpc}{$H+}

interface

uses
  IniFiles, Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls;

type

  { TConsultations }

  TConsultations = class(TForm)
    Button1: TButton;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    procedure Button1Click(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  Consultations: TConsultations;
  Ini: TIniFile;

implementation

{$R *.lfm}

{ TConsultations }

procedure TConsultations.Button1Click(Sender: TObject);
var Cons, int1, int2: Integer;
var ExtraH, r1, r2: Real;
begin
  //Считываем из файла Cons и ExtraH
  Ini:=TIniFile.Create('D:\MyEFSalary\res.ini');
  Cons:=Ini.ReadInteger('MAINFORM', 'Cons', 0);
  ExtraH:=Ini.ReadFloat('MAINFORM', 'ExtraH', 0);
  //Считывание значений
  int1:=StrToInt(Edit1.Text);
  r1:=StrToFloat(Edit2.Text);
  int2:=StrToInt(Edit3.Text);
  r2:=StrToFloat(Edit4.Text);
  //Запись в файл
  Ini.WriteInteger('MAINFORM', 'Cons', Cons+int1-int2);
  Ini.WriteFloat('MAINFORM', 'ExtraH', ExtraH+r1-r2);
end;

end.


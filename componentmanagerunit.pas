unit ComponentManagerUnit;

{$mode objfpc}{$H+}

interface

uses
  IniFiles, PaymentsUnit,
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, TAGraph, TASeries, TAChartUtils, StdCtrls;

type

  { TComponentManager }

  TComponentManager = class(TObject)
     Label1: TLabel;
     Label2: TLabel;
     KPI, PLST:array of Integer;
     PLM:array of Real;
     Mas:array of TChart;
     MasBars:array of TBarSeries;
     procedure ReadFileINI();
     procedure PutEverything(Put: TForm);
     procedure CloseEverything(Put: TForm);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  IniFile: TIniFile;

implementation

procedure TComponentManager.ReadFileINI();
var i, HM: Integer;
begin
  IniFile:=TIniFile.Create('D:\MyEFSalary\res.ini');
  HM:=IniFile.ReadInteger('STAT', 'MOUNTH', 0);
  SetLength(KPI, HM);
  SetLength(PLM, HM);
  SetLength(PLST, HM);//Выделяем память
  for i:=0 to HM-1 do begin//В цикле считываем данные в массивы
    KPI[i]:=IniFile.ReadInteger('KPI','KPI'+IntToStr(i+1),0);
    PLM[i]:=IniFile.ReadFloat('PLANMON','PLM'+IntToStr(i+1),0);
    PLST[i]:=IniFile.ReadInteger('PLANSTUD','PLST'+IntToStr(i+1),0);
  end;
end;

procedure TComponentManager.CloseEverything(Put: TForm);
begin
  //Освобождаем массив
  Mas:=nil;
  MasBars:=nil;
  KPI:=nil;
  PLM:=nil;
  PLST:=nil;
end;

procedure TComponentManager.PutEverything(Put: TForm); //"Рисуем" всю форму
var i, x, HM: Integer;
begin
  //Всё для постройки Bar-ов
  ReadFileINI();
  //Считываем количество месяцев, с которыми мы работаем
  IniFile:=TIniFile.Create('D:\MyEFSalary\res.ini');
  HM:=IniFile.ReadInteger('STAT', 'MOUNTH', 0);
  if (HM<3) Or (HM=3) then x:=3 else x:=6;
  SetLength(Mas, x);
  SetLength(MasBars, x);//Выделяем память
  //Располагаем графики и Label
  //Задаём расположение TLabel
  Label1:=Tlabel.Create(Put);
  Label1.Caption:='Last 3 months';
  Label1.Top:=8;
  if (HM<3) Or (HM=3) then Label1.Left:=320;
  if (HM>3) then begin
    Label1.Left:=136;
    //Label2
    Label2:=Tlabel.Create(Put);
    Label2.Caption:='Last 6 months';
    Label2.Top:=8;
    Label2.Left:=516;
    Label2.Parent:=Put;
    Label2.Show;
  end;
  Label1.Parent:=Put;
  Label1.Show;
  //Задаём расположение TChart-ов для 3-ёх месяцев
  for i:=0 to 2 do begin
    Mas[i]:=TChart.Create(Put);
    MasBars[i]:=TBarSeries.Create(Mas[i]);
    MasBars[i].Marks.Style := TSeriesMarksStyle(smsValue); //или smsLabelValue
    MasBars[i].Marks.Distance:= 5;
    Mas[i].Left:=24;
    if (HM<3) Or (HM=3) then Mas[i].Width:=645;
  end;
  Mas[0].Top:=32;
  Mas[0].Title.Text.Strings[0]:='KPI';
  Mas[0].Title.Visible := true;
  Mas[1].Top:=232;
  Mas[1].Title.Text.Strings[0]:='Net Revenue';
  Mas[1].Title.Visible := true;
  Mas[2].Top:=432;
  Mas[2].Title.Text.Strings[0]:='Net New Student';
  Mas[2].Title.Visible := true;
  //Рисуем графики на первых трёх TChart-ах
  //Первый график
  if (HM<3) Or (HM=3) then x:=0; //Начинаем отсчёт от нулевого элемента
  if (HM>3) And (HM<6) then x:= HM-3;
  if (HM>6) Or (HM=6) then x:= HM-3;
  for i:=x to HM-1 do begin
    MasBars[0].AddXY(i, KPI[i], IntToStr(i+1), clRed);
    Mas[0].AddSeries(MasBars[0]);
    Mas[0].AxisList.BottomAxis.Marks.Source := MasBars[0].Source;
    Mas[0].AxisList.BottomAxis.Marks.Style := smsLabel;
  end;
  //Второй график
  for i:=x to HM-1 do begin
    MasBars[1].AddXY(i, PLST[i], IntToStr(i+1), clBlue);
    Mas[1].AddSeries(MasBars[1]);
    Mas[1].AxisList.BottomAxis.Marks.Source := MasBars[1].Source;
    Mas[1].AxisList.BottomAxis.Marks.Style := smsLabel;
  end;
  //Третий график
  for i:=x to HM-1 do begin
    MasBars[2].AddXY(i, PLM[i], IntToStr(i+1), clGreen);
    Mas[2].AddSeries(MasBars[2]);
    Mas[2].AxisList.BottomAxis.Marks.Source := MasBars[2].Source;
    Mas[2].AxisList.BottomAxis.Marks.Style := smsLabel;
  end;
  //Рисуем
  for i:=0 to 2 do begin
    Mas[i].Parent:=Put;
    Mas[i].Show;
  end;
  //
  if HM>3 then begin //Если будут все 6 TChart-ов - "рисуем" второй столбик
     for i:=3 to 5 do begin
        Mas[i]:=TChart.Create(Put);
        MasBars[i]:=TBarSeries.Create(Mas[i]);
        MasBars[i].Marks.Style := TSeriesMarksStyle(smsValue); //или smsLabelValue
        MasBars[i].Marks.Distance:= 5;
        Mas[i].Left:=384;
     end;
     Mas[3].Top:=32;
     Mas[4].Top:=232;
     Mas[5].Top:=432;
     for i:=3 to 5 do begin
       Mas[i].Parent:=Put;
       Mas[i].Show;
     end;
     //Теперь нарисуем графики во втором столбике
     //Четвёртый график
     if (HM>3) And (HM<6) then x:= 0;
     if (HM>6) Or (HM=6) then x:= HM-6;
     for i:=x to HM-1 do begin
       MasBars[3].AddXY(i, KPI[i], IntToStr(i+1), clRed);
       Mas[3].AddSeries(MasBars[3]);
       Mas[3].AxisList.BottomAxis.Marks.Source := MasBars[3].Source;
       Mas[3].AxisList.BottomAxis.Marks.Style := smsLabel;
     end;
     //Пятый график
     for i:=x to HM-1 do begin
       MasBars[4].AddXY(i, PLST[i], IntToStr(i+1), clBlue);
       Mas[4].AddSeries(MasBars[4]);
       Mas[4].AxisList.BottomAxis.Marks.Source := MasBars[4].Source;
       Mas[4].AxisList.BottomAxis.Marks.Style := smsLabel;
     end;
     //Шестой график
     for i:=x to HM-1 do begin
       MasBars[5].AddXY(i, PLM[i], IntToStr(i+1), clGreen);
       Mas[5].AddSeries(MasBars[5]);
       Mas[5].AxisList.BottomAxis.Marks.Source := MasBars[5].Source;
       Mas[5].AxisList.BottomAxis.Marks.Style := smsLabel;
     end;
     //Рисуем
     for i:=3 to 5 do begin
       Mas[i].Parent:=Put;
       Mas[i].Show;
     end;
     //
  end;
end;

end.


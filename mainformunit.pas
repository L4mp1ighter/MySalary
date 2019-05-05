unit MainFormUnit;

{$mode objfpc}{$H+}

interface

uses
  SettingsUnit, ConsultationsUnit, PaymentsUnit, SalesFunnel, BonusSystemUnit, IniFiles, Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs,
  StdCtrls, ComCtrls, Grids, ExtCtrls, Math, BGRAGraphicControl, BGRABitmap, BCTypes,  TAGraph, TASeries, TAChartUtils;

type

  { TMyEFSalary }

  TMyEFSalary = class(TForm)
    BGRAGraphicControl1: TBGRAGraphicControl;
    BGRAGraphicControl2: TBGRAGraphicControl;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    GroupBox3: TGroupBox;
    GroupBox4: TGroupBox;
    GroupBox5: TGroupBox;
    Image1: TImage;
    Image2: TImage;
    //LABEL ВСЕ ДЕЛАЕМ ЭЛЕМЕНТАМИ МАССИВА!!!
    Label1: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Label2: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    Label22: TLabel;
    Label23: TLabel;
    Label24: TLabel;
    Label25: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    StringGrid1: TStringGrid;
    StringGrid2: TStringGrid;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure mainform(Sender: TObject);
    procedure CellColorText(StringGridX: TStringGrid; ACol, ARow: Integer;
    Rect: TRect; State: TGridDrawState);
    procedure BGRAGraphicControl1Redraw(Sender: TObject; Bitmap: TBGRABitmap);
    procedure BGRAGraphicControl2Redraw(Sender: TObject; Bitmap: TBGRABitmap);
    procedure ShowLabelCaption(LabelX: TLabel; Cifra: Real);
    procedure ShowStringCells(StringGridX: TStringGrid; ACol, ARow: Integer;
    Cifra: Real);
    procedure CountAndShowButton(PerConsNSX, PerConsNRX, AmMX, AmSX, AvChX: Real);
    procedure GetINI();
    procedure DrawGridsInfo();
    procedure DrawRoundStatInfo(PerConsNSX, PerConsNRX: Real);
    procedure Refresh();
    function SetAngle(ProcX: Real): Integer;
  private
    { private declarations }
  public
    { public declarations }


  end;

var
  MyEFSalary: TMyEFSalary;
  Ini: TIniFile;
  Check, Check1, Check2 : Boolean;
  Num: Real;
  NRT, ExtraH, AmM, RefM, PNR, PerConsNR, NRt1, GrSl, PrS, PrM, help: Real;
  NST, Cons, AmS, RefS, PNS, PerConsNS, NSt1, AvCh, ProcNS, ProcNR: Integer;
  Rect : TRect;
  State: TGridDrawState;

implementation

{$R *.lfm}

{ TMyEFSalary }

procedure TMyEFSalary.mainform(Sender: TObject);
begin
  Refresh();
end;

procedure TMyEFSalary.Refresh();
begin
  //Считываем данные из INI-файла (ПЕРЕДЕЛАТЬ НА БД!!!)
  GetINI();
  Button1.Caption:='With expected payments';
  Check2:=False; //Вывод данных БЕЗ expected payments
  DrawGridsInfo();
  //Заполняем All about this mounth
  //Выводим часы переработки - их мы не пересчитываем
  ShowLabelCaption(Label14, ExtraH);
  CountAndShowButton(PerConsNS, PerConsNR, AmM, AmS, AvCh);
  //
end;

procedure TMyEFSalary.Button1Click(Sender: TObject);
var PerConsNSX, PerConsNRX, AmMX, AmSX, AvChX: Real;
begin
  if(Check2) then begin
    Check2:=False;
    CountAndShowButton(PerConsNS, PerConsNR, AmM, AmS, AvCh);
    Button1.Caption:='With expected payments';
  end else begin
    PerConsNSX:=PerConsNS+PNS;
    PerConsNRX:=PerConsNR+PNR;
    AmMX:=AmM+PNR;
    AmSX:=AmS+PNS;
    AvChX:=Round((AmM+PNR)/(AmS+PNS));
    CountAndShowButton(PerConsNSX, PerConsNRX, AmMX, AmSX, AvChX);
    Button1.Caption:='Without expected payments';
    Check2:=True;
  end;
end;

procedure TMyEFSalary.Button2Click(Sender: TObject);
var Consultations: TConsultations;
begin
  Consultations:=TConsultations.Create(Self);
  Consultations.Show;
end;

procedure TMyEFSalary.Button3Click(Sender: TObject);
var Form2:TForm2;
begin
  Form2:=TForm2.Create(Self);
  Form2.Show;
end;

procedure TMyEFSalary.Button4Click(Sender: TObject);
var Settings: TSettings;
begin
   Settings:=TSettings.Create(Self);
   Settings.Show;
end;

procedure TMyEFSalary.Button5Click(Sender: TObject);
var BonusSystem: TBonusSystem;
begin
  BonusSystem:=TBonusSystem.Create(Self);
  BonusSystem.Show;
end;

procedure TMyEFSalary.Button6Click(Sender: TObject);
var Form3:TForm3;
begin
  Form3:=TForm3.Create(Self);
  Form3.Show;
end;

procedure TMyEFSalary.Button7Click(Sender: TObject);
begin
  Refresh();
end;

procedure TMyEFSalary.GetINI();
begin
  Ini:=TIniFile.Create('D:\MyEFSalary\res.ini');
  //Считываем необходимые для расчёта значения из .ini-файла
  GrSl:=Ini.ReadFloat('MAINFORM', 'GrSl', 0);
  NRT:=Ini.ReadFloat('MAINFORM', 'NRT', 0);
  ExtraH:=Ini.ReadFloat('MAINFORM', 'ExtraH', 0);
  AmM:=Ini.ReadFloat('MAINFORM', 'AmM', 0);
  RefM:=Ini.ReadFloat('MAINFORM', 'RefM', 0);
  PNR:=Ini.ReadFloat('MAINFORM', 'PNR', 0);
  NST:=Ini.ReadInteger('MAINFORM', 'NST', 0);
  Cons:=Ini.ReadInteger('MAINFORM', 'Cons', 0);
  AmS:=Ini.ReadInteger('MAINFORM', 'AmS', 0);
  RefS:=Ini.ReadInteger('MAINFORM', 'RefS', 0);
  PNS:=Ini.ReadInteger('MAINFORM', 'PNS', 0);
  //Расчёт данных по консультанту
  PerConsNR:=AmM-RefM;
  PerConsNS:=AmS-RefS;
  if (AmS=0) then AvCh:=-1 else AvCh:=Round(AmM/AmS);
  NRt1:=NRT/2;
  NSt1:=Ceil(NST/2);
end;

procedure TMyEFSalary.DrawGridsInfo();
begin
  Check:=False;
  Check1:=False;
  //Заполняем StringGrid1 - Net Revenue
  //Столбец1
  StringGrid1.Cells[0,1]:='Threshold';
  StringGrid1.Cells[0,2]:='Target';
  //Столбец2
  ShowStringCells(StringGrid1, 1, 1, NRt1);
  ShowStringCells(StringGrid1, 1, 2, NRT);
  //Столбец3
  help:=NRt1-PerConsNR;
  if(help<=0) then begin
    StringGrid1.Cells[2,1]:='Done';
  end
  else ShowStringCells(StringGrid1, 2, 1, help);
  //
  help:=NRT-PerConsNR;
  if(help<0) then begin
    StringGrid1.Cells[2,2]:=FloatToStrF(-NRT+PerConsNR, ffNumber, 7,0) + ' more';
    Check:=True;
    Num:=(PerConsNR-NRT)/100000;
  end;
  if(help=0) then begin
    StringGrid1.Cells[2,2]:='Done';
  end;
  if(help>0) then ShowStringCells(StringGrid1, 2, 2, help);
  //Столбец4
  if(AvCh=-1) then StringGrid1.Cells[3,1]:='-' else begin
    help:=(NRt1-PerConsNR)/AvCh;
  if(help<=0) then begin
    StringGrid1.Cells[3,1]:='Done';
  end
  else StringGrid1.Cells[3,1]:=FloatToStrF(Ceil((NRt1-PerConsNR)/AvCh), ffNumber, 7, 0);
  end;
  //
  if(AvCh=-1) then StringGrid1.Cells[3,2]:='-' else begin
    help:=(NRT-PerConsNR)/AvCh;
    if(help<=0) then begin
      StringGrid1.Cells[3,2]:='Done';
    end
    else StringGrid1.Cells[3,2]:=FloatToStr(Ceil((NRT-PerConsNR)/AvCh));
  end;
  //Столбец5
  help:=NRt1-PerConsNR-PNR;
  if(help<=0) then begin
    StringGrid1.Cells[4,1]:='Done';
  end
  else ShowStringCells(StringGrid1, 4, 1, help);
  //
  help:=NRT-PerConsNR-PNR;
  if(help<0) then begin
    StringGrid1.Cells[4,2]:=FloatToStrF(-NRT+PerConsNR+PNR, ffNumber, 7,0) + ' more';
    Check:=True;
    Num:=(PerConsNR-NRT)/100000;
  end;
  if (help=0) then StringGrid1.Cells[4,2]:='Done';
  if(help>0) then begin
    Check:=False;
    ShowStringCells(StringGrid1, 4, 2, help);
  end;
  Check:=False;
  //Заполняем StringGrid2 - Net New Students
  //Столбец1
  StringGrid2.Cells[0,1]:='Threshold';
  StringGrid2.Cells[0,2]:='Target';
  //Столбец2
  StringGrid2.Cells[1,1]:=IntToStr(NSt1);
  StringGrid2.Cells[1,2]:=IntToStr(NST);
  //Столбец3
  help:=NSt1-PerConsNS;
  if(help<=0) then begin
    StringGrid2.Cells[2,1]:='Done';
  end else StringGrid2.Cells[2,1]:=FloatToStr(help);
  //
  help:=NST-PerConsNS;
  if(help<0) then begin
    StringGrid2.Cells[2,2]:=IntToStr(PerConsNS-NST)+' more';
    Check1:=True;
  end;
  if(help=0) then begin
    StringGrid2.Cells[2,2]:='Done';
  end;
  if(help>0) then begin
    Check1:=False;
    StringGrid2.Cells[2,2]:=FloatToStr(help);
  end;
  //Столбец4
  help:=NSt1-PerConsNS-PNS;
  if(help<=0) then begin
    StringGrid2.Cells[3,1]:='Done';
  end else StringGrid2.Cells[3,1]:=FloatToStr(help);
  //
  help:=NST-PerConsNS-PNS;
  if(help<0) then begin
    StringGrid2.Cells[3,2]:=IntToStr(PerConsNS-NST+PNS)+' more';
    Check1:=True;
    Num:=help;
  end;
  if(help=0) then begin
    StringGrid2.Cells[3,2]:='Done';
  end;
  if(help>0) then begin
    Check1:=False;
    StringGrid2.Cells[3,2]:=FloatToStr(help);
  end;
end;

procedure TMyEFSalary.CountAndShowButton(PerConsNSX, PerConsNRX, AmMX, AmSX, AvChX: Real);
begin
  //Заполняем All about this mounth
  //Расчёт гросс премии по студентам (без запланированных оплат)
  if(PerConsNSX<NSt1) then PrS:=0;
  if(PerConsNSX=Nst1) then PrS:=PerConsNSX*750;
  if(PerConsNSX>NSt1) And (PerConsNSX<NST) then PrS:=Nst1*750+(PerConsNSX-Nst1)*1500;
  if(PerConsNSX=NST) then PrS:=NSt1*750+NSt1*1500;
  if(PerConsNSX>NST) then PrS:=NSt1*750+NSt1*1500+(PerConsNSX-NST)*2000;
  //Расчёт гросс премии по деньгам (без запланированных оплат)
  if(PerConsNRX<NRt1) then PrM:=0;
  if(PerConsNRX=NRt1) then PrM:=AmM*0.01;
  if(PerConsNRX>=NRt1) And (PerConsNRX<NRT) then PrM:=NRt1*0.01+(PerConsNRX-NRt1)*0.02;
  if(PerConsNRX=NRT) then PrM:=NRt1*0.01+NRt1*0.02;
  if(PerConsNRX>NRT) then PrM:=NRt1*0.01+NRt1*0.02+(PerConsNRX-NRT)*0.03;
  //Вывод гросс премии по деньгам и студентам
  ShowLabelCaption(Label13, PrM+PrS);
  //Вывод зарплаты с вычетом налога
  ShowLabelCaption(Label8,(PrM+PrS+GrSl)*0.87);
  //Вывод суммы по SF
  ShowLabelCaption(Label9, AmMX);
  //Вывод KPI
  Label10.Caption:=FloatToStrF(Round((AmSX-RefS)*100/Cons), ffNumber, 4, 0)+'%';
  //Вывод среднего чека
  ShowLabelCaption(Label11, AvChX);
  //Вывод налога
  ShowLabelCaption(Label12, (PrM+PrS+GrSl)*0.13);
  //Прорисовываем графики
  Label16.Font.Color:=clRed;
  ShowLabelCaption(Label16, NRt1);
  Label17.Font.Color:=clRed;
  Label17.Caption:=FloatToStr(Ceil(NSt1));
  Label18.Font.Color:=clGreen;
  ShowLabelCaption(Label18, NRT*0.8);
  Label19.Font.Color:=clGreen;
  Label19.Caption:=FloatToStr(Ceil(NST*0.8));
  DrawRoundStatInfo(PerConsNSX, PerConsNRX);
end;

procedure TMyEFSalary.DrawRoundStatInfo(PerConsNSX, PerConsNRX: Real);
begin
  //Считаем проценты
  ProcNR:=Floor(PerConsNRX*100/NRT);
  ProcNS:=Floor(PerConsNSX*100/NST);
  //Выводим данные
  Label24.Caption:=FloatToStr(ProcNR)+'%';
  Label25.Caption:=FloatToStr(ProcNS)+'%';
  //Просчитываем угол поворота изображения
  ProcNR:=SetAngle(ProcNR);
  ProcNS:=SetAngle(ProcNS);
  //
end;

procedure TMyEFSalary.CellColorText(StringGridX: TStringGrid; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
begin
  if (StringGridX.Cells[ACol,ARow] = 'Done') then begin
    StringGridX.Canvas.Brush.Color := clWhite;
    StringGridX.Canvas.FillRect(Rect);
    StringGridX.Canvas.Font.Color:=clGreen;
    StringGridX.Canvas.TextOut(Rect.Left+50, Rect.Top+3, StringGridX.Cells[ACol, ARow]);
  end;
  if (Check) And (((ACol = 2) And (ARow = 2)) Or ((ACol = 4) and (ARow = 2))) then begin
    StringGridX.Canvas.Brush.Color := clWhite;
    StringGridX.Canvas.FillRect(Rect);
    StringGridX.Canvas.Font.Color:=clGreen;
    if (Num>1) then Num:=35 else Num:=50;
    StringGridX.Canvas.TextOut(Rect.Left+Trunc(Num), Rect.Top+3, StringGridX.Cells[ACol, ARow]);
  end;
  if (Check1) And (((ACol = 2) And (ARow = 2)) Or ((ACol = 3) and (ARow = 2))) then begin
    StringGridX.Canvas.Brush.Color := clWhite;
    StringGridX.Canvas.FillRect(Rect);
    StringGridX.Canvas.Font.Color:=clGreen;
    if(Num>9) then Num:=35 else Num:=75;
    StringGridX.Canvas.TextOut(Rect.Left+Trunc(Num), Rect.Top+3, StringGridX.Cells[ACol, ARow]);
  end;
end;

procedure TMyEFSalary.BGRAGraphicControl2Redraw(Sender: TObject; Bitmap: TBGRABitmap);
var bmp: TBGRABitmap;
begin
  bmp := TBGRABitmap.Create('D:\MyEFSalary\line.png');
  Bitmap.PutImageAngle(Bitmap.Width/2-0.5,Bitmap.Height*0.8,bmp,ProcNS,bmp.Width/2-0.5,bmp.Height*0.8);
end;

procedure TMyEFSalary.BGRAGraphicControl1Redraw(Sender: TObject; Bitmap: TBGRABitmap);
var bmp: TBGRABitmap;
begin
  bmp := TBGRABitmap.Create('D:\MyEFSalary\line.png');
  Bitmap.PutImageAngle(Bitmap.Width/2-0.5,Bitmap.Height*0.8,bmp,ProcNR,bmp.Width/2-0.5,bmp.Height*0.8);
end;

function TMyEFSalary.SetAngle(ProcX: Real): Integer;
begin
  if(ProcX<0) then ProcX:=-105;
  if(ProcX>0) And (ProcX<50) then ProcX:=-90+(ProcX)*1.6;
  if(ProcX=50) then ProcX:=-1;
  if(ProcX>50) And (ProcX<100) then ProcX:=-1+(ProcX-50)*1.8;
  if(ProcX=100) then ProcX:=90;
  if(ProcX>100) then ProcX:=102;
  SetAngle:=Round(ProcX);
end;

procedure TMyEFSalary.ShowLabelCaption(LabelX: TLabel; Cifra: Real);
var FracCifra: Real;
begin
  FracCifra:=frac(Cifra);
  if(FracCifra>0) then LabelX.Caption:=FloatToStrF(Cifra, ffNumber, 7, 2)
  else LabelX.Caption:=FloatToStrF(Cifra, ffNumber, 7, 0);
end;

procedure TMyEFSalary.ShowStringCells(StringGridX: TStringGrid; ACol, ARow: Integer;
Cifra: Real);
var FracCifra: Real;
begin
  FracCifra:=frac(Cifra);
  if (FracCifra>0) then StringGridX.Cells[ACol,ARow]:=FloatToStrF(Cifra, ffNumber, 7, 2)
  else StringGridX.Cells[ACol,ARow]:=FloatToStrF(Cifra, ffNumber, 7, 0);
end;

end.


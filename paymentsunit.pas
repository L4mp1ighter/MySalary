unit PaymentsUnit;

{$mode objfpc}{$H+}

interface

uses
  IniFiles, Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls, Grids, Buttons;

type

  { TForm2 }

  TForm2 = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Button1: TButton;
    Label1: TLabel;
    Label2: TLabel;
    StringGrid1: TStringGrid;
    StringGrid2: TStringGrid;
    procedure Button1Click(Sender: TObject);
    procedure RedrawTable(StringGridX: TStringGrid; k, ARowZ: Integer);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure payments(Sender: TObject);
    procedure SetColor(StringGridX: TStringGrid; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
    procedure ReadINI();
    procedure StringGrid1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure StringGrid2MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    function INeedYourAmount(StringGridX: TStringGrid; ACol, ARow: Integer): String;
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  Form2: TForm2;
  IniFile: TIniFile;
  AllPay, AllWillPay, Refund, AColX, ARowX, ARowY: Integer;
  Rect : TRect;
  State: TGridDrawState;

implementation

{$R *.lfm}

{TForm2}

procedure TForm2.payments(Sender: TObject);
begin
  ReadINI();
end;

procedure TForm2.RedrawTable(StringGridX: TStringGrid; k, ARowZ: Integer);
var i, j, z: Integer;
begin
  z:=ARowZ;
  for i:=ARowZ to 39 do begin
    if (StringGridX.Cells[0,i]='') then begin
      z:=ARowZ;
   end else begin
    for j:=0 to k-1 do begin
      StringGridX.Cells[j,z]:=StringGridX.Cells[j,i];
      StringGridX.Cells[j,i]:='';
    end;
    z:=i;
    end;
  end;
end;

function TForm2.INeedYourAmount(StringGridX: TStringGrid; ACol, ARow: Integer):String;
var x : Integer;
var helpme, please: String;
begin
  helpme:=StringGridX.Cells[ACol,ARow];
  x:=Length(helpme);
  if(x>0) then begin
    if helpme[1]='-' then begin //Для отрицательных чисел
      if x=6 then please:=helpme[1]+helpme[2]+helpme[4]+helpme[5]+helpme[6];
      if x=7 then please:=helpme[1]+helpme[2]+helpme[3]+helpme[5]+helpme[6]+helpme[7];
      if x=8 then please:=helpme[1]+helpme[2]+helpme[3]+helpme[4]+helpme[6]+helpme[7]+helpme[8];
      INeedYourAmount:=please;
    end;
    if helpme[1]<>'-' then begin //Для положительных чисел
      if x=5 then please:=helpme[1]+helpme[3]+helpme[4]+helpme[5];
      if x=6 then please:=helpme[1]+helpme[2]+helpme[4]+helpme[5]+helpme[6];
      if x=7 then please:=helpme[1]+helpme[2]+helpme[3]+helpme[5]+helpme[6]+helpme[7];
      INeedYourAmount:=please;
    end else please:='';
end;

end;

procedure TForm2.Button1Click(Sender: TObject);
var i, j, k: Integer;
var Stringushka: String;
var AM, RM: Real;
var ItsBetter: Extended;
begin
  //Начинаем сохранять в файл
  AM:=0;
  RM:=0;
  Allpay:=0;
  Refund:=0;
  AllWillPay:=0;
  //Таблица Payments
  j:=1;
  k:=Length(StringGrid2.Cells[0,j]);
  while k<>0 do begin
    Stringushka:=INeedYourAmount(StringGrid2, 1, j);
    ItsBetter:=StrToFloat(Stringushka);
      if (ItsBetter>0) Or (ItsBetter=0) then begin //Записываем в Payments
        IniFile.WriteString('PAYMENTS_PAY_NAME', 'NSN'+IntToStr(AllPay+1), StringGrid2.Cells[0,j]);
        IniFile.WriteInteger('PAYMENTS_PAY_AMOUNT', 'NSA'+IntToStr(AllPay+1), Round(ItsBetter));
        AM:=AM+Round(ItsBetter);
        AllPay:=AllPay+1;
      end;
      if ItsBetter<0 then begin //Записываем в Refunds
        IniFile.WriteString('PAYMENTS_REF_NAME', 'PRN'+IntToStr(Refund+1), StringGrid2.Cells[0,j]);
        IniFile.WriteInteger('PAYMENTS_REF_AMOUNT', 'PRA'+IntToStr(Refund+1), -Round(ItsBetter));
        RM:=RM-Round(ItsBetter);
        Refund:=Refund+1;
      end;
    j:=j+1;
    k:=Length(StringGrid2.Cells[0,j]);
  end;
  //Теперь сохраняем новые значения AmM, AmS, RefM и RefS
  IniFile.WriteFloat('MAINFORM', 'AmM', AM);
  IniFile.WriteFloat('MAINFORM', 'AmS', AllPay);
  IniFile.WriteFloat('MAINFORM', 'RefM', RM);
  IniFile.WriteFloat('MAINFORM', 'RefS', Refund);
  //Таблица Planned Payments
  AM:=0;
  i:=1;
  j:=1;
  k:=Length(StringGrid1.Cells[0,j]);
  while k<>0 do begin
    Stringushka:=INeedYourAmount(StringGrid1, 1, j);
    //Записываем в Payments_Will
    IniFile.WriteString('PAYMENTS_WILL_NAME', 'PSN'+IntToStr(j), StringGrid1.Cells[0,j]);
    IniFile.WriteInteger('PAYMENTS_WILL_AMOUNT', 'PSA'+IntToStr(j), StrToInt(Stringushka));
    IniFile.WriteString('PAYMENTS_WILL_DATE', 'DATE'+IntToStr(j), StringGrid1.Cells[2,j]);
    AM:=AM+StrToInt(Stringushka);
    j:=j+1;
    AllWillPay:=AllWillPay+1;
    k:=Length(StringGrid1.Cells[0,j]);
  end;
  //Теперь сохраняем новые значения PNS и PNR
  IniFile.WriteInteger('MAINFORM', 'PNS', AllWillPay);
  IniFile.WriteFloat('MAINFORM', 'PNR', AM);
end;

procedure TForm2.BitBtn2Click(Sender: TObject);
begin
   StringGrid2.Cells[0,AllPay+Refund+1]:=StringGrid1.Cells[0,ARowX];
   StringGrid2.Cells[1,AllPay+Refund+1]:=StringGrid1.Cells[1,ARowX];
   StringGrid1.Cells[0,ARowX]:='';
   StringGrid1.Cells[1,ARowX]:='';
   StringGrid1.Cells[2,ARowX]:='';
   AllPay:=AllPay+1;
   AllWillPay:=AllWillPay-1;
   //Перерисовка таблицы
   RedrawTable(StringGrid1, 3, ARowX);
end;

procedure TForm2.BitBtn1Click(Sender: TObject);
begin
   StringGrid1.Cells[0,AllWillPay+1]:=StringGrid2.Cells[0,ARowY];
   StringGrid1.Cells[1,AllWillPay+1]:=StringGrid2.Cells[1,ARowY];
   StringGrid1.Cells[2,AllWillPay+1]:='';
   StringGrid2.Cells[0,ARowY]:='';
   StringGrid2.Cells[1,ARowY]:='';
   AllPay:=AllPay-1;
   AllWillPay:=AllWillPay+1;
   //Перерисовка таблицы
   RedrawTable(StringGrid2, 2, ARowY);
end;

procedure TForm2.SetColor(StringGridX: TStringGrid; ACol, ARow: Integer;
Rect: TRect; State: TGridDrawState);
var znak: Char;
var Str: String[50];
begin
  Str:=StringGridX.Cells[ACol, ARow];
  znak:=Str[1];
  if (znak='-') then begin
    StringGridX.Canvas.Brush.Color := clRed;
    StringGridX.Canvas.FillRect(Rect);
    StringGridX.Canvas.Font.Color:=clWhite;
    StringGridX.Canvas.TextOut(Rect.Left, Rect.Top, StringGridX.Cells[ACol, ARow]);
  end;
end;

procedure TForm2.ReadINI();
var HM: String;
var i, j, HR:Integer;
begin
  IniFile:=TIniFile.Create('D:\MyEFSalary\res.ini');
  //Считаем количество записей в каждой из таблиц
  AllPay:=IniFile.ReadInteger('MAINFORM', 'AmS', 0);
  Refund:=IniFile.ReadInteger('MAINFORM', 'RefS', 0);
  AllWillPay:=IniFile.ReadInteger('MAINFORM', 'PNS', 0);
  //ТАБЛИЦА NAME-AMOUNT
  //Выведем данные по покупкам
  for i:=1 to AllPay do begin
    HM:=IniFile.ReadString('PAYMENTS_PAY_NAME', 'NSN'+IntToStr(i), '');
    StringGrid2.Cells[0,i]:=HM;
    HR:=IniFile.ReadInteger('PAYMENTS_PAY_AMOUNT', 'NSA'+IntToStr(i), 0);
    StringGrid2.Cells[1,i]:=FloatToStrF(HR, ffNumber, 7, 0);
  end;
  j:=1;
  //Выведем данные по возвратам
  for i:=AllPay+1 to AllPay+Refund do begin
    HM:=IniFile.ReadString('PAYMENTS_REF_NAME', 'PRN'+IntToStr(j), '');
    StringGrid2.Cells[0,i]:=HM;
    SetColor(StringGrid2,0,i,Rect,State);
    HR:=IniFile.ReadInteger('PAYMENTS_REF_AMOUNT', 'PRA'+IntToStr(j), 0);
    StringGrid2.Cells[1,i]:=FloatToStrF(-HR, ffNumber, 7, 0);
    SetColor(StringGrid2,0,i,Rect,State);
    j:=j+1;
  end;
  //ТАБЛИЦА NAME-AMOUNT-DATE
  for i:=1 to AllWillPay do begin
    HM:=IniFile.ReadString('PAYMENTS_WILL_NAME', 'PSN'+IntToStr(i), '');
    StringGrid1.Cells[0,i]:=HM;
    HR:=IniFile.ReadInteger('PAYMENTS_WILL_AMOUNT', 'PSA'+IntToStr(i), 0);
    StringGrid1.Cells[1,i]:=FloatToStrF(HR, ffNumber, 7, 0);
    HM:=IniFile.ReadString('PAYMENTS_WILL_DATE', 'DATE'+IntToStr(i), '');
    StringGrid1.Cells[2,i]:=HM;
  end;
end;

procedure TForm2.StringGrid1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
   StringGrid1.MouseToCell(X, Y, AColX, ARowX);//Получаем индексы ячейки ACol и ARow
end;

procedure TForm2.StringGrid2MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
   StringGrid2.MouseToCell(X, Y, AColX, ARowY);//Получаем индексы ячейки ACol и ARow
end;


end.


unit MyGameUnit;

interface

uses SysUtils, Graphics, Windows;

const
  R = 26;
  MulX = 25;
  MulY = 25;

type
  TLei = (LEI, NOTLEI);
  TOp = (OP_YES, OP_NO);
  TSHOW = (SHOW_YES, SHOW_NO);
  TData = record
    FLei: TLei;
    Fop: TOp;
    FShow: TShow;
  end;
  TArray = array of array of TData;

var
  X: integer = 20;
  Y: integer = 10;
  TMPMAX: integer;
  Data: TArray;
  TotalLei: integer = 20;
  temp: array of TPoint;
  NowTempPosition: integer;
  clSquare: TColor = clGreen;
  clBackGround: TColor = clBtnface;
  clGrid: TColor = clBlack;
  clPressed: TColor = clBlack;

procedure InitArray();
procedure FreeArray();
function GetDataLei(i, j: integer): TLei;
function GetDataOp(i, j: integer): TOp;
function GetDataShow(i, j: integer): TShow;
procedure SetDataLei(i, j: integer; tmpLei: TLei);
procedure SetDataOp(i, j: integer; tmpOp: TOp);
procedure SetDataShow(i, j: integer; tmpShow: TShow);
function XtoI(X: integer): integer;
function YtoJ(Y: integer): integer;
function ItoX(I: integer): integer;
function JtoY(J: integer): integer;
function NumberOfPoint(i, j: integer): integer;

implementation

procedure InitArray();
var
  i, j, k: integer;
begin
  SetLength(Data, X, Y);
  randomize;
  for i := 0 to X - 1 do
    for j := 0 to Y - 1 do
    begin
      Data[i, j].FLei := NOTLEI;
      Data[i, j].Fop := OP_NO;
      Data[i, j].FShow := SHOW_NO;
    end;
  k := 0;
  while k < TotalLei do
  begin
    repeat
      i := random(X);
      j := random(Y);
    until data[i][j].FLei <> LEI;
    data[i][j].FLei := LEI;
    inc(k);
  end;
end;

procedure FreeArray();
begin
  SetLength(Data, 0, 0);
end;

function GetDataLei(i, j: integer): TLei;
begin
  result := Data[i, j].FLei;
end;

function GetDataOp(i, j: integer): TOp;
begin
  result := Data[i, j].Fop;
end;

function GetDataShow(i, j: integer): TShow;
begin
  result := Data[i, j].FShow;
end;

procedure SetDataLei(i, j: integer; tmpLei: TLei);
begin
  Data[i, j].FLei := tmpLei;
end;

procedure SetDataOp(i, j: integer; tmpOp: TOp);
begin
  if GetDataShow(i, j) = SHOW_YES then
    exit;
  Data[i, j].Fop := tmpOp;
end;

procedure SetDataShow(i, j: integer; tmpShow: TShow);
begin
  Data[i, j].FShow := tmpShow;
end;

function XtoI(X: integer): integer;
begin
  result := X div MulX;
end;

function YtoJ(Y: integer): integer;
begin
  result := Y div MulY;
end;

function ItoX(I: integer): integer;
begin
  result := I * MulX;
end;

function JToY(J: integer): integer;
begin
  result := J * MulY;
end;

function NumberOfPoint(i, j: integer): integer;
var
  num, k: integer;
  points: array[1..8] of TPoint;
begin
  num := 0;
  points[1].X := i - 1;
  points[1].Y := j - 1;
  points[2].X := i;
  points[2].Y := j - 1;
  points[3].X := i + 1;
  points[3].Y := j - 1;
  points[4].X := i - 1;
  points[4].Y := j;
  points[5].X := i + 1;
  points[5].Y := j;
  points[6].X := i - 1;
  points[6].Y := j + 1;
  points[7].X := i;
  points[7].Y := j + 1;
  points[8].X := i + 1;
  points[8].Y := j + 1;
  for k := Low(points) to High(points) do
  begin
    if (points[k].X >= 0) and (points[k].X <= X - 1) and
      (points[k].Y >= 0) and (points[k].Y <= Y - 1) and
      (Data[points[k].X][points[k].Y].FLei = LEI) then
      inc(num);
  end;
  result := num;
end;

end.


unit MainUnit;

{
CONTACT: WANGXINGHE1983@GMAIL.COM
}

interface

uses
  Windows, SysUtils, Classes, Graphics, Controls, Forms, ExtCtrls, Menus,
  StdCtrls, ComCtrls, Buttons, Dialogs;

type
  TFormMain = class(TForm)
    MainMenuGame: TMainMenu;
    MenuGame: TMenuItem;
    MenuHelp: TMenuItem;
    MenuGameStart: TMenuItem;
    MenuGameSeperator1: TMenuItem;
    MenuGameLow: TMenuItem;
    MenuGameMedium: TMenuItem;
    MenuGameHigh: TMenuItem;
    MenuGameSelf: TMenuItem;
    MenuGameSeperator3: TMenuItem;
    MenuGameTop: TMenuItem;
    MenuGameSeperator4: TMenuItem;
    MenuGameExit: TMenuItem;
    MenuHelpAbout: TMenuItem;
    PanelMain: TPanel;
    PanelHead: TPanel;
    SBStart: TSpeedButton;
    PanelClient: TPanel;
    MainPaintBox: TPaintBox;
    MenuHelpGame: TMenuItem;
    TimerDelay: TTimer;
    PanelTimeDelay: TPanel;
    PanelLeft: TPanel;
    MenuAutoShow: TMenuItem;
    StatusBar1: TStatusBar;
    MenuAdvance: TMenuItem;
    MenuSetMouse: TMenuItem;
    MenuColorSet: TMenuItem;
    procedure MenuGameExitClick(Sender: TObject);
    procedure MenuHelpAboutClick(Sender: TObject);
    procedure MainPaintBoxMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure MainPaintBoxMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure SBStartClick(Sender: TObject);
    procedure MainPaintBoxPaint(Sender: TObject);
    procedure MenuGameLowClick(Sender: TObject);
    procedure MenuGameMediumClick(Sender: TObject);
    procedure MenuGameHighClick(Sender: TObject);
    procedure MenuGameStartClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure MenuHelpGameClick(Sender: TObject);
    procedure TimerDelayTimer(Sender: TObject);
    procedure MenuAutoShowClick(Sender: TObject);
    procedure MenuGameSelfClick(Sender: TObject);
    procedure MenuSetMouseClick(Sender: TObject);
    procedure MenuColorSetClick(Sender: TObject);
    procedure MenuGameTopClick(Sender: TObject);
  private
    LeftDown, RightDown, IsFirstTime, CanShowRound: boolean;
    tmpX, tmpY, tmpShowNum, tmpOPNum, tmpLei, UserTotals, TimeDelay: integer;
    tmpMouseRect: TRect;
    procedure ShowOneData(i, j: integer);
    procedure ShowData();
    procedure GameStart();
    procedure GameEnd();
    procedure GameOver();
    procedure GameSuccess();
    function CheckGame(): boolean;
    procedure ShowNumber(i, j: integer);
    procedure ShowString(x, y: integer; s: string);
    procedure ShowTemp();
    procedure ShowRound(i, j: integer);
    procedure AddToTemp(i, j: integer);
    procedure InitTemp();
    procedure FreeTemp();
    procedure ReShow(i, j: integer);
    procedure ToShow(i, j: integer);
    function InTemp(i, j: integer): boolean;
    procedure LockMouse();
    procedure UnLockMouse();
    procedure ToShowIJ(i, j: integer);
    procedure ReShowIJ(i, j: integer);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormMain: TFormMain;

implementation

uses MyGameUnit, MMSystem, UnitColor;

{$R *.dfm}

procedure TFormMain.MenuAutoShowClick(Sender: TObject);
begin
  MenuAutoShow.Checked := not MenuAutoShow.Checked;
end;

procedure TFormMain.MenuColorSetClick(Sender: TObject);
begin
  FormColor := TFormColor.Create(Application);
  try
    FormColor.CBSquare.Selected := clSquare;
    FormColor.CBBackGround.Selected := clBackGround;
    FormColor.CBGrid.Selected := clGrid;
    FormColor.CBPressed.Selected := clPressed;
    FormColor.ShowModal;
  finally
    FormColor.Free;
  end;
  ShowData();
end;

procedure TFormMain.MenuGameExitClick(Sender: TObject);
begin
  Close;
end;

procedure TFormMain.MenuHelpAboutClick(Sender: TObject);
begin
  MessageBox(Self.Handle, '游戏名称 - 扫雷游戏' + sLineBreak +
                          '开发者   - RICOL' + sLineBreak +
                          '联系     - WANGXINGHE1983@GMAIL.COM', '关于', MB_OK);
end;

procedure TFormMain.MenuHelpGameClick(Sender: TObject);
begin
  MenuHelpGame.Checked := not MenuHelpGame.Checked;
  ShowData;
end;

procedure TFormMain.ReShow(i, j: integer);
var
  II, tmpII, tmpJJ, tmpXX, tmpYY: integer;
  tmpData: array[1..8] of TPoint;
  AutoShow: boolean;
begin
  ReShowIJ(i, j);
  AutoShow := false;
  if (tmpShowNum = tmpLei - tmpOpNum) and MenuAutoShow.Checked then
    AutoShow := true;
  tmpData[1].X := i - 1;
  tmpData[1].Y := j - 1;
  tmpData[2].X := i;
  tmpData[2].Y := j - 1;
  tmpData[3].X := i + 1;
  tmpData[3].Y := j - 1;
  tmpData[4].X := i - 1;
  tmpData[4].Y := j;
  tmpData[5].X := i + 1;
  tmpData[5].Y := j;
  tmpData[6].X := i - 1;
  tmpData[6].Y := j + 1;
  tmpData[7].X := i;
  tmpData[7].Y := j + 1;
  tmpData[8].X := i + 1;
  tmpData[8].Y := j + 1;
  for II := Low(tmpData) to High(tmpData) do
  begin
    tmpII := tmpData[II].X;
    tmpJJ := tmpData[II].Y;
    if (tmpII <= X - 1) and (tmpII >= 0) and (tmpJJ <= Y - 1) and (tmpJJ >= 0) and
      (GetDataShow(tmpII, tmpJJ) = SHOW_NO) and (GetDataOP(tmpII, tmpJJ) = OP_NO) then
    begin
      tmpXX := IToX(tmpII);
      tmpYY := JToY(tmpJJ);
      with MainPaintBox do
      begin
        Canvas.Pen.Color := clGrid;
        Canvas.Brush.Color := clSquare;
        Canvas.Rectangle(tmpXX, tmpYY, tmpXX + R, tmpYY + R);
      end;
      if AutoShow then
      begin
        SetDataOp(tmpII, tmpJJ, OP_YES);
        inc(UserTotals);
        PanelLeft.Caption := IntToStr(TotalLei - UserTotals);
        ShowOneData(tmpII, tmpJJ);
      end;
    end;
  end;
end;

procedure TFormMain.ReShowIJ(i, j: integer);
begin
  if (GetDataShow(i, j) = SHOW_NO) and (GetDataOP(i, j) = OP_NO) then
  begin
    with MainPaintBox do
    begin
      Canvas.Pen.Color := clGrid;
      Canvas.Brush.Color := clSquare;
      Canvas.Rectangle(IToX(i), JToY(j), IToX(i) + R, JToY(j) + R);
    end;
  end
  else if (GetDataOP(i, j) = OP_NO) then
  begin
    with MainPaintBox do
    begin
      Canvas.Pen.Color := clGrid;
      Canvas.Brush.Color := clBackGround;
      Canvas.Rectangle(IToX(i), JToY(j), IToX(i) + R, JToY(j) + R);
      Canvas.Font.Color := clBlack;
      Canvas.Font.Size := 12;
      if tmpLei = 0 then
        Canvas.TextOut(IToX(i) + 2, JToY(j) + 2, ' ')
      else
        Canvas.TextOut(IToX(i) + 2, JToY(j) + 2, ' ' + IntToStr(tmpLei));
    end;
  end;
end;

procedure TFormMain.MainPaintBoxMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  i, j: integer;
begin
  if MenuHelpGame.Checked then exit;
  if (tmpX >= MainPaintBox.Width - 5) or (tmpY >= MainPaintBox.Height - 5) then
    exit;
  i := XToI(tmpX);
  j := YToJ(tmpY);
  LeftDown := false;
  RightDown := false;
  try
    if CanShowRound then
    begin
      if MenuSetMouse.Checked then
        UnLockMouse();
      ReShow(XToI(tmpX), YToJ(tmpY));
      CanShowRound := false;
      if (i <> XToI(X)) or (j <> YToJ(Y)) or (GetDataShow(i, j) = SHOW_NO) then
        exit;
      ShowRound(i, j);
      if CheckGame then
      begin
        GameSuccess;
        exit;
      end;
    end;
    ReShowIJ(i, j);
    if (i <> XToI(X)) or (j <> YToJ(Y)) then
      exit;
    if (Button = mbRight) and (GetDataShow(i, j) <> SHOW_YES) then
    begin
      if GetDataOp(i, j) = OP_YES then
      begin
        SetDataOp(i, j, OP_NO);
        Dec(UserTotals);
      end
      else
      begin
        SetDataOp(i, j, OP_YES);
        Inc(UserTotals);
      end;
      PanelLeft.Caption := IntToStr(TotalLei - UserTotals);
      if CheckGame then
      begin
        GameSuccess;
        exit;
      end;
      ShowOneData(i, j);
    end
    else if (Button = mbLeft) and (GetDataShow(i, j) = SHOW_NO) and
      (GetDataOP(i, j) = OP_NO) then
    begin
      if data[i, j].FLei = LEI then
      begin
        if IsFirstTime then
        begin
          TimerDelay.Enabled := false;
          GameEnd;
          GameStart;
        end
        else
          GameOver;
      end
      else
      begin
        if IsFirstTime then
          TimerDelay.Enabled := true;
        IsFirstTime := false;
        InitTemp();
        ShowNumber(i, j);
        ShowTemp();
        if CheckGame then
        begin
          GameSuccess;
          exit;
        end;
      end;
    end;
  except

  end;
end;

procedure TFormMain.MainPaintBoxMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if MenuHelpGame.Checked then exit;
  tmpX := X;
  tmpY := Y;
  if (tmpX >= MainPaintBox.Width - 5) or (tmpY >= MainPaintBox.Height - 5) then
    exit;
  if (LeftDown and (Button = mbRight)) or (RightDown and (Button = mbLeft)) then
  begin
    LeftDown := false;
    RightDown := false;
    CanShowRound := true;
    if MenuSetMouse.Checked then
      LockMouse();
    ToShow(XToI(tmpX), YToJ(tmpY));
    exit;
  end;
  if Button = mbLeft then
    LeftDown := true;
  if Button = mbRight then
    RightDown := true;
  ToShowIJ(XToI(tmpX), YToJ(tmpY));
end;

procedure TFormMain.GameStart;
begin
  InitArray();
  ShowData();
  InitTemp();
  UserTotals := 0;
  TimeDelay := 0;
  IsFirstTime := true;
  TimerDelay.Enabled := false;
  LeftDown := false;
  RightDown := false;
  PanelLeft.Caption := IntToStr(TotalLei - UserTotals);
  PanelTimeDelay.Caption := IntToStr(0);
  MainPaintBox.Canvas.Pen.Color := clBlack;
  MainPaintBox.Canvas.Font.Color := clBlack;
end;

procedure TFormMain.GameSuccess;
begin
  MenuHelpGame.Checked := true;
  ShowData();
  TimerDelay.Enabled := false;
  MessageBox(Self.Handle, '真厉害，你成功了!', '信息', MB_OK or MB_ICONINFORMATION);
  MenuHelpGame.Checked := false;
  MenuGameStartClick(nil);
end;

function TFormMain.CheckGame: boolean;
var
  i, j: integer;
begin
  result := true;
  for i := 0 to X - 1 do
    for j := 0 to Y - 1 do
    begin
      if (GetDataLei(i, j) <> LEI) then
      begin
        if (GetDataShow(i, j) <> SHOW_YES) then
        begin
          result := false;
          exit;
        end
        else
          continue;
      end
      else
      begin
        if (GetDataOP(i, j) <> OP_YES) then
        begin
          result := false;
          exit;
        end
        else
          continue;
      end;
    end;
end;

procedure TFormMain.FormCreate(Sender: TObject);
begin
  IsFirstTime := true;
  GameStart();
end;

procedure TFormMain.FormDestroy(Sender: TObject);
begin
  GameEnd();
end;

procedure TFormMain.FormResize(Sender: TObject);
begin
  PanelClient.Width := X * R - X + 4;
  PanelClient.Height := Y * R - Y + 4;
  PanelHead.Width := PanelClient.Width;
  SBStart.Left := PanelHead.Width div 2 - SBStart.Width div 2;
  Self.Width := PanelClient.Width + 38;
  Self.Height := PanelClient.Height + 140;
end;

procedure TFormMain.GameEnd;
begin
  FreeArray();
  FreeTemp();
end;

procedure TFormMain.GameOver;
begin
  MenuHelpGame.Checked := true;
  ShowData();
  TimerDelay.Enabled := false;
  MessageBox(Self.Handle, '很遗憾，你失败了!', '信息', MB_OK or MB_ICONWARNING);
  MenuHelpGame.Checked := false;
  MenuGameStartClick(nil);
end;

procedure TFormMain.ShowData;
var
  i, j: integer;
begin
  for i := 0 to X - 1 do
    for j := 0 to Y - 1 do
      ShowOneData(i, j);
end;

procedure TFormMain.ShowOneData(i, j: integer);
begin
  if (GetDataShow(i, j) = SHOW_NO) and (GetDataOp(i, j) = OP_NO) then
  begin
    MainPaintBox.Canvas.Pen.Color := clGrid;
    MainPaintBox.Canvas.Brush.Color := clSquare;
    MainPaintBox.Canvas.Rectangle(ItoX(i), JtoY(j), ItoX(i) + R, JtoY(j) + R);
  end
  else if (GetDataShow(i, j) = SHOW_NO) and (GetDataOp(i, j) = OP_YES) then
  begin
    MainPaintBox.Canvas.Pen.Color := clGrid;
    MainPaintBox.Canvas.Brush.Color := clSquare;
    MainPaintBox.Canvas.Rectangle(ItoX(i), JtoY(j), ItoX(i) + R, JtoY(j) + R);
    MainPaintBox.Canvas.Pen.Color := clRed;
    MainPaintBox.Canvas.Brush.Color := CLRED;
    MainPaintBox.Canvas.Rectangle(ItoX(i) + R div 3, JtoY(j) + R div 3,
      ItoX(i) + R div 3 + R div 3, JtoY(j) + R div 3 + R div 3);
  end
  else if GetDataShow(i, j) = SHOW_YES then
  begin
    MainPaintBox.Canvas.Pen.Color := clGrid;
    MainPaintBox.Canvas.Brush.Color := clBackGround;
    MainPaintBox.Canvas.Rectangle(IToX(i), JToY(j), IToX(i) + R, JToY(j) + R);
    ShowString(IToX(i), JToY(j), IntToStr(NumberOfPoint(i, j)));
  end;
  if MenuHelpGame.Checked and (GetDataLei(i, j) = LEI) then
  begin
    MainPaintBox.Canvas.Pen.Color := clGrid;
    MainPaintBox.Canvas.Brush.Color := CLRED;
    MainPaintBox.Canvas.Rectangle(IToX(i), JToY(j), IToX(i) + R, JToY(j) + R);
  end;
end;

procedure TFormMain.ShowRound(i, j: integer);
var
  CanShowRound: boolean;
  tmp: array[1..8] of boolean;
  tmpData: array[1..8] of TPoint;
  num, tmpI: integer;
begin
  CanShowRound := false;
  num := 0;
  if (GetDataSHOW(i, j) = SHOW_NO) then
    exit;
  tmpData[1].X := i - 1;
  tmpData[1].Y := j - 1;
  tmpData[2].X := i;
  tmpData[2].Y := j - 1;
  tmpData[3].X := i + 1;
  tmpData[3].Y := j - 1;
  tmpData[4].X := i - 1;
  tmpData[4].Y := j;
  tmpData[5].X := i + 1;
  tmpData[5].Y := j;
  tmpData[6].X := i - 1;
  tmpData[6].Y := j + 1;
  tmpData[7].X := i;
  tmpData[7].Y := j + 1;
  tmpData[8].X := i + 1;
  tmpData[8].Y := j + 1;
  for tmpI := Low(tmpData) to High(tmpData) do
  begin
    if (tmpData[tmpI].X >= 0) and (tmpData[tmpI].X <= X - 1) and
      (tmpData[tmpI].Y >= 0) and (tmpData[tmpI].Y <= Y - 1) and
      (GetDataOp(tmpData[tmpI].X, tmpData[tmpI].Y) = OP_YES) then
    begin
      CanShowRound := true;
      tmp[tmpI] := true;
      inc(num);
    end
    else
      tmp[tmpI] := false;
  end;
  if num <> NumberOfPoint(i, j) then
    CanShowRound := false;
  if not CanShowRound then exit;
  if (tmp[1] and (GetDataLei(i - 1, j - 1) <> LEI)) or
    (tmp[2] and (GetDataLei(i, j - 1) <> LEI)) or
    (tmp[3] and (GetDataLei(i + 1, j - 1) <> LEI)) or
    (tmp[4] and (GetDataLei(i - 1, j) <> LEI)) or
    (tmp[5] and (GetDataLei(i + 1, j) <> LEI)) or
    (tmp[6] and (GetDataLei(i - 1, j + 1) <> LEI)) or
    (tmp[7] and (GetDataLei(i, j + 1) <> LEI)) or
    (tmp[8] and (GetDataLei(i + 1, j + 1) <> LEI)) then
  begin
    GameOver;
  end
  else
  begin
    for tmpI := Low(tmpData) to High(tmpData) do
    begin
      if (not tmp[tmpI]) and
        (tmpData[tmpI].X >= 0) and (tmpData[tmpI].X <= X - 1) and
        (tmpData[tmpI].Y >= 0) and (tmpData[tmpI].Y <= Y - 1) and
        (GetDataShow(tmpData[tmpI].X, tmpData[tmpI].Y) <> SHOW_YES) then
      begin
        InitTemp;
        ShowNumber(tmpData[tmpI].X, tmpData[tmpI].Y);
        ShowTemp;
      end;
    end;
  end;
end;

procedure TFormMain.SBStartClick(Sender: TObject);
begin
  GameStart;
end;

procedure TFormMain.ShowString(x, y: integer; s: string);
begin
  if (GetDataOP(XToI(x), YToJ(Y)) = OP_YES) then
    exit;
  MainPaintBox.Canvas.Pen.Color := CLBLACK;
  MainPaintBox.Canvas.Brush.Color := CLBTNFACE;
  MainPaintBox.Canvas.Rectangle(x, y, x + r, y + r);
  if s = '0' then
    s := '';
  s := ' ' + s;
  MainPaintBox.Canvas.Font.Size := 12;
  MainPaintBox.Canvas.TextOut(x + 2, y + 2, s);
  SetDataShow(XToI(x), YToJ(y), SHOW_YES);
end;

procedure TFormMain.ShowNumber(i, j: integer);
var
  tmpI, n: integer;
  tmpData: array[1..8] of TPoint;
begin
  n := NumberOfPoint(i, j);
  ShowString(IToX(i), JToY(j), IntToStr(n));
  if n = 0 then
  begin
    if InTemp(i, j) then exit
    else
    begin
      AddToTemp(i, j);
      tmpData[1].X := i - 1;
      tmpData[1].Y := j - 1;
      tmpData[2].X := i;
      tmpData[2].Y := j - 1;
      tmpData[3].X := i + 1;
      tmpData[3].Y := j - 1;
      tmpData[4].X := i - 1;
      tmpData[4].Y := j;
      tmpData[5].X := i + 1;
      tmpData[5].Y := j;
      tmpData[6].X := i - 1;
      tmpData[6].Y := j + 1;
      tmpData[7].X := i;
      tmpData[7].Y := j + 1;
      tmpData[8].X := i + 1;
      tmpData[8].Y := j + 1;
      for tmpI := Low(tmpData) to High(tmpData) do
        if (tmpData[tmpI].X >= 0) and (tmpData[tmpI].X <= X - 1) and
          (tmpData[tmpI].Y >= 0) and (tmpData[tmpI].Y <= Y - 1) and
          (NumberOfPoint(tmpData[tmpI].X, tmpData[tmpI].Y) = 0) then
          ShowNumber(tmpData[tmpI].X, tmpData[tmpI].Y);
    end;
  end;
end;

procedure TFormMain.ShowTemp;
var
  k, i, j, tmpI: integer;
  tmpData: array[1..8] of TPoint;
begin
  for k := 0 to NowTempPosition do
  begin
    i := XToI(temp[k].X);
    j := YToJ(temp[k].Y);
    tmpData[1].X := i - 1;
    tmpData[1].Y := j - 1;
    tmpData[2].X := i;
    tmpData[2].Y := j - 1;
    tmpData[3].X := i + 1;
    tmpData[3].Y := j - 1;
    tmpData[4].X := i - 1;
    tmpData[4].Y := j;
    tmpData[5].X := i + 1;
    tmpData[5].Y := j;
    tmpData[6].X := i - 1;
    tmpData[6].Y := j + 1;
    tmpData[7].X := i;
    tmpData[7].Y := j + 1;
    tmpData[8].X := i + 1;
    tmpData[8].Y := j + 1;
    for tmpI := Low(tmpData) to High(tmpData) do
    begin
      if (tmpData[tmpI].X >= 0) and (tmpData[tmpI].X <= X - 1) and
         (tmpData[tmpI].Y >= 0) and (tmpData[tmpI].Y <= Y - 1) and
         (Data[tmpData[tmpI].X][tmpData[tmpI].Y].FLei <> LEI) then
        ShowString(IToX(tmpData[tmpI].X),
                   JToY(tmpData[tmpI].Y),
                   IntToStr(NumberOfPoint(tmpData[tmpI].X,
                   tmpData[tmpI].Y)));
    end;
  end;
end;

procedure TFormMain.TimerDelayTimer(Sender: TObject);
begin
  inc(TimeDelay);
  PanelTimeDelay.Caption := IntToStr(TimeDelay);
end;

procedure TFormMain.ToShow(i, j: integer);
var
  II, tmpII, tmpJJ, tmpXX, tmpYY: integer;
  tmpData: array[1..8] of TPoint;
begin
  tmpShowNum := 0;
  tmpOpNum := 0;
  ToShowIJ(i, j);
  tmpData[1].X := i - 1;
  tmpData[1].Y := j - 1;
  tmpData[2].X := i;
  tmpData[2].Y := j - 1;
  tmpData[3].X := i + 1;
  tmpData[3].Y := j - 1;
  tmpData[4].X := i - 1;
  tmpData[4].Y := j;
  tmpData[5].X := i + 1;
  tmpData[5].Y := j;
  tmpData[6].X := i - 1;
  tmpData[6].Y := j + 1;
  tmpData[7].X := i;
  tmpData[7].Y := j + 1;
  tmpData[8].X := i + 1;
  tmpData[8].Y := j + 1;
  for II := Low(tmpData) to High(tmpData) do
  begin
    tmpII := tmpData[II].X;
    tmpJJ := tmpData[II].Y;
    if (tmpII <= X - 1) and (tmpII >= 0) and (tmpJJ <= Y - 1) and (tmpJJ >= 0) and
      (GetDataShow(tmpII, tmpJJ) = SHOW_NO) then
    begin
      if GetDataOP(tmpII, tmpJJ) = OP_NO then
      begin
        inc(tmpShowNum);
        tmpXX := IToX(tmpII);
        tmpYY := JToY(tmpJJ);
        with MainPaintBox do
        begin
          Canvas.Pen.Color := clPressed;
          Canvas.Brush.Color := clPressed;
          Canvas.Rectangle(tmpXX, tmpYY, tmpXX + R, tmpYY + R);
        end;
      end
      else
        inc(tmpOpNum);
    end;
  end;
end;

procedure TFormMain.ToShowIJ(i, j: integer);
begin
  if (GetDataShow(i, j) = SHOW_NO) and (GetDataOP(i, j) = OP_NO) then
  begin
    with MainPaintBox do
    begin
      Canvas.Pen.Color := clPressed;
      Canvas.Brush.Color := clPressed;
      Canvas.Rectangle(IToX(i), JToY(j), IToX(i) + R, JToY(j) + R);
    end;
  end
  else if GetDataOP(i, j) = OP_NO then
  begin
    tmpLei := NumberOfPoint(i, j);
    with MainPaintBox do
    begin
      Canvas.Pen.Color := clBlack;
      Canvas.Brush.Color := clWhite;
      Canvas.Rectangle(IToX(i), JToY(j), IToX(i) + R, JToY(j) + R);
      Canvas.Font.Color := clBlack;
      Canvas.Font.Size := 12;
      if tmpLei = 0 then
        Canvas.TextOut(IToX(i) + 2, JToY(j) + 2, ' ')
      else
        Canvas.TextOut(IToX(i) + 2, JToY(j) + 2, ' ' + IntToStr(tmpLei));
    end;
  end;
end;

procedure TFormMain.AddToTemp(i, j: integer);
begin
  Inc(NowTempPosition);
  temp[NowTempPosition].X := IToX(i);
  temp[NowTempPosition].Y := JToY(j);
  ShowNumber(i, j);
end;

function TFormMain.InTemp(i, j: integer): boolean;
var
  k: integer;
begin
  result := false;
  for k := 0 to NowTempPosition do
    if (Temp[k].X = IToX(i)) and (Temp[k].Y = JToY(j)) then
    begin
      result := true;
      exit;
    end;
end;

procedure TFormMain.InitTemp;
var
  i: integer;
begin
  TMPMAX := X * Y;
  SetLength(temp, TMPMAX);
  for i := 0 to TMPMAX - 1 do
  begin
    temp[i].X := -1;
    temp[i].Y := -1;
  end;
  NowTempPosition := -1;
end;

procedure TFormMain.MainPaintBoxPaint(Sender: TObject);
begin
  ShowData();
end;

procedure TFormMain.FreeTemp;
begin
  SetLength(temp, 0);
end;

procedure TFormMain.MenuGameLowClick(Sender: TObject);
begin
  TotalLei := 20;
  X := 20;
  Y := 10;
  GameEnd;
  GameStart;
  FormResize(Sender);
end;

procedure TFormMain.MenuGameMediumClick(Sender: TObject);
begin
  TotalLei := 70;
  X := 25;
  Y := 15;
  GameEnd;
  GameStart;
  FormResize(Sender);
end;

procedure TFormMain.MenuGameHighClick(Sender: TObject);
begin
  TotalLei := 120;
  X := 30;
  Y := 20;
  GameEnd;
  GameStart;
  FormResize(Sender);
end;

procedure TFormMain.MenuGameStartClick(Sender: TObject);
begin
  GameEnd;
  GameStart;
  FormResize(Sender);
end;

procedure TFormMain.MenuGameSelfClick(Sender: TObject);
var
  tmpUserLei, tmpUserX, tmpUserY: integer;
begin
  if MessageBox(Self.Handle, '要结束本局游戏，确定吗？', '注意', MB_OKCANCEL) <> ID_OK then
    exit;
  try
    tmpUserX := StrToInt(InputBox('信息', '请输入横向格子数目：             ', IntToStr(X)));
  except
    MessageBox(Self.Handle, '您输入的数据非法，将使用默认值!', '出错', MB_OK or MB_ICONERROR);
    tmpUserX := 20;
  end;
  try
    tmpUserY := StrToInt(InputBox('信息', '请输入纵向格子数目：              ', IntToStr(Y)));
  except
    MessageBox(Self.Handle, '您输入的数据非法，将使用默认值!', '出错', MB_OK or MB_ICONERROR);
    tmpUserY := 10;
  end;
  try
    tmpUserLei := StrToInt(InputBox('信息', '请输入地雷数目：           ', IntToStr(TotalLei)));
    if tmpUserLei > tmpUserX * tmpUserY then
    begin
      MessageBox(Self.Handle, '输入的地雷数目超出最大数目，将使用最大值.', '注意', MB_OK or MB_ICONINFORMATION);
      tmpUserLei := tmpUserX * tmpUserY;
    end;
  except
    MessageBox(Self.Handle, '您输入的数据非法，将使用默认值!', '出错', MB_OK or MB_ICONERROR);
    tmpUserLei := 20;
  end;
  TotalLei := tmpUserLei;
  X := tmpUserX;
  Y := tmpUserY;
  MessageBox(Self.Handle, PChar('开始启动自定义游戏：' + #$D + #$A + #$D + #$A +
    '横向格子数目：' + IntToStr(X) + #$D + #$A +
    '纵向格子数目：' + IntToStr(Y) + #$D + #$A +
    '地雷数目：' + IntToStr(TotalLei)), '信息', MB_OK or MB_ICONINFORMATION);
  GameEnd;
  GameStart;
  FormResize(Sender);
end;

procedure TFormMain.LockMouse;
var
  tmpMousePos: TPoint;
begin
  GetCursorPos(tmpMousePos);
  tmpMouseRect.Left := tmpMousePos.X;
  tmpMouseRect.Top := tmpMousePos.Y;
  tmpMouseRect.Right := tmpMouseRect.Left + 1;
  tmpMouseRect.Bottom := tmpMouseRect.Top + 1;
  ClipCursor(@tmpMouseRect);
end;

procedure TFormMain.UnLockMouse;
begin
  tmpMouseRect.Left := 0;
  tmpMouseRect.Top := 0;
  tmpMouseRect.Right := Screen.Width;
  tmpMouseRect.Bottom := Screen.Height;
  ClipCursor(@tmpMouseRect);
end;

procedure TFormMain.MenuSetMouseClick(Sender: TObject);
begin
  MenuSetMouse.Checked := not MenuSetMouse.Checked;
end;

procedure TFormMain.MenuGameTopClick(Sender: TObject);
begin
  MessageBox(Self.Handle, '功能暂不实现', '信息', MB_OK or MB_ICONINFORMATION);
end;

end.


unit Main;

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
    procedure MainPaintBoxMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure MainPaintBoxMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
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
    fX, fY, fShowNum, fOpNum, fLei, UserTotals, TimeDelay: Integer;
    FMouseRect: TRect;
    procedure ShowOneData(i, j: Integer);
    procedure ShowData();
    procedure GameStart();
    procedure GameEnd();
    procedure GameOver();
    procedure GameSuccess();
    function CheckGame(): boolean;
    procedure ShowNumber(i, j: Integer);
    procedure ShowString(X, Y: Integer; s: string);
    procedure ShowTemp();
    procedure ShowRound(i, j: Integer);
    procedure AddToTemp(i, j: Integer);
    procedure InitTemp();
    procedure FreeTemp();
    procedure ReShow(i, j: Integer);
    procedure ToShow(i, j: Integer);
    function InTemp(i, j: Integer): boolean;
    procedure LockMouse();
    procedure UnLockMouse();
    procedure ToShowIJ(i, j: Integer);
    procedure ReShowIJ(i, j: Integer);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormMain: TFormMain;

implementation

uses Game, MMSystem, Color;

{$R *.dfm}

procedure TFormMain.MenuAutoShowClick(Sender: TObject);
begin
  MenuAutoShow.Checked := not MenuAutoShow.Checked;
end;

procedure TFormMain.MenuColorSetClick(Sender: TObject);
begin
  FormColor := TFormColor.Create(Application);
  with FormColor do
  begin
    try
      CBSquare.Selected := clSquare;
      CBBackGround.Selected := clBackGround;
      CBGrid.Selected := clGrid;
      CBPressed.Selected := clPressed;
      ShowModal;
    finally
      Free;
    end;
  end;
  ShowData();
end;

procedure TFormMain.MenuGameExitClick(Sender: TObject);
begin
  Close;
end;

procedure TFormMain.MenuHelpAboutClick(Sender: TObject);
begin
  MessageBox(Self.Handle, '游戏名称 - 扫雷游戏' + sLineBreak + '开发者   - RICOL' + sLineBreak + '联系     - WANGXINGHE1983@GMAIL.COM', '关于', MB_OK);
end;

procedure TFormMain.MenuHelpGameClick(Sender: TObject);
begin
  MenuHelpGame.Checked := not MenuHelpGame.Checked;
  ShowData;
end;

procedure TFormMain.ReShow(i, j: Integer);
var
  m, n, l, a, b: Integer;
  data: array [1 .. 8] of TPoint;
  AutoShow: boolean;
begin
  ReShowIJ(i, j);
  AutoShow := false;
  if (fShowNum = fLei - fOpNum) and MenuAutoShow.Checked then
    AutoShow := true;
  data[1].X := i - 1;
  data[1].Y := j - 1;
  data[2].X := i;
  data[2].Y := j - 1;
  data[3].X := i + 1;
  data[3].Y := j - 1;
  data[4].X := i - 1;
  data[4].Y := j;
  data[5].X := i + 1;
  data[5].Y := j;
  data[6].X := i - 1;
  data[6].Y := j + 1;
  data[7].X := i;
  data[7].Y := j + 1;
  data[8].X := i + 1;
  data[8].Y := j + 1;
  for m := Low(data) to High(data) do
  begin
    n := data[m].X;
    l := data[m].Y;
    if (n <= X - 1) and (n >= 0) and (l <= Y - 1) and (l >= 0) and (GetDataShow(n, l) = SHOW_NO) and (GetDataOP(n, l) = OP_NO) then
    begin
      a := IToX(n);
      b := JToY(l);
      with MainPaintBox.Canvas do
      begin
        Pen.Color := clGrid;
        Brush.Color := clSquare;
        Rectangle(a, b, a + R, b + R);
      end;
      if AutoShow then
      begin
        SetDataOp(n, l, OP_YES);
        inc(UserTotals);
        PanelLeft.Caption := IntToStr(TotalLei - UserTotals);
        ShowOneData(n, l);
      end;
    end;
  end;
end;

procedure TFormMain.ReShowIJ(i, j: Integer);
begin
  if (GetDataShow(i, j) = SHOW_NO) and (GetDataOP(i, j) = OP_NO) then
  begin
    with MainPaintBox.Canvas do
    begin
      Pen.Color := clGrid;
      Brush.Color := clSquare;
      Rectangle(IToX(i), JToY(j), IToX(i) + R, JToY(j) + R);
    end;
  end
  else if (GetDataOP(i, j) = OP_NO) then
  begin
    with MainPaintBox.Canvas do
    begin
      Pen.Color := clGrid;
      Brush.Color := clBackGround;
      Rectangle(IToX(i), JToY(j), IToX(i) + R, JToY(j) + R);
      Font.Color := clBlack;
      Font.Size := 12;
      if fLei = 0 then
        TextOut(IToX(i) + 2, JToY(j) + 2, ' ')
      else
        TextOut(IToX(i) + 2, JToY(j) + 2, ' ' + IntToStr(fLei));
    end;
  end;
end;

procedure TFormMain.MainPaintBoxMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  i, j: Integer;
begin
  if MenuHelpGame.Checked then
    exit;
  if (fX >= MainPaintBox.Width - 5) or (fY >= MainPaintBox.Height - 5) then
    exit;
  i := XToI(fX);
  j := YToJ(fY);
  LeftDown := false;
  RightDown := false;
  try
    if CanShowRound then
    begin
      if MenuSetMouse.Checked then
        UnLockMouse();
      ReShow(XToI(fX), YToJ(fY));
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
      if GetDataOP(i, j) = OP_YES then
      begin
        SetDataOp(i, j, OP_NO);
        Dec(UserTotals);
      end
      else
      begin
        SetDataOp(i, j, OP_YES);
        inc(UserTotals);
      end;
      PanelLeft.Caption := IntToStr(TotalLei - UserTotals);
      if CheckGame then
      begin
        GameSuccess;
        exit;
      end;
      ShowOneData(i, j);
    end
    else if (Button = mbLeft) and (GetDataShow(i, j) = SHOW_NO) and (GetDataOP(i, j) = OP_NO) then
    begin
      if data[i, j].fLei = LEI then
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

procedure TFormMain.MainPaintBoxMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if MenuHelpGame.Checked then
    exit;
  fX := X;
  fY := Y;
  if (fX >= MainPaintBox.Width - 5) or (fY >= MainPaintBox.Height - 5) then
    exit;
  if (LeftDown and (Button = mbRight)) or (RightDown and (Button = mbLeft)) then
  begin
    LeftDown := false;
    RightDown := false;
    CanShowRound := true;
    if MenuSetMouse.Checked then
      LockMouse();
    ToShow(XToI(fX), YToJ(fY));
    exit;
  end;
  if Button = mbLeft then
    LeftDown := true;
  if Button = mbRight then
    RightDown := true;
  ToShowIJ(XToI(fX), YToJ(fY));
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
  i, j: Integer;
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
  i, j: Integer;
begin
  for i := 0 to X - 1 do
    for j := 0 to Y - 1 do
      ShowOneData(i, j);
end;

procedure TFormMain.ShowOneData(i, j: Integer);
begin
  with MainPaintBox.Canvas do
  begin
    if (GetDataShow(i, j) = SHOW_NO) and (GetDataOP(i, j) = OP_NO) then
    begin
      Pen.Color := clGrid;
      Brush.Color := clSquare;
      Rectangle(IToX(i), JToY(j), IToX(i) + R, JToY(j) + R);
    end
    else if (GetDataShow(i, j) = SHOW_NO) and (GetDataOP(i, j) = OP_YES) then
    begin
      Pen.Color := clGrid;
      Brush.Color := clSquare;
      Rectangle(IToX(i), JToY(j), IToX(i) + R, JToY(j) + R);
      Pen.Color := clRed;
      Brush.Color := clRed;
      Rectangle(IToX(i) + R div 3, JToY(j) + R div 3, IToX(i) + R div 3 + R div 3, JToY(j) + R div 3 + R div 3);
    end
    else if GetDataShow(i, j) = SHOW_YES then
    begin
      Pen.Color := clGrid;
      Brush.Color := clBackGround;
      Rectangle(IToX(i), JToY(j), IToX(i) + R, JToY(j) + R);
      ShowString(IToX(i), JToY(j), IntToStr(NumberOfPoint(i, j)));
    end;
    if MenuHelpGame.Checked and (GetDataLei(i, j) = LEI) then
    begin
      Pen.Color := clGrid;
      Brush.Color := clRed;
      Rectangle(IToX(i), JToY(j), IToX(i) + R, JToY(j) + R);
    end;
  end;
end;

procedure TFormMain.ShowRound(i, j: Integer);
var
  CanShowRound: boolean;
  data: array [1 .. 8] of boolean;
  points: array [1 .. 8] of TPoint;
  num, k: Integer;
begin
  CanShowRound := false;
  num := 0;
  if (GetDataShow(i, j) = SHOW_NO) then
    exit;
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
    if (points[k].X >= 0) and (points[k].X <= X - 1) and (points[k].Y >= 0) and (points[k].Y <= Y - 1) and (GetDataOP(points[k].X, points[k].Y) = OP_YES) then
    begin
      CanShowRound := true;
      data[k] := true;
      inc(num);
    end
    else
      data[k] := false;
  end;
  if num <> NumberOfPoint(i, j) then
    CanShowRound := false;
  if not CanShowRound then
    exit;
  if (data[1] and (GetDataLei(i - 1, j - 1) <> LEI)) or (data[2] and (GetDataLei(i, j - 1) <> LEI)) or (data[3] and (GetDataLei(i + 1, j - 1) <> LEI)) or
    (data[4] and (GetDataLei(i - 1, j) <> LEI)) or (data[5] and (GetDataLei(i + 1, j) <> LEI)) or (data[6] and (GetDataLei(i - 1, j + 1) <> LEI)) or
    (data[7] and (GetDataLei(i, j + 1) <> LEI)) or (data[8] and (GetDataLei(i + 1, j + 1) <> LEI)) then
  begin
    GameOver;
  end
  else
  begin
    for k := Low(points) to High(points) do
    begin
      if (not data[k]) and (points[k].X >= 0) and (points[k].X <= X - 1) and (points[k].Y >= 0) and (points[k].Y <= Y - 1) and
        (GetDataShow(points[k].X, points[k].Y) <> SHOW_YES) then
      begin
        InitTemp;
        ShowNumber(points[k].X, points[k].Y);
        ShowTemp;
      end;
    end;
  end;
end;

procedure TFormMain.SBStartClick(Sender: TObject);
begin
  GameStart;
end;

procedure TFormMain.ShowString(X, Y: Integer; s: string);
begin
  if (GetDataOP(XToI(X), YToJ(Y)) = OP_YES) then
    exit;
  with MainPaintBox.Canvas do
  begin
    Pen.Color := clBlack;
    Brush.Color := CLBTNFACE;
    Rectangle(X, Y, X + R, Y + R);
    if s = '0' then
      s := '';
    s := ' ' + s;
    Font.Size := 12;
    TextOut(X + 2, Y + 2, s);
  end;
  SetDataShow(XToI(X), YToJ(Y), SHOW_YES);
end;

procedure TFormMain.ShowNumber(i, j: Integer);
var
  m, n: Integer;
  points: array [1 .. 8] of TPoint;
begin
  n := NumberOfPoint(i, j);
  ShowString(IToX(i), JToY(j), IntToStr(n));
  if n = 0 then
  begin
    if InTemp(i, j) then
      exit
    else
    begin
      AddToTemp(i, j);
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
      for m := Low(points) to High(points) do
        if (points[m].X >= 0) and (points[m].X <= X - 1) and (points[m].Y >= 0) and (points[m].Y <= Y - 1) and (NumberOfPoint(points[m].X, points[m].Y) = 0)
        then
          ShowNumber(points[m].X, points[m].Y);
    end;
  end;
end;

procedure TFormMain.ShowTemp;
var
  k, i, j, l: Integer;
  points: array [1 .. 8] of TPoint;
begin
  for k := 0 to NowTempPosition do
  begin
    i := XToI(temp[k].X);
    j := YToJ(temp[k].Y);
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
    for l := Low(points) to High(points) do
    begin
      if (points[l].X >= 0) and (points[l].X <= X - 1) and (points[l].Y >= 0) and (points[l].Y <= Y - 1) and (data[points[l].X][points[l].Y].fLei <> LEI) then
        ShowString(IToX(points[l].X), JToY(points[l].Y), IntToStr(NumberOfPoint(points[l].X, points[l].Y)));
    end;
  end;
end;

procedure TFormMain.TimerDelayTimer(Sender: TObject);
begin
  inc(TimeDelay);
  PanelTimeDelay.Caption := IntToStr(TimeDelay);
end;

procedure TFormMain.ToShow(i, j: Integer);
var
  l, m, n, p, q: Integer;
  points: array [1 .. 8] of TPoint;
begin
  fShowNum := 0;
  fOpNum := 0;
  ToShowIJ(i, j);
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
  for l := Low(points) to High(points) do
  begin
    m := points[l].X;
    n := points[l].Y;
    if (m <= X - 1) and (m >= 0) and (n <= Y - 1) and (n >= 0) and (GetDataShow(m, n) = SHOW_NO) then
    begin
      if GetDataOP(m, n) = OP_NO then
      begin
        inc(fShowNum);
        p := IToX(m);
        q := JToY(n);
        with MainPaintBox do
        begin
          Canvas.Pen.Color := clPressed;
          Canvas.Brush.Color := clPressed;
          Canvas.Rectangle(p, q, p + R, q + R);
        end;
      end
      else
        inc(fOpNum);
    end;
  end;
end;

procedure TFormMain.ToShowIJ(i, j: Integer);
begin
  if (GetDataShow(i, j) = SHOW_NO) and (GetDataOP(i, j) = OP_NO) then
  begin
    with MainPaintBox.Canvas do
    begin
      Pen.Color := clPressed;
      Brush.Color := clPressed;
      Rectangle(IToX(i), JToY(j), IToX(i) + R, JToY(j) + R);
    end;
  end
  else if GetDataOP(i, j) = OP_NO then
  begin
    fLei := NumberOfPoint(i, j);
    with MainPaintBox.Canvas do
    begin
      Pen.Color := clBlack;
      Brush.Color := clWhite;
      Rectangle(IToX(i), JToY(j), IToX(i) + R, JToY(j) + R);
      Font.Color := clBlack;
      Font.Size := 12;
      if fLei = 0 then
        TextOut(IToX(i) + 2, JToY(j) + 2, ' ')
      else
        TextOut(IToX(i) + 2, JToY(j) + 2, ' ' + IntToStr(fLei));
    end;
  end;
end;

procedure TFormMain.AddToTemp(i, j: Integer);
begin
  inc(NowTempPosition);
  temp[NowTempPosition].X := IToX(i);
  temp[NowTempPosition].Y := JToY(j);
  ShowNumber(i, j);
end;

function TFormMain.InTemp(i, j: Integer): boolean;
var
  k: Integer;
begin
  result := false;
  for k := 0 to NowTempPosition do
    if (temp[k].X = IToX(i)) and (temp[k].Y = JToY(j)) then
    begin
      result := true;
      exit;
    end;
end;

procedure TFormMain.InitTemp;
var
  i: Integer;
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
  userLei, userX, userY: Integer;
begin
  if MessageBox(Self.Handle, '要结束本局游戏，确定吗？', '注意', MB_OKCANCEL) <> ID_OK then
    exit;
  try
    userX := StrToInt(InputBox('信息', '请输入横向格子数目：             ', IntToStr(X)));
  except
    MessageBox(Self.Handle, '您输入的数据非法，将使用默认值!', '出错', MB_OK or MB_ICONERROR);
    userX := 20;
  end;
  try
    userY := StrToInt(InputBox('信息', '请输入纵向格子数目：              ', IntToStr(Y)));
  except
    MessageBox(Self.Handle, '您输入的数据非法，将使用默认值!', '出错', MB_OK or MB_ICONERROR);
    userY := 10;
  end;
  try
    userLei := StrToInt(InputBox('信息', '请输入地雷数目：           ', IntToStr(TotalLei)));
    if userLei > userX * userY then
    begin
      MessageBox(Self.Handle, '输入的地雷数目超出最大数目，将使用最大值.', '注意', MB_OK or MB_ICONINFORMATION);
      userLei := userX * userY;
    end;
  except
    MessageBox(Self.Handle, '您输入的数据非法，将使用默认值!', '出错', MB_OK or MB_ICONERROR);
    userLei := 20;
  end;
  TotalLei := userLei;
  X := userX;
  Y := userY;
  MessageBox(Self.Handle, PChar('开始启动自定义游戏：' + #$D + #$A + #$D + #$A + '横向格子数目：' + IntToStr(X) + #$D + #$A + '纵向格子数目：' + IntToStr(Y) + #$D + #$A + '地雷数目：' +
    IntToStr(TotalLei)), '信息', MB_OK or MB_ICONINFORMATION);
  GameEnd;
  GameStart;
  FormResize(Sender);
end;

procedure TFormMain.LockMouse;
var
  pos: TPoint;
begin
  GetCursorPos(pos);
  FMouseRect.Left := pos.X;
  FMouseRect.Top := pos.Y;
  FMouseRect.Right := FMouseRect.Left + 1;
  FMouseRect.Bottom := FMouseRect.Top + 1;
  ClipCursor(@FMouseRect);
end;

procedure TFormMain.UnLockMouse;
begin
  FMouseRect.Left := 0;
  FMouseRect.Top := 0;
  FMouseRect.Right := Screen.Width;
  FMouseRect.Bottom := Screen.Height;
  ClipCursor(@FMouseRect);
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

program SaoLei;

uses
  Forms,
  MainUnit in 'MainUnit.pas' {FormMain},
  MyGameUnit in 'MyGameUnit.pas',
  UnitColor in 'UnitColor.pas' {FormColor};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'É¨À×ÓÎÏ·';
  Application.CreateForm(TFormMain, FormMain);
  Application.Run;
end.


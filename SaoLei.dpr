program SaoLei;

uses
  Forms,
  Main in 'Main.pas' {FormMain},
  Game in 'Game.pas',
  Color in 'Color.pas' {FormColor};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'ɨ����Ϸ';
  Application.CreateForm(TFormMain, FormMain);
  Application.Run;
end.


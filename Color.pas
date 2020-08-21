unit Color;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Buttons;

type
  TFormColor = class(TForm)
    BitBtnOK: TBitBtn;
    PanelMain: TPanel;
    CBSquare: TColorBox;
    CBBackGround: TColorBox;
    CBGrid: TColorBox;
    CBPressed: TColorBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    BitBtnCancel: TBitBtn;
    BitBtnDefault: TBitBtn;
    procedure BitBtnOKClick(Sender: TObject);
    procedure BitBtnDefaultClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormColor: TFormColor;

implementation

uses Game;

{$R *.dfm}

procedure TFormColor.BitBtnDefaultClick(Sender: TObject);
begin
  clSquare := clGreen;
  clBackGround := clBtnFace;
  clGrid := clBlack;
  clPressed := clBlack;
  Close;
end;

procedure TFormColor.BitBtnOKClick(Sender: TObject);
begin
  clSquare := CBSquare.Selected;
  clBackGround := CBBackGround.Selected;
  clGrid := CBGrid.Selected;
  clPressed := CBPressed.Selected;
end;

end.

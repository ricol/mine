object FormColor: TFormColor
  Left = 366
  Top = 154
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = #39068#33394
  ClientHeight = 179
  ClientWidth = 370
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object BitBtnOK: TBitBtn
    Left = 263
    Top = 16
    Width = 89
    Height = 32
    Caption = #30830#23450
    TabOrder = 1
    OnClick = BitBtnOKClick
    Kind = bkOK
  end
  object PanelMain: TPanel
    Left = 8
    Top = 8
    Width = 235
    Height = 161
    TabOrder = 2
    object Label1: TLabel
      Left = 24
      Top = 16
      Width = 26
      Height = 13
      Caption = #26041#22359
    end
    object Label2: TLabel
      Left = 24
      Top = 56
      Width = 26
      Height = 13
      Caption = #32972#26223
    end
    object Label3: TLabel
      Left = 24
      Top = 91
      Width = 26
      Height = 13
      Caption = #26684#23376
    end
    object Label4: TLabel
      Left = 24
      Top = 128
      Width = 26
      Height = 13
      Caption = #25353#19979
    end
    object CBSquare: TColorBox
      Left = 72
      Top = 14
      Width = 145
      Height = 22
      ItemHeight = 16
      TabOrder = 0
    end
    object CBBackGround: TColorBox
      Left = 72
      Top = 51
      Width = 145
      Height = 22
      ItemHeight = 16
      TabOrder = 1
    end
    object CBGrid: TColorBox
      Left = 72
      Top = 88
      Width = 145
      Height = 22
      ItemHeight = 16
      TabOrder = 2
    end
    object CBPressed: TColorBox
      Left = 72
      Top = 126
      Width = 145
      Height = 22
      ItemHeight = 16
      TabOrder = 3
    end
  end
  object BitBtnCancel: TBitBtn
    Left = 263
    Top = 73
    Width = 89
    Height = 32
    Cancel = True
    Caption = #21462#28040
    Default = True
    ModalResult = 2
    TabOrder = 0
    Glyph.Data = {
      DE010000424DDE01000000000000760000002800000024000000120000000100
      0400000000006801000000000000000000001000000000000000000000000000
      80000080000000808000800000008000800080800000C0C0C000808080000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
      333333333333333333333333000033338833333333333333333F333333333333
      0000333911833333983333333388F333333F3333000033391118333911833333
      38F38F333F88F33300003339111183911118333338F338F3F8338F3300003333
      911118111118333338F3338F833338F3000033333911111111833333338F3338
      3333F8330000333333911111183333333338F333333F83330000333333311111
      8333333333338F3333383333000033333339111183333333333338F333833333
      00003333339111118333333333333833338F3333000033333911181118333333
      33338333338F333300003333911183911183333333383338F338F33300003333
      9118333911183333338F33838F338F33000033333913333391113333338FF833
      38F338F300003333333333333919333333388333338FFF830000333333333333
      3333333333333333333888330000333333333333333333333333333333333333
      0000}
    NumGlyphs = 2
  end
  object BitBtnDefault: TBitBtn
    Left = 263
    Top = 128
    Width = 89
    Height = 32
    Caption = #40664#35748
    TabOrder = 3
    OnClick = BitBtnDefaultClick
    Kind = bkIgnore
  end
end

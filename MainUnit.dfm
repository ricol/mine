object FormMain: TFormMain
  Left = 146
  Top = 115
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = #25195#38647
  ClientHeight = 324
  ClientWidth = 537
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -35
  Font.Name = #23435#20307
  Font.Style = []
  KeyPreview = True
  Menu = MainMenuGame
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 35
  object PanelMain: TPanel
    Left = 0
    Top = 0
    Width = 537
    Height = 305
    Align = alClient
    BevelOuter = bvLowered
    TabOrder = 0
    object PanelHead: TPanel
      Left = 16
      Top = 16
      Width = 505
      Height = 37
      BevelOuter = bvLowered
      TabOrder = 0
      object SBStart: TSpeedButton
        Left = 235
        Top = 4
        Width = 46
        Height = 29
        Caption = #24320#22987
        Flat = True
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = #23435#20307
        Font.Style = []
        ParentFont = False
        OnClick = SBStartClick
      end
      object PanelTimeDelay: TPanel
        Left = 472
        Top = 1
        Width = 32
        Height = 35
        Align = alRight
        Color = clNavy
        Font.Charset = ANSI_CHARSET
        Font.Color = clLime
        Font.Height = -13
        Font.Name = #23435#20307
        Font.Style = []
        ParentBackground = False
        ParentFont = False
        TabOrder = 0
      end
      object PanelLeft: TPanel
        Left = 1
        Top = 1
        Width = 32
        Height = 35
        Align = alLeft
        Color = clNavy
        Font.Charset = ANSI_CHARSET
        Font.Color = clLime
        Font.Height = -13
        Font.Name = #23435#20307
        Font.Style = []
        ParentBackground = False
        ParentFont = False
        TabOrder = 1
      end
    end
    object PanelClient: TPanel
      Left = 16
      Top = 60
      Width = 505
      Height = 229
      BevelOuter = bvNone
      TabOrder = 1
      object MainPaintBox: TPaintBox
        Left = 0
        Top = 0
        Width = 505
        Height = 229
        Align = alClient
        OnMouseDown = MainPaintBoxMouseDown
        OnMouseUp = MainPaintBoxMouseUp
        OnPaint = MainPaintBoxPaint
      end
    end
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 305
    Width = 537
    Height = 19
    Panels = <
      item
        Width = 50
      end>
  end
  object MainMenuGame: TMainMenu
    Left = 25
    Top = 64
    object MenuGame: TMenuItem
      Caption = #28216#25103
      object MenuGameStart: TMenuItem
        Caption = #24320#23616
        OnClick = MenuGameStartClick
      end
      object MenuGameSeperator1: TMenuItem
        Caption = '-'
      end
      object MenuGameLow: TMenuItem
        Caption = #21021#32423
        OnClick = MenuGameLowClick
      end
      object MenuGameMedium: TMenuItem
        Caption = #20013#32423
        OnClick = MenuGameMediumClick
      end
      object MenuGameHigh: TMenuItem
        Caption = #39640#32423
        OnClick = MenuGameHighClick
      end
      object MenuGameSelf: TMenuItem
        Caption = #33258#23450#20041
        OnClick = MenuGameSelfClick
      end
      object MenuGameSeperator3: TMenuItem
        Caption = '-'
      end
      object MenuGameTop: TMenuItem
        Caption = #25195#38647#33521#38596#27036
        OnClick = MenuGameTopClick
      end
      object MenuGameSeperator4: TMenuItem
        Caption = '-'
      end
      object MenuGameExit: TMenuItem
        Caption = #36864#20986
        OnClick = MenuGameExitClick
      end
    end
    object MenuAdvance: TMenuItem
      Caption = #39640#32423
      object MenuHelpGame: TMenuItem
        Caption = #26174#31034#38647#21306
        OnClick = MenuHelpGameClick
      end
      object MenuAutoShow: TMenuItem
        Caption = #33258#21160#26631#27880
        Checked = True
        OnClick = MenuAutoShowClick
      end
      object MenuSetMouse: TMenuItem
        Caption = #31934#30830#23450#20301
        OnClick = MenuSetMouseClick
      end
      object MenuColorSet: TMenuItem
        Caption = #39068#33394#35774#32622
        OnClick = MenuColorSetClick
      end
    end
    object MenuHelp: TMenuItem
      Caption = #24110#21161
      object MenuHelpAbout: TMenuItem
        Caption = #20851#20110#25195#38647
        OnClick = MenuHelpAboutClick
      end
    end
  end
  object TimerDelay: TTimer
    Enabled = False
    OnTimer = TimerDelayTimer
    Left = 72
    Top = 64
  end
end

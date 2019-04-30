object Form1: TForm1
  Left = 346
  Height = 148
  Top = 250
  Width = 481
  BorderStyle = bsSingle
  Caption = 'Gitea Panel'
  ClientHeight = 148
  ClientWidth = 481
  OnCreate = FormCreate
  Position = poDesktopCenter
  LCLVersion = '6.7'
  object Label1: TLabel
    Left = 9
    Height = 17
    Top = 8
    Width = 67
    Caption = 'Gitea patch:'
    ParentColor = False
  end
  object GiteaPatch: TFileNameEdit
    Left = 9
    Height = 29
    Top = 32
    Width = 463
    FilterIndex = 0
    HideDirectories = False
    ButtonWidth = 23
    NumGlyphs = 1
    MaxLength = 0
    TabOrder = 0
  end
  object ButtonPanel1: TButtonPanel
    Left = 6
    Height = 39
    Top = 103
    Width = 469
    OKButton.Name = 'OKButton'
    OKButton.DefaultCaption = True
    OKButton.OnClick = OKButtonClick
    HelpButton.Name = 'HelpButton'
    HelpButton.DefaultCaption = True
    CloseButton.Name = 'CloseButton'
    CloseButton.DefaultCaption = True
    CancelButton.Name = 'CancelButton'
    CancelButton.DefaultCaption = True
    CancelButton.OnClick = CancelButtonClick
    TabOrder = 1
    ShowButtons = [pbOK, pbCancel]
  end
  object Label2: TLabel
    Left = 9
    Height = 17
    Top = 72
    Width = 50
    Caption = 'Browser:'
    ParentColor = False
  end
  object EditBrows: TEdit
    Left = 72
    Height = 29
    Top = 68
    Width = 400
    TabOrder = 2
    Text = 'firefox'
  end
  object Process1: TProcess
    Active = False
    Options = []
    Priority = ppNormal
    StartupOptions = []
    ShowWindow = swoNone
    WindowColumns = 0
    WindowHeight = 0
    WindowLeft = 0
    WindowRows = 0
    WindowTop = 0
    WindowWidth = 0
    FillAttribute = 0
    Left = 8
    Top = 112
  end
  object TrayIcon1: TTrayIcon
    PopUpMenu = PopupMenu1
    Left = 48
    Top = 112
  end
  object PopupMenu1: TPopupMenu
    Left = 88
    Top = 112
    object MenuStart: TMenuItem
      Caption = 'Start Gitea'
    end
    object MenuStop: TMenuItem
      Caption = 'Stop Gitea'
    end
    object MenuItem3: TMenuItem
      Caption = '-'
    end
    object MenuOpenGitea: TMenuItem
      Caption = 'Open Gitea...'
    end
    object MenuSetting: TMenuItem
      Caption = 'Setting'
      OnClick = MenuSettingClick
    end
    object MenuItem5: TMenuItem
      Caption = '-'
    end
    object MenuClose: TMenuItem
      Caption = 'Close'
      OnClick = MenuCloseClick
    end
  end
  object ImageList1: TImageList
    Left = 128
    Top = 112
  end
end

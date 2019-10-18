object FormUpdGitea: TFormUpdGitea
  Left = 86
  Height = 98
  Top = 85
  Width = 470
  AutoSize = True
  BorderStyle = bsSingle
  Caption = 'Update Gitea'
  ClientHeight = 98
  ClientWidth = 470
  Constraints.MinWidth = 470
  OnShow = FormShow
  Position = poDesktopCenter
  LCLVersion = '6.9'
  object Label1: TLabel
    Left = 6
    Height = 16
    Top = 6
    Width = 458
    Align = alTop
    BorderSpacing.Around = 6
    Caption = 'Current version of Gitea:'
    ParentColor = False
  end
  object ProgressBar1: TProgressBar
    Left = 6
    Height = 24
    Top = 50
    Width = 458
    Align = alTop
    BorderSpacing.Around = 6
    Smooth = True
    TabOrder = 0
    Visible = False
  end
  object Label2: TLabel
    Left = 6
    Height = 16
    Top = 28
    Width = 458
    Align = alTop
    BorderSpacing.Around = 6
    Caption = '  '
    ParentColor = False
  end
  object Panel1: TPanel
    Left = 6
    Height = 40
    Top = 80
    Width = 458
    Align = alTop
    BorderSpacing.Left = 6
    BorderSpacing.Right = 6
    BorderSpacing.Bottom = 6
    BevelOuter = bvNone
    ClientHeight = 40
    ClientWidth = 458
    ParentColor = False
    TabOrder = 1
    object BitBtnUpd: TBitBtn
      Left = 374
      Height = 32
      Top = 4
      Width = 80
      Align = alRight
      AutoSize = True
      BorderSpacing.Around = 4
      Caption = '&Update'
      Constraints.MinWidth = 60
      Kind = bkYes
      ModalResult = 6
      OnClick = BitBtnUpdClick
      TabOrder = 0
      Visible = False
    end
    object BitBtnCancel: TBitBtn
      Left = 294
      Height = 32
      Top = 4
      Width = 76
      Align = alRight
      AutoSize = True
      BorderSpacing.Around = 4
      Cancel = True
      Caption = '&Cancel'
      Constraints.MinWidth = 60
      Kind = bkNo
      ModalResult = 7
      OnClick = BitBtnCancelClick
      TabOrder = 1
      Visible = False
    end
    object BitBtnOk: TBitBtn
      Left = 230
      Height = 32
      Top = 4
      Width = 60
      Align = alRight
      AutoSize = True
      BorderSpacing.Around = 4
      Constraints.MinWidth = 60
      Default = True
      DefaultCaption = True
      Kind = bkOK
      ModalResult = 1
      OnClick = BitBtnOkClick
      TabOrder = 2
      Visible = False
    end
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 500
    OnTimer = CheckUpdateDownload
    Left = 344
    Top = 8
  end
end

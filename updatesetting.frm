object Form3: TForm3
  Left = 367
  Height = 296
  Top = 30
  Width = 319
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Update setting'
  ClientHeight = 296
  ClientWidth = 319
  OnShow = FormShow
  Position = poMainFormCenter
  ShowHint = True
  LCLVersion = '6.9'
  object GroupBox1: TGroupBox
    Left = 8
    Height = 184
    Top = 72
    Width = 304
    Caption = 'Proxy settings'
    ClientHeight = 167
    ClientWidth = 302
    Enabled = False
    TabOrder = 0
    object Label1: TLabel
      Left = 10
      Height = 16
      Top = 54
      Width = 29
      Caption = 'Port:'
      ParentColor = False
    end
    object EditProxyPort: TSpinEdit
      Left = 100
      Height = 26
      Top = 48
      Width = 195
      Alignment = taRightJustify
      MaxValue = 100000
      MinValue = 10
      TabOrder = 0
      Value = 10
    end
    object Label4: TLabel
      Left = 10
      Height = 16
      Top = 14
      Width = 31
      Caption = 'Host:'
      ParentColor = False
    end
    object Label5: TLabel
      Left = 10
      Height = 16
      Top = 94
      Width = 30
      Caption = 'User:'
      ParentColor = False
    end
    object Label6: TLabel
      Left = 10
      Height = 16
      Top = 134
      Width = 61
      Caption = 'Password:'
      ParentColor = False
    end
    object EditProxyHost: TEdit
      Left = 100
      Height = 26
      Top = 8
      Width = 195
      TabOrder = 1
    end
    object EditProxyUser: TEdit
      Left = 100
      Height = 26
      Top = 88
      Width = 195
      TabOrder = 2
    end
    object EditProxyPass: TEdit
      Left = 100
      Height = 26
      Top = 128
      Width = 195
      TabOrder = 3
    end
  end
  object CheckBoxUseProxy: TCheckBox
    Left = 8
    Height = 22
    Top = 40
    Width = 84
    Caption = 'Use Proxy'
    OnChange = CheckBoxUseProxyChange
    TabOrder = 1
  end
  object Label2: TLabel
    Left = 8
    Height = 16
    Top = 13
    Width = 104
    Caption = 'OS Identification:'
    ParentColor = False
  end
  object CoBoxOsIdent: TComboBox
    Left = 128
    Height = 28
    Hint = 'Specify the OS to download Gitea'#10'in addiction to your real OS.'
    Top = 8
    Width = 184
    Constraints.MinHeight = 28
    DropDownCount = 12
    ItemHeight = 0
    Items.Strings = (
      'linux,386'
      'linux,amd64'
      'linux,arm-5'
      'linux,arm-6'
      'linux,arm64'
      'linux,mips'
      'linux,mips64le'
      'linux,mipsle'
      'darwin,386'
      'darwin,amd64'
      'windows,386'
      'windows,amd64'
    )
    Style = csDropDownList
    TabOrder = 2
  end
  object ButtonPanel1: TButtonPanel
    Left = 6
    Height = 34
    Top = 256
    Width = 307
    OKButton.Name = 'OKButton'
    OKButton.DefaultCaption = True
    OKButton.OnClick = OKButtonClick
    HelpButton.Name = 'HelpButton'
    HelpButton.DefaultCaption = True
    CloseButton.Name = 'CloseButton'
    CloseButton.DefaultCaption = True
    CancelButton.Name = 'CancelButton'
    CancelButton.DefaultCaption = True
    TabOrder = 3
    ShowButtons = [pbOK, pbClose]
    ShowBevel = False
  end
end

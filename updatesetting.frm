object UpdSettingForm: TUpdSettingForm
  Left = 367
  Height = 281
  Top = 30
  Width = 325
  AutoSize = True
  BorderIcons = []
  BorderStyle = bsSingle
  Caption = 'Update setting'
  ClientHeight = 281
  ClientWidth = 325
  Constraints.MinWidth = 325
  OnShow = FormShow
  Position = poMainFormCenter
  ShowHint = True
  LCLVersion = '6.9'
  object GroupBox1: TGroupBox
    AnchorSideLeft.Control = Owner
    AnchorSideTop.Control = CheckBoxUseProxy
    AnchorSideTop.Side = asrBottom
    AnchorSideRight.Control = Owner
    AnchorSideRight.Side = asrBottom
    Left = 6
    Height = 163
    Top = 69
    Width = 313
    Anchors = [akTop, akLeft, akRight]
    BorderSpacing.Around = 6
    Caption = 'Proxy settings'
    ChildSizing.LeftRightSpacing = 6
    ChildSizing.EnlargeHorizontal = crsScaleChilds
    ChildSizing.EnlargeVertical = crsHomogenousSpaceResize
    ChildSizing.Layout = cclLeftToRightThenTopToBottom
    ChildSizing.ControlsPerLine = 2
    ClientHeight = 146
    ClientWidth = 311
    Enabled = False
    TabOrder = 0
    object Label4: TLabel
      Left = 6
      Height = 16
      Top = 13
      Width = 31
      BorderSpacing.CellAlignHorizontal = ccaLeftTop
      BorderSpacing.CellAlignVertical = ccaCenter
      Caption = 'Host:'
      ParentColor = False
    end
    object EditProxyHost: TEdit
      AnchorSideLeft.Side = asrBottom
      AnchorSideRight.Side = asrBottom
      Left = 93
      Height = 28
      Top = 7
      Width = 212
      AutoSize = False
      Constraints.MinWidth = 150
      TabOrder = 1
    end
    object Label1: TLabel
      Left = 6
      Height = 16
      Top = 48
      Width = 29
      BorderSpacing.CellAlignHorizontal = ccaLeftTop
      BorderSpacing.CellAlignVertical = ccaCenter
      Caption = 'Port:'
      ParentColor = False
    end
    object EditProxyPort: TSpinEdit
      AnchorSideRight.Side = asrBottom
      Left = 93
      Height = 28
      Top = 42
      Width = 212
      Alignment = taRightJustify
      AutoSize = False
      MaxValue = 100000
      MinValue = 10
      TabOrder = 0
      Value = 10
    end
    object Label5: TLabel
      Left = 6
      Height = 16
      Top = 83
      Width = 30
      BorderSpacing.CellAlignHorizontal = ccaLeftTop
      BorderSpacing.CellAlignVertical = ccaCenter
      Caption = 'User:'
      ParentColor = False
    end
    object EditProxyUser: TEdit
      AnchorSideRight.Side = asrBottom
      Left = 93
      Height = 28
      Top = 77
      Width = 212
      AutoSize = False
      Constraints.MinWidth = 150
      TabOrder = 2
    end
    object Label6: TLabel
      Left = 6
      Height = 16
      Top = 118
      Width = 61
      BorderSpacing.CellAlignHorizontal = ccaLeftTop
      BorderSpacing.CellAlignVertical = ccaCenter
      Caption = 'Password:'
      ParentColor = False
    end
    object EditProxyPass: TEdit
      AnchorSideRight.Side = asrBottom
      Left = 93
      Height = 28
      Top = 112
      Width = 212
      AutoSize = False
      Constraints.MinWidth = 150
      EchoMode = emPassword
      PasswordChar = '*'
      TabOrder = 3
    end
  end
  object CheckBoxUseProxy: TCheckBox
    AnchorSideLeft.Control = Owner
    AnchorSideTop.Control = CoBoxOsIdent
    AnchorSideTop.Side = asrBottom
    AnchorSideRight.Control = Owner
    AnchorSideRight.Side = asrBottom
    Left = 6
    Height = 23
    Top = 40
    Width = 313
    Anchors = [akTop, akLeft, akRight]
    BorderSpacing.Around = 6
    Caption = 'Use Proxy'
    OnChange = CheckBoxUseProxyChange
    TabOrder = 1
  end
  object Label2: TLabel
    AnchorSideLeft.Control = Owner
    AnchorSideTop.Control = CoBoxOsIdent
    AnchorSideTop.Side = asrCenter
    Left = 8
    Height = 16
    Top = 12
    Width = 104
    BorderSpacing.Around = 8
    Caption = 'OS Identification:'
    ParentColor = False
  end
  object CoBoxOsIdent: TComboBox
    AnchorSideLeft.Control = Label2
    AnchorSideLeft.Side = asrBottom
    AnchorSideTop.Control = Owner
    AnchorSideRight.Control = Owner
    AnchorSideRight.Side = asrBottom
    Left = 120
    Height = 28
    Hint = 'Specify the OS to download Gitea'#10'in addiction to your real OS.'
    Top = 6
    Width = 199
    Anchors = [akTop, akLeft, akRight]
    AutoSize = False
    BorderSpacing.Around = 6
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
    AnchorSideLeft.Control = Owner
    AnchorSideTop.Control = GroupBox1
    AnchorSideTop.Side = asrBottom
    AnchorSideRight.Control = Owner
    AnchorSideRight.Side = asrBottom
    Left = 6
    Height = 34
    Top = 238
    Width = 313
    Align = alNone
    Anchors = [akTop, akLeft, akRight]
    Constraints.MaxHeight = 34
    Constraints.MinHeight = 34
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

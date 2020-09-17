object AboutForm: TAboutForm
  AnchorSideRight.Side = asrBottom
  Left = 303
  Height = 209
  Top = 30
  Width = 402
  AutoSize = True
  BorderIcons = []
  BorderStyle = bsSingle
  Caption = 'About Gitea Panel'
  ClientHeight = 209
  ClientWidth = 402
  OnClose = FormClose
  OnShow = FormShow
  Position = poDesktopCenter
  LCLVersion = '7.2'
  object Image1: TImage
    AnchorSideLeft.Side = asrBottom
    Left = 16
    Height = 144
    Top = 16
    Width = 144
    BorderSpacing.Left = 16
    BorderSpacing.Top = 16
    Stretch = True
  end
  object Label1: TLabel
    AnchorSideLeft.Control = Image1
    AnchorSideLeft.Side = asrBottom
    Left = 180
    Height = 1
    Top = 40
    Width = 1
    Alignment = taRightJustify
    BorderSpacing.Left = 20
    BorderSpacing.Top = 40
    ParentColor = False
  end
  object Label2: TLabel
    AnchorSideLeft.Control = Label1
    AnchorSideLeft.Side = asrBottom
    Left = 186
    Height = 1
    Top = 40
    Width = 1
    BorderSpacing.Left = 5
    BorderSpacing.Top = 40
    BorderSpacing.Right = 16
    ParentColor = False
  end
  object Label3: TLabel
    AnchorSideLeft.Control = Image1
    AnchorSideLeft.Side = asrBottom
    AnchorSideRight.Control = Label1
    AnchorSideRight.Side = asrBottom
    Left = 180
    Height = 1
    Top = 16
    Width = 1
    Alignment = taRightJustify
    Anchors = [akTop, akLeft, akRight]
    BorderSpacing.Left = 20
    Font.Height = -16
    Font.Name = 'TakaoPGothic'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
  end
  object Label4: TLabel
    AnchorSideLeft.Control = Label3
    AnchorSideLeft.Side = asrBottom
    AnchorSideRight.Control = Label2
    AnchorSideRight.Side = asrBottom
    Left = 186
    Height = 1
    Top = 16
    Width = 1
    Anchors = [akTop, akLeft, akRight]
    BorderSpacing.Left = 5
    Font.Height = -16
    Font.Name = 'TakaoPGothic'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
  end
  object Label5: TLabel
    AnchorSideLeft.Control = Owner
    AnchorSideLeft.Side = asrCenter
    Cursor = crHandPoint
    Left = 109
    Height = 19
    Top = 176
    Width = 185
    BorderSpacing.Bottom = 16
    Caption = 'Homepage in GitHub'
    Font.Height = -16
    Font.Name = 'TakaoPGothic'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
    OnClick = Label5Click
    OnMouseEnter = Label5MouseEnter
    OnMouseLeave = Label5MouseLeave
  end
end

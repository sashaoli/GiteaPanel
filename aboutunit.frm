object AboutForm: TAboutForm
  AnchorSideRight.Side = asrBottom
  Left = 303
  Height = 202
  Top = 30
  Width = 402
  BorderIcons = []
  BorderStyle = bsSingle
  Caption = 'About Gitea Panel'
  ClientHeight = 202
  ClientWidth = 402
  OnShow = FormShow
  Position = poDesktopCenter
  LCLVersion = '6.9'
  object Image1: TImage
    AnchorSideLeft.Side = asrBottom
    Left = 16
    Height = 144
    Top = 16
    Width = 144
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
    Left = 16
    Height = 1
    Top = 176
    Width = 1
    Font.Height = -13
    Font.Name = 'Sans'
    ParentColor = False
    ParentFont = False
    Visible = False
  end
end

object MainForm: TMainForm
  Left = 86
  Height = 467
  Top = 85
  Width = 608
  AutoSize = True
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Gitea Panel'
  ClientHeight = 467
  ClientWidth = 608
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnShow = FormShow
  ParentFont = True
  Position = poDefault
  ShowHint = True
  LCLVersion = '7.1'
  object GroupBox2: TGroupBox
    Left = 6
    Height = 145
    Top = 6
    Width = 596
    Align = alTop
    AutoSize = True
    BorderSpacing.Around = 6
    Caption = 'Gitea'
    ClientHeight = 128
    ClientWidth = 594
    TabOrder = 2
    object Label1: TLabel
      Left = 6
      Height = 16
      Top = 6
      Width = 582
      Align = alTop
      BorderSpacing.Around = 6
      Caption = 'Gitea path:'
      ParentColor = False
    end
    object EditGiteaPatch: TFileNameEdit
      Left = 6
      Height = 28
      Top = 28
      Width = 582
      DialogTitle = 'MOMOMO'
      FilterIndex = 0
      HideDirectories = False
      ButtonWidth = 28
      Constraints.MinWidth = 450
      NumGlyphs = 1
      Images = ImageList1
      ImageIndex = 0
      Align = alTop
      BorderSpacing.Around = 6
      Color = clDefault
      MaxLength = 0
      ParentColor = True
      Spacing = 0
      TabOrder = 0
      TextHint = 'Full path to Gitea'
    end
    object RButtDefPort: TRadioButton
      AnchorSideLeft.Control = GroupBox2
      AnchorSideTop.Control = EditPort
      AnchorSideTop.Side = asrCenter
      Left = 6
      Height = 23
      Hint = 'The default port is 3000'
      Top = 97
      Width = 101
      BorderSpacing.Around = 6
      Caption = 'Default port'
      Checked = True
      TabOrder = 1
      TabStop = True
    end
    object RButtSpecPort: TRadioButton
      AnchorSideLeft.Control = Label4
      AnchorSideTop.Control = EditPort
      AnchorSideTop.Side = asrCenter
      Left = 173
      Height = 23
      Top = 97
      Width = 110
      Caption = 'Specified port'
      OnChange = RButtPortChange
      TabOrder = 2
    end
    object EditPort: TSpinEdit
      AnchorSideLeft.Control = RButtSpecPort
      AnchorSideLeft.Side = asrBottom
      AnchorSideTop.Control = CoBoxProtocol
      AnchorSideTop.Side = asrBottom
      AnchorSideRight.Control = GroupBox2
      AnchorSideRight.Side = asrBottom
      Left = 289
      Height = 28
      Top = 94
      Width = 299
      Alignment = taRightJustify
      Anchors = [akTop, akLeft, akRight]
      BorderSpacing.Around = 6
      Enabled = False
      MaxValue = 100000
      MinValue = 80
      TabOrder = 3
      Value = 8080
    end
    object CoBoxProtocol: TComboBox
      AnchorSideLeft.Control = Label3
      AnchorSideLeft.Side = asrBottom
      AnchorSideTop.Control = EditGiteaPatch
      AnchorSideTop.Side = asrBottom
      AnchorSideRight.Control = Label4
      AnchorSideBottom.Side = asrBottom
      Left = 67
      Height = 26
      Top = 62
      Width = 100
      BorderSpacing.Top = 6
      BorderSpacing.Right = 6
      ItemHeight = 0
      Items.Strings = (
        'http://'
        'https://'
      )
      Style = csDropDownList
      TabOrder = 4
    end
    object Label3: TLabel
      AnchorSideLeft.Control = GroupBox2
      AnchorSideTop.Control = CoBoxProtocol
      AnchorSideTop.Side = asrCenter
      Left = 6
      Height = 16
      Top = 67
      Width = 55
      BorderSpacing.Around = 6
      Caption = 'Protocol:'
      ParentColor = False
    end
    object Label4: TLabel
      AnchorSideLeft.Control = CoBoxProtocol
      AnchorSideLeft.Side = asrBottom
      AnchorSideTop.Control = CoBoxProtocol
      AnchorSideTop.Side = asrCenter
      Left = 173
      Height = 16
      Top = 67
      Width = 31
      Caption = 'Host:'
      ParentColor = False
    end
    object EditHost: TEdit
      AnchorSideLeft.Control = Label4
      AnchorSideLeft.Side = asrBottom
      AnchorSideTop.Control = CoBoxProtocol
      AnchorSideTop.Side = asrCenter
      AnchorSideRight.Control = GroupBox2
      AnchorSideRight.Side = asrBottom
      Left = 210
      Height = 28
      Top = 61
      Width = 378
      Anchors = [akTop, akLeft, akRight]
      BorderSpacing.Around = 6
      ParentColor = True
      TabOrder = 5
      TextHint = 'Default: localhost'
    end
  end
  object GroupBox1: TGroupBox
    Left = 6
    Height = 144
    Top = 280
    Width = 596
    Align = alTop
    AutoSize = True
    BorderSpacing.Around = 6
    Caption = 'Browser'
    ClientHeight = 127
    ClientWidth = 594
    TabOrder = 1
    object RButtDefBrows: TRadioButton
      Left = 6
      Height = 23
      Top = 6
      Width = 582
      Align = alTop
      BorderSpacing.Around = 6
      Caption = 'Open Gitea default browser'
      Checked = True
      OnClick = RButtBrowsChange
      TabOrder = 0
      TabStop = True
    end
    object RButtSelBrows: TRadioButton
      Tag = 1
      AnchorSideTop.Control = RButtDefBrows
      AnchorSideTop.Side = asrBottom
      Left = 6
      Height = 23
      Top = 35
      Width = 146
      BorderSpacing.Around = 6
      Caption = 'In selected browser:'
      OnClick = RButtBrowsChange
      TabOrder = 1
    end
    object RButtOterBrows: TRadioButton
      Tag = 2
      AnchorSideTop.Control = RButtSelBrows
      AnchorSideTop.Side = asrBottom
      AnchorSideRight.Control = GroupBox1
      AnchorSideRight.Side = asrBottom
      Left = 6
      Height = 23
      Top = 64
      Width = 582
      Anchors = [akTop, akLeft, akRight]
      BorderSpacing.Around = 6
      Caption = 'Other browser. Please enter your browser path.'
      OnClick = RButtBrowsChange
      TabOrder = 2
    end
    object EditBrowsPath: TFileNameEdit
      AnchorSideTop.Control = RButtOterBrows
      AnchorSideTop.Side = asrBottom
      AnchorSideRight.Control = GroupBox1
      AnchorSideRight.Side = asrBottom
      Left = 6
      Height = 28
      Top = 93
      Width = 582
      FilterIndex = 0
      HideDirectories = False
      ButtonWidth = 28
      NumGlyphs = 1
      Images = ImageList1
      ImageIndex = 6
      Anchors = [akTop, akLeft, akRight]
      BorderSpacing.Around = 6
      Enabled = False
      MaxLength = 0
      Spacing = 0
      TabOrder = 3
      TextHint = 'Full path to your browser'
    end
    object CoBoxBrow: TComboBox
      AnchorSideLeft.Control = RButtSelBrows
      AnchorSideLeft.Side = asrBottom
      AnchorSideTop.Control = RButtSelBrows
      AnchorSideTop.Side = asrCenter
      AnchorSideRight.Control = GroupBox1
      AnchorSideRight.Side = asrBottom
      Left = 158
      Height = 30
      Top = 31
      Width = 430
      Anchors = [akTop, akLeft, akRight]
      BorderSpacing.Around = 6
      Enabled = False
      ItemHeight = 0
      Style = csDropDownList
      TabOrder = 4
    end
  end
  object BitBtn1: TBitBtn
    Left = 6
    Height = 30
    Top = 244
    Width = 596
    Align = alTop
    AutoSize = True
    BorderSpacing.Around = 6
    Caption = 'Update options'
    Images = ImageList1
    ImageIndex = 7
    OnClick = BtnUpdSettingClick
    TabOrder = 4
  end
  object ButtonPanel1: TButtonPanel
    Left = 6
    Height = 30
    Top = 430
    Width = 596
    Align = alTop
    OKButton.Name = 'OKButton'
    OKButton.DefaultCaption = True
    OKButton.OnClick = OKButtonClick
    HelpButton.Name = 'HelpButton'
    HelpButton.DefaultCaption = True
    CloseButton.Name = 'CloseButton'
    CloseButton.DefaultCaption = True
    CancelButton.Name = 'CancelButton'
    CancelButton.DefaultCaption = True
    TabOrder = 0
    ShowButtons = [pbOK, pbClose]
    ShowBevel = False
  end
  object CoBoxLang: TComboBox
    AnchorSideLeft.Control = ButtonPanel1
    AnchorSideTop.Control = ButtonPanel1
    AnchorSideTop.Side = asrCenter
    Left = 12
    Height = 30
    Hint = 'Language preferences will be applied after restarting the application.'#10'Click "OK" to save the setting.'
    Top = 430
    Width = 202
    BorderSpacing.Around = 6
    ItemHeight = 0
    OnChange = CoBoxLangChange
    Style = csDropDownList
    TabOrder = 3
  end
  object GroupBox3: TGroupBox
    Left = 6
    Height = 81
    Top = 157
    Width = 596
    Align = alTop
    AutoSize = True
    BorderSpacing.Around = 6
    Caption = 'Behavior'
    ChildSizing.LeftRightSpacing = 6
    ChildSizing.TopBottomSpacing = 6
    ChildSizing.VerticalSpacing = 6
    ChildSizing.EnlargeHorizontal = crsScaleChilds
    ChildSizing.Layout = cclLeftToRightThenTopToBottom
    ChildSizing.ControlsPerLine = 2
    ClientHeight = 64
    ClientWidth = 594
    TabOrder = 5
    object CheckBoxRunGiteaStartup: TCheckBox
      Left = 6
      Height = 23
      Top = 6
      Width = 269
      Caption = 'Run Gitea with the program'
      OnChange = CheckBoxRunGiteaStartupChange
      TabOrder = 0
    end
    object CheckBoxStopGiteaWhenClose: TCheckBox
      Left = 275
      Height = 23
      Top = 6
      Width = 313
      Caption = 'Stop Gita when the program closes'
      TabOrder = 1
    end
    object CheckBoxOpenPageAfterLaunch: TCheckBox
      Left = 6
      Height = 23
      Top = 35
      Width = 269
      Caption = 'Open Gitea page after launch'
      Enabled = False
      TabOrder = 2
    end
    object CheckBoxCheckUpdateStartup: TCheckBox
      Left = 275
      Height = 23
      Top = 35
      Width = 313
      Caption = 'Check for updates on startup'
      TabOrder = 3
      Visible = False
    end
  end
  object TrayIcon1: TTrayIcon
    PopUpMenu = PopupMenu1
    OnDblClick = TrayIcon1DblClick
    Left = 256
    Top = 8
  end
  object PopupMenu1: TPopupMenu
    Images = ImageList1
    TrackButton = tbLeftButton
    Left = 288
    Top = 8
    object MenuItem2: TMenuItem
      Caption = '-'
    end
    object MenuOpenGitea: TMenuItem
      Caption = 'Open Gitea...'
      ImageIndex = 2
      OnClick = MenuOpenGiteaClick
    end
    object MenuItem1: TMenuItem
      Caption = '-'
    end
    object MenuStartStop: TMenuItem
      ImageIndex = 0
      OnClick = MenuStartStopClick
    end
    object MenuItem3: TMenuItem
      Caption = '-'
    end
    object MenuSetting: TMenuItem
      Caption = 'Setting'
      ImageIndex = 3
      OnClick = MenuSettingClick
    end
    object MenuUpdate: TMenuItem
      Caption = 'Check update Gitea'
      ImageIndex = 8
      OnClick = MenuUpdateClick
    end
    object MenuAbout: TMenuItem
      Caption = 'About'
      ImageIndex = 4
      OnClick = MenuAboutClick
    end
    object MenuItem5: TMenuItem
      Caption = '-'
    end
    object MenuClose: TMenuItem
      Caption = 'Close'
      ImageIndex = 5
      OnClick = MenuCloseClick
    end
    object MenuItem4: TMenuItem
      Caption = '-'
    end
  end
  object ImageList1: TImageList
    Left = 328
    Top = 8
    Bitmap = {
      4C7A0900000010000000100000002D0A00000000000078DAED580B4C5467169E
      01EB2B2D6A655D77DDA8281946D9B8A4316963F0D1515083CBEAD6FADC02011C
      507171D15254546A2584EEA2D2C220B65881E2DBAAED5A53A9ABE3A08838588B
      2D0F4560901245C23CE4312073F69CE1BF78B9DC7960496ABA3BC997FFDE73CE
      77FE73CE7FCE9D3B2391FC7A3EAFFCE937AECFC3F34A5F1622DB1FA497658680
      2C3318BC3256834CB5CA2C53FDAD56B63FF84ACA85AC4BB86A641978AF5AD5E6
      95B10AD01EBCD2DE5AEDB577A187F53AFDED68F9C74B0E74FBE80DE483985C9E
      F656822C2358817E7FB2C6A15AA910DA6CFF32153EBA9823CA9765AC5EE495BE
      7436ED2FFF97629457F29CD174CDE9D79F4884F60E335CBC73D58AC5399B7AF1
      A7ECF397B9074C96E2FED5E8EB866CEF5FBC71BDCAE9BFABF911CAEBABE0FABD
      EFE0A1E131D43C7AF08CBFFF9D9FB8FAC93F0AF441DE4DAE7EB4AE3DFE01185B
      4D505859022DEDAD50FDA80E4E6B2FF4F031D774E139C853FCE458FB40CCC112
      90FD0F28C27DF52D0638597C1E5ACD6D30336B1DF49C51EA124F5BE7294B5F91
      C8ED137E2C01B4F74BE170E1D967B1AB567F66AF1F5C5F194C67912556739417
      4ED9AB1829F9FFE75733FFD2B94F4224FE4FF592F90092F91690FA7580745EBB
      59E2D7512BF1B75C494E834BB86AE81EE56D523F3348FCBB40AA30AC7699D5E0
      61BD9E6B8A7651341FE8F6D11BC8073139F21390AB40BFD65992CE6B53086DE2
      9200F61D10E7236F9174AE7136C60EAEBE55A35CDEB83F9A62E1F4115B00DADB
      01BE5503E423E687F6E6BBCE7A2093BA9E974AFC3BAB31A71BD2D98FBD257EE6
      AB9CFE5629407925407109C0A346801A1D8FEFDFD933FF2E6F3EF6C1586E72F5
      A3352C16C06802B87603A0A515A0BA16E0CC795EEEF3DAFACCBF8B6F9D1CE308
      C41C2C7383018AB4007A03C0A9AF005ADB005E5BC6F1F18CE6347BDA3ECFD644
      6E9FE04D00DADB009F9FE0EDED67B63BFF2E4307D15964899E995F7BA1EBCCDA
      FFA9F90F0F0FFF23E2585858D82D5C73119ECE7291E38BF62604F0D08498EE04
      7706C2CA5DB3660D6CDAB489EFA31921B313F318E4D23E10131303353535409F
      B2B232502A959C8F3C3BFC7564B379F3662828A886921213709FDDBB7773FC5B
      76F871B1B1B1909D5D0E43876A402A554371B1118C46236CD8B081E31F1170C6
      22A230EEB83D7BF6C41D3A540143865C0189440D83075F819B371FC1AE5DBB38
      AE0121E7717D594D60CB962D70F060A595435CF271F8700D242424705CAAE90C
      1E77067746DBB66D834F3FAD84975EEAE652EC478F56C38E1D3BF875F7E571E5
      2C16D8BE7D3B72EFC1A041DDDC61C33470FCF87D50A954F19413E546390A723E
      42DCA8A828686E6E863163AE59B9C3876BE0E4C9FBB075EB56DA33CE4E9DA927
      212929C97A36EFBE5B0553A716C3175F54415C5C1C17F33A3BFC3CB259BB762D
      E8743AAB8F868606A0B32339EBA13176F832AEEE111111B073E74E888C8CE4B8
      26EA6127E66B3A9B097E7F13D7B71F33EA49B3C966F418CD6C3F67FC55443ED5
      137D9CC055F11CCF89395C2FA00FCA21D689199F8E18C4F3E183F78DAC065D88
      690EF6FC0691C4BB77417E21AF8E890EF85AB6CF6204DD670ACE21D3013F9B17
      6BA3804B8872C09F86F19A457884FAE5CBA3F1BB46FD1AE2653B3E1671CF3A1E
      2A0202B661FFA8D5344F880AC4EFED9C831B62298266740102CF449DC9B81CCA
      10639DEF08B546C0279422C638C9F7413489F8B88D7077D2077ECFA89B457CE0
      B35BFDAA933EDE401888E7E65680B5AD60CFD6CB47FA510B3A0BD38C19B7A0A9
      A903264F2EA218BEE9DF84A967215A58FC7508CFFE7F9BAB719ED431B67A01CF
      DD0D11CA9E21850CC798CCCD412F07211E22D4881836538BD9B59AE9826C7093
      B0F7AAE9BB0552DD25081F4428035D5BBFE3984DA2705F9457E0EA8E76324421
      020420193DABDD996D102FDF7AC454D44F42348A7039906E12D9320E57AB6CF2
      05A9A3F37B6C8FFA03547D0D507B095F7C97F17C8CCEE73D37B83A07A26E62AF
      BD4CF500BA2B009567013A5A00D2C6F1E398481CDE19C92DFB4607F6E27F3C16
      E0A00FC08D3D005D9D00191E3D3AB265DFDB8536F9847BE7F0C5FB31C085F5BD
      E402BE78FC848B3100EA6D6275E4C72F5E3FC2F79F0194EC1770FBD4CFF6F995
      A830FFBD76CF8FD7B765CEF60FB30D12F62FA2CA51FF329BC4819E9F8198DF17
      65FEF1D9C43DFB4319E8DAA9F9473BFC4DA02E1479DE93CCEEFCA37E12A25184
      CB817436E71F75F96447EFB02B57FED8C353286EC3F8F1D7B97BD1F947F944CE
      7EC182EFC162B1E0BB640D040797C3D3A71658BFFE2E3F8E3EF38FDF4581FC58
      376EBC873E70F4BB2C909AFA4090C7E53EF32FE44746565A63201FD1D1F7ECF1
      FBC41F1878C7CA4D4AD2E16F8E1AEBF59225776CC5DFA77E13265C879090F21E
      FB88884A9832A5D856FD7ED6F909E7DF99FE7134FFF6FAF7459FFFBADC889711
      A1883C5D6EC4695CE310A7109188E1F6B8681F8E365B11C081F9F83B6233220B
      112EBEAF3285D917E37A166140D9FB3ADA3F272215EF8B787E5304312F15EC19
      841CDAB39627DF816862D7CDBA1CE554C675434431790BE58BFC4F087C9F148F
      2E5749399C465D3CC65685704319D52519F103CA63F0FE21B34FA27D9EF1950D
      A85F8171253E8B53A9A4DA622CF9BAEE1CCCBCFD9A985FBACE65FE5AD06E1DAE
      9DCCE7095CCF315DA4205E60FC8D082D4FA6A1B3653ED09792EAD4853164E35A
      C86CBA109908AA7BBC885FDAEB038A9BF9225927C61685F801AF631115D61C73
      AC3116F3CEA60DD74084DA9A7B77CF00D6C5CCFA6E23DB9FB307E68F6CEA588D
      CBA807280EBC1FCE6A407D57CFFACC248897728E61B9B4B1DA511DDD580FCCE3
      D936E23EEFF3EEABEABAF35A86FB76F2E47F15F4600A2F66EAD5BDBAEE589290
      D7C2EA91C9F248B1317BE1CC66B3CE5A07E557BDF2C0B8501EEA787EAD3D798A
      D5ED2CEB132597AFBDCF06CFCA21C1E3CAB562209D23FEDB7FD00D0B19570E62
      20DD8BCEDF29B93428645C59326166984E4FE0EE49D79F5F5A6E0586FB84E7FD
      DFD559FE488D219AB3E5634481BE9320A6230EC71FA131248C2830809B465FEF
      908F36644B1C217F94C6E8EB287EB21948BE297DE286D3B921051F9EDC05DAAC
      79794F5413169A3EF1F8AD49E5919C7A7CAB9E40D724231DD9902D71886B5479
      68510F3C249BD2267B0B64C064C97C19717F717EFAC4CF393F565F98935E357E
      125F462019976F0F902BF2FE301211893884B8CC7088C9463A78F70866EF5517
      10EF215631BCC764A40BB6C1DD8D2847BCF9E77F0648033E5CF83A621DC3EB24
      231DB3D92DF2DE548AF81DDA7A23D408108064DE64C36CB9F7FF51881AFADF11
      F5724403C73973F72E9CB97E9EEF8374F4DEEBC338A3585DB2C817EACEF1F72C
      35764069E54D611CE7D8BE59BC3A2F47B9A730E652632794561483482EF45FEF
      72C6A5F7C269285BD1A34F0BEBE69BBAA0B4BCA85BB66F059FBF82388CDB8B1F
      9D130F7AB319E2BFCC86D22716B856A6853CED35D0B79A2020F51D317E9FF8F3
      AEFE1BF49D00FAA788CE2EFC11D20179170EDA8A5FB47E7945DF5AFF8B273FF1
      5F1FB1573F9BE79777E33F107FEEB0DDF3FBB9FD3310FD3B10F3F3BCF3FB5FD3
      0EDD1B
    }
  end
  object UniqueInstance1: TUniqueInstance
    Enabled = True
    Identifier = 'GiPane_hhjjeKLJghfHk'
    Left = 368
    Top = 8
  end
end

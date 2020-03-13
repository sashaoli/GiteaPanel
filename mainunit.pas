unit mainunit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, process, Forms, Controls, Graphics, Dialogs, LCLTranslator, DefaultTranslator,StdCtrls,
  EditBtn, ButtonPanel, ExtCtrls, Menus, Spin, IniFiles, FileUtil,
  UniqueInstance, LCLIntf, Buttons, resstr, IdHTTP, IdComponent, IdSSLOpenSSL;


type

  { TMainForm }

  TMainForm = class(TForm)
    BitBtn1: TBitBtn;
    ButtonPanel1: TButtonPanel;
    CoBoxProtocol: TComboBox;
    CoBoxBrow: TComboBox;
    CoBoxLang: TComboBox;
    EditHost: TEdit;
    EditBrowsPath: TFileNameEdit;
    EditGiteaPatch: TFileNameEdit;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    ImageList1: TImageList;
    Label1: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    MenuItem1: TMenuItem;
    MenuAbout: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem4: TMenuItem;
    MenuUpdate: TMenuItem;
    MenuSetting: TMenuItem;
    MenuStartStop: TMenuItem;
    MenuItem3: TMenuItem;
    MenuOpenGitea: TMenuItem;
    MenuItem5: TMenuItem;
    MenuClose: TMenuItem;
    PopupMenu1: TPopupMenu;
    RButtDefPort: TRadioButton;
    RButtSpecPort: TRadioButton;
    RButtDefBrows: TRadioButton;
    RButtSelBrows: TRadioButton;
    RButtOterBrows: TRadioButton;
    EditPort: TSpinEdit;
    TrayIcon1: TTrayIcon;
    UniqueInstance1: TUniqueInstance;
    procedure CoBoxLangChange(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure MenuAboutClick(Sender: TObject);
    procedure MenuCloseClick(Sender: TObject);
    procedure MenuUpdateClick(Sender: TObject);
    procedure MenuOpenGiteaClick(Sender: TObject);
    procedure MenuSettingClick(Sender: TObject);
    procedure MenuStartStopClick(Sender: TObject);
    procedure BtnUpdSettingClick(Sender: TObject);
    procedure OKButtonClick(Sender: TObject);
    procedure RButtPortChange(Sender: TObject);
    procedure RButtBrowsChange(Sender: TObject);
    procedure TrayIcon1DblClick(Sender: TObject);

  private
    function GetSetupBrowser: TStringList;
    function GetLangNameOfCode(ALangPatch, ALangCode: String): String;
    function GetLangCodeOfName(ALangPatch, AlangName: String): String;
    function IsReady(aGiteaUrl: String): Boolean;

    procedure PathDefinition;
    procedure FillLangCoBox(aLangPatch: String);
    procedure ReadIniFile;
    procedure WriteIniFile;
    procedure SetMainVar;
    procedure ReRunApp;

  public
    function IsRuning(AProcName: String): Boolean;
    procedure SetTrayIcon(aGiStatus: Boolean);
    procedure StopGiteaServer;
    procedure RunGiteaServer;
    procedure OpenGiteaServer;

  end;

var
  MainForm: TMainForm;

  UseProxyStatus: Boolean;
  OSIdent: String;
  ProxyHost: String;
  ProxyPort: Integer;
  ProxyUser: String;
  ProxyPass: String;

  SelPort: Boolean;
  SelBrows: Integer;
  CloseFlag: Boolean;
  LangCode: String;
  LangName: String;
  GiPort: String;
  GiPath: String;      // Full Gitea path
  GiFileName: String;      // Ony Gitea filename
  GiProtocol: String;
  GiHost: String;
  BrowsPath: String;
  BrowsInst: String;
  LangPath: String;
  ConfPath: String;

implementation

uses aboutunit, updatesetting, updategitea;

{$R *.frm}

{ TMainForm }

function TMainForm.IsRuning(AProcName: String): Boolean;
var s: String;
begin
  s:= '';
  Result:= False;
  Sleep(300);
  if RunCommand('pgrep',['-x',AProcName],s,[poWaitOnExit]) then Result:= s <> '';
end;

function TMainForm.GetSetupBrowser: TStringList;
var list: TStringList;
    s: String;
    i: Integer;
begin
  Result:= TStringList.Create;
  list:= TStringList.Create;
  try
  if RunCommand('update-alternatives',['--list', 'x-www-browser'], s,[poWaitOnExit]) then
     begin
       list.AddText(s);
       for i:= 0 to list.Count - 1 do Result.Add(ExtractFileName(list[i]));
     end;
  finally
    list.Free;
  end;
end;

function TMainForm.GetLangNameOfCode(ALangPatch, ALangCode: String): String;
var LngList: TStringList;
begin
  Result:= '';
  LngList:= TStringList.Create;
  LngList.NameValueSeparator:= '=';
  try
    LngList.LoadFromFile(ALangPatch + '/lang.list');
    Result:= LngList.Values[ALangCode];
  finally
    LngList.Free;
  end;
end;

function TMainForm.GetLangCodeOfName(ALangPatch, AlangName: String): String;
var LngList: TStringList;
    i: Integer;
begin
  Result:= '';
  LngList:= TStringList.Create;
  LngList.NameValueSeparator:= '=';
  try
    LngList.LoadFromFile(ALangPatch + '/lang.list');
    for i:= 0 to LngList.Count - 1 do
      if LngList.ValueFromIndex[i] = ALangName then
        begin
          Result:= LngList.Names[i];
          Break;
        end;
  finally
    LngList.Free;
  end;
end;

function TMainForm.IsReady(aGiteaUrl: String): Boolean;
var HCSSL: TIdSSLIOHandlerSocketOpenSSL;
begin
  HCSSL:= TIdSSLIOHandlerSocketOpenSSL.Create;
  HCSSL.SSLOptions.Method:= sslvSSLv23;
  with TIdHTTP.Create do
    try
      HandleRedirects:= True;
      Request.UserAgent:= 'GiteaPanel';
      IOHandler:= HCSSL;
      try
        Head(aGiteaUrl);
        Result:= ResponseCode = 200 ;
      except
        on Err: Exception do Result:= False;
      end;
    finally
      HCSSL.Free;
      Free;
    end;
end;

procedure TMainForm.PathDefinition;
var aMyDir: String;
    aUserDir: String;
begin
  aMyDir:= ExtractFilePath(ParamStr(0));
  aUserDir:= GetUserDir;
  if Pos('/usr/bin', aMyDir) > 0 then
    begin
      SetCurrentDir(aMyDir);
      LangPath:= ExpandFileName('../share/giteapanel/locale');
      if DirectoryExists(aUserDir + '.config') then ConfPath:= aUserDir + '.config'
      else ConfPath:= aUserDir;
    end
  else
    begin
      LangPath:= aMyDir + 'locale';
      ConfPath:= aMyDir;
    end;
end;

procedure TMainForm.FillLangCoBox(aLangPatch: String);
var LngList: TStringList;
    ResSearsh: TSearchRec;
    LaCode: String;
begin
  CoBoxLang.Clear;
  LngList:= TStringList.Create;
  LngList.NameValueSeparator:='=';
  try
    LngList.LoadFromFile(ALangPatch + '/lang.list');
    if FindFirst(ALangPatch + '/giteapanel.*.po', faAnyFile, ResSearsh) <> -1 then  //'/giteapanel.*.po'
      repeat
        LaCode:= String(ResSearsh.Name).Split('.')[1];
        if LngList.Values[LaCode] <> '' then CoBoxLang.Items.Add(LngList.Values[LaCode]);
      until FindNext(ResSearsh) <> 0;
  FindClose(ResSearsh);
  finally
    LngList.Free;
  end;
end;

procedure TMainForm.ReadIniFile;
begin
  with TIniFile.Create(ConfPath + '/giteapanel.conf') do
    try
      LangCode         := ReadString('DATA','Language','en');
      GiPath           := ReadString('GITEA','GiteaPath','');
      BrowsInst        := ReadString('BROWSER','BrowserInst','');
      GiPort           := ReadString('GITEA','GiteaPort','8080');
      SelBrows         := ReadInteger('BROWSER','SelctedBrowser',0);
      SelPort          := ReadBool('BROWSER','SelectedPort',False);
      BrowsPath        := ReadString('BROWSER','BrowserPath','');
      GiProtocol       := ReadString('GITEA','GiteaProtocol','http://');
      GiHost           := ReadString('GITEA','GiteaHost','localhost');

      UseProxyStatus   := ReadBool('UPDATE','ProxyStatus', false);
      OSIdent          := ReadString('UPDATE','My_OS','');
      ProxyHost        := ReadString('UPDATE','ProxyHost','');
      ProxyPort        := ReadInteger('UPDATE','ProxyPort',80);
      ProxyUser        := ReadString('UPDATE','ProxyUser','');
      ProxyPass        := ReadString('UPDATE','ProxyPass','');
      Top              := ReadInteger('DATA','TopPosition',0);
      Left             := ReadInteger('DATA', 'LeftPosition',0);
    finally
      Free;
    end;
  LangName:= GetLangNameOfCode(LangPath,LangCode);
  if GiPath='' then GiFileName:= 'gitea' else GiFileName:=ExtractFileName(GiPath);

  if Not FileExists(GiPath,False) then Show;
end;

procedure TMainForm.WriteIniFile;
begin
  with TIniFile.Create(ConfPath + '/giteapanel.conf') do
    try
      WriteString('GITEA','GiteaPath',GiPath);
      WriteString('GITEA','GiteaPort',GiPort);
      WriteString('GITEA','GiteaProtocol',GiProtocol);
      WriteString('GITEA','GiteaHost',GiHost);
      WriteBool('GITEA','SelectedPort',SelPort);
      WriteInteger('BROWSER','SelctedBrowser',SelBrows);
      WriteString('BROWSER','BrowserInst', BrowsInst);
      WriteString('BROWSER','BrowserPath',BrowsPath);

      WriteBool('UPDATE','ProxyStatus', UseProxyStatus);
      WriteString('UPDATE','My_OS',OSIdent);
      WriteString('UPDATE','ProxyHost',ProxyHost);
      WriteInteger('UPDATE','ProxyPort',ProxyPort);
      WriteString('UPDATE','ProxyUser',ProxyUser);
      WriteString('UPDATE','ProxyPass',ProxyPass);

      if LangCode = '' then LangCode:= 'en';
      WriteString('DATA','Language',LangCode);
    finally
      Free;
    end;
end;

procedure TMainForm.SetTrayIcon(aGiStatus: Boolean);
begin
  if aGiStatus then
     begin
       TrayIcon1.Icon.LoadFromResourceName(HINSTANCE, 'GITEAGREEN');
       MenuStartStop.Caption:= i18_StopGitea;
       MenuStartStop.ImageIndex:=1;
       MenuOpenGitea.Enabled:=True;
       TrayIcon1.Hint:= i18_GiteaRunig;
     end
  else
     begin
       TrayIcon1.Icon.LoadFromResourceName(HINSTANCE, 'GITEARED');
       MenuStartStop.Caption:= i18_StartGitea;
       MenuStartStop.ImageIndex:=0;
       MenuOpenGitea.Enabled:=False;
       TrayIcon1.Hint:= i18_GiteaStoped;
     end;
end;

procedure TMainForm.StopGiteaServer;
var s: String;
begin
  RunCommand('killall',['-w', '-e', GiFileName],s,[poWaitOnExit]);
  SetTrayIcon(IsRuning(GiFileName));
end;

procedure TMainForm.RunGiteaServer;
var cmd: String;
    fAtt: LongInt;
    //i: Integer;
begin
  if SelPort then cmd:= ' web --port ' + GiPort
  else cmd:= ' web';

  fAtt:= FileGetAttr(GiPath);
  if ((fAtt <> -1) and ((fAtt and faDirectory) <> 0)) or not FileExists(GiPath) then
     begin
       MessageDlg('Gitea Panel', i18_Msg_Err_RunGitea, mtError, [mbOK], 0);
       Exit;
     end;

  with TProcess.Create(nil) do
     try
      InheritHandles:= False;
      Executable:= '/bin/bash';
      Parameters.Add('-c');
      Parameters.Add('(' + GiPath + cmd +' &) &&  exit 0');
      Options:= [];

      //for i:= 1 to GetEnvironmentVariableCount do
      //    Environment.Add(GetEnvironmentString(i));

      Execute;
    finally
      Free;
    end;
    SetTrayIcon(IsRuning(GiFileName));
end;

procedure TMainForm.OpenGiteaServer;
var link, tmp, tmp1 : String;
    fAttr: LongInt;
    i: Integer;
begin
  if SelPort then link:= GiProtocol + GiHost + ':' + GiPort else link:= GiProtocol + GiHost + ':3000';

  case SelBrows of
    0: FindDefaultBrowser(tmp,tmp1);
    1: tmp:= FindDefaultExecutablePath(BrowsInst);
    2: tmp:= BrowsPath;
  end;

  fAttr:= FileGetAttr(tmp);
  if ((fAttr <> -1) and ((fAttr and faDirectory) <> 0)) or not FileExists(tmp) then
     begin
       MessageDlg('Gitea Panel', i18_Msg_Err_NoFindBrowser, mtError, [mbOK], 0);
       Exit;
     end;

  for i:= 0 to 20 do       // Wait ready gitea server ~8 s.
    if IsReady(link) then
      begin
        with TProcess.Create(nil) do
          try
            Executable:= tmp;
            Parameters.Add(link);
            Execute;
          finally
            Free;
          end;
        Break;
      end
    else begin
      Application.ProcessMessages;
      Sleep(400);
    end;
  if not IsReady(link) then MessageDlg('Gitea Panel', i18_Msg_Err_CantOpenServer, mtError, [mbOK], 0);
end;

procedure TMainForm.SetMainVar;
begin
  GiProtocol:= CoBoxProtocol.Text;
  GiHost:= EditHost.Text;
  GiPath:= EditGiteaPatch.Text;
  GiFileName:= ExtractFileName(GiPath);
  GiPort:= IntToStr(EditPort.Value);
  SelPort:= RButtSpecPort.Checked;
  BrowsInst:= CoBoxBrow.Text;
  BrowsPath:= EditBrowsPath.Text;
  LangName:= CoBoxLang.Text;
  LangCode:= GetLangCodeOfName(LangPath, LangName);
end;

procedure TMainForm.ReRunApp;
begin
  with TProcess.Create(nil) do
    try
      Executable:= ParamStr(0);
      Execute;
    finally
      Free;
      Application.Terminate;
    end;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  CloseFlag:= False;
  PathDefinition;
  ReadIniFile;
  SetDefaultLang(LangCode, LangPath, 'giteapanel');
  SetTrayIcon(IsRuning(GiFileName));
  EditGiteaPatch.DialogTitle:= i18_DlgTitle_Giteapatch;
  EditBrowsPath.DialogTitle:= i18_DlgTitle_BrowsPath;
  TrayIcon1.Visible:=true;
end;

procedure TMainForm.FormShow(Sender: TObject);
begin
  DisableAutoSizing;
  FillLangCoBox(LangPath);
  EditGiteaPatch.Text:= GiPath;
  CoBoxProtocol.ItemIndex:= CoBoxProtocol.Items.IndexOf(GiProtocol);
  EditHost.Caption:= GiHost;
  CoBoxLang.ItemIndex:= CoBoxLang.Items.IndexOf(LangName);

  CoBoxBrow.Clear;
  CoBoxBrow.Items.AddText(GetSetupBrowser.Text);
  CoBoxBrow.ItemIndex:= CoBoxBrow.Items.IndexOf(BrowsInst);
  EditBrowsPath.Text:= BrowsPath;

  case SelBrows of
    0:  RButtDefBrows.Checked:= True;
    1:  RButtSelBrows.Checked:= True;
    2:  RButtOterBrows.Checked:= True;
  end;

  RButtSpecPort.Checked:= SelPort;
  EditPort.Value:= StrToInt(GiPort);
  EnableAutoSizing;
end;

procedure TMainForm.MenuAboutClick(Sender: TObject);
begin
  AboutForm.Show;
end;

procedure TMainForm.CoBoxLangChange(Sender: TObject);
begin
  if LangName <> CoBoxLang.Text then
      if MessageDlg('Gitea Panel', i18_Msg_ReRunApp, mtConfirmation, [mbYes, mbNo], 0) = mrYes then
        begin
          SetMainVar;
          WriteIniFile;
          ReRunApp;
        end;
end;

procedure TMainForm.FormCloseQuery(Sender: TObject; var CanClose: boolean);
begin
  with TIniFile.Create(ConfPath + '/giteapanel.conf') do
    try
      WriteInteger('DATA','TopPosition', Top);
      WriteInteger('DATA','LeftPosition', Left);
    finally
    end;
  CanClose:=CloseFlag;
  if Not CloseFlag then Hide;
end;

procedure TMainForm.MenuCloseClick(Sender: TObject);
begin
  CloseFlag:=True;
  Close;
end;

procedure TMainForm.MenuUpdateClick(Sender: TObject);
begin
  FormUpdGitea.Show;
end;

procedure TMainForm.MenuOpenGiteaClick(Sender: TObject);
begin
  OpenGiteaServer;
end;

procedure TMainForm.MenuSettingClick(Sender: TObject);
begin
  if MainForm.Visible then Hide
  else MainForm.Show;
end;

procedure TMainForm.MenuStartStopClick(Sender: TObject);
begin
  if IsRuning(GiFileName) then  StopGiteaServer else RunGiteaServer;
end;

procedure TMainForm.BtnUpdSettingClick(Sender: TObject);
begin
  UpdSettingForm.ShowModal;
end;

procedure TMainForm.OKButtonClick(Sender: TObject);
begin
  SetMainVar;
  WriteIniFile;
  Hide;
end;

procedure TMainForm.RButtPortChange(Sender: TObject);
begin
  SelPort:= RButtSpecPort.Checked;
  EditPort.Enabled:= Not EditPort.Enabled;
end;

procedure TMainForm.RButtBrowsChange(Sender: TObject);
begin
  with (Sender as TRadioButton) do SelBrows:= Tag;
  CoBoxBrow.Enabled:= (((SelBrows shr 0) and 1) = 1);
  EditBrowsPath.Enabled:= (((SelBrows shr 1) and 1) = 1);
end;

procedure TMainForm.TrayIcon1DblClick(Sender: TObject);
begin
  if Not IsRuning(GiFileName) then RunGiteaServer;
  if IsRuning(GiFileName) then OpenGiteaServer;
end;

end.
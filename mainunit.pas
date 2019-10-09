unit mainunit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, process, Forms, Controls, Graphics, Dialogs, LCLTranslator, StdCtrls,
  EditBtn, ButtonPanel, ExtCtrls, Menus, Spin, IniFiles, FileUtil,
  UniqueInstance, LCLIntf, Buttons, resstr, opensslsockets, fphttpclient{, logger};

type
  TGiStatus = record
    IsRun: Boolean;
    GiPID: String;
  end;

type

  { TForm1 }

  TForm1 = class(TForm)
    ButtonPanel1: TButtonPanel;
    CheckBoxUpdate: TCheckBox;
    CheckBoxAutoUpdate: TCheckBox;
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
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    MenuItem1: TMenuItem;
    MenuAbout: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem4: TMenuItem;
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
    BtnUpdSetting: TSpeedButton;
    TrayIcon1: TTrayIcon;
    UniqueInstance1: TUniqueInstance;
    procedure CheckBoxUpdateChange(Sender: TObject);
    procedure CoBoxLangChange(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure MenuAboutClick(Sender: TObject);
    procedure MenuCloseClick(Sender: TObject);
    procedure MenuOpenGiteaClick(Sender: TObject);
    procedure MenuSettingClick(Sender: TObject);
    procedure MenuStartStopClick(Sender: TObject);
    procedure BtnUpdSettingClick(Sender: TObject);
    procedure OKButtonClick(Sender: TObject);
    procedure RButtPortChange(Sender: TObject);
    procedure RButtBrowsChange(Sender: TObject);
    procedure TrayIcon1DblClick(Sender: TObject);

  private
    SelPort: Boolean;
    SelBrows: Integer;
    CloseFlag: Boolean;
    RIR: TGiStatus;
    LangCode: String;
    LangName: String;
    GiPort: String;
    GiPatch: String;
    GiFile: String;
    GiProtocol: String;
    GiHost: String;
    BrowsPath: String;
    BrowsInst: String;

    LangPath: String;
    ConfPath: String;

    function IsRuning(AProcName: String): TGiStatus;
    function GetSetupBrowser: TStringList;
    function GetLangNameOfCode(ALangPatch, ALangCode: String): String;
    function GetLangCodeOfName(ALangPatch, AlangName: String): String;
    function IsReady(aGiteaUrl: String): Boolean;
    procedure PathDefinition;
    procedure FillLangCoBox(ALangPatch: String);
    procedure ReadIniFile;
    procedure WriteIniFile;
    procedure SetTrayIcon(AGiStatus: Boolean);
    procedure StopGiteaServer;
    procedure RunGiteaServer;
    procedure OpenGiteaServer;
    procedure SetMainVar;
    procedure ReRunApp;

  public

  end;

type
  TGHData = record
    GiteaVersion: string;
    DownloadUrl: String;
  end;

var
  Form1: TForm1;

  UpdStatus: Boolean;
  AutoUpdStatus: Boolean;
  UseProxyStatus: Boolean;
  OSIdent: String;
  ProxyHost: String;
  ProxyPort: Integer;
  ProxyUser: String;
  ProxyPass: String;

const
  GITHUB_URL = 'https://api.github.com/repos/go-gitea/gitea/releases/latest';
  EXCLUDE_STRING = '.asc,.sha256,.xz,.xz.asc,.xz.sha256';

implementation

uses aboutunit, updatesetting;

{$R *.frm}

{ TForm1 }

function TForm1.IsRuning(AProcName: String): TGiStatus;
var s: String;
begin
  Result.IsRun:= False;
  Result.GiPID:= '';
  if RunCommand('pgrep',['-x',AProcName],s,[poWaitOnExit,poUsePipes]) then
    begin
      Result.IsRun:= s <> '';
      if Result.IsRun then Result.GiPID:= TrimRight(s);
    end;
end;

function TForm1.GetSetupBrowser: TStringList;
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

function TForm1.GetLangNameOfCode(ALangPatch, ALangCode: String): String;
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

function TForm1.GetLangCodeOfName(ALangPatch, AlangName: String): String;
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

function TForm1.IsReady(aGiteaUrl: String): Boolean;
begin
  with TFPHTTPClient.Create(nil) do
    try
      AllowRedirect:= True;
      AddHeader('User-Agent','GiteaPanel');
      try
        Get(aGiteaUrl);
        Result:= ResponseStatusCode = 200 ;
      except
        on Err: Exception do Result:= False;
      end;
    finally
      Free;
    end;
end;

procedure TForm1.PathDefinition;
var aMyDir: String;
    aUserDir: String;
begin
  aMyDir:= ExtractFilePath(ParamStr(0));
  aUserDir:= GetUserDir;
  if Pos('/usr/bin', aMyDir) > 0 then
    begin
      LangPath:= '/usr/share/giteapanel/locale';
      if DirectoryExists(aUserDir + '/.config') then ConfPath:= aUserDir + '/.config'
      else ConfPath:= aUserDir;
    end
  else
    begin
      LangPath:= aMyDir + '/locale';
      ConfPath:= aMyDir;
    end;
end;

procedure TForm1.FillLangCoBox(ALangPatch: String);
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

procedure TForm1.ReadIniFile;
//var Conf: TIniFile;
begin
  //Conf:= TIniFile.Create(ConfPath + '/giteapanel.conf');
  with TIniFile.Create(ConfPath + '/giteapanel.conf') do
    try
      LangCode:= ReadString('DATA','Language','uk');
      GiPatch:= ReadString('GITEA','GiteaPath','');
      BrowsInst:= ReadString('BROWSER','BrowserInst','');
      GiPort:= ReadString('GITEA','GiteaPort','8080');
      SelBrows:= ReadInteger('BROWSER','SelctedBrowser',0);
      SelPort:= ReadBool('BROWSER','SelectedPort',False);
      BrowsPath:= ReadString('BROWSER','BrowserPath','');
      GiProtocol:= ReadString('GITEA','GiteaProtocol','http://');
      GiHost:= ReadString('GITEA','GiteaHost','localhost');

      UpdStatus:= ReadBool('UPDATE','UpdateStatus', False);
      AutoUpdStatus:= ReadBool('UPDATE','AutoUpdateStatus', False);
      UseProxyStatus:= ReadBool('UPDATE','ProxyStatus', false);
      OSIdent:= ReadString('UPDATE','My_OS','');
      ProxyHost:=ReadString('UPDATE','ProxyHost','');
      ProxyPort:=ReadInteger('UPDATE','ProxyPort',80);
      ProxyUser:=ReadString('UPDATE','ProxyUser','');
      ProxyPass:=ReadString('UPDATE','ProxyPass','');
    finally
      Free;
    end;
  LangName:= GetLangNameOfCode(LangPath,LangCode);
  if GiPatch='' then GiFile:= 'gitea' else GiFile:=ExtractFileName(GiPatch);

  if Not FileExists(GiPatch,False) then Show;
end;

procedure TForm1.WriteIniFile;
//var Conf: TIniFile;
begin
  //Conf:= TIniFile.Create(ConfPath + '/giteapanel.conf');
  with TIniFile.Create(ConfPath + '/giteapanel.conf') do
    try
      WriteString('GITEA','GiteaPath',GiPatch);
      WriteString('GITEA','GiteaPort',GiPort);
      WriteString('GITEA','GiteaProtocol',GiProtocol);
      WriteString('GITEA','GiteaHost',GiHost);
      WriteBool('GITEA','SelectedPort',SelPort);
      WriteInteger('BROWSER','SelctedBrowser',SelBrows);
      WriteString('BROWSER','BrowserInst', BrowsInst);
      WriteString('BROWSER','BrowserPath',BrowsPath);

      WriteBool('UPDATE','UpdateStatus', UpdStatus);
      WriteBool('UPDATE','AutoUpdateStatus', AutoUpdStatus);
      WriteBool('UPDATE','ProxyStatus', UseProxyStatus);
      WriteString('UPDATE','My_OS',OSIdent);
      WriteString('UPDATE','ProxyHost',ProxyHost);
      WriteInteger('UPDATE','ProxyPort',ProxyPort);
      WriteString('UPDATE','ProxyUser',ProxyUser);
      WriteString('UPDATE','ProxyPass',ProxyPass);

      if LangCode = '' then LangCode:= 'uk';               // ????
      WriteString('DATA','Language',LangCode);
    finally
      Free;
    end;
end;

procedure TForm1.SetTrayIcon(AGiStatus: Boolean);
begin
  if AGiStatus then
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

procedure TForm1.StopGiteaServer;
var s: String;
begin
  RunCommand('killall',[GiFile{RIR.GiPID}],s,[poWaitOnExit, poUsePipes]);
end;

procedure TForm1.RunGiteaServer;
var t:Tprocess;
    cmd: String;
    fAtt: LongInt;
begin
  if SelPort then cmd:= ' web --port ' + GiPort
  else cmd:= ' web';

  fAtt:= FileGetAttr(GiPatch);

  t:=TProcess.Create(nil);
  try
     if ((fAtt <> -1) and ((fAtt and faDirectory) <> 0)) or not FileExists(GiPatch) then
       begin
         MessageDlg('Gitea Panel', i18_Msg_Err_RunGitea, mtError, [mbOK], 0);
         Exit;
       end;
     t.Executable:='/bin/bash';
     t.Parameters.Add('-c');
     t.Parameters.Add('$(' + GiPatch + cmd +')');
     t.Execute;
  finally
    t.Free;
  end;
end;

procedure TForm1.OpenGiteaServer;
var t: TProcess;
    link, tmp, tmp1 : String;
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

  for i:= 0 to 20 do       // Wait ready gitea server 8 s.
    if IsReady(link) then
      begin
        //Log.LogStatus('Gitea server is ready, open gitea server.','OpenGiteaServer');
        t:=TProcess.Create(nil);
        try
          t.Executable:= FindDefaultExecutablePath(tmp);
          t.Parameters.Add(link);
          t.Execute;
        finally
          t.Free
        end;
        Break;
      end
    else begin
      //Log.LogStatus('Wait Gitea: Iteration - ' + IntToStr(i), 'OpenGiteaServer');
      Application.ProcessMessages;
      Sleep(400);
    end;
  if not IsReady(link) then MessageDlg('Gitea Panel', i18_Msg_Err_CantOpenServer, mtError, [mbOK], 0);
end;

procedure TForm1.SetMainVar;
begin
  GiProtocol:= CoBoxProtocol.Text;
  GiHost:= EditHost.Text;
  GiPatch:= EditGiteaPatch.Text;
  GiFile:= ExtractFileName(GiPatch);
  GiPort:= IntToStr(EditPort.Value);
  SelPort:= RButtSpecPort.Checked;
  BrowsInst:= CoBoxBrow.Text;
  BrowsPath:= EditBrowsPath.Text;
  LangName:= CoBoxLang.Text;
  LangCode:= GetLangCodeOfName(LangPath, LangName);
  UpdStatus:= CheckBoxUpdate.Checked;
  AutoUpdStatus:= CheckBoxAutoUpdate.Checked;
end;

procedure TForm1.ReRunApp;
var t: TProcess;
begin
  t:= TProcess.Create(nil);
  try
    t.Executable:= ParamStr(0);
    t.Execute;
  finally
    t.Free;
    Application.Terminate;
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  CloseFlag:= False;
  PathDefinition;
  ReadIniFile;
  SetDefaultLang(LangCode, LangPath, 'giteapanel');
  RIR:= IsRuning(GiFile);
  SetTrayIcon(RIR.IsRun);
  EditGiteaPatch.DialogTitle:= i18_DlgTitle_Giteapatch;
  EditBrowsPath.DialogTitle:= i18_DlgTitle_BrowsPath;
  //TrayIcon1.Visible:=true;
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  FillLangCoBox(LangPath);
  EditGiteaPatch.Text:= GiPatch;
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
  CheckBoxUpdate.Checked:= UpdStatus;
  CheckBoxAutoUpdate.Checked:= AutoUpdStatus;
end;

procedure TForm1.MenuAboutClick(Sender: TObject);
begin
  Form2.Show;
end;

procedure TForm1.CheckBoxUpdateChange(Sender: TObject);
begin
  CheckBoxAutoUpdate.Enabled:= CheckBoxUpdate.Checked;
  BtnUpdSetting.Enabled:= CheckBoxUpdate.Checked;
end;

procedure TForm1.CoBoxLangChange(Sender: TObject);
begin
  if LangName <> CoBoxLang.Text then
    if MessageDlg('Gitea Panel', i18_Msg_ReRunApp, mtConfirmation, [mbYes, mbNo], 0) = mrYes then
      begin
        SetMainVar;
        WriteIniFile;
        ReRunApp;
      end;
end;

procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: boolean);
begin
  CanClose:=CloseFlag;
  if Not CloseFlag then Hide;
end;

procedure TForm1.MenuCloseClick(Sender: TObject);
begin
  CloseFlag:=True;
  Close;
end;

procedure TForm1.MenuOpenGiteaClick(Sender: TObject);
begin
  OpenGiteaServer;
end;

procedure TForm1.MenuSettingClick(Sender: TObject);
begin
  if Form1.Visible then Hide
  else Form1.Show;
end;

procedure TForm1.MenuStartStopClick(Sender: TObject);
//var s: String;
begin
  if RIR.IsRun then  StopGiteaServer
    else RunGiteaServer;
  Sleep(300);
  RIR:= IsRuning(GiFile);
  SetTrayIcon(RIR.IsRun);
end;

procedure TForm1.BtnUpdSettingClick(Sender: TObject);
begin
  Form3.ShowModal;
end;

procedure TForm1.OKButtonClick(Sender: TObject);
begin
  SetMainVar;
  WriteIniFile;
  Hide;
end;

procedure TForm1.RButtPortChange(Sender: TObject);
begin
  SelPort:= RButtSpecPort.Checked;
  EditPort.Enabled:= Not EditPort.Enabled;
end;

procedure TForm1.RButtBrowsChange(Sender: TObject);
begin
  with (Sender as TRadioButton) do SelBrows:= Tag;
  CoBoxBrow.Enabled:= (((SelBrows shr 0) and 1) = 1);
  EditBrowsPath.Enabled:= (((SelBrows shr 1) and 1) = 1);
end;

procedure TForm1.TrayIcon1DblClick(Sender: TObject);
begin
  if Not RIR.IsRun then RunGiteaServer;
  Sleep(500);
  RIR:= IsRuning(GiFile);
  SetTrayIcon(RIR.IsRun);
  if RIR.IsRun then OpenGiteaServer;
end;

end.

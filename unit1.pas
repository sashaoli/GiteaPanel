unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, process, Forms, Controls, Graphics, Dialogs, LCLTranslator, StdCtrls,
  EditBtn, ButtonPanel, ExtCtrls, Menus, Spin, IniFiles, FileUtil,
  UniqueInstance, LCLIntf, resstr;

type
  TGiStatus = record
    IsRun: Boolean;
    GiPID: String;
  end;

type

  { TForm1 }

  TForm1 = class(TForm)
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
    TrayIcon1: TTrayIcon;
    UniqueInstance1: TUniqueInstance;
    procedure CancelButtonClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure MenuAboutClick(Sender: TObject);
    procedure MenuCloseClick(Sender: TObject);
    procedure MenuOpenGiteaClick(Sender: TObject);
    procedure MenuSettingClick(Sender: TObject);
    procedure MenuStartStopClick(Sender: TObject);
    procedure OKButtonClick(Sender: TObject);
    procedure RButtPortChange(Sender: TObject);
    procedure RButtBrowsChange(Sender: TObject);

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

    function IsRuning(AProcName: String): TGiStatus;
    function GetSetupBrowser: TStringList;
    function GetLangNameOfCode(ALangPatch, ALangCode: String): String;
    function GetLangCodeOfName(ALangPatch, AlangName: String): String;
    procedure FillLangCoBox(ALangPatch: String);
    procedure ReadIniFile;
    procedure WriteIniFile;
    procedure SetTrayIcon(AGiStatus: Boolean);

  public

  end;

var
  Form1: TForm1;

const
  LANG_PATH = './locale';

implementation

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
    LngList.LoadFromFile(ALangPatch + './lang.list');
    Result:= LngList.Values[ALangCode];
  finally
    LngList.Free;
  end;
end;

function TForm1.GetLangCodeOfName(ALangPatch, ALangName: String): String;
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
    if FindFirst(ALangPatch + '/giteapanel.*.po', faAnyFile, ResSearsh) <> -1 then
      repeat
        LaCode:= Copy(ResSearsh.Name,Pos('.',ResSearsh.Name)+ 1,2);
        if LngList.Values[LaCode] <> '' then CoBoxLang.Items.Add(LngList.Values[LaCode]);
      until FindNext(ResSearsh) <> 0;
  FindClose(ResSearsh);
  finally
    LngList.Free;
  end;
end;

procedure TForm1.ReadIniFile;
var Conf: TIniFile;
begin
  Conf:= TIniFile.Create('.config/giteapanel.conf');
  with Conf do
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
    finally
      Conf.Free;
    end;
  if GiPatch='' then GiFile:= 'gitea' else GiFile:=ExtractFileName(GiPatch);

  if Not FileExists(GiPatch,False) then Show;
end;

procedure TForm1.WriteIniFile;
var Conf: TIniFile;
begin
  Conf:= TIniFile.Create('.config/giteapanel.conf');
  with Conf do
  try
    WriteString('GITEA','GiteaPath',GiPatch);
    WriteString('GITEA','GiteaPort',GiPort);
    WriteString('GITEA','GiteaProtocol',GiProtocol);
    WriteString('GITEA','GiteaHost',GiHost);
    WriteBool('GITEA','SelectedPort',SelPort);
    WriteInteger('BROWSER','SelctedBrowser',SelBrows);
    WriteString('BROWSER','BrowserInst', BrowsInst);
    WriteString('BROWSER','BrowserPath',BrowsPath);
    WriteString('DATA','Language',LangCode);
  finally
    Conf.Free;
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

procedure TForm1.FormCreate(Sender: TObject);
begin
  CloseFlag:= False;
  ReadIniFile;
  FillLangCoBox(LANG_PATH);
  SetDefaultLang(LangCode,LANG_PATH);
  RIR:= IsRuning(GiFile);
  SetTrayIcon(RIR.IsRun);
  EditGiteaPatch.DialogTitle:= i18_DlgTitle_Giteapatch;
  EditBrowsPath.DialogTitle:= i18_DlgTitle_BrowsPath;
  //TrayIcon1.Visible:=true;
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  EditGiteaPatch.Text:= GiPatch;                             {done: move to new procedure "Form1.FormShow"}
  CoBoxProtocol.ItemIndex:= CoBoxProtocol.Items.IndexOf(GiProtocol);
  EditHost.Caption:= GiHost;
  CoBoxLang.ItemIndex:= CoBoxLang.Items.IndexOf(LangName);

  CoBoxBrow.Clear;
  CoBoxBrow.Items.AddText(GetSetupBrowser.Text);
  CoBoxBrow.ItemIndex:= CoBoxBrow.Items.IndexOf(BrowsInst); {done: move to new procedure "Form1.FormShow"}
  EditBrowsPath.Text:= BrowsPath;

  case SelBrows of                                          {done: move to new procedure "Form1.FormShow"}
    0:  RButtDefBrows.Checked:= True;                       {done: move to new procedure "Form1.FormShow"}
    1:  RButtSelBrows.Checked:= True;                       {done: move to new procedure "Form1.FormShow"}
    2:  RButtOterBrows.Checked:= True;                      {done: move to new procedure "Form1.FormShow"}
  end;                                                      {done: move to new procedure "Form1.FormShow"}

  RButtSpecPort.Checked:= SelPort;                          {done: move to new procedure "Form1.FormShow"}
  EditPort.Value:= StrToInt(GiPort);                        {done: move to new procedure "Form1.FormShow"}
end;

procedure TForm1.MenuAboutClick(Sender: TObject);
//var af: frAboutForm;
begin

end;

procedure TForm1.CancelButtonClick(Sender: TObject);
begin
  Hide;
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
var t: TProcess;
    link, tmp, tmp1 : String;
    fAttr: LongInt;
begin
  tmp:= GiProtocol + GiHost + ':';
  if SelPort then link:= tmp + GiPort else link:= tmp + '3000';

  case SelBrows of
    0: FindDefaultBrowser(tmp,tmp1);
    1: tmp:= FindDefaultExecutablePath(BrowsInst);
    2: tmp:= BrowsPath;
  end;

  fAttr:= FileGetAttr(tmp);

  if ((fAttr <> -1) and ((fAttr and faDirectory) <> 0)) or not FileExists(tmp) then
     begin
       MessageDlg('Gitea Panel', i18_Msg_Err_OpenServer, mtError, [mbOK], 0);
       Exit;
     end;

  t:=TProcess.Create(nil);
  try
    t.Executable:= FindDefaultExecutablePath(tmp);
    t.Parameters.Add(link);
    t.Execute;
  finally
    t.Free
  end;
end;

procedure TForm1.MenuSettingClick(Sender: TObject);
begin
  if Form1.Visible then Hide
  else Form1.Show;
end;

procedure TForm1.MenuStartStopClick(Sender: TObject);
var t:Tprocess;
    s, cmd: String;
    fAtt: LongInt;
begin
  if SelPort then cmd:= ' web --port ' + GiPort   // done: replce to GiPort
  else cmd:= ' web';

  fAtt:= FileGetAttr(GiPatch);

  t:=TProcess.Create(nil);
  try
    if RIR.IsRun then RunCommand('kill',[RIR.GiPID],s,[poWaitOnExit, poUsePipes])
    else
       begin
         if ((fAtt <> -1) and ((fAtt and faDirectory) <> 0)) or not FileExists(GiPatch) then
           begin
             MessageDlg('Gitea Panel', i18_Msg_Err_RunGitea, mtError, [mbOK], 0);
             Exit;
           end;
         t.Executable:='/bin/bash';
         t.Parameters.Add('-c');
         t.Parameters.Add('$(' + GiPatch + cmd +')');
         t.Execute;
       end;
  finally
    t.Free;
  end;
  Sleep(300);
  RIR:= IsRuning(GiFile);
  SetTrayIcon(RIR.IsRun);
end;

procedure TForm1.OKButtonClick(Sender: TObject);
begin
  GiPatch:= EditGiteaPatch.Text;             { done : move #1 to OKButtonClick }
  GiFile:= ExtractFileName(GiPatch);         { done : move #2 to OKButtonClick }
  GiPort:= IntToStr(EditPort.Value);
  SelPort:= RButtSpecPort.Checked;
  BrowsInst:= CoBoxBrow.Text;
  BrowsPath:= EditBrowsPath.Text;

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

end.

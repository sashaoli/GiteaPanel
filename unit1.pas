unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, process, Forms, Controls, Graphics, Dialogs, StdCtrls,
  EditBtn, ButtonPanel, ExtCtrls, Menus, ComboEx, Spin, IniFiles, FileUtil,
  UniqueInstance, LCLIntf;

type
  TGiStatus = record
    IsRun: Boolean;
    GiPID: String;
  end;

type

  { TForm1 }

  TForm1 = class(TForm)
    ButtonPanel1: TButtonPanel;
    CoBoxBrow: TComboBoxEx;
    CoBoxProtocol: TComboBox;
    EditHost: TEdit;
    EditBrowsPath: TFileNameEdit;
    EditGiteaPatch: TFileNameEdit;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    ImageList1: TImageList;
    ImageBrowser: TImageList;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    MenuItem1: TMenuItem;
    MenuAbout: TMenuItem;
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
    procedure CoBoxBrowChange(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
    procedure FormCreate(Sender: TObject);
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

    GiPort: String;
    GiPatch: String;
    GiFile: String;
    GiProtocol: String;
    GiHost: String;
    Brows: String;

    function IsRuning(AProcName: String):TGiStatus;
    procedure ReadIniFile;
    procedure WriteIniFile;
    procedure SetTrayIcon(AGiStatus: Boolean);
  public

  end;

var
  Form1: TForm1;

const
  LOCALHOST = 'http://localhost:';

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

procedure TForm1.ReadIniFile;
var ind: Integer;
    Conf: TIniFile;
begin
  Conf:= TIniFile.Create('.config/giteapanel.conf');
  with Conf do
    try
      GiPatch:= ReadString('DATA','GiteaPath','');
      Brows:= ReadString('DATA','Browser','');
      GiPort:= ReadString('DATA','GiteaPort','');
      SelBrows:= ReadInteger('DATA','SelctedBrowser',0);
      SelPort:= ReadBool('DATA','SelectedPort',False);
      ind:= ReadInteger('DATA','BRW',0);
      GiProtocol:= ReadString('DATA','GiteaProtocol','http://');
      GiHost:= ReadString('DATA','GiteaHost','localhost');
    finally
      Conf.Free;
    end;

  if GiPatch='' then GiFile:= 'gitea' else GiFile:=ExtractFileName(GiPatch);

  EditGiteaPatch.Text:=GiPatch;
  CoBoxBrow.ItemIndex:= ind;

  case SelBrows of
    0:  RButtDefBrows.Checked:= True;
    1:  RButtSelBrows.Checked:= True;
    2:  begin
          RButtOterBrows.Checked:= True;
          EditBrowsPath.Text:= Brows;
        end;
  end;
  RButtSpecPort.Checked:= SelPort;
  EditPort.Value:= StrToInt(GiPort);
  if Not FileExists(GiPatch,False) then Show;
end;

procedure TForm1.WriteIniFile;
var Conf: TIniFile;
begin
  Conf:= TIniFile.Create('.config/giteapanel.conf');
  with Conf do
  try
    WriteString('DATA','GiteaPath',GiPatch);
    WriteString('DATA','GiteaPort',GiPort);
    WriteString('DATA','Browser',Brows);
    WriteInteger('DATA','SelctedBrowser',SelBrows);
    WriteBool('DATA','SelectedPort',SelPort);
    WriteInteger('DATA','BRW',CoBoxBrow.ItemIndex);
    WriteString('DATA','GiteaProtocol',GiProtocol);
    WriteString('DATA','GiteaHost',GiHost);
  finally
    Conf.Free;
  end;
end;

procedure TForm1.SetTrayIcon(AGiStatus: Boolean);
begin
  if AGiStatus then
     begin
       TrayIcon1.Icon.LoadFromResourceName(HINSTANCE, 'GITEAGREEN');
       MenuStartStop.Caption:='Stop Gitea';
       MenuStartStop.ImageIndex:=1;
       MenuOpenGitea.Enabled:=True;
       TrayIcon1.Hint:= 'Gitea is running';
     end
  else
     begin
       TrayIcon1.Icon.LoadFromResourceName(HINSTANCE, 'GITEARED');
       MenuStartStop.Caption:='Start Gitea';
       MenuStartStop.ImageIndex:=0;
       MenuOpenGitea.Enabled:=False;
       TrayIcon1.Hint:= 'Gitea stopped';
     end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  CloseFlag:= False;
  ReadIniFile;
  RIR:= IsRuning(GiFile);
  SetTrayIcon(RIR.IsRun);
  //TrayIcon1.Visible:=true;
end;

procedure TForm1.MenuAboutClick(Sender: TObject);
//var af: frAboutForm;
begin

end;

procedure TForm1.CancelButtonClick(Sender: TObject);
begin
  Hide;
end;


procedure TForm1.CoBoxBrowChange(Sender: TObject);
begin

  //EditBrows.Text:= CoBoxBrow;
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
    1: tmp:= FindDefaultExecutablePath(Brows);
    2: tmp:= Brows;
  end;

  fAttr:= FileGetAttr(tmp);

  if ((fAttr <> -1) and ((fAttr and faDirectory) <> 0)) or not FileExists(tmp) then
     begin
       MessageDlg('Gitea Panel', 'I can not find the browser.' + #13 +
                  'Please specify the browser in the settings.', mtError, [mbOK], 0);
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
             MessageDlg('Gitea Panel', 'I can not find a way to Gitea.' + #13 +
                        'Please specify the path in the settings.', mtError, [mbOK], 0);
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

  case SelBrows of
    0: Brows:= '';
    1: Brows:= CoBoxBrow.ItemsEx.Items[CoBoxBrow.ItemIndex].Caption;
    2: Brows:= EditBrowsPath.Text;
  end;

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


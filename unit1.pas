unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, process, Forms, Controls, Graphics, Dialogs, StdCtrls,
  EditBtn, ButtonPanel, ExtCtrls, Menus, ComboEx, IniFiles, FileUtil,
  UniqueInstance, StrUtils;

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
    EditPort: TEdit;
    EditBrowsPath: TFileNameEdit;
    EditGiteaPatch: TFileNameEdit;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    ImageList1: TImageList;
    ImageBrowser: TImageList;
    Label1: TLabel;
    Label2: TLabel;
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
    TrayIcon1: TTrayIcon;
    UniqueInstance1: TUniqueInstance;
    procedure CancelButtonClick(Sender: TObject);
    procedure CoBoxBrowChange(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
    procedure FormCreate(Sender: TObject);
    procedure MenuCloseClick(Sender: TObject);
    procedure MenuOpenGiteaClick(Sender: TObject);
    procedure MenuSettingClick(Sender: TObject);
    procedure MenuStartStopClick(Sender: TObject);
    procedure OKButtonClick(Sender: TObject);
    procedure RButtPortChange(Sender: TObject);
    procedure RButtBrowsChange(Sender: TObject);

  private
    CloseFlag: Boolean;
    RIR: TGiStatus;
    GiPatch: String;
    GiFile: String;
    Brows: String;
    Conf: TIniFile;
    function IsRuning(AProcName: String):TGiStatus;
    procedure ReadIniFile;
    procedure WriteIniFile;
    procedure SetTrayIcon(AGiStatus: Boolean);
  public

  end;

var
  Form1: TForm1;

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
begin
  Conf:= TIniFile.Create('.config/giteapanel.conf');
  try
    GiPatch:=Conf.ReadString('DATA','GiteaPath','');
    Brows:=Conf.ReadString('DATA','Browser','firefox');
  finally
    Conf.Free;
  end;
  if GiPatch='' then GiFile:= 'gitea' else GiFile:=ExtractFileName(GiPatch);
  EditGiteaPatch.Text:=GiPatch;
  //EditBrows.Text:=Brows;
  if Not FileExists(GiPatch,False) then Show;
end;

procedure TForm1.WriteIniFile;
begin
  Conf:= TIniFile.Create('.config/giteapanel.conf');
  try
    Conf.WriteString('DATA','GiteaPath',EditGiteaPatch.Text);
    //Conf.WriteString('DATA','Browser',EditBrows.Text);
  finally
    Conf.Free;
  end;
  GiPatch:= EditGiteaPatch.Text;
  //Brows:= EditBrows.Text;
  GiFile:= ExtractFileName(GiPatch);
end;

procedure TForm1.SetTrayIcon(AGiStatus: Boolean);
begin
  if AGiStatus then
     begin
       TrayIcon1.Icon.LoadFromResourceName(HINSTANCE, 'GITEAGREEN');
       MenuStartStop.Caption:='Stop Gitea';
       MenuStartStop.ImageIndex:=1;
       MenuOpenGitea.Enabled:=True;
     end
  else
     begin
       TrayIcon1.Icon.LoadFromResourceName(HINSTANCE, 'GITEARED');
       MenuStartStop.Caption:='Start Gitea';
       MenuStartStop.ImageIndex:=0;
       MenuOpenGitea.Enabled:=False;
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
var t:TProcess;
begin
  t:=TProcess.Create(nil);
  try
    t.Executable:= FindDefaultExecutablePath(Brows);
    t.Parameters.Add('http://localhost:3000');
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
    s: String;
begin
  t:=TProcess.Create(nil);
  try
    if RIR.IsRun then RunCommand('kill',[RIR.GiPID],s,[poWaitOnExit, poUsePipes])
    else
       begin
         t.Executable:='/bin/bash';
         t.Parameters.Add('-c');
         t.Parameters.Add('$(' + GiPatch + ' web)');
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
  if (GiPatch <> EditGiteaPatch.Text) {or (Brows <> EditBrows.Text)} then WriteIniFile;
  Hide;
end;

procedure TForm1.RButtPortChange(Sender: TObject);
begin
  EditPort.Enabled:= Not EditPort.Enabled;
end;

procedure TForm1.RButtBrowsChange(Sender: TObject);
var i: Integer;
begin
  with (Sender as TRadioButton) do i:= Tag;
  CoBoxBrow.Enabled:= (((i shr 0) and 1) = 1);
  EditBrowsPath.Enabled:= (((i shr 1) and 1) = 1);
end;

end.


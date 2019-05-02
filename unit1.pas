unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, process, Forms, Controls, Graphics, Dialogs, StdCtrls,
  EditBtn, ButtonPanel, ExtCtrls, Menus, IniFiles, FileUtil;

type
  TGiStatus = record
    IsRun: Boolean;
    GiPID: String;
  end;

type

  { TForm1 }

  TForm1 = class(TForm)
    ButtonPanel1: TButtonPanel;
    EditBrows: TEdit;
    GiteaPatch: TFileNameEdit;
    ImageList1: TImageList;
    Label1: TLabel;
    Label2: TLabel;
    MenuItem1: TMenuItem;
    MenuSetting: TMenuItem;
    MenuStartStop: TMenuItem;
    MenuItem3: TMenuItem;
    MenuOpenGitea: TMenuItem;
    MenuItem5: TMenuItem;
    MenuClose: TMenuItem;
    PopupMenu1: TPopupMenu;
    TrayIcon1: TTrayIcon;
    procedure CancelButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure MenuCloseClick(Sender: TObject);
    procedure MenuOpenGiteaClick(Sender: TObject);
    procedure MenuSettingClick(Sender: TObject);
    procedure MenuStartStopClick(Sender: TObject);
    procedure OKButtonClick(Sender: TObject);
  private
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
  Conf:= TIniFile.Create('giteapanel.conf');
  GiPatch:=Conf.ReadString('DATA','GiteaPath','');
  Brows:=Conf.ReadString('DATA','Browser','');
  if GiPatch='' then GiFile:= 'gitea' else GiFile:=ExtractFileName(GiPatch);
  GiteaPatch.Text:=GiPatch;
  EditBrows.Text:=Brows;
  if Not FileExists(GiPatch,False) or (Brows = '') then Form1.Show;
end;

procedure TForm1.WriteIniFile;
begin
  Conf.WriteString('DATA','GiteaPath',GiteaPatch.Text);
  Conf.WriteString('DATA','Browser',EditBrows.Text);
  GiPatch:= GiteaPatch.Text;
  Brows:= EditBrows.Text;
  GiFile:= ExtractFileName(GiPatch);
end;

procedure TForm1.SetTrayIcon(AGiStatus: Boolean);
begin
  //SendDebugEx('Set icon: PID '+  RIR.GiPID, dlInformation);
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
  ReadIniFile;
  RIR:= IsRuning(GiFile);
  SetTrayIcon(RIR.IsRun);
  TrayIcon1.Visible:=true;
end;

procedure TForm1.CancelButtonClick(Sender: TObject);
begin
  Form1.Hide;
end;

procedure TForm1.MenuCloseClick(Sender: TObject);
begin
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
  if Form1.Visible then Form1.Hide
  else Form1.Show;
end;

procedure TForm1.MenuStartStopClick(Sender: TObject);
var t:Tprocess;
    s: String;
begin
  t:=TProcess.Create(nil);
  //SendDebug('1 - Menu R/S ' + BoolToStr(RIR.IsRun,'Gitea RUN', 'Gitea NOT RUN'));
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
  Sleep(500);
  RIR:= IsRuning(GiFile);
  //SendDebug('2 - Menu R/S ' + BoolToStr(RIR.IsRun,'Gitea RUN', 'Gitea NOT RUN'));
  SetTrayIcon(RIR.IsRun);
end;

procedure TForm1.OKButtonClick(Sender: TObject);
begin
  if (GiPatch <> GiteaPatch.Text) or (Brows <> EditBrows.Text) then WriteIniFile;
  Form1.Hide;
end;

end.


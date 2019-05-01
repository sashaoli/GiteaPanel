unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, process, Forms, Controls, Graphics, Dialogs, StdCtrls,
  EditBtn, ButtonPanel, ExtCtrls, Menus, IniFiles, FileUtil;

type
  TRunStatus = record
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
    procedure TrayIcon1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
  private
    GiPatch: String;
    GiFile: String;
    Brows: String;
    Conf: TIniFile;
    function IsRuning(AProcName:string):TRunStatus;
    procedure ReadIniFile;
    procedure WriteIniFile;
    procedure SetTrayIcon;
  public

  end;

var
  Form1: TForm1;

implementation

{$R *.frm}

{ TForm1 }

function TForm1.IsRuning(AProcName: string): TRunStatus;
var t:Tprocess;
    s:TStringList;
begin
  Result.IsRun:= False;
  Result.GiPID:= '-';
  t:=TProcess.Create(nil);
  t.Executable:= FindDefaultExecutablePath('pgrep');
  t.Parameters.Add('-x');
  t.Parameters.Add('"'+ AProcName +'"');
  t.Options:= [poUsePipes, poWaitOnExit];
  t.Execute;
  s:=TStringList.Create;
  s.LoadFromStream(t.Output);
  Result.IsRun:= s.Text <> '';
  if Result.IsRun then Result.GiPID:= s[0];
  t.Free;
  s.Free;
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

procedure TForm1.SetTrayIcon;
var RIR:TRunStatus;
begin
  RIR:= IsRuning(GiFile);
  //ShowMessage('Set icon: PID '+ RIR.GiPID);
  if RIR.IsRun then
     begin
       //ShowMessage('Set icon: STOP');
       TrayIcon1.Icon.LoadFromResourceName(HINSTANCE, 'GITEAGREEN');
       MenuStartStop.Caption:='Stop Gitea';
       MenuStartStop.ImageIndex:=1;
       MenuOpenGitea.Enabled:=True;
     end
  else
     begin
       //ShowMessage('Set icon: RUN');
       TrayIcon1.Icon.LoadFromResourceName(HINSTANCE, 'GITEARED');
       MenuStartStop.Caption:='Start Gitea';
       MenuStartStop.ImageIndex:=0;
       MenuOpenGitea.Enabled:=False;
     end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  ReadIniFile;
  SetTrayIcon;
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
  t.Executable:= FindDefaultExecutablePath(Brows);
  t.Parameters.Add('http://localhost:3000');
  t.Execute;
  t.Free
end;

procedure TForm1.MenuSettingClick(Sender: TObject);
begin
  if Form1.Visible then Form1.Hide
  else Form1.Show;
end;

procedure TForm1.MenuStartStopClick(Sender: TObject);
var t:Tprocess;
    RIR:TRunStatus;
begin
  t:=TProcess.Create(nil);
  RIR:= IsRuning(GiFile);
  //ShowMessage('Menu R/S click: '+BoolToStr(RIR.IsRun,'Gitea run', 'Gitea stop')+ #13 +
  //'Menu R/S click: PID Gitea: '+RIR.GiPID);
  if RIR.IsRun then
     begin
       t.Executable:=FindDefaultExecutablePath('kill');
       t.Parameters.Add(RIR.GiPID);
       t.Options:=[poWaitOnExit];
       t.Execute;
     end
  else
     begin
       t.Executable:=GiPatch;
       t.Parameters.Add('web');
       t.Execute;
     end;
  t.Free;
  //ShowMessage('PreEnd procedure');
  SetTrayIcon;
end;

procedure TForm1.OKButtonClick(Sender: TObject);
begin
  if (GiPatch <> GiteaPatch.Text) or (Brows <> EditBrows.Text) then WriteIniFile;
  Form1.Hide;
end;

procedure TForm1.TrayIcon1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  SetTrayIcon;
end;

end.


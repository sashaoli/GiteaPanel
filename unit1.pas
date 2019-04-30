unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, process, Forms, Controls, Graphics, Dialogs, StdCtrls,
  EditBtn, ButtonPanel, ExtCtrls, Menus, IniFiles;

type

  { TForm1 }

  TForm1 = class(TForm)
    ButtonPanel1: TButtonPanel;
    EditBrows: TEdit;
    GiteaPatch: TFileNameEdit;
    ImageList1: TImageList;
    Label1: TLabel;
    Label2: TLabel;
    MenuSetting: TMenuItem;
    MenuStart: TMenuItem;
    MenuStop: TMenuItem;
    MenuItem3: TMenuItem;
    MenuOpenGitea: TMenuItem;
    MenuItem5: TMenuItem;
    MenuClose: TMenuItem;
    PopupMenu1: TPopupMenu;
    Process1: TProcess;
    TrayIcon1: TTrayIcon;
    procedure CancelButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure MenuCloseClick(Sender: TObject);
    procedure MenuSettingClick(Sender: TObject);
    procedure OKButtonClick(Sender: TObject);
  private
    GiPatch:String;
    Brows:String;
    Conf:TIniFile;
  public

  end;

var
  Form1: TForm1;

implementation

{$R *.frm}

{ TForm1 }


procedure TForm1.FormCreate(Sender: TObject);
begin
  Conf:= TIniFile.Create('giteapanel.conf');
  GiPatch:=Conf.ReadString('DATA','GiteaPath','');
  Brows:=Conf.ReadString('DATA','Browser','');
  GiteaPatch.Text:=GiPatch;
  EditBrows.Text:=Brows;
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

procedure TForm1.MenuSettingClick(Sender: TObject);
begin
  if Form1.Visible then Form1.Hide
  else Form1.Show;
end;

procedure TForm1.OKButtonClick(Sender: TObject);
begin
  if (GiPatch <> GiteaPatch.Text) or (Brows <> EditBrows.Text) then
     begin
       Conf.WriteString('DATA','GiteaPath',GiteaPatch.Text);
       Conf.WriteString('DATA','Browser',EditBrows.Text);
       GiPatch:=GiteaPatch.Text;
       Brows:=EditBrows.Text;
     end;
  Form1.Hide;
end;

end.


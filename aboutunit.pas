unit aboutunit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  resstr, InterfaceBase, FileInfo, LCLVersion;


type
  TAppInfo = record
    CName:     String;
    FDescr:    String;
    FVer:      String;
    LCopyr:    String;
    OFName:    String;
    PName:     String;
    PVer:      String;
    IName:     String;

    SVNRevis:  String;
    FPVer:     String;
    CPUTarget: String;
    OSTarget:  String;
    CTVer:     String;
    BDate:     String;
    NWidget:   String;
  end;

type

  { TAboutForm }

  TAboutForm = class(TForm)
    Image1: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure Label5Click(Sender: TObject);
    procedure Label5MouseEnter(Sender: TObject);
    procedure Label5MouseLeave(Sender: TObject);

  private

  public

  end;

function GetAppInfo: TAppInfo;
function RunAboutForm: Boolean;

var
  AboutForm: TAboutForm;
  AppInfo: TAppInfo;

implementation

uses mainunit;

function GetAppInfo: TAppInfo;
var inf: TFileVersionInfo;
begin
  inf:= TFileVersionInfo.Create(nil);
  try
    inf.ReadFileInfo;
    with inf.VersionStrings do
      begin
        Result.CName   := Values['CompanyName'];
        Result.FDescr  := Values['FileDescription'];
        Result.FVer    := Values['FileVersion'];
        Result.IName   := Values['InternalName'];
        Result.LCopyr  := Values['LegalCopyright'];
        Result.OFName  := Values['OriginalFilename'];
        Result.PName   := Values['ProductName'];
        Result.PVer    := Values['ProductVersion'];
      end;
    Result.CPUTarget   := {$I %FPCTARGETCPU%};
    Result.OSTarget    := {$I %FPCTARGETOS%};
    Result.CTVer       := lcl_version;
    Result.FPVer       := {$I %FPCVERSION%};
    Result.SVNRevis    := {$I project_svnrevision.inc};
    Result.BDate       := {$I %DATE%};
    Result.NWidget     := GetLCLWidgetTypeName;
  finally
    inf.Free;
  end;
end;

function RunAboutForm: Boolean;
begin
  Result:= True;
  if not Assigned(AboutForm) then AboutForm:= TAboutForm.Create(Application);
  try
    AboutForm.Show;
  except
    AboutForm.Free;
    FreeAndNil(AboutForm);
  end;
end;

{$R *.frm}

{ TAboutForm }

procedure TAboutForm.FormShow(Sender: TObject);
begin
  DisableAutoSizing;
  Image1.Picture.LoadFromResourceName(HINSTANCE, 'GITEAGREEN');
  Label3.Caption:= AppInfo.PName.Split(' ')[0];
  Label4.Caption:= AppInfo.PName.Split(' ')[1];
  Label1.Caption:= i18_Program       + #10 + // line 1
                   i18_CodeRivis     + #10 + // line 2
                   'CodeTyphon:'     + #10 + // line 3
                   'FreePascal:'     + #10 + // line 4
                   i18_ForTarget     + #10 + // line 5
                   i18_Widget        + #10 + // line 6
                   i18_BuildDate;            // line 7

  Label2.Caption:=  i18_Version + AppInfo.PVer                 + #10 +  // line 1
                    AppInfo.SVNRevis                           + #10 +  // line 2
                    i18_Version + AppInfo.CTVer                + #10 +  // line 3
                    i18_Version + AppInfo.FPVer                + #10 +  // line 4
                    AppInfo.CPUTarget + '-' + AppInfo.OSTarget + #10 +  // line 5
                    Appinfo.NWidget                            + #10 +  // line 6
                    AppInfo.BDate;                                      // line 7
  //Label5.Caption:= i18_Copyright + LCopyr;
  //AboutForm.Width:= Label2.Left + Label2.Width + 25;
  EnableAutoSizing;
end;

procedure TAboutForm.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  CloseAction:= caFree;
  FreeAndNil(AboutForm);
end;

procedure TAboutForm.Label5Click(Sender: TObject);
begin
  Label5.Font.Color:= clDefault;
  Label5.Font.Style:= [fsBold];
  OpenLink('https://github.com/sashaoli/GiteaPanel');
end;

procedure TAboutForm.Label5MouseEnter(Sender: TObject);
begin
  Label5.Font.Color:= clBlue;
  Label5.Font.Style:= [fsBold,fsUnderline];
end;

procedure TAboutForm.Label5MouseLeave(Sender: TObject);
begin
  Label5.Font.Color:= clDefault;
  Label5.Font.Style:= [fsBold];
end;

initialization
  AppInfo:= GetAppInfo;

end.

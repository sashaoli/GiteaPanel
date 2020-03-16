unit aboutunit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  resstr, InterfaceBase, FileInfo, LCLVersion, lclintf;

type

  { TAboutForm }

  TAboutForm = class(TForm)
    Image1: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    procedure FormShow(Sender: TObject);
    procedure Label5Click(Sender: TObject);
    procedure Label5MouseEnter(Sender: TObject);
    procedure Label5MouseLeave(Sender: TObject);

  private

  public

  end;

var
  AboutForm: TAboutForm;

implementation

{$R *.frm}

{ TAboutForm }

procedure TAboutForm.FormShow(Sender: TObject);
var inf: TFileVersionInfo;
    CName, FDescr, FVer, LCopyr, OFName, PName, PVer, IName: String;
begin
  inf:= TFileVersionInfo.Create(nil);
  try
    inf.ReadFileInfo;
    with inf.VersionStrings do
    begin
      CName   := Values['CompanyName'];
      FDescr  := Values['FileDescription'];
      FVer    := Values['FileVersion'];
      IName   := Values['InternalName'];
      LCopyr  := Values['LegalCopyright'];
      OFName  := Values['OriginalFilename'];
      PName   := Values['ProductName'];
      PVer    := Values['ProductVersion'];
    end;
  finally
    inf.Free;
  end;

  Image1.Picture.LoadFromResourceName(HINSTANCE, 'GITEAGREEN');
  Label3.Caption:= Copy(PName,1, Pos(' ',PName)-1);
  Label4.Caption:= Copy(PName,Pos(' ',PName)+1, Length(PName));
  Label1.Caption:= i18_Program       + #10 + // line 1
                   i18_CodeRivis     + #10 + // line 2
                   'CodeTyphon:'     + #10 + // line 3
                   'FreePascal:'     + #10 + // line 4
                   i18_ForTarget     + #10 + // line 5
                   i18_Widget        + #10 + // line 6
                   i18_BuildDate;            // line 7

  Label2.Caption:=  i18_Version + PVer + #10 +
                    {$I project_svnrevision.inc} + #10 +
                    i18_Version + LCLVersion + #10 +
                    i18_Version + {$I %FPCVERSION%} + #10 +
                    {$I %FPCTARGETCPU%} + '-' + {$I %FPCTARGETOS%} + #10 +
                    GetLCLWidgetTypeName + #10 +
                    {$I %DATE%};
  //Label5.Caption:= i18_Copyright + LCopyr;
  AboutForm.Width:= Label2.Left + Label2.Width + 25;
end;

procedure TAboutForm.Label5Click(Sender: TObject);
begin
  Label5.Font.Color:= clDefault;
  Label5.Font.Style:= [fsBold];
  OpenURL('https://github.com/sashaoli/GiteaPanel');
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

end.
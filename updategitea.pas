unit updategitea;

{$mode objfpc}{$H+}

interface

uses
  {$IFDEF UNIX} BaseUnix, {$ENDIF}
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ComCtrls,
  ExtCtrls, Buttons, fpjson, jsonparser, resstr, opensslsockets, {openssl,} base64,
  fphttpclient, process{, logger};

type
  TGHData = record
    GiteaVersion: string;
    DownloadUrl: String;
  end;

type
  TButtType = (BtnOk, BtnYes, BtnNo);
  TArrayBut = array of TButtType;
  TImageType = (imOk, imCheck, imErr, imDownload, imLamp);

type

  { TFormUpdGitea }

  TFormUpdGitea = class(TForm)
    BitBtnUpd: TBitBtn;
    BitBtnCancel: TBitBtn;
    BitBtnOk: TBitBtn;
    Image1: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Panel1: TPanel;
    Panel2: TPanel;
    ProgressBar1: TProgressBar;
    Timer1: TTimer;
    procedure BitBtnCancelClick(Sender: TObject);
    procedure BitBtnOkClick(Sender: TObject);
    procedure BitBtnUpdClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure CheckUpdateDownload(Sender: TObject);
    procedure BitBtnVisidle(aImageType: TImageType; aVisButt: TArrayBut);
  private
    function GetCurrentVersion(aFilePath: String): String;
    function GetGitHubData(aUrl, aOSIdent: String; out outError: String): TGHData;
    function _Download(aUrl, aOutFile: string): Boolean;
    function CheckString(aStr, aInclude, aExclude: String; aDelim: Char): Boolean;
    procedure Progress(Sender: TObject; const aMaxLength, aCopyLength: Int64);
    procedure SetProxy(aHTTPclient:TFPHTTPClient);
  public
    GHData: TGHData;
    CurrVer: String;
    function CompareVersion(aOldVersion, aNewVersion: String): Boolean;
  end;

var
  FormUpdGitea: TFormUpdGitea;

const
  GITHUB_URL = 'https://api.github.com/repos/go-gitea/gitea/releases/latest';
  EXCLUDE_STRING = '.asc,.sha256,.xz,.xz.asc,.xz.sha256';

implementation

uses mainunit;


{$R *.frm}

{ TFormUpdGitea }


procedure TFormUpdGitea.Progress(Sender: TObject; const aMaxLength, aCopyLength: Int64);
begin
  ProgressBar1.Position:= Trunc(aCopyLength/aMaxLength*100);
  Application.ProcessMessages;
  //log.LogStatus(Sender.ClassName, 'Progress');
end;

procedure TFormUpdGitea.SetProxy(aHTTPclient: TFPHTTPClient);
begin
  if UseProxyStatus then
    with aHTTPclient do
      begin
        Proxy.Host:= ProxyHost;
        Proxy.Port:= ProxyPort;
        Proxy.UserName:= ProxyUser;
        Proxy.Password:= DecodeStringBase64(ProxyPass);
      end;
end;

function TFormUpdGitea.CompareVersion(aOldVersion, aNewVersion: String): Boolean;
var min, i: Integer;
begin
  Result:= false;
  if High(aOldVersion.Split('.')) < High(aNewVersion.Split('.')) then min:= High(aOldVersion.Split('.'))
  else min:= High(aNewVersion.Split('.'));
  for i:= 0 to min do
      if StrToInt(aNewVersion.Split('.')[i]) > StrToInt(aOldVersion.Split('.')[i]) then
        begin
          Result:= True;
          Break;
        end;
end;

procedure TFormUpdGitea.FormShow(Sender: TObject);
begin
  DisableAutoSizing;
  ProgressBar1.Visible:= False;
  BitBtnVisidle(imCheck,[]);
  Label1.Caption:= i18_GeCurrentVersion;
  Label2.Caption:= ' ';
  EnableAutoSizing;
  Timer1.Enabled:= True;
end;

procedure TFormUpdGitea.BitBtnCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TFormUpdGitea.BitBtnOkClick(Sender: TObject);
begin
  Close;
end;

procedure TFormUpdGitea.BitBtnUpdClick(Sender: TObject);
var RunStatus: Boolean;
begin
  BitBtnVisidle(imDownload,[]);
  RunStatus:= MainForm.IsRuning(GiFile);
  if RunStatus then MainForm.StopGiteaServer;
  Sleep(300);
  RenameFile(GiPath, GiPath + '_' + CurrVer);
  Label2.Caption:= i18_DownloadFile;
  ProgressBar1.Visible:= True;
  if _Download(GHData.DownloadUrl, GiPath) then
    begin
      FpChmod(GiPath, &755);
      Label1.Caption:= i18_CurrentVersion + GetCurrentVersion(GiPath);
      Label2.Caption:= i18_UpfradeComplete;
      BitBtnVisidle(imOk,[BtnOk]);
    end
  else begin
      Label2.Caption:= I18_Err_DownloadFile;
      BitBtnVisidle(imErr,[BtnOk]);
  end;
  if RunStatus then MainForm.RunGiteaServer;
end;

procedure TFormUpdGitea.CheckUpdateDownload(Sender: TObject);
var ErrGHData: String;
begin
  Timer1.Enabled:= False;
  if not DirectoryExists(ExtractFileDir(GiPath)) then
    begin
      Label1.Caption:= i18_Msg_Err_RunGitea;
      BitBtnVisidle(imErr,[BtnOk]);
      Exit;
    end;
  CurrVer:= GetCurrentVersion(GiPath);
  Label1.Caption:= i18_CurrentVersion + CurrVer;
  If OSIdent <> '' then
    begin
      Label2.Caption:= i18_CheckNewversion;
      Application.ProcessMessages;
      GHData:= GetGitHubData(GITHUB_URL, OSIdent, ErrGHData);
      if ErrGHData = '' then
        if CompareVersion(CurrVer, GHData.GiteaVersion) then
          begin
            Label2.Caption:= i18_NewVersionAvailable + GHData.GiteaVersion;
            BitBtnVisidle(imLamp,[BtnYes,BtnNo]);
          end
        else
          begin
            Label2.Caption:= i18_LatesVersion;
            BitBtnVisidle(imOk,[BtnOk]);
          end
      else begin
        Label2.Caption:= ErrGHData;
        BitBtnVisidle(imErr,[BtnOk]);
      end;
    end
  else
    begin
      Label2.Caption:= i18_Err_NotOSIdent;
      BitBtnVisidle(imErr,[BtnOk]);
    end;
end;

procedure TFormUpdGitea.BitBtnVisidle(aImageType: TImageType;
  aVisButt: TArrayBut);

  function InArray(aBtnType: TButtType): Boolean;
  var i: Integer;
  begin
    Result:= False;
    for i:= Low(aVisButt) to High(aVisButt) do
      if aBtnType = aVisButt[i] then begin
        Result:= true;
        Break;
      end;
  end;

begin
  BitBtnCancel.Visible:= InArray(BtnNo);
  BitBtnOk.Visible:= InArray(BtnOk);
  BitBtnUpd. Visible:= InArray(BtnYes);

  case aImageType of
    imOk:         Image1.Picture.LoadFromResourceName(HINSTANCE, 'OK');
    imCheck:      Image1.Picture.LoadFromResourceName(HINSTANCE, 'CHECK');
    imDownload:   Image1.Picture.LoadFromResourceName(HINSTANCE, 'DOWNLOAD');
    imErr:        Image1.Picture.LoadFromResourceName(HINSTANCE, 'ERROR');
    imLamp:       Image1.Picture.LoadFromResourceName(HINSTANCE, 'LAMP');
  end;
end;

function TFormUpdGitea.GetCurrentVersion(aFilePath: String): String;
begin
  Try
    RunCommand(aFilePath + ' -v', Result);
    if Result <> '' then Result:= Result.Split(' ')[2] else Result:= '0.0.0';
  except
    on Err:Exception do Result:= '0.0.0';
  end;
end;

function TFormUpdGitea.GetGitHubData(aUrl, aOSIdent: String; out outError: String): TGHData;
var i: Integer;
    J: TJSONData;
    JA: TJSONArray;
    HC: TFPHTTPClient;
begin
  //InitSSLInterface;
  Result.GiteaVersion:= '0.0.0';
  Result.DownloadUrl:= '';
  outError:= '';
  J:= nil;
  HC:= TFPHTTPClient.Create(nil);
  with HC do
    try
      SetProxy(HC);
      AllowRedirect:= True;
      AddHeader('User-Agent','GiteaPanel');  //!!!!!!!  Mozilla/5.0 (compatible; fpweb)
      try
        J:= GetJSON(Get(aUrl));
        Result.GiteaVersion:= StringReplace(j.FindPath('tag_name').AsString, 'v','',[]);
        JA:= TJSONArray(j.FindPath('assets'));
        for i:= 0 to JA.Count - 1 do
          if CheckString(JA[i].FindPath('name').AsString, aOSIdent, EXCLUDE_STRING,',') then
            begin
              Result.DownloadUrl:= JA[i].FindPath('browser_download_url').AsString;
              Break;
            end;
      except
        on Err: Exception do outError:= i18_Msg_Err_GetGitHubData + #13 + Err.Message;
      end;
    finally
      J.Free;
      Free;
    end;
end;

function TFormUpdGitea._Download(aUrl, aOutFile: string): Boolean;
var HC: TFPHTTPClient;
begin
  HC:= TFPHTTPClient.Create(nil);
  with HC do
    try
      SetProxy(HC);
      AllowRedirect:= True;
      OnDataReceived:= @Progress;
      AddHeader('User-Agent','GiteaPanel');
      try
        Get(aUrl,aOutFile);
        Result:= 200 = ResponseStatusCode;
      except
        on Err: Exception do Result:= False;
      end;
    finally
      Free;
    end;
end;

function TFormUpdGitea.CheckString(aStr, aInclude, aExclude: String; aDelim: Char): Boolean;
var i, r: Integer;
    IncArray, ExcArray: TStringArray;
begin
  Result:= False;
  if Length(aInclude) = 0 then Exit;
  if Length(aExclude) <> 0 then
    begin
      ExcArray:= aExclude.Split(aDelim);
      for i:= Low(ExcArray) to High(ExcArray) do if Pos(ExcArray[i], aStr) <> 0 then Exit;
    end;
  IncArray:= aInclude.Split(aDelim);
  r:= 0;
  for i:= Low(IncArray) to High(IncArray) do
    if Pos(IncArray[i], aStr) > 0 then Inc(r);
  Result:= r = High(IncArray)+1;
end;

end.


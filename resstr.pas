unit resstr;

interface

resourcestring
  i18_GiteaStoped               = 'Gitea stoped';
  i18_GiteaRunig                = 'Gitea is runing';
  i18_StartGitea                = 'Start Gitea';
  i18_StopGitea                 = 'Stop Gitea';
  i18_Msg_Err_NoFindBrowser     = 'I can not find the browser "%s". Please specify the browser in the settings.';
  i18_Msg_Err_RunGitea          = 'I can not find a way to Gitea.' + #13 + 'Please specify the path in the settings.';
  i18_DlgTitle_Giteapatch       = 'Select Gitea binary file';
  i18_DlgTitle_BrowsPath        = 'Select browser binary file';
  i18_Program                   = 'Program:';
  i18_CodeRivis                 = 'Code revision:';
  i18_ForTarget                 = 'For CPU, OS:';
  i18_Widget                    = 'Widget:';
  i18_BuildDate                 = 'Build date:';
  i18_Version                   = 'version ';
  i18_Copyright                 = 'Copyright: ';
  i18_Msg_Err_CantOpenServer    = 'Can''t open gitea server from link: "%s"';
  i18_Msg_ReRunApp              = 'Language settings changed.' + #13 + 'Save parameters and restart the application to apply these parameters?';
  i18_Msg_Err_GetVerGitea       = 'Error defining version of Gitea!';
  i18_Msg_Err_GetGitHubData     = 'Error retrieving data from GitHub!';
  i18_Msg_Err_MissingFromHosts  = 'The "%s" is not in the host file. Add it to the "/etc/hosts" file: "127.0.0.1  %s"';
  i18_GeCurrentVersion          = 'Get the current version of Gitea...';
  i18_CurrentVersion            = 'Current version of Gitea: ';
  i18_CheckNewVersion           = 'Checking for a new version of Gitea...';
  i18_NewVersionAvailable       = 'New version of Gitea is available: ';
  i18_LatesVersion              = 'You have the latest version of Gitea.';
  i18_Err_DownloadFile          = 'Failed to download file.';
  i18_DownloadFile              = 'Download file...';
  i18_UpfradeComplete           = 'Download and upgrade complete.';
  i18_Err_NotOSIdent            = 'The operating system is not specified in the settings.' + #13 + 'Specify your operating system in the settings.';
  i18_Err_NoConfirmPass         = 'Passwords do not match.' + #13 + 'Please re-enter your password.';
  i18_CancelDownload            = 'Discard update Gitea?';

const
  WBROWSER='chromium-*;'+
           'vivaldi-*;'+
           'firefox*;'+
           'brave*;'+
           'epiphany*;'+
           'konqueror*;'+
           'falkon*;'+
           'midori*;'+
           'opera-*;'+
           'google-chrome*;'+
           'arora*;'+
           'palemoon*;'+
           'seamonkey*;'+
           'waterfox*;'+
           'yandex*;'+
           'beaker*;'+
           'netsurf*;'+
           'dillo*;'+
           'conkeror*;'+
           'iridium*;'+
           'links*;'+
           'lynx*;'+
           'elinks*;'+
           'w3m*';

implementation

end.

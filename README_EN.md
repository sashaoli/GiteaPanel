# Gitea Panel

[![download]](https://github.com/sashaoli/GiteaPanel/releases/latest) [![release]](https://github.com/sashaoli/GiteaPanel/releases/latest) ![plathorm][platform] ![AppImage][appimage] [![MIT license][license]](./LICENSE.md) [![CodeTyphon 7.20][typhon]](https://www.pilotlogic.com/sitejoom/)

*Перемкнутися на [Українську](./README.md)*

### Manage the local Gitea server from the tray.

## Features.
- Start/Stop Gitea server.
- Opens the Gitea page in the selected browser.
- Update Gitea to the latest version.

## Install.
1.  Download and Install the application from the deb package and launch from the main menu of your system. Example:
    ```
    curl -L -O https://github.com/sashaoli/GiteaPanel/releases/download/v0.7.0/giteapanel_0.7.0_amd64.deb
    sudo dpkg -i giteapanel_0.7.0_amd64.deb
    ```
    Or, to start the program, use the AppImage file. Example:
    ```
    curl -L -O https://github.com/sashaoli/GiteaPanel/releases/download/v0.7.0/giteapanel_0.7.0_amd64.AppImage
    chmod +x giteapanel_0.7.0_amd64.AppImage
    ```
    > For environment **"Gnome"** must be installed extension ["TopIcons"](https://extensions.gnome.org/extension/495/topicons/), or ["TopIcons Plus"](https://extensions.gnome.org/extension/1031/topicons/), or ["Tray Icons"](https://extensions.gnome.org/extension/1503/tray-icons/).

2.  In the "Gitea path" field, specify the path to the binary file of the Gitea server. The file name is preferably "gitea".
3.  Click the "Gitea update options" button and in the "OS Idettification" field, specify your operating system.
4.  Change the program language if necessary.

## Usage.
The program is controlled from the tray by right-clicking. Double-clicking on the tray icon launches the Gitea server and opens the Gitea page in the browser.

## Translate.
Currently the program supports the following languages:

| Language   | code |
| ---------- | ---- |
| Belarusian | `be` |
| German     | `de` |
| English    | `en` |
| Polish     | `pl` |
| Russian    | `ru` |
| Ukrainian  | `uk` |

*The translation may contain errors because it was made using a machine translator.*

If you **find an error in the translation of the program - please report it**, indicating the translation language code, the original text in English and the correct translation text. For example:

| Language code | Original text in English                 | Correct translation text            |
| ------------- | ---------------------------------------- | ----------------------------------- |
| `pl`          | `Checking for a new version of Gitea...` | `Sprawdzanie nowej wersji Gitea...` |

[download]: https://img.shields.io/github/downloads/sashaoli/GiteaPanel/total?style=flat
[release]:  https://img.shields.io/github/v/release/sashaoli/Giteapanel?style=flat
[platform]: https://img.shields.io/badge/platform-linux--64%20%7C%20linux--32-red
[appimage]: https://img.shields.io/badge/AppImage-x86__x64%20%7C%20i386-9cf
[license]:  http://img.shields.io/badge/license-MIT-brightgreen.svg
[typhon]:   https://img.shields.io/badge/CodeTyphon-7.20-green.svg

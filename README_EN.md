# Gitea Panel

[![download](https://img.shields.io/github/downloads/sashaoli/GiteaPanel/total?style=plastic)](https://github.com/sashaoli/GiteaPanel/releases/latest) [![release](https://img.shields.io/github/v/release/sashaoli/Giteapanel?style=plastic)](https://github.com/sashaoli/GiteaPanel/releases/latest) [![GitHub](https://img.shields.io/github/license/sashaoli/GiteaPanel?style=plastic)](./LICENSE.md)

_Перемкнутися на [Українську](./README.md)_

### Manage the local Gitea server from the tray.

## Features.
- Start/Stop Gitea server.
- Opens the Gitea page in the selected browser.
- Update Gitea to the latest version.

## Install.
1.  Download and Install the application from the deb package and launch from the main menu of your system. Example:
    ```
    curl -L -O https://github.com/sashaoli/GiteaPanel/releases/download/v0.5.6/giteapanel_0.5.6_amd64.deb
    sudo dpkg -i giteapanel_0.5.6_amd64.deb
    ```
    Or, to start the program, use the AppImage file. Example:
    ```
    curl -L -O https://github.com/sashaoli/GiteaPanel/releases/download/v0.5.6/giteapanel_0.5.6_x86_64.AppImage
    chmod +x giteapanel_0.5.6_x86_64.AppImage
    ```

    > For environment **"Gnome"** must be installed extension ["TopIcons"](https://extensions.gnome.org/extension/495/topicons/), or ["TopIcons Plus"](https://extensions.gnome.org/extension/1031/topicons/), or ["Tray Icons"](https://extensions.gnome.org/extension/1503/tray-icons/). Also, similar extensions must be installed for others **"Unity"**.

2.  In the "Gitea path" field, specify the path to the binary file of the Gitea server. The file name is preferably "gitea".
3.  Click the "Gitea update options" button and in the "OS Idettification" field, specify your operating system.
4.  Change the program language if necessary.

## Usage.
The program is controlled from the tray by right-clicking. Double-clicking on the tray icon launches the Gitea server and opens the Gitea page in the browser.

## Translate.
Currently the program supports three languages: Ukrainian, English, Russian.

# Gitea Panel

[![download](https://img.shields.io/github/downloads/sashaoli/GiteaPanel/total?style=flat)](https://github.com/sashaoli/GiteaPanel/releases/latest) [![release](https://img.shields.io/github/v/release/sashaoli/Giteapanel?style=flat)](https://github.com/sashaoli/GiteaPanel/releases/latest) [![MIT license](http://img.shields.io/badge/license-MIT-brightgreen.svg)](./LICENSE.md)

*Swith to [English](./README_EN.md)*

### Управління локальним сервером Gitea з трею.

![ScreenMenu](resource/ScreenMenu.png)

![ScreenSeting](resource/ScreenSeting.png)

![ScreenAbout](resource/ScreenAbout.png)

*Swith to [English](./README_EN.md)*

## Можливості.
- Запуск/Зупинка сервера Gitea.
- Відкриття сторінки Gitea у вибраному браузері.
- Оновлення Gitea до останньої версії.

## Встановлення.
1. Завантажте та встановіть програму з деб-пакунка та запустіть з головного меню Вашої системи. До прикладу:
    ```
    curl -L -O https://github.com/sashaoli/GiteaPanel/releases/download/v0.6.0/giteapanel_0.6.0_amd64.deb
    sudo dpkg -i giteapanel_0.6.0_amd64.deb
    ```
    Або, для запуску програми, використовуйте файл AppImage. До прикладу:
    ```
    curl -L -O https://github.com/sashaoli/GiteaPanel/releases/download/v0.6.0/giteapanel_0.6.0_x86_64.AppImage
    chmod +x giteapanel_0.6.0_x86_64.AppImage
    ```
    > Для оточення **"Gnome"** необхідно встановити розширення ["TopIcons"](https://extensions.gnome.org/extension/495/topicons/), або ["TopIcons Plus"](https://extensions.gnome.org/extension/1031/topicons/), або ["Tray Icons"](https://extensions.gnome.org/extension/1503/tray-icons/).

2.  Вкажіть, у полі "Gitea path", шлях до бінарного файлу сервера Gitea. Бажано, щоб назва файлу була "gitea".
3.  Натисніть кнопку "Gitea update options" та у полі "OS Idettification" вкажіть Вашу операційну систему.
4.  За необхідності змініть мову програми.

## Використання.
Управління програмою здійснюється з трею при кліку правою кнопкою мишки. Подвійний клік на іконці в трею запускає сервер Gitea та відкриває сторінку Gitea в браузері.

## Переклад.
На даний момент програма підтримує такі мови:

Мова|код
----|-----
Білоруська|`be`
Германська|`de`
Англійська|`en`
Польська|`pl`
Російська|`ru`
Українська|`uk`

*У перекладі можуть міститися помилки, оскільки він здійснений за допомогою машинного перекладача.*

Якщо, Ви, **знайшли помилку у перекладі програми - будь-ласка повідомте про неї**, вказавши код мови перекладу, оригінальний текст англійською та правильний текст перекладу. До прикладу:

| код мови | оригінальний текст англійською           | правильний текст перекладу          |
| -------- | ---------------------------------------- | ----------------------------------- |
| `pl`     | `Checking for a new version of Gitea...` | `Sprawdzanie nowej wersji Gitea...` |

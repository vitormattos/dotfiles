# Setup dotfiles

For a long time, every time I needed to format my notebook I had to configure my entire working environment after formatting, installing and adjusting all the systems I use on a daily basis (or I think I use them). I saw that this work was always thrown away and redone with each new setup, so I decided to automate the manual actions so as not to lose them.

## How to use

Use `make` without targets to list all the follow targets:

| Target             | Description                                                                                                         |
| ------------------ | ------------------------------------------------------------------------------------------------------------------- |
| act                | Run your GitHub Actions locally                                                                                     |
| adb                | Install adb                                                                                                         |
| appimage-launcher  | Helper application for Linux distributions serving as a kind of "entry point" for running and integrating AppImages |
| bashrc             | My custom bashrc                                                                                                    |
| codium             | Binary releases of VS Code without MS branding/telemetry/licensing                                                  |
| dbeaver            | Install dbeaver                                                                                                     |
| docker             | Setup docker                                                                                                        |
| essentials         | Essentials binaries                                                                                                 |
| firefox-developer  | Firefox developer edition                                                                                           |
| firefox            | Firefox without ppa                                                                                                 |
| gestures           | My custom gestures                                                                                                  |
| github-cli         | Work seamlessly with GitHub from the command line                                                                   |
| git                | Setup git with small customizations                                                                                 |
| gpg                | Setup essentials to sign git commits and configure                                                                  |
| insomnia           | Insomnia API client                                                                                                 |
| keepassxc-develop  | Setup keepassxc from source                                                                                         |
| keepassxc          | Setup keepassxc                                                                                                     |
| nextcloud-desktop  | Desktop sync client for Nextcloud. Will be good to run the target appimage-launcher                                 |
| obs-flatpak        | Install OBS Studio from flatpak                                                                                     |
| onlyoffice-desktop | ONLYOFFICE Desktop                                                                                                  |
| slim               | Slim(toolkit). Don't change anything in your container image and minify it by up to 30x making it secure too!       |
| telegram-flatpak   | Install Telegram from flatpak                                                                                       |
| telegram           | Telegram oficial                                                                                                    |
| udev               | Install udev rules                                                                                                  |
| vim                | Setup my vimrc                                                                                                      |
| vscode             | VS Code                                                                                                             |
| youtube-dl         | A youtube-dl fork with additional features and fixes                                                                |

To run a target use `make <target-name>`

## Environments to makefile

| Name            | Default value | Description                    |
| --------------- | ------------- | ------------------------------ |
| `PROJECTS_PATH` | `~/projects`  | The path to store all projects |

Example to rum make using an environment:

```bash
PROJECTS_PATH=~/Projects make essentials
```
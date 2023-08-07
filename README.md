# Setup dotfiles

Use `make` without targets to list all the follow targets:

| Target              | Description                                                                                                         |
| ------------------- | ------------------------------------------------------------------------------------------------------------------- |
| `act`               | Run your GitHub Actions locally                                                                                     |
| `adb`               | Install adb and setup udev rules                                                                                    |
| `appimage-launcher` | Helper application for Linux distributions serving as a kind of "entry point" for running and integrating AppImages |
| `bashrc`            | My custom bashrc                                                                                                    |
| `codium`            | Binary releases of VS Code without MS branding/telemetry/licensing                                                  |
| `dbeaver`           | Install dbeaver                                                                                                     |
| `docker`            | Setup docker                                                                                                        |
| `essentials`        | Essentials binaries                                                                                                 |
| `firefox-developer` | Firefox developer edition                                                                                           |
| `gestures`          | My custom gestures                                                                                                  |
| `git`               | Setup git with small customizations                                                                                 |
| `gpg`               | Setup essentials to sign git commits and configure                                                                  |
| `keepassxc-develop` | Setup keepassxc from source                                                                                         |
| `keepassxc`         | Setup keepassxc                                                                                                     |
| `nextcloud`         | desktop: Desktop sync client for Nextcloud. Will be good to run the target appimage-launcher                        |
| `obs`               | flatpak: Install OBS Studio from flatpak                                                                            |
| `slim`              | Slim(toolkit): Don't change anything in your container image and minify it by up to 30x making it secure too!       |
| `telegram`          | flatpak: Install Telegram from flatpak                                                                              |
| `vim`               | Setup my vimrc                                                                                                      |

To run a target use `make <target-name>`

## Environments to makefile

| Name            | Default value | Description                    |
| --------------- | ------------- | ------------------------------ |
| `PROJECTS_PATH` | `~/projects`  | The path to store all projects |

Example to rum make using an environment:

```bash
PROJECTS_PATH=~/Projects make essentials
```
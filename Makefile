PROJECTS_PATH := $(if $(PROJECTS_PATH),$(PROJECTS_PATH),~/projects)
SHELL := /bin/bash

default: help

help:
	@grep -E '^[a-zA-Z0-9 -]+:.*#'  Makefile | sort | while read -r l; do printf "\033[1;32m$$(echo $$l | cut -f 1 -d':')\033[00m:$$(echo $$l | cut -f 2- -d'#')\n"; done

appimage-launcher: # Helper application for Linux distributions serving as a kind of "entry point" for running and integrating AppImages
	curl -L `curl -s https://api.github.com/repos/TheAssassin/AppImageLauncher/releases/latest | jq -r ".assets[] | select(.name | test(\"bionic_amd64\")) | .browser_download_url"` -o appimage.deb
	sudo dpkg -i appimage.deb
	rm appimage.deb

essentials: # Essentials binaries
	sudo apt update
	sudo apt install -y \
		curl \
		flatpak \
		htop \
		jq \
		meld \
		pavucontrol \
		pulseaudio-module-bluetooth \
		terminator \
		wget

gpg: # Setup essentials to sign git commits and configure
	@read -p "Type your GPG signing key: " signingkey; \
	sudo apt update; \
	sudo apt install -y \
		kleopatra \
		scdaemon; \
	git config --global user.signingkey $${signingkey} \
	git config --global commit.gpgsign true

git: # Setup git with small customizations
	sudo apt update
	sudo apt install -y \
		git
	sudo pip install diff-highlight
	git config --global alias.fpush "push --force-with-lease"
	git config --global interactive.diffFilter diff-highlight
	git config --global pager.diff 'diff-highlight | less'
	git config --global pager.log 'diff-highlight | less'
	git config --global pager.show 'diff-highlight | less'

vim: # Setup my vimrc
	sudo apt update
	sudo apt install -y \
		exuberant-ctags \
		vim \
		vim-gtk3
	@if [ ! -d $(PROJECTS_PATH)/vimrc ]; then \
		git clone https://github.com/vitormattos/vimrc.git $(PROJECTS_PATH)/vimrc; \
	fi
	sh $(PROJECTS_PATH)/vimrc/./install.sh

keepassxc: # Setup keepassxc
	sudo add-apt-repository ppa:phoerious/keepassxc
	sudo apt update
	sudo apt install -y keepassxc

keepassxc-develop: # Setup keepassxc from source
	@if [ ! -d $(PROJECTS_PATH)/keepassxc ]; then \
		git clone https://github.com/keepassxreboot/keepassxc $(PROJECTS_PATH)/keepassxc; \
		mkdir -p $(PROJECTS_PATH)/keepassxc/build; \
	fi
	cd $(PROJECTS_PATH)/keepassxc
	sudo apt update
	sudo apt install -y \
		asciidoctor \
		botan \
		build-essential \
		cmake \
		libargon2-dev \
		libbotan-2-dev \
		libdbus-glib-1-2 \
		libminizip-dev \
		libpcsclite-dev \
		libqrencode-dev \
		libqt5svg5-dev \
		libqt5x11extras5-dev \
		libreadline-dev \
		libusb-1.0-0-dev \
		libxtst-dev \
		make \
		minizip \
		qt5-image-formats-plugins \
		qtbase5-dev \
		qtbase5-private-dev \
		qttools5-dev \
		terminator \
		zlib1g-dev
	cd build
	cmake -DWITH_XC_ALL=ON ..
	make -j $(nproc)
	sudo make install

nextcloud-desktop: # Desktop sync client for Nextcloud. Will be good to run the target appimage-launcher
	mkdir -p ~/.local/opt/Application/
	curl -L `curl -s https://api.github.com/repos/nextcloud-releases/desktop/releases/latest | jq -r ".assets[] | select(.name | test(\"x86_64\")) | .browser_download_url" | grep AppImage$` -o ~/.local/opt/Application/Nextcloud.appimage
	chmod u+x ~/.local/opt/Application/Nextcloud.appimage

obs-flatpak: # Install OBS Studio from flatpak
	flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
	flatpak install flathub com.obsproject.Studio

docker: # Setup docker
	curl -fsSL https://get.docker.com -o get-docker.sh
	DRY_RUN=1 sudo sh ./get-docker.sh
	rm get-docker.sh

codium: # Binary releases of VS Code without MS branding/telemetry/licensing
	echo 'deb [ signed-by=/usr/share/keyrings/vscodium-archive-keyring.gpg ] https://download.vscodium.com/debs vscodium main'     | sudo tee /etc/apt/sources.list.d/vscodium.list
	wget -qO - https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/master/pub.gpg     | gpg --dearmor     | sudo dd of=/usr/share/keyrings/vscodium-archive-keyring.gpg
	sudo apt update
	sudo apt install -y codium

vscode: # VS Code
	sudo apt-get install wget gpg
	wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
	sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
	sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
	rm -f packages.microsoft.gpg
	sudo apt-get update
	sudo apt install apt-transport-https
	sudo apt update
	sudo apt install code

telegram-flatpak: # Install Telegram from flatpak
	flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
	flatpak install flathub org.telegram.desktop

telegram: # Telegram oficial
	curl -fSL --progress-bar https://telegram.org/dl/desktop/linux -o linux.tar.xz
	@if [ -d ~/.local/opt/bin/telegram ]; then \
		rm -rf ~/.local/opt/bin/telegram; \
	fi
	mkdir -p ~/.local/opt/
	tar -xvf linux.tar.xz -C ~/.local/opt/
	@if [ ! -f ~/.local/opt/bin/telegram ]; then \
		ln -s ~/.local/opt/Telegram/Telegram ~/.local/opt/bin/telegram; \
	fi
	mkdir -p ~/.local/opt/bin/
	chmod +x ~/.local/opt/bin/telegram
	@if [ ! -f ~/.local/share/applications/telegram.desktop ]; then \
		ln -s $(CURDIR)/assets/telegram/telegram.desktop ~/.local/share/applications/; \
	fi
	rm linux.tar.xz

dbeaver: # Install dbeaver
	sudo  wget -O /usr/share/keyrings/dbeaver.gpg.key https://dbeaver.io/debs/dbeaver.gpg.key
	echo "deb [signed-by=/usr/share/keyrings/dbeaver.gpg.key] https://dbeaver.io/debs/dbeaver-ce /" | sudo tee /etc/apt/sources.list.d/dbeaver.list
	sudo apt-get update && sudo apt-get install dbeaver-ce

adb: # Install adb
	bash <(curl -s https://raw.githubusercontent.com/corbindavenport/nexus-tools/main/install.sh)
udev: adb # Install udev rules
	@if [ ! -d $(PROJECTS_PATH)/android-udev-rules ]; then \
		git clone https://github.com/M0Rf30/android-udev-rules.git $(PROJECTS_PATH)/android-udev-rules; \
	fi
	cd $(PROJECTS_PATH)/android-udev-rules
	sudo ln -sf "$PWD"/51-android.rules /etc/udev/rules.d/51-android.rules
	sudo chmod a+r /etc/udev/rules.d/51-android.rules
	sudo cp android-udev.conf /usr/lib/sysusers.d/
	sudo systemd-sysusers
	sudo gpasswd -a $$USER adbusers
	sudo udevadm control --reload-rules
	sudo systemctl restart systemd-udevd.service
	adb kill-server

bashrc: # My custom bashrc
	@if [ -f ~/.bashrc ]; then \
		rm -f ~/.bashrc; \
	fi;
	@if [ -f ~/.bash_aliases ]; then \
		rm -f ~/.bash_aliases; \
	fi;
	ln -s $(CURDIR)/assets/bashrc/.bashrc ~/.bashrc
	ln -s $(CURDIR)/assets/bashrc/.bash_aliases ~/.bash_aliases
	@echo "Run the command source ~/.bashrc or restart your terminal"

gestures: # My custom gestures
	@if [ ! -d $(PROJECTS_PATH)/libpinput-gestures ]; then \
		git clone https://github.com/bulletmark/libinput-gestures $(PROJECTS_PATH)/libpinput-gestures; \
	fi
	sudo apt install python3 python3-gi meson xdotool libinput-tools gettext wmctrl
	sudo $(PROJECTS_PATH)/libpinput-gestures/libinput-gestures-setup install
	ln -s $(CURDIR)/assets/gestures/libinput-gestures.conf ~/.config/libinput-gestures.conf
	sudo gpasswd -a $$USER input
	libinput-gestures-setup autostart start
	flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/appstream/com.gitlab.cunidev.Gestures.flatpakref
	flatpak install flathub com.gitlab.cunidev.Gestures

firefox-developer: # Firefox developer edition
	mkdir -p ~/.local/opt
	curl -fSL --progress-bar "https://download.mozilla.org/?product=firefox-devedition-latest-ssl&os=linux64&lang=en-US" -o firefox.tar.bz2
	@if [ -d ~/.local/opt/firefox-developer ]; then \
		rm -rf ~/.local/opt/firefox-developer; \
	fi
	mkdir -p ~/.local/opt/firefox-developer-tmp
	tar -xvf firefox.tar.bz2 -C ~/.local/opt/firefox-developer-tmp
	mv ~/.local/opt/firefox-developer-tmp/firefox ~/.local/opt/firefox-developer/
	rm -rf ~/.local/opt/firefox-developer-tmp/
	@if [ ! -f ~/.local/opt/bin/firefox-developer ]; then \
		ln -s ~/.local/opt/firefox-developer/firefox ~/.local/opt/bin/firefox-developer; \
	fi
	@if [ ! -f ~/.local/share/applications/firefox_dev.desktop ]; then \
		ln -s $(CURDIR)/assets/firefox-developer/firefox_dev.desktop ~/.local/share/applications/; \
	fi
	rm firefox.tar.bz2

youtube-dl: # A youtube-dl fork with additional features and fixes
	# Reference: https://github.com/yt-dlp/yt-dlp/wiki/Installation#apt
	sudo add-apt-repository ppa:tomtomtom/yt-dlp    # Add ppa repo to apt
	sudo apt update                                 # Update package list
	sudo apt install yt-dlp                         # Install yt-dlp

act: # Run your GitHub Actions locally
	mkdir -p $(PROJECTS_PATH)/act
	wget -O $(PROJECTS_PATH)/act/install.sh https://raw.githubusercontent.com/nektos/act/master/install.sh
	mkdir -p ~/.local/opt/bin
	sh $(PROJECTS_PATH)/act/install.sh -b ~/.local/opt/bin

slim: # Slim(toolkit): Don't change anything in your container image and minify it by up to 30x making it secure too!
	curl -sL https://raw.githubusercontent.com/slimtoolkit/slim/master/scripts/install-slim.sh | sudo -E bash -

insomnia:
	mkdir -p ~/.local/opt/Application/
	curl -L `curl -s https://api.github.com/repos/Kong/insomnia/releases/latest | jq -r ".assets[] | select(.name | test(\"AppImage\")) | .browser_download_url"` -o ~/.local/opt/Application/insomnia.appimage
	chmod u+x ~/.local/opt/Application/insomnia.appimage

PROJECTS_PATH := $(if $(PROJECTS_PATH),$(PROJECTS_PATH),~/projects)

appimage-launcher:
	curl -L `curl -s https://api.github.com/repos/TheAssassin/AppImageLauncher/releases/latest | jq -r ".assets[] | select(.name | test(\"bionic_amd64\")) | .browser_download_url"` -o appimage.deb
	sudo dpkg -i appimage.deb
	rm appimage.deb

essentials:
	sudo apt update
	sudo apt install -y \
		curl \
		exuberant-ctags \
		flatpak \
		htop \
		jq \
		kleopatra \
		meld \
		pavucontrol \
		pulseaudio-module-bluetooth \
		terminator \
		wget

git:
	sudo apt update
	sudo apt install -y \
		git
	sudo pip install diff-highlight
	git config --global pager.log 'diff-highlight | less'
	git config --global pager.show 'diff-highlight | less'
	git config --global pager.diff 'diff-highlight | less'
	git config --global interactive.diffFilter diff-highlight

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

keepassxc:
	@if [ ! -d $(PROJECTS_PATH)/keepassxc ]; then \
		git clone https://github.com/keepassxreboot/keepassxc $(PROJECTS_PATH)/keepassxc; \
		mkdir $(PROJECTS_PATH)/keepassxc/build; \
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

nextcloud-desktop:
	mkdir -p ~/.local/opt/Application/
	curl -L `curl -s https://api.github.com/repos/nextcloud/desktop/releases/latest | jq -r ".assets[] | select(.name | test(\"x86_64\")) | .browser_download_url" | grep AppImage$` -o ~/.local/opt/Application/Nextcloud.appimage
	chmod u+x ~/.local/opt/Application/Nextcloud.appimage

obs:
	flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
	flatpak install flathub com.obsproject.Studio

docker:
	curl -fsSL https://get.docker.com -o get-docker.sh
	DRY_RUN=1 sudo sh ./get-docker.sh
	rm get-docker.sh

codium:
	echo 'deb [ signed-by=/usr/share/keyrings/vscodium-archive-keyring.gpg ] https://download.vscodium.com/debs vscodium main'     | sudo tee /etc/apt/sources.list.d/vscodium.list
	wget -qO - https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/master/pub.gpg     | gpg --dearmor     | sudo dd of=/usr/share/keyrings/vscodium-archive-keyring.gpg
	sudo apt update
	sudo apt install -y codium

telegram:
	flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
	flatpak install flathub org.telegram.desktop

dbeaver:
	sudo  wget -O /usr/share/keyrings/dbeaver.gpg.key https://dbeaver.io/debs/dbeaver.gpg.key
	echo "deb [signed-by=/usr/share/keyrings/dbeaver.gpg.key] https://dbeaver.io/debs/dbeaver-ce /" | sudo tee /etc/apt/sources.list.d/dbeaver.list
	sudo apt-get update && sudo apt-get install dbeaver-ce

adb:
	sudo apt install adb
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

bashrc:
	rm -f ~/.bashrc ~/.bash_aliases
	ln -s $(CURDIR)/.bashrc ~/.bashrc
	ln -s $(CURDIR)/.bash_aliases ~/.bash_aliases
	source ~/.bashrc

gestures:
	@if [ ! -d $(PROJECTS_PATH)/libpinput-gestures ]; then \
		git clone https://github.com/bulletmark/libinput-gestures $(PROJECTS_PATH)/libpinput-gestures; \
	fi
	sudo apt install python3 python3-gi meson xdotool libinput-tools gettext wmctrl
	sudo $(PROJECTS_PATH)/libpinput-gestures/libinput-gestures-setup install
	ln -s $(CURDIR)/libinput-gestures.conf ~/.config/libinput-gestures.conf
	sudo gpasswd -a $$USER input
	libinput-gestures-setup autostart start
	flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/appstream/com.gitlab.cunidev.Gestures.flatpakref
	flatpak install flathub com.gitlab.cunidev.Gestures
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
		vim \
		vim-gtk \
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

vim:
	sudo apt update
	sudo apt install exuberant-ctags vim-gtk

codium:
	wget -qO - https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/master/pub.gpg     | gpg --dearmor     | sudo dd of=/usr/share/keyrings/vscodium-archive-keyring.gpg
	echo 'deb [ signed-by=/usr/share/keyrings/vscodium-archive-keyring.gpg ] https://download.vscodium.com/debs vscodium main'     | sudo tee /etc/apt/sources.list.d/vscodium.list
	sudo apt update
	sudo apt install codium

keepassxc:
	cd ~/projects/keepassxc
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
	sudo make install

nextcloud-desktop:
	mkdir -p ~/.local/opt/Application/
	curl -L `curl -s https://api.github.com/repos/nextcloud/desktop/releases/latest | jq -r ".assets[] | select(.name | test(\"x86_64\")) | .browser_download_url" | grep appimage` -o ~/.local/opt/Application/Nextcloud.appimage
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
	# git clone https://github.com/M0Rf30/android-udev-rules.git
	cd ~/projects/android-udev-rules
	sudo ln -sf "$PWD"/51-android.rules /etc/udev/rules.d/51-android.rules
	sudo chmod a+r /etc/udev/rules.d/51-android.rules
	sudo cp android-udev.conf /usr/lib/sysusers.d/
	sudo systemd-sysusers
	sudo gpasswd -a $(whoami) adbusers
	sudo udevadm control --reload-rules
	sudo systemctl restart systemd-udevd.service
	adb kill-server
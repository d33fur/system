#!/bin/bash

# 
# Linux Mint 22 Cinnamon
# 
# 
# base
# 
exec > >(tee -a logs.txt) 2> >(tee -a errors.txt >&2)

sudo rm /etc/apt/preferences.d/nosnap.pref
sudo apt update
sudo apt upgrade -y
sudo apt install -y \
    git \
    wget \
    curl \
    vim \
    python3 \
    python3-pip \
    pipx \
    make \
    doxygen \
    build-essential \
    gcc \
    pkg-config \
    libssl-dev \
    tmux \
    libfreetype6-dev \
    libfontconfig1-dev \
    libxcb-xfixes0-dev \
    libxkbcommon-dev \
    nodejs \
    zsh \
    snapd \
    libsecret-1-0 \
    libsecret-1-dev \
    gpg

sudo systemctl enable --now snapd.service
sudo snap install core
snap refresh

cd /usr/share/doc/git/contrib/credential/libsecret
sudo make
git config --global user.email "d33fur@gmail.com"
git config --global user.name "d33fur"
git config --global credential.helper manager-core
git config --global credential.helper /usr/share/doc/git/contrib/credential/libsecret/git-credential-libsecret

cd ~/system/install/

chsh -s $(which zsh)

pipx ensurepath
pipx install \
    cmake \
    conan

pipx completions
echo 'autoload -U bashcompinit' >> ~/.zshrc
echo 'bashcompinit' >> ~/.zshrc
echo 'eval "$(register-python-argcomplete pipx)"' >> ~/.zshrc

# 
# oh-my-zsh
# 
yes | sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# 
# nerd font
# 
declare -a fonts=(
    JetBrainsMono
)

version='2.1.0'
fonts_dir="${HOME}/.local/share/fonts"

if [[ ! -d "$fonts_dir" ]]; then
    mkdir -p "$fonts_dir"
fi

for font in "${fonts[@]}"; do
    zip_file="${font}.zip"
    download_url="https://github.com/ryanoasis/nerd-fonts/releases/download/v${version}/${zip_file}"
    echo "Downloading $download_url"
    wget "$download_url"
    unzip "$zip_file" -d "$fonts_dir"
    rm "$zip_file"
done

find "$fonts_dir" -name '*Windows Compatible*' -delete

fc-cache -fv

# 
# starship
# 
curl -sS https://starship.rs/install.sh | sh -s -- -y
echo 'eval "$(starship init zsh)"' >> ~/.zshrc
mkdir -p ~/.config
starship preset plain-text-symbols -o ~/.config/starship.toml

# 
# rust
# 
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
. "$HOME/.cargo/env"
rustc --version

cargo install cargo-edit

# 
# docker and docker-compose
# 
sudo apt update
sudo apt install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common \
    gnupg \
    lsb-release

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
    sudo gpg --dearmor -o /usr/share/keyrings/docker.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker.gpg] \
    https://download.docker.com/linux/ubuntu focal stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt update
sudo apt install -y \
    docker-ce \
    docker-ce-cli \
    containerd.io \
    docker-compose-plugin \
    docker-compose

sudo usermod -aG docker $USER

sudo systemctl enable docker
sudo systemctl start docker
sudo docker run hello-world

docker-compose --version

# 
# yandex browser
# 
sudo apt install -y \
    curl \
    apt-transport-https \
    libgstreamer1.0-0 \
    gstreamer1.0-plugins-base \
    gstreamer1.0-plugins-good \
    gstreamer1.0-plugins-bad \
    gstreamer1.0-plugins-bad-faad \
    gstreamer1.0-libav


curl -fSsL https://repo.yandex.ru/yandex-browser/YANDEX-BROWSER-KEY.GPG | \
    sudo gpg --dearmor | \
    sudo tee /usr/share/keyrings/yandex.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/yandex.gpg] \
    http://repo.yandex.ru/yandex-browser/deb stable main" | \
    sudo tee /etc/apt/sources.list.d/yandex-stable.list

sudo apt update
sudo apt install -y yandex-browser-stable

sudo rm /etc/apt/sources.list.d/yandex-browser.list
sudo apt update

# 
# flameshot
# 
sudo apt update
sudo apt install -y \
    libqt5dbus5 \
    libqt5network5 \
    libqt5core5a \
    libqt5widgets5 \
    libqt5gui5 \
    openssl \
    ca-certificates

sudo apt install -y flameshot

# 
# code
# 
sudo snap install code --classic

# 
# obsidian
# 
sudo snap install obsidian --classic

# 
# telegram
# 
sudo snap install telegram-desktop

# 
# vlc
# 
sudo apt install -y vlc

# 
# obs
# 
sudo snap install obs-studio
sudo snap connect obs-studio:alsa
sudo snap connect obs-studio:audio-record
sudo snap connect obs-studio:avahi-control
sudo snap connect obs-studio:camera
sudo snap connect obs-studio:jack1
sudo snap connect obs-studio:kernel-module-observe

# 
# discord
# 
sudo snap install discord
sudo snap connect discord:system-observe

# 
# teams
# 
sudo snap install teams-for-linux

# 
# postman
# 
sudo snap install postman

# 
# stellarium
# 
sudo snap install stellarium-daily

# 
# bitwarden
# 
sudo snap install bitwarden
sudo snap connect bitwarden:password-manager-service

# 
# libreoffice
# 
sudo apt install -y libreoffice

# 
# ktorrent
# 
sudo apt install -y ktorrent

# 
# startup disk creator
# 
sudo apt install -y usb-creator-kde

# 
# nekoray
# link for guide
# https://telegra.ph/NekoRay-v-Linyx-07-11
# 
sudo apt update
sudo apt install -y libqt5x11extras5
wget https://github.com/MatsuriDayo/nekoray/releases/download/4.0-beta3/nekoray-4.0-beta3-2024-07-13-debian-x64.deb
sudo dpkg -i nekoray-4.0-beta3-2024-07-13-debian-x64.deb

# 
# spoofdpi
# 
curl -fsSL https://raw.githubusercontent.com/xvzc/SpoofDPI/main/install.sh | bash -s linux-amd64
echo 'export PATH=$PATH:~/.spoofdpi/bin' >> ~/.zshrc
sudo cp ./spoofdpi.service /etc/systemd/system/spoofdpi.service
sudo systemctl daemon-reload
sudo systemctl enable spoofdpi.service
sudo systemctl start spoofdpi.service

# 
# alacritty
# 
sudo apt update
sudo apt install scdoc

git clone https://github.com/alacritty/alacritty.git
cd alacritty
rustup override set stable
rustup update stable
cargo build --release

if infocmp alacritty > /dev/null 2>&1; then
    echo "alacritty terminfo is already installed."
else
    echo "alacritty terminfo is not installed. Installing now..."
    sudo tic -xe alacritty,alacritty-direct extra/alacritty.info
    if [ $? -eq 0 ]; then
        echo "alacritty terminfo installed successfully."
    else
        echo "Failed to install alacritty terminfo."
    fi
fi

sudo cp target/release/alacritty /usr/local/bin
sudo cp extra/logo/alacritty-term.svg /usr/share/pixmaps/Alacritty.svg
sudo desktop-file-install extra/linux/Alacritty.desktop
sudo update-desktop-database

sudo mkdir -p /usr/local/share/man/man1
sudo mkdir -p /usr/local/share/man/man5
scdoc < extra/man/alacritty.1.scd | gzip -c | \
    sudo tee /usr/local/share/man/man1/alacritty.1.gz > /dev/null
scdoc < extra/man/alacritty-msg.1.scd | gzip -c | \
    sudo tee /usr/local/share/man/man1/alacritty-msg.1.gz > /dev/null
scdoc < extra/man/alacritty.5.scd | gzip -c | \
    sudo tee /usr/local/share/man/man5/alacritty.5.gz > /dev/null
scdoc < extra/man/alacritty-bindings.5.scd | gzip -c | \
    sudo tee /usr/local/share/man/man5/alacritty-bindings.5.gz > /dev/null

mkdir -p ${ZDOTDIR:-~}/.zsh_functions
echo 'fpath+=${ZDOTDIR:-~}/.zsh_functions' >> ${ZDOTDIR:-~}/.zshrc
cp extra/completions/_alacritty ${ZDOTDIR:-~}/.zsh_functions/_alacritty
cd ..

if [[ "$1" == "--reboot" ]]; then
    echo "Rebooting the system..."
    sudo reboot
else
    read -p "Do you want to reboot the system? (y/n): " reboot_choice
    if [[ "$reboot_choice" == "y" ]]; then
        sudo reboot
    else
        echo "Reboot cancelled."
    fi
fi

# my files
# murglar
# nekoray
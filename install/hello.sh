#!/bin/bash

# base
sudo apt update
sudo apt install -y \
    git \
    wget \
    curl \
    zsh \
    vim \
    tmux \
    python3 \
    python3-pip \
    pipx \
    make \
    doxygen \
    build-essential \
    gcc \
    apt-transport-https \
    ca-certificates \
    software-properties-common \
    pkg-config \
    libssl-dev \
    tmux \
    pkg-config \
    libfreetype6-dev \
    libfontconfig1-dev \
    libxcb-xfixes0-dev \
    libxkbcommon-dev \
    nodejs

node --version

pipx ensurepath
pipx install cmake requests streamlit conan

# docker and docker-compose
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
    sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] \
    https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt update
sudo apt install -y \
    docker-ce \
    docker-ce-cli \
    containerd.io

sudo systemctl enable docker
sudo systemctl start docker
sudo docker run hello-world

sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" \
    -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
docker-compose --version

# yandex browser
curl -fSsL https://repo.yandex.ru/yandex-browser/YANDEX-BROWSER-KEY.GPG | \
    sudo gpg --dearmor | \
    sudo tee /usr/share/keyrings/yandex.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/yandex.gpg] \
    http://repo.yandex.ru/yandex-browser/deb stable main" | \
    sudo tee /etc/apt/sources.list.d/yandex-stable.list

sudo apt update
sudo apt install -y yandex-browser-stable

sudo rm /etc/apt/sources.list.d/yandex-browser.list
sudo apt update

# snap apps
sudo snap install code --classic
sudo snap install obsidian --classic
sudo snap install \
    telegram-desktop \
    flameshot \
    vlc \
    obs-studio \
    discord \
    teams-for-linux \
    postman \
    stellarium-daily \
    bitwarden \
    libreoffice \
    ktorrent

sudo snap connect bitwarden:password-manager-service
sudo snap connect obs-studio:alsa
sudo snap connect obs-studio:audio-record
sudo snap connect obs-studio:avahi-control
sudo snap connect obs-studio:camera
sudo snap connect obs-studio:jack1
sudo snap connect obs-studio:kernel-module-observe
sudo snap connect discord:system-observe

# nekoray
# link for settings
# https://telegra.ph/NekoRay-v-Linyx-07-11
wget https://github.com/MatsuriDayo/nekoray/releases/download/3.26/nekoray-4.0-beta3-2024-07-13-debian-x64.deb && \
    sudo dpkg -i nekoray-4.0-beta3-2024-07-13-debian-x64.deb

# spoofdpi
curl -fsSL https://raw.githubusercontent.com/xvzc/SpoofDPI/main/install.sh | bash -s linux-amd64
echo 'export PATH=$PATH:~/.spoofdpi/bin' >> ~/.zshrc
sudo cp ./spoofdpi.service /etc/systemd/system/spoofdpi.service
sudo systemctl daemon-reload
sudo systemctl start spoofdpi.service
sudo systemctl stop spoofdpi.service

# nerd font
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


# starship
curl -sS https://starship.rs/install.sh | sh
eval "$(starship init zsh)"
mkdir -p ~/.config && cp ./starship.toml ~/.config/starship.toml

# rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source "$HOME/.cargo/env"
rustc --version

cargo install cargo-edit

# alacritty
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

# oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# reboot

# my files
# murglar
# nekoray
#!/bin/bash

# 
# base
# 
sudo apt update
sudo apt upgrade -y
sudo apt install -y \
    git \
    wget \
    curl \
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
    nodejs \
    zsh

git config --global user.email "d33fur@gmail.com"
git config --global user.name "d33fur"

chsh -s $(which zsh)
# need to reload shell


zsh hello-zsh.sh

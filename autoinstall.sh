#!/bin/bash

set -euo pipefail

PHP_VERSION=7.4
RUBY_VERSION=2.7.4

function message() {
	printf "%$(tput cols)s\n"|sed "s/ /#/g"
	echo -e "\e[92m\e[1m $1 \e[0m"
	printf "%$(tput cols)s\n"|sed "s/ /#/g"
}

message "Adding ${USER} to sudoers"
echo "${USER} ALL=(ALL) NOPASSWD: ALL" | sudo tee -a /etc/sudoers

message "Installing packages ..."
sudo apt update && sudo apt upgrade -y
sudo apt install -y postgresql mysql-server ruby git gcc make software-properties-common qt5-qmake ruby ruby-build htop vim imagemagick

wget -O /tmp/google-chrome.deb https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo dpkg -i /tmp/google-chrome.deb

wget -O /tmp/vscode.deb https://update.code.visualstudio.com/latest/linux-deb-x64/stable
sudo dpkg -i /tmp/vscode.deb



message "Installing rbenv"
git clone https://github.com/sstephenson/rbenv.git ~/.rbenv
git clone https://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build

echo 'export PATH="${HOME}/.rbenv/bin:$PATH"' | tee -a ~/.bash_profile ~/.bashrc
echo 'eval "$(rbenv init -)"' | tee -a ~/.bash_profile ~/.bashrc

message "Installing ruby"
source ${HOME}/.bashrc
eval "$(rbenv init -)"
rbenv install ${RUBY_VERSION}
rbenv global ${RUBY_VERSION}
gem install bundler


message "Installing php ..."
sudo add-apt-repository -y ppa:ondrej/php
sudo apt update
sudo apt -y install php${PHP_VERSION}-{mysql,curl,json,cgi,xsl,gd,cli,xml,zip,mbstring,bcmath,imagick,dev,propro,raphf}
printf "\n" | sudo pecl install pecl_http-3.2.4




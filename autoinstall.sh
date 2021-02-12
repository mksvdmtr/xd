#!/bin/bash

set -euo pipefail

PHP_VERSION=7.4
RUBY_VERSION=2.7.2

function message() {
	printf "%$(tput cols)s\n"|sed "s/ /#/g"
	echo -e "\e[92m\e[1m $1 \e[0m"
	printf "%$(tput cols)s\n"|sed "s/ /#/g"
}

message "Adding $USER to sudoers"
echo "$USER ALL=(ALL) NOPASSWD: ALL" | sudo tee -a /etc/sudoers

message "Installing packages ..."
sudo apt install postgresql mysql-server ruby git gcc make software-properties-common qt5-qmake ruby ruby-build 

message "Downloading vscode ..."
wget -O /tmp/vscode.deb https://update.code.visualstudio.com/latest/linux-deb-x64/stable
message "Installing vscode ..."
sudo dpkg -i /tmp/vscode.deb

message "Installing rbenv"
git clone https://github.com/sstephenson/rbenv.git ~/.rbenv
git clone https://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build

echo 'export PATH="$HOME/.rbenv/bin:$PATH"' tee -a ~/.bash_profile ~/.bashrc
echo 'eval "$(rbenv init -)"' tee -a ~/.bash_profile ~/.bashrc

message "Installing ruby"
source $HOME/.bashrc
eval "$(rbenv init -)"
rbenv install $RUBY_VERSION
rbenv global $RUBY_VERSION
gem install bundler


message "Installing php ..."
sudo add-apt-repository ppa:ondrej/php
sudo apt update
sudo apt-get install \
	php$PHP_VERSION-mysql \
	php$PHP_VERSION-curl \
	php$PHP_VERSION-json \
	php$PHP_VERSION-cgi \
	php$PHP_VERSION-xsl \
	php$PHP_VERSION-gd \
	php$PHP_VERSION-cli \
	php$PHP_VERSION-zip \
	php$PHP_VERSION-mbstring \ 
	php$PHP_VERSION-bcmath 







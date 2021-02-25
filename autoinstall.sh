#!/bin/bash

set -euo pipefail

PHP_VERSION=7.4
RUBY_VERSION=2.7.2
INTELIJ_IDEA_VERSION=2020.3.2

function message() {
	printf "%$(tput cols)s\n"|sed "s/ /#/g"
	echo -e "\e[92m\e[1m $1 \e[0m"
	printf "%$(tput cols)s\n"|sed "s/ /#/g"
}

message "Adding ${USER} to sudoers"
echo "${USER} ALL=(ALL) NOPASSWD: ALL" | sudo tee -a /etc/sudoers

message "Installing packages ..."
sudo apt update && sudo apt upgrade -y
sudo apt install -y postgresql mysql-server ruby git gcc make software-properties-common qt5-qmake ruby ruby-build htop vim 

wget -O /tmp/google-chrome.deb https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo dpkg -i /tmp/google-chrome.deb

wget -O /tmp/vscode.deb https://update.code.visualstudio.com/latest/linux-deb-x64/stable
sudo dpkg -i /tmp/vscode.deb

message "Downloading idea"
mkdir ${HOME}/bin
wget -O /tmp/ideaIU-${INTELIJ_IDEA_VERSION}.tar.gz https://download.jetbrains.com/idea/ideaIU-${INTELIJ_IDEA_VERSION}.tar.gz 

message "Installing idea"
tar -C ${HOME}/bin -xzf /tmp/ideaIU-${INTELIJ_IDEA_VERSION}.tar.gz
mv ${HOME}/bin/{idea*,Idea} 

cat >> ${HOME}/Рабочий\ стол/Idea.desktop <<ENDCONFIG
[Desktop Entry]
Version=1.0
Type=Application
Name=Idea
Comment=
Exec=${HOME}/bin/Idea/bin/idea.sh
Icon=${HOME}/bin/Idea/bin/idea.png
Path=${HOME}/bin/Idea/bin/
Terminal=false
StartupNotify=false
ENDCONFIG

chmod +x ${HOME}/Рабочий\ стол/Idea.desktop


wget -O ${HOME}/bin/reset_jetbrains_eval_linux.sh https://raw.githubusercontent.com/mksvdmtr/xd/master/reset_jetbrains_eval_linux.sh
chmod +x ${HOME}/bin/reset_jetbrains_eval_linux.sh
(crontab -l 2>/dev/null; echo "0 12 * * 3 ${HOME}/bin/reset_jetbrains_eval_linux.sh") | crontab -


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
sudo apt -y install \
	php${PHP_VERSION}-mysql \
	php${PHP_VERSION}-curl \
	php${PHP_VERSION}-json \
	php${PHP_VERSION}-cgi \
	php${PHP_VERSION}-xsl \
	php${PHP_VERSION}-gd \
	php${PHP_VERSION}-cli \
	php${PHP_VERSION}-zip \
	php${PHP_VERSION}-mbstring \
	php${PHP_VERSION}-bcmath




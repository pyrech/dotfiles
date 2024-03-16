#!/bin/bash

NOCOLOR='\e[0m'
REDCOLOR='\e[37;41m'

if [[ $EUID -ne 0 ]]; then
   echo -e "$REDCOLOR Think to run this bash script as root$NOCOLOR"
fi

DOTFILES=`pwd`

touch $DOTFILES/.private-gitconfig

echo 'Create $HOME symlink'

ln -sf $DOTFILES/.bash_aliases        ~/.bash_aliases
ln -sf $DOTFILES/.bash_logout         ~/.bash_logout
ln -sf $DOTFILES/.bashrc              ~/.bashrc
ln -sf $DOTFILES/.gitconfig           ~/.gitconfig
ln -sf $DOTFILES/.gitglobalexclude    ~/.gitglobalexclude
ln -sf $DOTFILES/.private-gitconfig   ~/.private-gitconfig
ln -sf $DOTFILES/.profile             ~/.profile
ln -sf $DOTFILES/.psqlrc              ~/.psqlrc
ln -sf $DOTFILES/.ripgreprc           ~/.ripgreprc
ln -sf $DOTFILES/.screenrc            ~/.screenrc
ln -sf $DOTFILES/.vimrc               ~/.vimrc
ln -sf $DOTFILES/git-template         ~/.git-template

echo 'Install git submodule'
if [[ `which git` ]] ; then
  git submodule update --init
  ln -sf $DOTFILES/vendor/dircolors-solarized/dircolors.ansi-dark  ~/.dir_colors
fi

echo 'Setup dnsmasq'
if [[ -d /etc/dnsmasq.d ]] ; then
  ln -sf $DOTFILES/dnsmasq/localhost  /etc/dnsmasq.d/localhost
  ln -sf $DOTFILES/dnsmasq/test  /etc/dnsmasq.d/test
fi

echo 'Create custom bin symlink'
mkdir -p $HOME/.local/bin

ln -sf $DOTFILES/bin/\$                         /$HOME/.local/bin/\$
ln -sf $DOTFILES/bin/git-new                    /$HOME/.local/bin/git-new
ln -sf $DOTFILES/bin/json_pp                    /$HOME/.local/bin/json_pp
ln -sf $DOTFILES/bin/remove-csi                 /$HOME/.local/bin/remove-csi
ln -sf $DOTFILES/bin/slug                       /$HOME/.local/bin/slug

if [[ `which php` ]] ; then
    ln -sf $DOTFILES/php/my.ini  /etc/php/8.2/cli/conf.d/my.ini

    if [[ ! -f $HOME/.local/bin/composer ]]; then
        echo 'Install composer'
        curl -sS https://getcomposer.org/installer | php
        mv composer.phar $HOME/.local/bin/composer
    fi
fi

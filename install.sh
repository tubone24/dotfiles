#!/usr/bin/env bash

cp -r .userscript ~/
cp -r .vim ~/
cp -r .config ~/
cp .agignore ~/
cp .ansible.cfg ~/
cp .gitconfig ~/
cp .gitignore_global ~/
cp .tmux.conf ~/
cp .vimrc ~/
cp .zprofile ~/
cp .zshrc ~/
mkdir ~/.cache
curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh
ls -la
source ~/.zplug/init.zsh
source ~/.zshrc
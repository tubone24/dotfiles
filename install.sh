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
cp .huskyrc ~/
cp .wezterm.lua ~/
mkdir ~/.cache
export ZPLUG_HOME=~/.zplug
git clone https://github.com/zplug/zplug.git $ZPLUG_HOME
source ~/.zplug/init.zsh
source ~/.zshrc

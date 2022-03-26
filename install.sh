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
git clone https://github.com/zplug/zplug.git ~/.zplug
source ~/.zplug/init.zsh
source ~/.zshrc
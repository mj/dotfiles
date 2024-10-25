#!/bin/bash

PREFIX=$HOME

for file in .bash_profile .bashrc .gitconfig .inputrc .screenrc .wgetrc .zshrc joerc .vimrc .p10k.zsh; do
  cp -va $file $PREFIX/$file
done

rsync -av --delete .zsh/ $PREFIX/.zsh/
rsync -av --delete .vim/ $PREFIX/.vim/
rsync -av --delete .config/ $PREFIX/.config/

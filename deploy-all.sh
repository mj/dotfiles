#!/bin/bash

PREFIX=$HOME

for file in .bash_profile .bashrc .gitconfig .inputrc .screenrc .wgetrc .zshrc joerc
do
	cp -va $file $PREFIX/$file
done

rsync -av --delete .zsh/ $PREFIX/.zsh/

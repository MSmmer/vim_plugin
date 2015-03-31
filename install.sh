#!/bin/bash

CURRENT_DIR=`pwd`

echo "backing up current vim config"
today = `date+%Y%m%d`
for i in $HOME/.vim $HOME/.vimrc $HOME/.gvimrc; do [ -e $i ] && [ ! -L $i ] && mv $i $i.$today; done
for i in $HOME/.vim $HOME/.vimrc $HOME/.gvimrc; do [ -L $i ] && unlink $i ; done


echo "setting up symlinks"
lnif $CURRENT_DIR/vimrc $HOME/.vimrc
lnif "$CURRENT_DIR/" "$HOME/.vim"


echo "install vundle"
if [ ! -e $CURRENT_DIR/bundle/vundle ]; then
    echo "Installing Vundle"
    git clone https://github.com/gmarik/vundle.git $CURRENT_DIR/bundle/vundle
else
    echo "Upgrade Vundle"
    cd "$HOME/.vim/bundle/vundle" && git pull origin master
fi

echo "Step4: update/install plugins using Vundle"
system_shell=$SHELL
export SHELL="/bin/sh"
vim -u $HOME/.vimrc +BundleInstall! +BundleClean +qall
export SHELL=$system_shell

echo "Install Done!"

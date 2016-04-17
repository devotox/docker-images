#!/bin/bash

# This script is used to initiate the application by downloading the
# right resources and creating an accurate nginx folder


echo
echo "########################################################"
echo "####             Optional Dev Libraries             ####"
echo "########################################################"
echo

brew tab homebrew/dupes

brew tap homebrew/versions

brew install coreutils

brew install binutils
brew install diffutils
brew install ed --default-names
brew install findutils --with-default-names
brew install gawk
brew install gnu-indent --with-default-names
brew install gnu-sed --with-default-names
brew install gnu-tar --with-default-names
brew install gnu-which --with-default-names
brew install gnutls
brew install grep --with-default-names
brew install gzip
brew install screen
brew install watch
brew install wdiff --with-gettext
brew install wget

brew install bash
brew install emacs
brew install gdb  # gdb requires further actions to make it work. See `brew info gdb`.
brew install gpatch
brew install m4
brew install make
brew install nano

brew install file-formula
brew install git
brew install less
brew install openssh
brew install perl518   # must run "brew tap homebrew/versions" first!
brew install rsync
brew install svn
brew install unzip
brew install vim --override-system-vi
brew install macvim --override-system-vim --custom-system-icons
brew install zsh

brew update && brew upgrade

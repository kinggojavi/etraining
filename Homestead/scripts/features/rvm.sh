#!/usr/bin/env bash

if [ -f ~/.homestead-features/wsl_user_name ]; then
    WSL_USER_NAME="$(cat ~/.homestead-features/wsl_user_name)"
    WSL_USER_GROUP="$(cat ~/.homestead-features/wsl_user_group)"
else
    WSL_USER_NAME=vagrant
    WSL_USER_GROUP=vagrant
fi

export DEBIAN_FRONTEND=noninteractive

if [ -f /home/$WSL_USER_NAME/.homestead-features/rvm ]
then
    echo "rvm already installed."
    exit 0
fi

touch /home/$WSL_USER_NAME/.homestead-features/rvm
chown -Rf $WSL_USER_NAME:$WSL_USER_GROUP /home/$WSL_USER_NAME/.homestead-features

# Install RVM as vagrant user
sudo -u $WSL_USER_NAME gpg --keyserver keyserver.ubuntu.com --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
sudo -u $WSL_USER_NAME curl -LsS https://get.rvm.io | sudo -u $WSL_USER_NAME bash -s stable --ruby --gems=bundler --auto-dotfiles

# To start using RVM we need to run
source /home/vagrant/.rvm/scripts/rvm

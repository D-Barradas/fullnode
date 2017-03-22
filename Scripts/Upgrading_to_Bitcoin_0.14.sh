#!/bin/sh

# Install updates
sudo apt-get update

# Install dependencies for Bitcoin Core (not the GUI)
sudo apt-get install build-essential autoconf libssl-dev libboost-dev libboost-chrono-dev libboost-filesystem-dev libboost-program-options-dev libboost-system-dev libboost-test-dev libboost-thread-dev libtool libevent-dev -y

# Install dependencies for Bitcoin QT (GUI)
sudo apt-get install libqt4-dev qt4-dev-tools libprotobuf-dev protobuf-compiler libqrencode-dev -y

# Setup Swap file
sudo sed -i '16s/.*/CONF_SWAPSIZE=2048/g' /etc/dphys-swapfile
sudo dphys-swapfile setup
sudo dphys-swapfile swapon

mkdir ~/bin
cd ~/bin
git clone -b v0.14 https://github.com/bitcoin/bitcoin
cd bitcoin/
./autogen.sh
./configure CPPFLAGS="-I/usr/local/BerkeleyDB.4.8/include -O2" LDFLAGS="-L/usr/local/BerkeleyDB.4.8/lib" --enable-upnp-default --with-gui=qt4
make -j2
sudo make install
sudo rm -r -f ~/bin

# Remove the swap file we made earlier
sudo swapoff -a
sudo rm /var/swap
sudo systemctl disable dphys-swapfile
#!/bin/bash

read -n 1 -p "apt update? [y/n]" answer
echo
if [ "$answer" == "y" ] || [ "$answer" == "Y" ]; then
    sudo apt update
fi

sudo apt install build-essential
sudo apt install sqlite3 libsqlite3-dev
sudo apt install pkgconf
sudo apt install libssl-dev
sudo apt install libevent-dev
sudo apt install net-tools
sudo apt install nload

sudo ./configure
sudo make -j2

read -n 1 -p "install? [y/n]" answer
echo
if [ "$answer" == "y" ] || [ "$answer" == "Y" ]; then
    sudo make install
fi

echo
SOURCE_FILE="./examples/etc/turnserver.conf"
DEST_FILE="/etc/turnserver.conf"

if [ ! -f "$DEST_FILE" ]; then
    sudo cp "$SOURCE_FILE" "$DEST_FILE"
    echo "Copy config file: $SOURCE_FILE -> $DEST_FILE"
else
    echo "File already exists: $DEST_FILE"
fi

echo "install service：/etc/systemd/system/coturn.service"
sudo cp ./examples/etc/coturn.service /etc/systemd/system/

read -n 1 -p "start service? [y/n]" answer
echo
if [ "$answer" == "y" ] || [ "$answer" == "Y" ]; then
	sudo systemctl daemon-reload
	sudo systemctl stop coturn
	sudo systemctl disable coturn
	sudo systemctl enable coturn
	sudo systemctl start coturn
	sudo systemctl status coturn
fi

echo "Required configuration missing in /etc/turnserver.conf"
echo "Please set: external-ip, user, realm, max-bps"
echo "Then run: sudo systemctl restart coturn"

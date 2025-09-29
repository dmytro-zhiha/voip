#!/bin/bash
set -e

echo "[+] Updating system and installing dependencies..."
apt-get update
apt-get install -y build-essential git wget subversion \
    libncurses5-dev libssl-dev libxml2-dev libsqlite3-dev uuid-dev \
    libjansson-dev libedit-dev postgresql-client

echo "[+] Downloading and extracting Asterisk..."
cd /usr/src
wget -q http://downloads.asterisk.org/pub/telephony/asterisk/asterisk-20-current.tar.gz
tar zxvf asterisk-20-current.tar.gz

cd $(find . -maxdepth 1 -type d -name "asterisk-20.*" | head -n 1)

echo "[+] Configuring and building Asterisk..."
./configure
make
make install
make samples
make config

echo "[+] Starting Asterisk service..."
systemctl start asterisk
systemctl enable asterisk

echo "[✓] Asterisk installed and running."
#!/bin/bash

echo "Building telldusd from github with new libraries"
echo "Installing dependencies..."

apt-get update -q
apt-get --assume-yes install git build-essential cmake doxygen libftdi-dev  libconfuse-dev

ldconfig

git clone https://github.com/telldus/telldus
cd telldus/telldus-core
mkdir -p build
cd build
cmake -DFORCE_COMPILE_FROM_TRUNK=ON ..
make
make install
cat << EOM > /lib/systemd/system/telldusd.service
# service description from http://andreasahrens.se/getting-telldus-core-to-run-on-raspian-jessie-raspberry-pi/
[Unit]
Description=Tellstick service daemon
After=multi-user.target

[Service]
Type=forking
ExecStart=/usr/local/sbin/telldusd

[Install]
WantedBy=multi-user.target
EOM

ldconfig


systemctl daemon-reload
systemctl enable telldusd.service
systemctl start telldusd.service
systemctl status telldusd.service



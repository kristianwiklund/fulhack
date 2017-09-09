#!/bin/bash

#Copyright (c) 2017 <copyright holder>.
#All rights reserved.

#Redistribution and use in source and binary forms are permitted
#provided that the above copyright notice and this paragraph are
#duplicated in all such forms and that any documentation,
#advertising materials, and other materials related to such
#distribution and use acknowledge that the software was developed
#by the <organization>. The name of the
#<organization> may not be used to endorse or promote products derived
#from this software without specific prior written permission.
#THIS SOFTWARE IS PROVIDED ``AS IS'' AND WITHOUT ANY EXPRESS OR
#IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED
#WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.

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



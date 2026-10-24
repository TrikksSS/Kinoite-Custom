#!/usr/bin/env bash
set -oeux pipefail

# 1. Disable the old monolithic daemon completely
systemctl disable libvirtd.service

# 2. Enable the SOCKETS for all required modular daemons
systemctl enable virtqemud.socket
systemctl enable virtnetworkd.socket
systemctl enable virtnodedevd.socket
systemctl enable virtlogd.socket
systemctl enable virtlockd.socket

# 3. Ensure the default network is linked to autostart
mkdir -p /etc/libvirt/qemu/networks/autostart
ln -s /usr/share/libvirt/networks/default.xml /etc/libvirt/qemu/networks/default.xml
ln -s /etc/libvirt/qemu/networks/default.xml /etc/libvirt/qemu/networks/autostart/default.xml

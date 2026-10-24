#!/bin/bash

set -ouex pipefail

# Copy the contents of system_files/ of the git repo to /
cp -avf "/ctx/system_files"/. /

### Install packages

#1Password Setup and import

# Import the 1Password GPG key
rpm --import https://downloads.1password.com/linux/keys/1password.asc

# Create the 1Password repository configuration file
cat << 'EOF' > /etc/yum.repos.d/1password.repo
[1password]
name=1Password Stable Channel
baseurl=https://downloads.1password.com/linux/rpm/stable/$basearch
enabled=1
gpgcheck=1
repo_gpgcheck=0
gpgkey=https://downloads.1password.com/linux/keys/1password.asc
EOF

# Install 1Password and the 1Password CLI
dnf5 install -y 1password

# Install QEMU, KVM, libvirt, and virt-manager
 dnf5 install -y \
    qemu-kvm \
    libvirt \
    virt-manager \
    virt-install \
    && dnf5 clean all

# Enable the libvirtd service system-wide on boot
systemctl enable libvirtd.service

#Install Brave Origin
dnf5 install -y dnf-plugins-core

dnf5 config-manager addrepo --from-repofile https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo

dnf5 -y install brave-origin

#Install Ghostty from COPR
#dnf5 -y copr enable scottames/ghostty
#dnf5 -y install ghostty
#dnf5 -y copr disable scottames/ghostty

systemctl enable podman.socket

#!/bin/bash
set -e

apt-get update -y && apt-get upgrade -y
apt-get install -y \
  avahi-daemon \
  cloud-init \
  htop \
  tmux \
  git \
  vim 

cat -> /boot/wpa_supplicant.conf <<'EOF'
country=gb
update_config=1
ctrl_interface=/var/run/wpa_supplicant

# use envsubst to replace these values
network={
    scan_ssid=1
    ssid="$WIFI_SSID"
    psk="$WIFI_PASSWORD"
}
EOF

cat - > /boot/user-data <<'EOF'
#cloud-config
# vim: syntax=yaml
hostname: display-one
fqdn: display-one.ghr.lan
manage_etc_hosts: true
locale: en_GB.UTF-8
timezone: Europe/London

# Enable password authentication with the SSH daemon
ssh_pwauth: true

users:
  - default
  - name: jujhar
    shell: /bin/bash
    #passwd: "$6$MBp7Ay3DdGtqzLsI$.G3zVcAsrBtl5Yum4LTNEStOPT.l8A1ORHuDKI5oP.0f545venZYl0ZeMGZ2VbVyrzr9IswDr7WY4Q8gifY001"
    ssh_import_id:
      - gh:jujhars13
    lock_passwd: true
    sudo: "ALL=(ALL) NOPASSWD:ALL"
    groups: sudo
    ssh_authorized_keys:
      - ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAIEAxQCywIBr50F0tKiyQEbEnp3rcqqNe2lDkMG1rZG4w/CRQkXAYnKZZSeOgZlWDbMq3Q7IIu25eMhXbUlhD6ppXsN/qUH7e+HXJZc0pluta146oYGaUrunO679UzuvFBSVhi5NfnXi+svJVoefTzQvbW1LPYjIqXHpkWn/5pbTVgU= jujhar@jujhar.com
      - ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGGakkE8UR+O7GThbvNfQeV8UWHBRHxQrFu2FgPGNLFE root@sevak
package_update: true
package_upgrade: true
apt:
  conf: |
    Acquire {
      Check-Date "false";
    };
packages:
runcmd:
  - echo -e "\ninfo $(date +%F_%H-%M-%S) starting cloud-init user data"
  - localectl set-x11-keymap "gb" pc105
  - setupcon -k --force || true
  - printf "ubuntu-host-$(openssl rand -hex 3)" > /etc/hostname
  - printf "Ubuntu 24 LTS \nIP - $(hostname -I)\n" > /etc/issue
  - echo "chromium-brower --kiosk jujhar.com" >> /home/pi/.config/lxsession/LXDE-pi/autostart
  - echo -e "info $(date +%F_%H-%M-%S) Finished cloud-init user data\n"

power_state:
  mode: reboot
EOF

# Disable dhcpcd - it has a conflict with cloud-init network config
# systemctl mask dhcpcd
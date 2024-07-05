#!/bin/bash
set -e

apt-get update -y && apt-get upgrade -y
apt-get install -y \
  avahi-daemon \
  cloud-init \
  htop \
  tmux \
  git \
  unattended-upgrades \
  wtype \
  vim

# otherwise next command will wait for imput and hang
# echo "debconf debconf/frontend select noninteractive" | sudo debconf-set-selections
# dpkg-reconfigure --priority=low unattended-upgrades

# for kiosk mode
# @see https://www.raspberrypi.com/tutorials/how-to-use-a-raspberry-pi-in-kiosk-mode/
# wtype simulates keyboard input
# raspi-config
# -> autologin as pi user
# edit wayfire config
cat - >/home/pi/.config/wayfire.ini <<'EOF'
[autostart]
panel = wfrespawn wf-panel-pi
background = wfrespawn pcmanfm --desktop --profile LXDE-pi
xdg-autostart = lxsession-xdg-autostart
chromium = chromium-browser https://gurdwararoomdisplays.jujhar.com/?source=1USbXftm2RqLJ90Pj-PACVKxpsvdTvVOg3xnlNWAFgKA&screen=1&colourscheme=light https://gurdwararoomdisplays.jujhar.com/?source=1USbXftm2RqLJ90Pj-PACVKxpsvdTvVOg3xnlNWAFgKA&screen=1&colourscheme=dark --kiosk --noerrdialogs --disable-infobars --no-first-run --ozone-platform=wayland --enable-features=OverlayScrollbar --start-maximized
switchtab = bash ~/switchtab.sh
screensaver = false
dpms = false
EOF

cat - >/home/pi/switchtab.sh <<'EOF'
#!/bin/bash

# Find Chromium browser process ID
chromium_pid=$(pgrep chromium | head -1)

# Check if Chromium is running
while
[
[ -z $chromium_pid ]]; do
  echo "Chromium browser is not running yet."
  sleep 5
  chromium_pid=$(pgrep chromium | head -1)
done

echo "Chromium browser process ID: $chromium_pid"

export XDG_RUNTIME_DIR=/run/user/1000

# Loop to send keyboard events
while true; do
  # Send Ctrl+Tab using `wtype` command
  wtype -M ctrl -P Tab

  # Send Ctrl+Tab using `wtype` command
  wtype -m ctrl -p Tab

  sleep 10
done
EOF

cat - >/boot/wpa_supplicant.conf <<'EOF'
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

cat - >/boot/user-data <<'EOF'
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
  #- echo "chromium-brower --kiosk jujhar.com" >> /home/pi/.config/lxsession/LXDE-pi/autostart
  - echo -e "info $(date +%F_%H-%M-%S) Finished cloud-init user data\n"

power_state:
  mode: reboot
EOF

# Disable dhcpcd - it has a conflict with cloud-init network config
# systemctl mask dhcpcd

# to disable USB ports
# echo '1-1' | sudo tee /sys/bus/usb/drivers/usb/unbind
# to re-enable usb ports
# echo '1-1' | sudo tee /sys/bus/usb/drivers/usb/bind

# disable bluetooth
echo "dtoverlay=disable-bt" >>/boot/firmware/config.txt

## TODO turn machine display off at night
## TODO turn machine display on in morning
## TODO disable write mode for SD card to increase longevity

# Provision an Ubuntu image

To prevent as much clickops as possible when provisioning a bunch of these:
@see https://www.jimangel.io/posts/autoinstall-ubuntu-22-on-raspberry-pi-4/

Ubuntu 24

## To provision an Ubuntu image

```bash

# get image
export URL="https://www.mirrorservice.org/sites/cdimage.ubuntu.com/cdimage/noble/daily-preinstalled/current/noble-preinstalled-desktop-arm64+raspi.img.xz"
curl -O $URL

export ISO=(basename $URL)

# REPLACE WITH YOUR USB (`lsblk`)
export USB="/dev/sdc"
# `-d` decompress `<` redirect $FILE contents to expand `|` sending the output to `dd` to copy directly to $USB
xz -d < $ISO | sudo dd bs=100M of=$USB status=progress

# make a directory to mount the USB to
mkdir /tmp/pi-disk
sudo mount "${USB}1" /tmp/pi-disk

# copy a wpa_supplicant over to configure wifi if not wired
export WIFI_SSID="<your wifi ssid>"
export WIFI_PSK="<your wifi PSK>"
envsubst < wpa_supplicant.conf  > /tmp/pi-disk/wpa_supplicant.conf

# create a cloud-init user-data file
< cloud-init.yaml > /tmp/pi-disk/user-data

# enable ssh
touch /tmp/pi-disk/ssh

# safely unmount 
sudo umount "${USB}
sudo eject "${USB}"

```
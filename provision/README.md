# Provision an Ubuntu image

To reduce clickops as possible when provisioning a bunch of these devices:
@see https://www.jimangel.io/posts/autoinstall-ubuntu-22-on-raspberry-pi-4/

Ubuntu 24

## To provision an Ubuntu image

```bash

# get image
export URL="https://www.mirrorservice.org/sites/cdimage.ubuntu.com/cdimage/noble/daily-preinstalled/current/noble-preinstalled-desktop-arm64+raspi.img.xz"
export URL="https://www.mirrorservice.org/sites/cdimage.ubuntu.com/cdimage/ubuntu-server/noble/daily-preinstalled/current/noble-preinstalled-server-arm64+raspi.img.xz"
curl -O $URL

export ISO_IMAGE=$(basename $URL)

# REPLACE WITH YOUR USB (`lsblk`)
export USB="/dev/sdc"
# `-d` decompress `<` redirect $FILE contents to expand `|` sending the output to `dd` to copy directly to $USB
xz -d < $ISO_IMAGE | sudo dd bs=100M of=$USB status=progress

# make a directory to mount the USB to
mkdir /tmp/pi-disk || true
sudo mount "${USB}1" /tmp/pi-disk

# copy a wpa_supplicant over to configure wifi if not wired
export WIFI_SSID="<your wifi ssid>"
export WIFI_PSK="<your wifi PSK>"
envsubst < wpa_supplicant.conf  > /tmp/pi-disk/wpa_supplicant.conf

# backup then create a new cloud-init user-data file
cp /tmp/pi-disk/user-data /tmp/pi-disk/user-data.bak
< cloud-init.yaml > /tmp/pi-disk/user-data

# enable Elcrow 7" display params via "bios" 
# @see https://www.amazon.co.uk/dp/B07H79XMLT?psc=1&ref=ppx_yo2ov_dt_b_product_details
echo "
hdmi_force_hotplug=1
max_usb_current=1
hdmi_group=2
hdmi_mode-1
hdmi_mode=87
hdmi_cvr 1024 600 60 6 0 0 0
hdmi_drive=1
" >> /tmp/pi-disk/config.txt

# enable ssh
touch /tmp/pi-disk/ssh

# safely unmount
sudo umount "${USB}1"
sudo eject "${USB}"

```
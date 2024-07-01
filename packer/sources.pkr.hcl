source "arm-image" "raspios_bullseye_arm64" {
  image_type      = "raspberrypi"
  iso_url         = "https://downloads.raspberrypi.org/raspios_lite_arm64/images/raspios_lite_arm64-2024-03-15/2024-03-15-raspios-bookworm-arm64-lite.img.xz"
  iso_checksum    = "sha256:58a3ec57402c86332e67789a6b8f149aeeb4e7bb0a16c9388a66ea6e07012e45"
  output_filename = "images/rpi-raspios-arm64.img"
  qemu_binary     = "qemu-aarch64-static"
}
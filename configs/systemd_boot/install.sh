#!/usr/bin/env bash
set -e

# https://wiki.archlinux.org/title/Systemd-boot
if [[ -d /boot ]]; then
  rm -Rfv {/boot/efi,/boot/EFI,/boot/loader}
  bootctl install # by default create /efi and /boot into /boot
else
  echo "ERR. No such /boot dir"
  exit 1
fi

# copy configs from cur dir to /boot
cp -v "`dirname $0`/arch_loader.conf" /boot/loader/loader.conf
cp -v "`dirname $0`/arch.conf"        /boot/loader/entries
# cp -v "`dirname $0`/debian_bookworm.conf" /boot/loader/entries

echo "<<<< DONE >>>>"


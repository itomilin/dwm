#!/usr/bin/env bash

set -e

mode=$1

#if [[ $mode == '-c' ]]; then
#  echo "check latest driver"
#elif [[ `id -u` -ne 0 ]] && [[ $mode == '-i' ]]; then
#  echo "Login as root before run the script."
#  exit 1
#else
#  echo -e "Not handled: $mode\nAvailable:\n-c check updates\n-i install new driver"
#  exit 1
#fi

# TODO if first install, install latest

# required root
#current_driver_version=`modinfo nvidia --field=version`
# no required root
if [[ `which nvidia-smi` != "" ]]; then
  current_driver_version=`nvidia-smi --query-gpu=driver_version --format=csv,noheader --id=0`
else
  current_driver_version="DRIVER_NOT_INSTALLED"
fi


DRIVERS_DIR="/opt/nvidia/drivers"
PLATFORM="XFree86/Linux-x86_64"
FTP_URL="https://download.nvidia.com/${PLATFORM}"

latest_content=`curl -s $FTP_URL/latest.txt`
latest_stable_driver_version=${latest_content% *}
latest_beta_driver_version=`curl -s $FTP_URL/ | grep -Po "(?<=href=').*(?=\/')" | tail -n1`

# https://unix.stackexchange.com/questions/503572/how-to-break-a-long-string-into-multiple-lines-assigned-to-a-variable-in-linux-b
msg=(
  "current:       $current_driver_version"
  "latest_beta:   $latest_beta_driver_version"
  "latest_stable: $latest_stable_driver_version"
)
printf '%s\n' "${msg[@]}"

download_driver() {
  local driver_url=$1
  local driver_path=$2

  mkdir -pv `dirname ${driver_path}`

  # todo check hashsum and dont download if driver already downloaded
  echo "downloading..."
  curl --progress-bar \
       -L $driver_url \
       -o $driver_path
}

install_driver() {
  local driver_path=$1

  echo "checking running Xorg instance..."
  if [[ `pidof Xorg` -ne 0 ]]; then
    # also need to disable autostart login manager
    printf "Find running Xorg instance: `pidof Xorg`\nPress to stop(y/n): "
    read answer
    if [[ $answer == 'y' ]]; then
      kill `pidof Xorg`
      # systemctl stop lightdm.service #TODO
    else
      echo "quit.."
      exit 0
    fi
  fi

  echo "installing..."
  chmod +x $driver_path
  #TODO add select x32 lib for steam
  #echo "Do you want to install libglvnd (y/n):"
  $driver_path -a \
               -q \
               --ui=none \
               --dkms \
               --install-libglvnd
}

if [[ $current_driver_version != $latest_stable_driver_version ]] || [[ $current_driver_version != $latest_beta_driver_version ]]; then
  printf "New driver version available!\nUpdate?(y/n): "
  read answer
  if [[ $answer == 'y' ]]; then
    printf "stable or beta?(stable/beta): "
    read answer
    if [[ $answer == 'stable' ]]; then
      selected_driver_version=$latest_stable_driver_version
    elif [[ $answer == 'beta' ]]; then
      selected_driver_version=$latest_beta_driver_version
    else
      printf "ERR. wrong answer. stable|beta only"
      exit 1
    fi
    driver_file="NVIDIA-Linux-x86_64-${selected_driver_version}.run"
    download_driver $FTP_URL/$selected_driver_version/$driver_file $DRIVERS_DIR/$driver_file
    install_driver $DRIVERS_DIR/$driver_file
  else
    echo "quit.."
  fi
fi


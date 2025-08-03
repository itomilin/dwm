#!/bin/sh

userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap
sysresources=/etc/X11/xinit/.Xresources
sysmodmap=/etc/X11/xinit/.Xmodmap

# merge in defaults and keymaps

if [ -f $sysresources ]; then
    xrdb -merge $sysresources
fi

if [ -f $sysmodmap ]; then
    xmodmap $sysmodmap
fi

if [ -f "$userresources" ]; then
    xrdb -merge "$userresources"
fi

if [ -f "$usermodmap" ]; then
    xmodmap "$usermodmap"
fi

# start some nice programs

if [ -d /etc/X11/xinit/xinitrc.d ] ; then
 for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
  [ -x "$f" ] && . "$f"
 done
 unset f
fi

date_info () {
  date=`date +"%a %I:%M:%S%p %d-%m-%y"`
  echo $date
}

mem_info () {
  mem=`free -h | awk 'NR==2 { printf "%s of %s", $3,$2 }'`
  echo $mem
}

cpu_thermal_info () {
  cpu_thermal=`cat /proc/acpi/ibm/thermal | awk '{print $2}'`
  echo $cpu_thermal
}

thermal_sensors () {
    sensors=`sensors -j | jq -r '"C:\(."k10temp-pci-00c3"."Tctl"."temp1_input")|SD:\(."nvme-pci-5100"."Composite"."temp1_input")|BR:\(."amdgpu-pci-5200"."edge"."temp1_input")"'`
    echo $sensors
}

# acpi reqs
battery_left () {
  battery_left=`acpi -b | awk '{print $4 $5}'`
  energy_full=`cat /sys/class/power_supply/BAT0/energy_full`
  energy_full_design=`cat /sys/class/power_supply/BAT0/energy_full_design`
  wear_level=`echo "scale=1;$energy_full/$energy_full_design*100" | bc`
  echo "${battery_left}|${wear_level}"
}

rfkill_stat () {
  local stat=`rfkill list wlan --output=SOFT -r -n`
  local ret=""
  if [[  $stat == "unblocked" ]]; then
    ret="wlan: on"
  elif [[ $stat == "blocked" ]]; then
    ret="wlan: off"
  else
    ret="wlan: err_parse"
  fi

  echo $ret
}

laptop_id=10
if [ $(cat /sys/class/dmi/id/chassis_type) -eq $laptop_id ]; then
  /home/$(id -un 1000)/.dwm/custom_scripts/battery_low_power &
fi

# while :; do
#   xsetroot \
#   -name "`cpu_thermal_info`|`battery_left`|`rfkill_stat`|"
#   -name "`date_info` | `mem_info` | `cpu_thermal_info` | `battery_left` | `rfkill_stat` |"
#   sleep 10
# done &

# if [[ `which nvidia-settings` != "" ]]; then
#   echo -e "Nvidia card found:\n`nvidia-smi -L`" > /tmp/nv-log.txt
#   # base ~ 2790 -> 2940
#   nvidia-settings -c :0 -a '[gpu:0]/GPUGraphicsClockOffset[4]=150' | tee -a /tmp/nv-log.txt
# 
#   # base = 10501 -> 11001
#   #nvidia-settings -c :0 -a '[gpu:0]/GPUMemoryTransferRateOffset[4]=1000'
# 
#   # base = 10501 -> 12501
#   nvidia-settings -c :0 -a '[gpu:0]/GPUMemoryTransferRateOffset[4]=3000' | tee -a /tmp/nv-log.txt
# fi

exec /home/$(id -un)/.dwm/dwm
xsetroot -name ""


date_info () {
    date=`date +"%a %I:%M%p %d-%m-%y"`
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

#/home/$(id -un 1000)/.dwm/custom_scripts/battery_low_power &

#while :; do
#  #xsetroot -name "`date_info` | `mem_info` |"
#  xsetroot -name "`mem_info` |"
#  sleep 5
#done &

#if [[ `which nvidia-settings` != "" ]]; then
#  echo -e "Nvidia card found:\n`nvidia-smi -L`" > /tmp/nv-log.txt
#  # base ~ 2790 -> 2940
#  nvidia-settings -c :0 -a '[gpu:0]/GPUGraphicsClockOffset[4]=150' | tee -a /tmp/nv-log.txt
#
#  # base = 10501 -> 11001
#  #nvidia-settings -c :0 -a '[gpu:0]/GPUMemoryTransferRateOffset[4]=1000'
#
#  # base = 10501 -> 12501
#  nvidia-settings -c :0 -a '[gpu:0]/GPUMemoryTransferRateOffset[4]=3000' | tee -a /tmp/nv-log.txt
#fi

exec /home/$(id -un 1000)/.dwm/dwm


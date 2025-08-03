#!/usr/bin/env bash
set -e

osd_cat_wrapper() {
  local msg=$1
  echo $msg | osd_cat \
                -A right \
                -p top \
                --delay=3 \
                --colour=red \
                --font=-*-*-bold-*-*-*-60-60-*-*-*-*-*-*
}

screen_recorder=`whereis gpu-screen-recorder | awk '{print $2}'`
# ts_check=`which ts || true`
if [[ $screen_recorder == "" ]]; then
  osd_cat_wrapper 'gpu-screen-recorder NOT_FOUND!!'
  exit 1
# elif [[ $ts_check == "" ]]; then
#   osd_cat_wrapper 'intall_MOREUTILS_pkg'
#   exit 1
fi

proc_pid=`pidof gpu-screen-recorder || true`
if [[ $proc_pid == "" ]]; then
  file_name="screen_record-`date +%H_%M_%S`.mkv"
  quality=ultra
  quality=medium
  rm -f $HOME/Videos/record.log

  osd_cat_wrapper "recording `date +%Y-%m-%d_%H:%M:%S%p`" &
  $screen_recorder \
    -w screen \
    -k av1 \
    -q $quality \
    -c mkv \
    -f 60 \
    -a default_output \
    -a "`pactl get-default-source`" \
    -o "$HOME/Videos/$file_name"

    # -o "$HOME/Videos/$file_name" |& ts '[%Y-%m-%d %H:%M:%S]' >> $HOME/Videos/screen_recorder.log

#    -a "`pactl get-default-sink`.monitor" \
#    -a "alsa_input.usb-TC-Helicon_GoXLRMini-00.HiFi__goxlr_stereo_in_GoXLRMini_0_2_3__source" \
else
  kill -s SIGINT $proc_pid
  osd_cat_wrapper "recording stopped"
fi

exit 0


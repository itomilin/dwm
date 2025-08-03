#!/usr/bin/env bash

master_status=`amixer sget Master | awk 'END{print $NF}'`
speaker_status=`amixer sget Speaker | awk 'END{print $NF}'`

# toggle.
if [[ $master_status == "[on]" ]] && [[ $speaker_status == "[on]" ]]; then
  amixer -q sset Master toggle
else
  amixer -q sset Speaker toggle
  amixer -q sset Master  toggle
fi



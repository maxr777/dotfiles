#!/bin/bash
while ! xinput list | grep -q "Razer Razer Viper Mini"; do
    sleep 1
done
xinput --set-prop "pointer:Razer Razer Viper Mini" "libinput Accel Profile Enabled" 0, 0, 0
xinput --set-prop "pointer:Razer Razer Viper Mini" "libinput Accel Speed" -0.8

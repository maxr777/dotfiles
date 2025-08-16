#!/bin/bash
while ! xinput list | grep -q "Razer Razer Viper Mini"; do
    sleep 1
done
xinput --set-prop "pointer:Razer Razer Viper Mini" "libinput Accel Profile Enabled" 0, 0, 0
xinput --set-prop "pointer:Razer Razer Viper Mini" "libinput Accel Speed" -0.8

# Configure Wacom if connected
if xinput list | grep -q "Wacom One by Wacom M Pen Pen"; then
    xinput --set-prop "Wacom One by Wacom M Pen Pen (0)" "Coordinate Transformation Matrix" -0.5 0 1 0 -1 1 0 0 1
fi

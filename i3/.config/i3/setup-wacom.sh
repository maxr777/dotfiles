#!/bin/bash
# Configure Wacom tablet for right monitor with 180-degree flip

if xinput list | grep -q "Wacom One by Wacom M Pen Pen"; then
    echo "Configuring Wacom tablet..."
    # Map to right monitor (DP-0) which spans from x=1920 to x=3840 (total width 3840)
    # Matrix: scale_x, skew_x, translate_x, skew_y, scale_y, translate_y, 0, 0, 1
    # For right monitor only with 180° flip: -0.5 scale on x-axis, -1 scale on y-axis (full height)
    xinput --set-prop "Wacom One by Wacom M Pen Pen (0)" "Coordinate Transformation Matrix" -0.5 0 1 0 -1 1 0 0 1
    echo "Wacom configured: mapped to right monitor (DP-0), flipped 180 degrees"
else
    echo "Wacom tablet not found. Make sure it's connected."
fi
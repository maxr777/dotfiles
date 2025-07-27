### Setup
1. Edit the `exec --no-startup-id xrandr --output HDMI-0 --mode 1920x1080 --rate 59.94 --output DP-0 --mode 1920x1080 --rate 239.96 --right-of HDMI-0 --primary` line in i3's config to fit your display (or comment it out)
2. [Download the jetbrains mono nerd font](https://www.nerdfonts.com/font-downloads) or change the alacritty config to use some other font
3. Run `./setup.sh` - it will dnf all the required programs and plugins, backup config files if there are any, and stow everything (there's also an anki keybind that requires anki to be installed - I don't dnf install it in the script)

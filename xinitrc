#start xmonad
xsetroot -cursor_name left_ptr
if xrandr | grep "DP1 connected"; then
  xrandr --auto --output DP1 --mode 2560x1440 --above LVDS1 --output LVDS1 --mode 1366x768
  #xrandr --auto --output VGA1 --mode 1920x1080 --above LVDS1 --output LVDS1 --mode 1366x768
  #xrandr --auto --output VGA1 --mode 1366x768 --left-of LVDS1 --output LVDS1 --mode 1366x768
fi
#syndaemon -k -R -i 0.5 -d &
synclient TouchpadOff=1
#nm-applet
xmodmap ~/.Xmodmap
eval `cat ~/.fehbg` &
xmonad

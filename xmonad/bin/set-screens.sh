#!/bin/bash
xrandrcmd="xrandr --output LVDS1 --auto"
statusbarcmd="/home/glalonde/.xmonad/bin/set-status-bar.sh"
connectedOutputs=$(xrandr | grep " connected" | sed -e "s/\([A-Z0-9]\+\) connected.*/\1/")
VGA=""
DP=""
DVI=""
LVDS=""

for display in $connectedOutputs
do
  case "$display" in
    *DVI*) echo "found dvi"
      DVI="$display";;
    *DP*) echo "found dp"
      DP="$display";;
    *VGA*) echo "found vga"
      VGA="$display";;
    *LVDS*) echo "found lvds"
      LVDS="$display";;
    *) echo "Didn't match";;
  esac
done


xrandrcmd="xrandr --output $LVDS --auto --pos 0x0 --primary"
if [[ -n $DP  ]]
then
  xrandrcmd+=" --output $DP --auto --pos 1366x-672"
  statusbarcmd="/home/glalonde/.xmonad/bin/set-status-bar.sh 2"
else
  xrandrcmd+=" --primary"
fi
if [[ -n $DVI ]]
then
  xrandrcmd+=" --output $DVI --auto --pos 0x-1024"
  statusbarcmd="/home/glalonde/.xmonad/bin/set-status-bar.sh 3"
fi

for display in $connectedOutputs
do
  xrandr --output $display --off
done
echo $xrandrcmd
$xrandrcmd
nitrogen --restore &
$statusbarcmd &

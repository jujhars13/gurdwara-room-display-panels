#!/bin/bash

# Script to turn monitor off/on
#
function _trigger-monitors-off-in-gnome-wayland()
{
    busctl --user set-property org.gnome.Mutter.DisplayConfig /org/gnome/Mutter/DisplayConfig org.gnome.Mutter.DisplayConfig PowerSaveMode i 1
}

function _trigger-monitors-on-in-gnome-wayland()
{
    busctl --user set-property org.gnome.Mutter.DisplayConfig /org/gnome/Mutter/DisplayConfig org.gnome.Mutter.DisplayConfig PowerSaveMode i 0
}

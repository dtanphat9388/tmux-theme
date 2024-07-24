#!/bin/bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

export TMUX_PLUGIN_PREFIX="@tmux_theme"

source $CURRENT_DIR/scripts/shared.sh

window_with_icons() {
  result=""
  local icons="$1"
  local name="$2"
  IFS=$'\n';for row in $icons;do
    IFS=$' '
    set -- $row
    icon=$1
    regex=$2
    echo $icons >> /tmp/theme.log
    # echo $row >> /tmp/theme.log
  result+="#{?#{m/ri:^$regex,#{window_name}},$icon ,}"
  done
  result+="$name"
  echo "$result"
}

COLOR_BG=$(tmux_get_option "color_bg" "terminal")
COLOR_ACTIVE=$(tmux_get_option "color_active" "#17C3B2")
COLOR_INACTIVE=$(tmux_get_option "color_inactive" "#686868")
# -- [LEFT]
LEFT_COLOR_BG=$(tmux_get_option "left_color_bg" "#FFFFFF")
LEFT_LENGTH=$(tmux_get_option "left_length" 25)
# -- [RIGHT]
RIGHT_COLOR_BG=$(tmux_get_option "right_color_bg" "#FFFFFF")
RIGHT_LENGTH=$(tmux_get_option "right_length" 50)
RIGHT_LABEL=$(tmux_get_option "right_label" "#{host_short}")
# -- [WINDOW]
WINDOW_NAME_FORMAT=$(tmux_get_option "window_name_format" "#W")
WINDOW_ZOOM_FORMAT=$(tmux_get_option "window_zoom_format" "[$WINDOW_NAME_FORMAT]")
WINDOW_ICON=$(tmux_get_option "window_icon" "")
WINDOW_NAME_BASIC="#{?window_zoomed_flag,$WINDOW_ZOOM_FORMAT,$WINDOW_NAME_FORMAT}"
WINDOW_NAME="$(window_with_icons "$WINDOW_ICON" "$WINDOW_NAME_BASIC")"
# -- [BORDER]
BORDER_COLOR_ACTIVE=$(tmux_get_option "border_color_active" $COLOR_ACTIVE)
BORDER_COLOR_INACTIVE=$(tmux_get_option "border_color_inactive" $COLOR_INACTIVE)
# -- [STATUS]
STATUS_POSITION=$(tmux_get_option "status_position" "top")

tmux_set_default_env() {
    # -- set default option
    tmux_set_env "color_bg"       $COLOR_BG
    tmux_set_env "color_active"   $COLOR_ACTIVE
    tmux_set_env "color_inactive" $COLOR_INACTIVE
    # -- left
    tmux_set_env "left_color_bg"  $LEFT_COLOR_BG
    tmux_set_env "left_length"    $LEFT_LENGTH
    # -- right
    tmux_set_env "right_color_bg" $RIGHT_COLOR_BG
    tmux_set_env "right_length"   $RIGHT_LENGTH
    tmux_set_env "right_label"    $RIGHT_LABEL
    # -- windows
    tmux_set_env "window_name"          "$WINDOW_NAME"
    # -- border
    tmux_set_env "border_color_active"   $BORDER_COLOR_ACTIVE
    tmux_set_env "border_color_inactive" $BORDER_COLOR_INACTIVE
    # -- status
    tmux_set_env "status_position" $STATUS_POSITION
}

main() {
    tmux_set_default_env
    tmux source-file "$CURRENT_DIR/tmux-theme.conf"
}

main


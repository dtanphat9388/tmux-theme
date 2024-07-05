#!/bin/bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
TMUX_PLUGIN_PREFIX="@tmux_theme"

get_fullname() {
    opt_name=$1
    echo "${TMUX_PLUGIN_PREFIX}_${opt_name}"
}

get_option() {
    local name value default_value
    name=$1
    default_value=$2
    fullname=$(get_fullname $name)
    value=$(tmux show-option -gqv $fullname)
    if [[ -z $value ]]; then
      echo $default_value
    else
      echo "$value"
    fi
}

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

COLOR_BG=$(get_option "color_bg" "terminal")
COLOR_ACTIVE=$(get_option "color_active" "#17C3B2")
COLOR_INACTIVE=$(get_option "color_inactive" "#686868")
# -- [LEFT]
LEFT_COLOR_BG=$(get_option "left_color_bg" "#FFFFFF")
LEFT_LENGTH=$(get_option "left_length" 25)
# -- [RIGHT]
RIGHT_COLOR_BG=$(get_option "right_color_bg" "#FFFFFF")
RIGHT_LENGTH=$(get_option "right_length" 50)
RIGHT_LABEL=$(get_option "right_label" "#{host_short}")
# -- [WINDOW]
WINDOW_NAME_FORMAT=$(get_option "window_name_format" "#W")
WINDOW_ZOOM_FORMAT=$(get_option "window_zoom_format" "[$WINDOW_NAME_FORMAT]")
WINDOW_ICON=$(get_option "window_icon" "")
WINDOW_NAME_BASIC="#{?window_zoomed_flag,$WINDOW_ZOOM_FORMAT,$WINDOW_NAME_FORMAT}"
WINDOW_NAME="$(window_with_icons "$WINDOW_ICON" "$WINDOW_NAME_BASIC")"
# -- [BORDER]
BORDER_COLOR_ACTIVE=$(get_option "border_color_active" $COLOR_ACTIVE)
BORDER_COLOR_INACTIVE=$(get_option "border_color_inactive" $COLOR_INACTIVE)
# -- [STATUS]
STATUS_POSITION=$(get_option "status_position" "top")

get_env_name() {
    fullname=$(get_fullname $1)
    echo "${fullname/@/}"
}

set_env() {
    local name value
    name=$(get_env_name $1)
    value=$2
    tmux set-environment -g "$name" "$value"
}


tmux_set_default_env() {
    # -- set default option
    set_env "color_bg"       $COLOR_BG
    set_env "color_active"   $COLOR_ACTIVE
    set_env "color_inactive" $COLOR_INACTIVE
    # -- left
    set_env "left_color_bg"  $LEFT_COLOR_BG
    set_env "left_length"    $LEFT_LENGTH
    # -- right
    set_env "right_color_bg" $RIGHT_COLOR_BG
    set_env "right_length"   $RIGHT_LENGTH
    set_env "right_label"    $RIGHT_LABEL
    # -- windows
    set_env "window_name"          "$WINDOW_NAME"
    # -- border
    set_env "border_color_active"   $BORDER_COLOR_ACTIVE
    set_env "border_color_inactive" $BORDER_COLOR_INACTIVE
    # -- status
    set_env "status_position" $STATUS_POSITION
}

main() {
    tmux_set_default_env
    tmux source-file "$CURRENT_DIR/tmux-theme.conf"
}

main


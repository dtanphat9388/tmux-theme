#!/bin/bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
TMUX_PLUGIN_PREFIX="@tmux-theme"

get_fullname() {
    opt_name=$1
    echo "${TMUX_PLUGIN_PREFIX}-${opt_name}"
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

COLOR_BG=$(get_option "color-bg" "#101419")
COLOR_ACTIVE=$(get_option "color-active" "#17C3B2")
COLOR_INACTIVE=$(get_option "color-inactive" "#686868")
# -- [LEFT]
LEFT_COLOR_BG=$(get_option "left-color-bg" "#FFFFFF")
LEFT_LENGTH=$(get_option "left-length" 25)
# -- [RIGHT]
RIGHT_COLOR_BG=$(get_option "right-color-bg" "#FFFFFF")
RIGHT_LENGTH=$(get_option "right-length" 50)
RIGHT_LABEL=$(get_option "right-label" "#{host_short}")
# -- [WINDOW]
WINDOW_NAME_FORMAT=$(get_option "window-name-format" "#W")
WINDOW_ZOOM_FORMAT=$(get_option "window-zoom-format" "[$WINDOW_NAME_FORMAT]")
WINDOW_ICON=$(get_option "window-icon" "")
WINDOW_NAME_BASIC="#{?window_zoomed_flag,$WINDOW_ZOOM_FORMAT,$WINDOW_NAME_FORMAT}"
WINDOW_NAME="$(window_with_icons "$WINDOW_ICON" "$WINDOW_NAME_BASIC")"
# -- [BORDER]
BORDER_COLOR_ACTIVE=$(get_option "border-color-active" $COLOR_ACTIVE)
BORDER_COLOR_INACTIVE=$(get_option "border-color-inactive" $COLOR_INACTIVE)
# -- [STATUS]
STATUS_POSITION=$(get_option "status_position" "top")

get_env_name() {
    fullname=$(get_fullname $1)
    echo "${fullname/@/}" | tr - _
}

set_env() {
    local name value
    name=$(get_env_name $1)
    value=$2
    tmux set-environment -g "$name" "$value"
}


tmux_set_default_env() {
    # -- set default option
    set_env "color-bg"       $COLOR_BG
    set_env "color-active"   $COLOR_ACTIVE
    set_env "color-inactive" $COLOR_INACTIVE
    # -- left
    set_env "left-color-bg"  $LEFT_COLOR_BG
    set_env "left-length"    $LEFT_LENGTH
    # -- right
    set_env "right-color-bg" $RIGHT_COLOR_BG
    set_env "right-length"   $RIGHT_LENGTH
    set_env "right-label"    $RIGHT_LABEL
    # -- windows
    set_env "window-name"        "$WINDOW_NAME"
    # -- border
    set_env "border-color-active" $BORDER_COLOR_ACTIVE
    set_env "border-color-inactive" $BORDER_COLOR_INACTIVE
    # -- status
    set_env "status-position" $STATUS_POSITION
}

main() {
    tmux_set_default_env
    tmux source-file "$CURRENT_DIR/tmux-theme.conf"
}

main


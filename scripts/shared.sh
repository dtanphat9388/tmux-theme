#!/usr/bin/env bash

tmux_get_plugins() {
	plugins_list=$(tmux show-option -gqv "@tpm_plugins")
	for plugin in $plugins_list; do
		echo $plugin
	done
}

get_fullname() {
	echo "${TMUX_PLUGIN_PREFIX}_$1"
}

tmux_get_option() {
	local name=$(get_fullname $1)
	local default_value=$2
	local value=$(tmux show-option -gqv $fullname)
	if [[ -z $value ]]; then
		echo $default_value
	else
		echo "$value"
	fi
}

tmux_set_option() {
	local name="$1"
	local value="$2"
	tmux set-option -gq $name "$value"
}

tmux_get_env() {
	fullname=$(get_fullname $1)
	echo "${fullname/@/}"
}

tmux_set_env() {
	local name=$(tmux_get_env $1)
	local value=$2
	tmux set-environment -g "$name" "$value"
}

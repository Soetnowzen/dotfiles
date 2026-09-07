#!/bin/bash

_git_expand_alias() {
	local subcmd="$1" seen="${2:-}" acc_args="${3:-}"
	[[ "|$seen|" == *"|$subcmd|"* ]] && return
	local expanded
	expanded=$(command git config --get "alias.$subcmd" 2>/dev/null)
	[[ -z "$expanded" ]] && return
	seen+="|$subcmd"
	local display_call="$subcmd${acc_args:+ $acc_args}"
	if [[ "$expanded" == \!* ]]; then
		local shell_cmd="${expanded#!}"
		shell_cmd="${shell_cmd#\"}"; shell_cmd="${shell_cmd%\"}"
		local display_cmd
		display_cmd=$(eval "printf '%s' \"${shell_cmd//\"/\\\"}\"" 2>/dev/null) || display_cmd="$shell_cmd"
		printf "  git %s -> %s\n" "$display_call" "$display_cmd" >&2
		if [[ "$shell_cmd" =~ ^git[[:space:]]+([a-zA-Z_-]+)(.*) ]]; then
			local next_args="${BASH_REMATCH[2]# }"
			local combined="${next_args}${acc_args:+ $acc_args}"
			_git_expand_alias "${BASH_REMATCH[1]}" "$seen" "${combined% }"
		fi
	else
		local next="${expanded%% *}"
		local expansion_args=""
		[[ "$expanded" == *" "* ]] && expansion_args="${expanded#* }"
		local full_cmd="$expanded${acc_args:+ $acc_args}"
		printf "  git %s -> git %s\n" "$display_call" "$full_cmd" >&2
		local combined="${expansion_args}${acc_args:+ $acc_args}"
		_git_expand_alias "$next" "$seen" "${combined# }"
	fi
}

git() {
	local subcmd="${1:-}"
	if [[ -n "$subcmd" ]]; then
		local user_args=""
		[[ $# -gt 1 ]] && user_args="$(printf '%q ' "${@:2}")"
		_git_expand_alias "$subcmd" "" "${user_args% }"
	fi
	command git "$@"
}

function git-clone() {
	local repo_url="$1"
	local target_dir="${2:-$(basename "$repo_url" .git)}"
	local clone_to_projects=false

	if [[ -z "$2" ]]; then
		mkdir -p ~/projects
		target_dir="~/projects/$target_dir"
		clone_to_projects=true
	fi

	echo "🚀 Cloning $repo_url to $target_dir..."
	if git clone "$repo_url" "$target_dir"; then
		cd "$target_dir" || return 1

		echo "🔧 Setting up hooks and personal config..."
		git init >/dev/null 2>&1

		if [[ "$clone_to_projects" == true ]]; then
			echo "📁 Cloned to projects directory - personal config auto-applied"
		fi

		echo "✅ Repository cloned and configured!"
		echo "📁 Directory: $(pwd)"
		echo "👤 User: $(git config user.name) <$(git config user.email)>"
	else
		echo "❌ Clone failed!"
		return 1
	fi
}
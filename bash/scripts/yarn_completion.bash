# yarn completion                                          -*- shell-script -*-

function _yarn_complete()
{
	local current
	current="${COMP_WORDS[COMP_CWORD]}"

	# Find repo root (git root or fallback to cwd)
	local repo_root
	repo_root="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"

	local package_json="$repo_root/package.json"

	if [[ -f "$package_json" ]]; then
		local scripts
		scripts="$(jq -r '.scripts // {} | keys[]' "$package_json" 2>/dev/null)"
		COMPREPLY=( $( compgen -W "$scripts" -- "$current" ) )
	fi
}

complete -F _yarn_complete yarn

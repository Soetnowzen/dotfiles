# docker(1) completion                                     -*- shell-script -*-

# Helper: running container names
function _docker_running_containers()
{
	command docker ps --format '{{.Names}}' 2>/dev/null
}

# Helper: all container names (including stopped)
function _docker_all_containers()
{
	command docker ps -a --format '{{.Names}}' 2>/dev/null
}

# Helper: image names
function _docker_images()
{
	command docker images --format '{{.Repository}}:{{.Tag}}' 2>/dev/null | grep -v '<none>'
}

# dexec: exec into a running container
function _dexec_completion()
{
	local current="${COMP_WORDS[COMP_CWORD]}"
	COMPREPLY=( $( compgen -W "$(_docker_running_containers)" -- "$current" ) )
}
complete -F _dexec_completion dexec

# dlog: logs of a container (all, since it may be stopped)
function _dlog_completion()
{
	local current="${COMP_WORDS[COMP_CWORD]}"
	COMPREPLY=( $( compgen -W "$(_docker_all_containers)" -- "$current" ) )
}
complete -F _dlog_completion dlog

# dps: no meaningful argument completion needed, but allow flags
complete -F _dlog_completion dps

# dimg: image names for reference
function _dimg_completion()
{
	local current="${COMP_WORDS[COMP_CWORD]}"
	COMPREPLY=( $( compgen -W "$(_docker_images)" -- "$current" ) )
}
complete -F _dimg_completion dimg

# dc: docker-compose - complete subcommands and services from compose file
function _dc_completion()
{
	local current="${COMP_WORDS[COMP_CWORD]}"
	local previous="${COMP_WORDS[COMP_CWORD-1]}"

	local subcommands="up down build logs ps exec run restart stop rm pull push config version"

	if [[ $COMP_CWORD -eq 1 ]]; then
		COMPREPLY=( $( compgen -W "$subcommands" -- "$current" ) )
		return
	fi

	# For subcommands that operate on services, complete with service names
	case "$previous" in
		exec|logs|run|restart|stop|rm|up|build)
			local compose_file=""
			for f in docker-compose.yml docker-compose.yaml compose.yml compose.yaml; do
				[[ -f "$f" ]] && compose_file="$f" && break
			done
			if [[ -n "$compose_file" ]]; then
				local services
				services=$(command grep -E '^  [a-zA-Z0-9_-]+:' "$compose_file" 2>/dev/null | sed 's/://;s/  //')
				COMPREPLY=( $( compgen -W "$services" -- "$current" ) )
			fi
			return
			;;
	esac

	COMPREPLY=( $( compgen -W "$subcommands" -- "$current" ) )
}
complete -F _dc_completion dc

# dstart: start a devcontainer in the current repo
function dstart()
{
	local repo_root
	repo_root=$(git rev-parse --show-toplevel 2>/dev/null)

	if [[ -z "$repo_root" ]]; then
		echo "dstart: not inside a git repository" >&2
		return 1
	fi

	if [[ ! -d "$repo_root/.devcontainer" ]]; then
		echo "dstart: no .devcontainer found in $repo_root" >&2
		return 1
	fi

	if ! command -v devcontainer >/dev/null 2>&1; then
		echo "dstart: 'devcontainer' CLI not found" >&2
		echo "  Install it with: npm install -g @devcontainers/cli" >&2
		return 1
	fi

	printf "devcontainer up --workspace-folder %s\n" "$repo_root" >&2
	devcontainer up --workspace-folder "$repo_root"
}

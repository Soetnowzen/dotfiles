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

# dxec: exec into an arbitrary running container by name
function _dxec_completion()
{
	local current="${COMP_WORDS[COMP_CWORD]}"
	COMPREPLY=( $( compgen -W "$(_docker_running_containers)" -- "$current" ) )
}
complete -F _dxec_completion dxec

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

# ---- fallback for when the `devcontainer` CLI isn't installed: drive docker/docker-compose directly ----

# Strip // and /* */ comments and trailing commas from a devcontainer.json (JSONC) file.
function _devcontainer_json_clean()
{
	local json="$1"
	python3 - "$json" <<'PYEOF'
import json, re, sys
with open(sys.argv[1]) as f:
	text = f.read()
out, i, n, in_str, esc = [], 0, len(text), False, False
while i < n:
	c = text[i]
	if in_str:
		out.append(c)
		if esc:
			esc = False
		elif c == '\\':
			esc = True
		elif c == '"':
			in_str = False
		i += 1
		continue
	if c == '"':
		in_str = True
		out.append(c)
		i += 1
		continue
	if c == '/' and i + 1 < n and text[i + 1] == '/':
		while i < n and text[i] != '\n':
			i += 1
		continue
	if c == '/' and i + 1 < n and text[i + 1] == '*':
		i += 2
		while i + 1 < n and not (text[i] == '*' and text[i + 1] == '/'):
			i += 1
		i += 2
		continue
	out.append(c)
	i += 1
clean = re.sub(r',(\s*[}\]])', r'\1', ''.join(out))
json.dump(json.loads(clean), sys.stdout)
PYEOF
}

# Path to the repo's devcontainer.json, or nothing if none exists.
function _devcontainer_json_path()
{
	local repo_root="$1"
	local f
	for f in "$repo_root/.devcontainer/devcontainer.json" "$repo_root/.devcontainer.json"; do
		[[ -f "$f" ]] && echo "$f" && return 0
	done
	return 1
}

# The devcontainer CLI's own docker-compose project naming convention, so our fallback
# adopts containers already created by the real CLI (or VS Code's Dev Containers extension)
# instead of colliding with them.
function _devcontainer_compose_project()
{
	local repo_root="$1"
	local name
	name=$(basename "$repo_root")
	name="${name,,}"
	name="${name//[^a-z0-9]/-}"
	echo "${name}_devcontainer"
}

# -f <file> args for docker compose, resolved relative to the devcontainer.json's directory.
function _devcontainer_compose_file_args()
{
	local json="$1" clean="$2"
	local dir
	dir=$(dirname "$json")
	local f
	while IFS= read -r f; do
		[[ -z "$f" ]] && continue
		[[ "$f" = /* ]] && printf -- '-f\n%s\n' "$f" || printf -- '-f\n%s\n' "$dir/$f"
	done < <(jq -r 'if (.dockerComposeFile|type)=="array" then .dockerComposeFile[] else (.dockerComposeFile // empty) end' <<<"$clean")
}

# Resolve the running container id for the repo's devcontainer without the `devcontainer` CLI.
function _devcontainer_id_plain()
{
	local repo_root="$1"
	local json
	json=$(_devcontainer_json_path "$repo_root") || return 0
	local clean
	clean=$(_devcontainer_json_clean "$json") || return 0

	local service
	service=$(jq -r '.service // empty' <<<"$clean")

	if [[ -n "$service" ]]; then
		local project
		project=$(_devcontainer_compose_project "$repo_root")
		local compose_args=()
		mapfile -t compose_args < <(_devcontainer_compose_file_args "$json" "$clean")
		printf "docker compose %s -p %s ps -q %s\n" "${compose_args[*]}" "$project" "$service" >&2
		command docker compose "${compose_args[@]}" -p "$project" ps -q "$service" 2>/dev/null
	else
		command docker ps -q --filter "label=devcontainer.local_folder=$repo_root" 2>/dev/null
	fi
}

# Start the repo's devcontainer without the `devcontainer` CLI, driving docker/docker-compose
# directly from devcontainer.json. Supports dockerComposeFile+service, image, and build.dockerfile.
function _devcontainer_up_plain()
{
	local repo_root="$1"
	local json
	json=$(_devcontainer_json_path "$repo_root") || {
		echo "dstart: no devcontainer.json found in $repo_root" >&2
		return 1
	}
	local clean
	clean=$(_devcontainer_json_clean "$json") || {
		echo "dstart: failed to parse $json" >&2
		return 1
	}

	local service
	service=$(jq -r '.service // empty' <<<"$clean")

	if [[ -n "$service" ]]; then
		local project
		project=$(_devcontainer_compose_project "$repo_root")
		local compose_args=()
		mapfile -t compose_args < <(_devcontainer_compose_file_args "$json" "$clean")
		if [[ ${#compose_args[@]} -eq 0 ]]; then
			echo "dstart: devcontainer.json has 'service' but no 'dockerComposeFile'" >&2
			return 1
		fi

		# Without "runServices", the devcontainer spec starts every service in the compose
		# file (plain `up -d`, no service args) — not just the primary one.
		local run_services=()
		mapfile -t run_services < <(jq -r '(.runServices // [])[]' <<<"$clean")
		if [[ ${#run_services[@]} -eq 0 ]]; then
			printf "docker compose %s -p %s up -d\n" "${compose_args[*]}" "$project" >&2
			command docker compose "${compose_args[@]}" -p "$project" up -d
		else
			local services=("$service") s
			for s in "${run_services[@]}"; do
				[[ " ${services[*]} " == *" $s "* ]] || services+=("$s")
			done
			printf "docker compose %s -p %s up -d %s\n" "${compose_args[*]}" "$project" "${services[*]}" >&2
			command docker compose "${compose_args[@]}" -p "$project" up -d "${services[@]}"
		fi
		return
	fi

	if command docker ps -q --filter "label=devcontainer.local_folder=$repo_root" 2>/dev/null | command grep -q .; then
		return 0
	fi

	local existing
	existing=$(command docker ps -aq --filter "label=devcontainer.local_folder=$repo_root" 2>/dev/null | head -n1)
	if [[ -n "$existing" ]]; then
		printf "docker start %s\n" "$existing" >&2
		command docker start "$existing" >/dev/null
		return
	fi

	local image
	image=$(jq -r '.image // empty' <<<"$clean")

	if [[ -z "$image" ]]; then
		local dockerfile context dir
		dockerfile=$(jq -r '.build.dockerfile // .dockerFile // empty' <<<"$clean")
		context=$(jq -r '.build.context // "."' <<<"$clean")
		dir=$(dirname "$json")
		if [[ -z "$dockerfile" ]]; then
			echo "dstart: devcontainer.json has no 'image', 'build.dockerfile' or 'dockerComposeFile'" >&2
			return 1
		fi
		image="devcontainer-${repo_root##*/}"
		image="${image,,}"
		printf "docker build -f %s -t %s %s\n" "$dir/$dockerfile" "$image" "$dir/$context" >&2
		command docker build -f "$dir/$dockerfile" -t "$image" "$dir/$context" || return 1
	fi

	local workspace_folder
	workspace_folder=$(jq -r '.workspaceFolder // empty' <<<"$clean")
	[[ -z "$workspace_folder" ]] && workspace_folder="/workspaces/$(basename "$repo_root")"

	local env_args=() mount_args=() run_args=() port_args=()
	local key val
	while IFS=$'\t' read -r key val; do
		[[ -z "$key" ]] && continue
		env_args+=(-e "$key=$val")
	done < <(jq -r '(.containerEnv // {}) | to_entries[] | "\(.key)\t\(.value)"' <<<"$clean")

	while IFS= read -r m; do
		[[ -z "$m" ]] && continue
		mount_args+=(--mount "$m")
	done < <(jq -r '(.mounts // [])[] | select(type=="string")' <<<"$clean")

	while IFS= read -r a; do
		[[ -z "$a" ]] && continue
		run_args+=("$a")
	done < <(jq -r '(.runArgs // [])[]' <<<"$clean")

	while IFS= read -r p; do
		[[ -z "$p" ]] && continue
		if [[ "$p" =~ ^[0-9]+$ ]]; then
			port_args+=(-p "$p:$p")
		else
			port_args+=(-p "$p")
		fi
	done < <(jq -r '(.forwardPorts // [])[] | tostring' <<<"$clean")

	printf "docker run -d --label devcontainer.local_folder=%s --mount type=bind,source=%s,target=%s -w %s %s sleep infinity\n" \
		"$repo_root" "$repo_root" "$workspace_folder" "$workspace_folder" "$image" >&2
	command docker run -d \
		--label "devcontainer.local_folder=$repo_root" \
		--mount "type=bind,source=$repo_root,target=$workspace_folder" \
		-w "$workspace_folder" \
		"${env_args[@]}" "${mount_args[@]}" "${run_args[@]}" "${port_args[@]}" \
		"$image" sleep infinity >/dev/null
}

# Resolve the running container id for the repo's devcontainer, preferring the `devcontainer`
# CLI's own label lookup and falling back to plain docker/docker-compose otherwise.
function _devcontainer_container_id()
{
	local repo_root="$1"
	if command -v devcontainer >/dev/null 2>&1; then
		printf "docker ps -q --filter label=devcontainer.local_folder=%s\n" "$repo_root" >&2
		command docker ps -q --filter "label=devcontainer.local_folder=$repo_root" 2>/dev/null
	else
		_devcontainer_id_plain "$repo_root"
	fi
}

# dexec: run a command inside the current repo's devcontainer (starts it if needed)
# with no arguments, opens an interactive shell
function dexec()
{
	if [[ $# -eq 0 ]]; then
		set -- sh -c 'exec bash 2>/dev/null || exec sh'
	fi

	local repo_root
	repo_root=$(git rev-parse --show-toplevel 2>/dev/null)
	if [[ -z "$repo_root" ]]; then
		echo "dexec: not inside a git repository" >&2
		return 1
	fi

	if [[ ! -d "$repo_root/.devcontainer" ]]; then
		echo "dexec: no .devcontainer found in $repo_root" >&2
		return 1
	fi

	local container_id
	container_id=$(_devcontainer_container_id "$repo_root")

	if [[ -z "$container_id" ]]; then
		local name="devcontainer"
		local json="$repo_root/.devcontainer/devcontainer.json"
		if [[ -f "$json" ]]; then
			local parsed
			parsed=$(command grep -m1 '"name"' "$json" | sed 's/.*"name"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/')
			[[ -n "$parsed" ]] && name="$parsed"
		fi
		echo "dexec: '$name' is not running, starting devcontainer..." >&2
		dstart || return 1
		container_id=$(_devcontainer_container_id "$repo_root")
	fi

	if [[ -z "$container_id" ]]; then
		echo "dexec: container failed to start" >&2
		return 1
	fi

	# Prefer the devcontainer CLI (handles cwd/env automatically); fall back to docker exec
	if command -v devcontainer >/dev/null 2>&1; then
		printf "devcontainer exec --workspace-folder %s -- %s\n" "$repo_root" "$(printf '%q ' "$@")" >&2
		devcontainer exec --workspace-folder "$repo_root" -- "$@"
	else
		printf "docker inspect %s --format '{{range .Mounts}}...{{end}}'\n" "$container_id" >&2
		local workdir
		workdir=$(command docker inspect "$container_id" \
			--format '{{range .Mounts}}{{if eq .Source "'"$repo_root"'"}}{{.Destination}}{{end}}{{end}}' 2>/dev/null)
		[[ -z "$workdir" ]] && workdir="/workspaces/$(basename "$repo_root")"
		printf "docker exec -it -w %s %s %s\n" "$workdir" "$container_id" "$(printf '%q ' "$@")" >&2
		command docker exec -it -w "$workdir" "$container_id" "$@"
	fi
}

# dstart: start a devcontainer — uses current repo, or a path from tab completion
function dstart()
{
	local repo_root
	if [[ -n "${1:-}" ]]; then
		repo_root="$1"
	else
		repo_root=$(git rev-parse --show-toplevel 2>/dev/null)
	fi

	if [[ -z "$repo_root" ]]; then
		echo "dstart: not inside a git repository and no path given" >&2
		return 1
	fi

	if [[ ! -d "$repo_root/.devcontainer" ]]; then
		echo "dstart: no .devcontainer found in $repo_root" >&2
		return 1
	fi

	if ! command -v devcontainer >/dev/null 2>&1; then
		_devcontainer_up_plain "$repo_root"
		return
	fi

	printf "devcontainer up --workspace-folder %s\n" "$repo_root" >&2
	devcontainer up --workspace-folder "$repo_root"
}

function _dstart_completion()
{
	local current="${COMP_WORDS[COMP_CWORD]}"
	local prev_folders
	prev_folders=$(command docker ps -a \
		--filter "label=devcontainer.local_folder" \
		--format '{{index .Labels "devcontainer.local_folder"}}' 2>/dev/null | sort -u)
	COMPREPLY=( $( compgen -W "$prev_folders" -- "$current" ) )
}
complete -F _dstart_completion dstart

# dstop: stop a devcontainer — uses current repo, or a path from tab completion
function dstop()
{
	local repo_root
	if [[ -n "${1:-}" ]]; then
		repo_root="$1"
	else
		repo_root=$(git rev-parse --show-toplevel 2>/dev/null)
	fi

	if [[ -z "$repo_root" ]]; then
		echo "dstop: not inside a git repository and no path given" >&2
		return 1
	fi

	if [[ ! -d "$repo_root/.devcontainer" ]]; then
		echo "dstop: no .devcontainer found in $repo_root" >&2
		return 1
	fi

	# The devcontainer CLI has no stop/down command, so drive docker directly either way.
	local json clean service
	if json=$(_devcontainer_json_path "$repo_root"); then
		clean=$(_devcontainer_json_clean "$json") || {
			echo "dstop: failed to parse $json" >&2
			return 1
		}
		service=$(jq -r '.service // empty' <<<"$clean")
	fi

	if [[ -n "$service" ]]; then
		local project compose_args=()
		project=$(_devcontainer_compose_project "$repo_root")
		mapfile -t compose_args < <(_devcontainer_compose_file_args "$json" "$clean")
		printf "docker compose %s -p %s stop\n" "${compose_args[*]}" "$project" >&2
		command docker compose "${compose_args[@]}" -p "$project" stop
		return
	fi

	local container_ids=()
	mapfile -t container_ids < <(command docker ps -q --filter "label=devcontainer.local_folder=$repo_root" 2>/dev/null)
	if [[ ${#container_ids[@]} -eq 0 ]]; then
		echo "dstop: no running devcontainer for $repo_root" >&2
		return 0
	fi

	printf "docker stop %s\n" "${container_ids[*]}" >&2
	command docker stop "${container_ids[@]}"
}
complete -F _dstart_completion dstop

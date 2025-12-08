
RED="$(tput setaf 1)"
GREEN="$(tput setaf 2)"
YELLOW="$(tput setaf 3)"
BLUE="$(tput setaf 4)"
MAGENTA="$(tput setaf 5)"
CYAN="$(tput setaf 6)"
WHITE="$(tput setaf 7)"
ORANGE="$(tput setaf 9)"
VIOLET="$(tput setaf 13)"
# BLACK="\\[$(tput setaf 16)\\]"
# UNDERLINE="\\[$(tput smul)\\]"
# EXIT_UNDERLINE="\\[$(tput rmul)\\]"
RESET="$(tput sgr0)"

function __prompt_command()
{
	local args=("$@")
	local EXIT="${args[0]}"
	local dirs_count="${args[1]}"
	local jobs_count="${args[2]}"
	printf "[" # ]

	# SSH indicator
	__ssh_indicator

	# Python virtual environment indicator
	__python_venv_indicator

	# Docker indicator
	__docker_indicator

	# Node.js indicator (only in Node projects)
	__nodejs_indicator

	# Time
	printf "%s%s%s " "$CYAN" "$(date +%H:%M)" "$RESET"
	# user@pc - use $USER and $HOSTNAME instead of subshells
	if [[ $EXIT != 0 ]]; then
		printf "%s" "$RED"
	else
		printf "%s" "$BLUE"
	fi
	printf "%s%s@%s%s%s " "$USER" "$RESET" "$BLUE" "${HOSTNAME:-$(hostname)}" "$RESET"
	# Path - use $PWD instead of $(pwd)
	printf "%s%s" "$GREEN" "$PWD"
	# __smaller_path
	__count_dirs_stack "$dirs_count"
	__count_jobs_stack "$jobs_count"
	# Get current git branch
	branch=$(__parse_git_branch)
	if [[ ${branch} != "" ]]; then
		printf "%s(%s" "$YELLOW" "$branch"
		__git_prompt "$branch"
		printf ")"
	fi
	if [[ $EXIT != 0 ]]; then
		if [[ $EXIT == 1 ]]; then
			printf " %sCatchall for general errors (${EXIT}X)" "$RED"
		elif [[ $EXIT == 2 ]]; then
			printf " %sMisuse of shell builtins (${EXIT}X)" "$RED"
		elif [[ $EXIT == 126 ]]; then
			printf " %sCommand invoked cannot execute (${EXIT}X)" "$RED"
		elif [[ $EXIT == 127 ]]; then
			printf " %sCommand not found (${EXIT}X)" "$RED"
		elif [[ $EXIT == 130 ]]; then
			printf " %sScript terminated by Control-C (${EXIT}X)" "$RED"
		elif [[ $EXIT -gt 128 ]] && [[ $EXIT -lt 255 ]]; then
			printf " %sFatal error signal 'n=%s' (${EXIT}X)" $(($EXIT-128)) "$RED"
		else
			printf " %sX${EXIT}" "$RED"
		fi
	fi

	printf "%s]\\n" "$RESET"
}

function __smaller_path()
{
	local directories
	directories=$(pwd | tr '/' ' ')
	local last_directory
	last_directory=$(basename "$PWD")
	local new_path=""
	for directory in ${directories}; do
		if [[ $directory == "$last_directory" ]]; then
			new_path+="/$directory"
		else
			new_path+="/$(echo "$directory" | head -c1)"
		fi
	done
	if [[ $new_path == "" ]]; then
		new_path="/"
	fi
	printf "%s%s" "$GREEN" "$new_path"
}

function __ssh_indicator()
{
	# Check if we're in an SSH session
	if [[ -n $SSH_CLIENT ]] || [[ -n $SSH_TTY ]] || [[ -n $SSH_CONNECTION ]]; then
		printf "%s⚡%s" "$MAGENTA" "$RESET"
	fi
}

function __python_venv_indicator()
{
	# Check for Python virtual environment (venv, virtualenv, or conda)
	if [[ -n $VIRTUAL_ENV ]]; then
		local venv_name
		venv_name=$(basename "$VIRTUAL_ENV")
		printf "%s🐍%s%s " "$GREEN" "$venv_name" "$RESET"
	elif [[ -n $CONDA_DEFAULT_ENV ]]; then
		printf "%s🐍%s%s " "$GREEN" "$CONDA_DEFAULT_ENV" "$RESET"
	fi
}

function __docker_indicator()
{
	# Check if we're inside a container
	if [[ -f /.dockerenv ]] || grep -q 'docker\|lxc\|containerd' /proc/1/cgroup 2>/dev/null; then
		printf "%s🐳container%s " "$CYAN" "$RESET"
		return
	fi

	# Check if Docker is available and context is non-default
	if command -v docker &>/dev/null; then
		# Use DOCKER_CONTEXT env var if set, otherwise check current context
		local context="${DOCKER_CONTEXT:-}"
		if [[ -z $context ]]; then
			# Only check docker context if not set (this is slower)
			context=$(docker context show 2>/dev/null)
		fi
		if [[ -n $context ]] && [[ $context != "default" ]]; then
			printf "%s🐳%s%s " "$CYAN" "$context" "$RESET"
		fi
	fi
}

function __nodejs_indicator()
{
	# Only show Node version if we're in a Node project (has package.json)
	# Search current dir and up to 3 parent dirs for package.json
	local dir="$PWD"
	local found=false
	local depth=0
	while [[ $depth -lt 4 ]]; do
		if [[ -f "$dir/package.json" ]]; then
			found=true
			break
		fi
		[[ $dir == "/" ]] && break
		dir=$(dirname "$dir")
		((depth++))
	done

	if [[ $found == true ]] && command -v node &>/dev/null; then
		# Get version without 'v' prefix for cleaner display
		local node_version
		node_version=$(node --version 2>/dev/null)
		if [[ -n $node_version ]]; then
			printf "%s⬢%s%s " "$GREEN" "$node_version" "$RESET"
		fi
	fi
}

function __count_dirs_stack()
{
	local dirs_count="$1"
	if [[ $dirs_count != "" ]]; then
		if [[ $dirs_count != 1 ]]; then
			printf "[%sd%s%s]" "$ORANGE" "$dirs_count" "$GREEN"
		fi
	fi
}

function __count_jobs_stack()
{
	local jobs_count="$1"
	if [[ $jobs_count != "" ]]; then
		if [[ $jobs_count != 0 ]]; then
			printf "[%sj%s%s]" "$VIOLET" "$jobs_count" "$GREEN"
		fi
	fi
}

function __parse_git_branch()
{
	git rev-parse --abbrev-ref HEAD 2> /dev/null
}

function __git_prompt()
{
	local current_branch="$1"
	__git_operation_prompt
	__git_tag_prompt
	__git_modifications_prompt
	__git_commit_status
	__git_feature_branch_commits "$current_branch"
	__git_stash_count
}

function __git_operation_prompt()
{
	local git_dir
	git_dir=$(git rev-parse --git-dir 2> /dev/null)
	[[ -z $git_dir ]] && return

	if [[ -d "$git_dir/rebase-merge" ]] || [[ -d "$git_dir/rebase-apply" ]]; then
		# Get rebase progress
		local step total
		if [[ -d "$git_dir/rebase-merge" ]]; then
			step=$(cat "$git_dir/rebase-merge/msgnum" 2>/dev/null)
			total=$(cat "$git_dir/rebase-merge/end" 2>/dev/null)
		else
			step=$(cat "$git_dir/rebase-apply/next" 2>/dev/null)
			total=$(cat "$git_dir/rebase-apply/last" 2>/dev/null)
		fi
		if [[ -n $step ]] && [[ -n $total ]]; then
			printf " | %sREBASE %s/%s%s" "$RED" "$step" "$total" "$YELLOW"
		else
			printf " | %sREBASE%s" "$RED" "$YELLOW"
		fi
	elif [[ -f "$git_dir/MERGE_HEAD" ]]; then
		printf " | %sMERGE%s" "$RED" "$YELLOW"
	elif [[ -f "$git_dir/CHERRY_PICK_HEAD" ]]; then
		printf " | %sCHERRY-PICK%s" "$RED" "$YELLOW"
	elif [[ -f "$git_dir/REVERT_HEAD" ]]; then
		printf " | %sREVERT%s" "$RED" "$YELLOW"
	elif [[ -f "$git_dir/BISECT_LOG" ]]; then
		printf " | %sBISECT%s" "$ORANGE" "$YELLOW"
	fi
}

function __git_tag_prompt()
{
	git_tag=$(git tag -l --points-at HEAD 2> /dev/null)
	if [[ ${git_tag} != "" ]]; then
		printf " | %stag: %s%s" "$WHITE" "$git_tag" "$YELLOW"
	fi
}

function __git_modifications_prompt()
{
	__modified_files_count
	# Use --shortstat for efficient line counting
	git_shortstat=$(git diff --shortstat 2> /dev/null)
	if [[ ${git_shortstat} != "" ]]; then
		printf " | lines:"
		plus_lines=$(echo "$git_shortstat" | grep -oE '[0-9]+ insertion' | grep -oE '[0-9]+')
		minus_lines=$(echo "$git_shortstat" | grep -oE '[0-9]+ deletion' | grep -oE '[0-9]+')
		if [[ ${plus_lines} != "" ]]; then
			printf " %s+%s" "$GREEN" "$plus_lines"
		fi
		if [[ ${minus_lines} != "" ]]; then
			printf " %s-%s" "$RED" "$minus_lines"
		fi
		printf "%s" "$YELLOW"
	fi
}

function __modified_files_count()
{
	local git_status
	git_status=$(git status --porcelain 2> /dev/null)
	if [[ -n ${git_status} ]]; then
		printf " | files:"
		# Count all file states in a single awk pass
		local counts
		counts=$(echo "${git_status}" | awk '
			BEGIN { a=0; d=0; m=0; r=0; u=0; q=0 }
			/^A /  { a++ }
			/^ ?D/ { d++ }
			/^ ?M/ { m++ }
			/^R /  { r++ }
			/^UU/  { u++ }
			/^\?\?/ { q++ }
			END { print a, d, m, r, u, q }
		')
		read -r added_files deleted_files modified_files renamed_files unmerged_files untraced_files <<< "$counts"

		[[ $added_files -gt 0 ]] && printf " %s✚%s" "$GREEN" "$added_files"
		[[ $deleted_files -gt 0 ]] && printf " %s✖%s" "$RED" "$deleted_files"
		[[ $modified_files -gt 0 ]] && printf " %s~%s" "$BLUE" "$modified_files"
		[[ $renamed_files -gt 0 ]] && printf " %s➜%s" "$MAGENTA" "$renamed_files"
		[[ $unmerged_files -gt 0 ]] && printf " %s≠%s" "$YELLOW" "$unmerged_files"
		[[ $untraced_files -gt 0 ]] && printf " %s??%s" "$WHITE" "$untraced_files"
		printf "%s" "$YELLOW"
	fi
}

function __git_commit_status()
{
	git_commit_status=$(git status -uno 2> /dev/null | grep -i 'Your branch\|Din gren' | grep -Eo 'by [0-9]+|med [0-9]+|diverged|behind|ahead|efter|före')
	if [[ ${git_commit_status} != "" ]]; then
		printf " | %s" "$VIOLET"
		if [[ $(echo "$git_commit_status" | grep -Eo 'ahead|före') != "" ]]; then
			printf "↑"
			# printf "^"
		elif [[ $(echo "$git_commit_status" | grep -Eo 'behind|efter') != "" ]]; then
			printf "↓"
			# printf "v"
		elif [[ $(echo "$git_commit_status" | grep -Eo 'diverged') != "" ]]; then
			local_remote=$(git status -uno | grep -Eo 'and have [0-9]+ and [0-9]+' | sed -e 's/.\+\([[:digit:]]\+\) and \([[:digit:]]\+\)/\1⬆ \2⬇/')
			# local_remote=$(git status -uno | grep -Eo 'and have [0-9]+ and [0-9]+' | sed -e 's/.\+\([[:digit:]]\+\) and \([[:digit:]]\+\)/\1^ \2v/')
			# local_remote=$(git status -uno | grep -Eo 'and have [0-9]+ and [0-9]+' | sed -e 's/.\+ \([[:digit:]]\+\) and \([[:digit:]]\+\)/\1 \2/')
			printf "(%s)" "$local_remote"
		fi
		number_of_commits=$(echo "$git_commit_status" | grep -Eo '[0-9]+')
		printf "%s%s" "$number_of_commits" "$YELLOW"
	fi
}

function __git_feature_branch_commits()
{
	local current_branch="$1"

	# Get the default branch from origin/HEAD
	local base_branch
	base_branch=$(git rev-parse --abbrev-ref origin/HEAD 2> /dev/null)

	# If origin/HEAD is not set, fall back to common branch names
	if [[ -z $base_branch ]] || [[ $base_branch == "origin/HEAD" ]]; then
		if git show-ref --verify --quiet refs/heads/master; then
			base_branch="master"
		elif git show-ref --verify --quiet refs/heads/main; then
			base_branch="main"
		elif git show-ref --verify --quiet refs/heads/develop; then
			base_branch="develop"
		elif git show-ref --verify --quiet refs/remotes/origin/master; then
			base_branch="origin/master"
		elif git show-ref --verify --quiet refs/remotes/origin/main; then
			base_branch="origin/main"
		elif git show-ref --verify --quiet refs/remotes/origin/develop; then
			base_branch="origin/develop"
		fi
	fi

	# Skip if no base branch found or if on the base branch
	if [[ -z $base_branch ]] || [[ $current_branch == "${base_branch#origin/}" ]]; then
		return
	fi

	# Count commits ahead and behind base branch
	local counts
	counts=$(git rev-list --left-right --count "${base_branch}...HEAD" 2> /dev/null)
	if [[ -n $counts ]]; then
		local commits_behind commits_ahead
		read -r commits_behind commits_ahead <<< "$counts"

		if [[ $commits_ahead -gt 0 ]]; then
			printf " | %s↑%s from %s" "$CYAN" "$commits_ahead" "$base_branch"

			# Warn if also behind (needs rebase)
			if [[ $commits_behind -gt 0 ]]; then
				printf " %s(↓%s, rebase?)%s" "$ORANGE" "$commits_behind" "$YELLOW"
			else
				printf "%s" "$YELLOW"
			fi
		fi
	fi
}

function __git_stash_count()
{
	local git_stash_count
	git_stash_count=$(git rev-list --walk-reflogs --count refs/stash 2> /dev/null || echo 0)
	if [[ ${git_stash_count} -gt 0 ]]; then
		printf " | %sstash: %s%s" "$ORANGE" "$git_stash_count" "$YELLOW"
	fi
}

__prompt_command "$@"

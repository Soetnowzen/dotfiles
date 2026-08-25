#!/bin/bash
# Prompt renderer.
#
# Fast path: source this file once (my.bashrc does), then call __prompt_command;
# the rendered prompt lands in $__PROMPT_OUT without any subshell.
# Legacy path: executing this file still prints the prompt (tcsh uses that).
#
# Design rules for everything below: no external process unless it is the only
# way to get the data, and cache anything that cannot change during the shell's
# lifetime.

# Colors: computed once per shell, not once per prompt.
if [[ -z ${__PROMPT_COLORS_DONE:-} ]]; then
	RED="\\[$(tput setaf 1)\\]"
	GREEN="\\[$(tput setaf 2)\\]"
	YELLOW="\\[$(tput setaf 3)\\]"
	BLUE="\\[$(tput setaf 4)\\]"
	MAGENTA="\\[$(tput setaf 5)\\]"
	CYAN="\\[$(tput setaf 6)\\]"
	WHITE="\\[$(tput setaf 7)\\]"
	ORANGE="\\[$(tput setaf 9)\\]"
	VIOLET="\\[$(tput setaf 13)\\]"
	RESET="\\[$(tput sgr0)\\]"
	__PROMPT_COLORS_DONE=1
fi

# Per-shell facts. None of these can change while the shell lives.
if [[ -z ${__PROMPT_STATIC_DONE:-} ]]; then
	__PROMPT_SSH=""
	if [[ -n ${SSH_CLIENT:-} || -n ${SSH_TTY:-} || -n ${SSH_CONNECTION:-} ]]; then
		__PROMPT_SSH="${MAGENTA}⚡${RESET}"
	fi

	# Container / docker context indicator.
	__PROMPT_DOCKER=""
	if [[ -f /.dockerenv ]]; then
		__PROMPT_DOCKER="${CYAN}🐳${RESET} "
	else
		# Read /proc/1/cgroup with builtins instead of spawning grep.
		if [[ -r /proc/1/cgroup ]]; then
			__prompt_cgroup=$(<"/proc/1/cgroup")
			case $__prompt_cgroup in
			*docker* | *lxc* | *containerd*) __PROMPT_DOCKER="${CYAN}🐳${RESET} " ;;
			esac
			unset -v __prompt_cgroup
		fi
		if [[ -z $__PROMPT_DOCKER ]]; then
			__prompt_ctx="${DOCKER_CONTEXT:-}"
			# `docker context show` is slow (~100ms); only ever run it once, and
			# only when docker actually exists. `type -P` is a builtin.
			if [[ -z $__prompt_ctx && -n $(type -P docker) ]]; then
				__prompt_ctx=$(docker context show 2>/dev/null)
			fi
			if [[ -n $__prompt_ctx && $__prompt_ctx != "default" ]]; then
				__PROMPT_DOCKER="${CYAN}🐳 ${__prompt_ctx}${RESET} "
			fi
			unset -v __prompt_ctx
		fi
	fi

	# Running as root looks identical to a normal shell otherwise.
	__PROMPT_ROOT=""
	((UID == 0)) && __PROMPT_ROOT="${RED}⚠ root${RESET} "

	declare -gA __PROMPT_BASE_BRANCH=()
	__PROMPT_NODE_PATH=""
	__PROMPT_NODE_VER=""
	__PROMPT_STATIC_DONE=1
fi

function __prompt_command()
{
	local EXIT="${1:-0}"
	local dirs_count="${2:-}"
	local stopped_jobs="${3:-0}"
	local running_jobs="${4:-0}"

	local p="["
	local now

	p+="$__PROMPT_SSH"
	p+="$__PROMPT_ROOT"
	__python_venv_indicator
	p+="$__PROMPT_DOCKER"
	__nodejs_indicator

	# Time: builtin strftime, no `date` process.
	printf -v now '%(%H:%M)T' -1
	p+="${CYAN}${now}${RESET} "

	# user@pc
	if [[ $EXIT != 0 ]]; then
		p+="$RED"
	else
		p+="$BLUE"
	fi
	p+="${USER}${RESET}@${BLUE}${HOSTNAME}${RESET} "

	__smart_path_display
	[[ ! -w $PWD ]] && p+=" ${RED}🔒${GREEN}"
	__count_dirs_stack "$dirs_count"
	__count_jobs_stack "$stopped_jobs" "$running_jobs"

	__git_prompt

	if [[ $EXIT != 0 ]]; then
		case $EXIT in
		1) p+=" ${RED}Catchall for general errors (${EXIT}X)${RESET}" ;;
		2) p+=" ${RED}Misuse of shell builtins (${EXIT}X)${RESET}" ;;
		126) p+=" ${RED}Command invoked cannot execute (${EXIT}X)${RESET}" ;;
		127) p+=" ${RED}Command not found (${EXIT}X)${RESET}" ;;
		130) p+=" ${RED}Script terminated by Control-C (${EXIT}X)${RESET}" ;;
		*)
			if ((EXIT > 128 && EXIT < 255)); then
				p+=" ${RED}Fatal error signal n=$((EXIT - 128)) (${EXIT}X)${RESET}"
			else
				p+=" ${RED}X${EXIT}${RESET}"
			fi
			;;
		esac
	fi
	p+="${RESET}]"

	__PROMPT_OUT="$p"
}

function __smart_path_display()
{
	local current_path="$PWD"

	# ~ instead of spelling out $HOME.
	if [[ -n ${HOME:-} && $current_path == "$HOME" ]]; then
		current_path="~"
	elif [[ -n ${HOME:-} && $current_path == "$HOME"/* ]]; then
		current_path="~${current_path#"$HOME"}"
	fi

	# Truncate relative to the terminal width rather than a fixed column count.
	# The rest of the prompt (time, user@host, git) needs room too, so the path
	# gets at most half the line.
	local max=${PROMPT_PATH_MAX:-$((${COLUMNS:-100} / 2))}
	((max < 20)) && max=20

	if [[ $current_path == *"/.worktrees/"* ]]; then
		# <repo>/…/<worktree>, all with parameter expansion.
		local worktree_name="${current_path##*/}"
		local base_path="${current_path%/*}"
		base_path="${base_path%/*}"
		p+="${GREEN}${base_path##*/}/…/${worktree_name}"
	elif ((${#current_path} > max)); then
		__smaller_path "$current_path"
	else
		p+="${GREEN}${current_path}"
	fi
}

# /home/user/some/long/dir -> /h/u/s/dir     ~/some/long/dir -> ~/s/l/dir
function __smaller_path()
{
	local -a parts=()
	local IFS=/
	# Splitting on "/" keeps spaces in directory names intact.
	read -ra parts <<<"$1"
	unset IFS

	local last=$((${#parts[@]} - 1))
	if ((last < 1)); then
		p+="${GREEN}${parts[0]:-/}"
		return 0
	fi
	# parts[0] is "" for an absolute path and "~" for a home-relative one; it is
	# kept verbatim, the middle segments shrink to one character each.
	local i new_path="${parts[0]}"
	for ((i = 1; i < last; i++)); do
		new_path+="/${parts[i]:0:1}"
	done
	p+="${GREEN}${new_path}/${parts[last]}"
	return 0
}

function __python_venv_indicator()
{
	if [[ -n ${VIRTUAL_ENV:-} ]]; then
		p+="${GREEN}🐍 ${VIRTUAL_ENV##*/}${RESET} "
	elif [[ -n ${CONDA_DEFAULT_ENV:-} ]]; then
		p+="${GREEN}🐍 ${CONDA_DEFAULT_ENV}${RESET} "
	fi
}

function __nodejs_indicator()
{
	# Walk up at most 4 levels looking for package.json (builtins only).
	local dir="$PWD" depth=0
	while ((depth < 4)); do
		[[ -f "$dir/package.json" ]] && break
		[[ $dir == "/" || -z $dir ]] && return
		dir="${dir%/*}"
		[[ -z $dir ]] && dir="/"
		((depth++))
	done
	((depth == 4)) && return

	# `node --version` costs a fork, so it is cached and only refreshed when
	# $PATH changes (which is what `nvm use` does).
	if [[ $PATH != "$__PROMPT_NODE_PATH" ]]; then
		__PROMPT_NODE_PATH="$PATH"
		__PROMPT_NODE_VER=""
		if type -P node >/dev/null 2>&1; then
			__PROMPT_NODE_VER=$(node --version 2>/dev/null)
		fi
	fi
	[[ -n $__PROMPT_NODE_VER ]] && p+="${GREEN}⬢${__PROMPT_NODE_VER}${RESET} "
}

function __count_dirs_stack()
{
	local dirs_count="$1"
	[[ -n $dirs_count && $dirs_count != 1 ]] && p+="[${ORANGE}d${dirs_count}${GREEN}]"
	return 0
}

function __count_jobs_stack()
{
	local stopped_jobs="${1:-0}" running_jobs="${2:-0}"
	((stopped_jobs > 0 || running_jobs > 0)) || return 0

	p+="["
	if ((stopped_jobs > 0)); then
		p+="${ORANGE}⏸ ${stopped_jobs}${RESET}"
		((running_jobs > 0)) && p+=" "
	fi
	((running_jobs > 0)) && p+="${VIOLET}▶ ${running_jobs}${RESET}"
	p+="${GREEN}]${RESET}"
	return 0
}

# Locate $GIT_DIR by walking up from $PWD without forking git.
# Sets __git_dir; returns 1 when not inside a repository.
function __find_git_dir()
{
	__git_dir=""
	if [[ -n ${GIT_DIR:-} ]]; then
		__git_dir="$GIT_DIR"
		return 0
	fi
	local dir="$PWD" target
	while :; do
		target="$dir/.git"
		if [[ -d $target ]]; then
			__git_dir="$target"
			return 0
		elif [[ -f $target ]]; then
			# Linked worktree / submodule: "gitdir: <path>"
			local rel
			read -r rel <"$target"
			[[ $rel != "gitdir: "* ]] && return 1
			rel="${rel#gitdir: }"
			[[ -z $rel ]] && return 1
			[[ $rel != /* ]] && rel="$dir/$rel"
			__git_dir="$rel"
			return 0
		fi
		[[ -z $dir ]] && return 1
		dir="${dir%/*}"
		if [[ -z $dir ]]; then
			[[ -d /.git ]] && { __git_dir="/.git"; return 0; }
			return 1
		fi
	done
}

function __git_prompt()
{
	local __git_dir
	__find_git_dir || return 0

	# One porcelain=v2 call replaces: rev-parse HEAD, status --porcelain,
	# status -uno (branch tracking) and rev-list --count refs/stash.
	# `command git` skips the interactive git() wrapper from my.bashrc, which
	# would otherwise fork an extra `git config --get alias.status` per call
	# (and print alias expansions into the prompt).
	local status_out
	status_out=$(command git status --porcelain=v2 --branch --show-stash 2>/dev/null) || return 0

	local line branch="" oid="" upstream="" ahead=0 behind=0 stash=0 ab xy x y
	local added=0 deleted=0 modified=0 renamed=0 unmerged=0 untracked=0
	local worktree_dirty=0
	while IFS= read -r line; do
		case $line in
		'# branch.head '*) branch="${line#\# branch.head }" ;;
		'# branch.oid '*) oid="${line#\# branch.oid }" ;;
		'# branch.upstream '*) upstream="${line#\# branch.upstream }" ;;
		'# branch.ab '*)
			ab="${line#\# branch.ab }"
			ahead="${ab%% *}"
			behind="${ab#* }"
			ahead="${ahead#+}"
			behind="${behind#-}"
			;;
		'# stash '*) stash="${line#\# stash }" ;;
		'? '*) ((untracked++)) ;;
		'u '*) ((unmerged++)) ;;
		'1 '* | '2 '*)
			xy="${line:2:2}"
			x="${xy:0:1}"
			y="${xy:1:1}"
			[[ $x == A || $y == A ]] && ((added++))
			[[ $x == D || $y == D ]] && ((deleted++))
			[[ $x == M || $y == M ]] && ((modified++))
			[[ $x == R || $x == C ]] && ((renamed++))
			# Unstaged line counts can only be non-zero when the worktree side
			# of the status code is dirty; used to skip `git diff --shortstat`.
			[[ $y == M || $y == D ]] && worktree_dirty=1
			;;
		esac
	done <<<"$status_out"

	local detached=0
	if [[ $branch == "(detached)" ]]; then
		branch="${oid:0:7}"
		detached=1
	fi
	[[ -z $branch ]] && return 0

	__count_worktrees "$__git_dir"

	p+="${YELLOW}(${branch}"
	__git_operation_prompt "$__git_dir"
	__git_tag_prompt
	__git_file_counts "$added" "$deleted" "$modified" "$renamed" "$unmerged" "$untracked"
	# `git diff --shortstat` is the most expensive call in the prompt (~70ms in
	# a 1.5k-file repo), and it can only report something when the worktree
	# side of the status output was dirty.
	((worktree_dirty)) && __git_line_counts
	__git_commit_status "$ahead" "$behind" "$upstream" "$detached"
	__git_feature_branch_commits "$__git_dir" "$branch"
	((stash > 0)) && p+=" | ${ORANGE}stash: ${stash}${YELLOW}"
	p+=")${RESET}"
	return 0
}

function __count_worktrees()
{
	local git_dir="$1" common="$1"
	# Linked worktree: .../.git/worktrees/<name>
	[[ $common == */worktrees/* ]] && common="${common%/worktrees/*}"
	local entries=("$common"/worktrees/*/)
	# Unmatched glob leaves the literal pattern behind.
	[[ -d ${entries[0]} ]] || return 0
	local count=$((${#entries[@]} + 1))
	((count > 1)) && p+="[${VIOLET}🌳 ${count}${RESET}]"
	return 0
}

function __git_operation_prompt()
{
	local git_dir="$1" step total
	if [[ -d "$git_dir/rebase-merge" ]]; then
		[[ -r "$git_dir/rebase-merge/msgnum" ]] && read -r step <"$git_dir/rebase-merge/msgnum"
		[[ -r "$git_dir/rebase-merge/end" ]] && read -r total <"$git_dir/rebase-merge/end"
	elif [[ -d "$git_dir/rebase-apply" ]]; then
		[[ -r "$git_dir/rebase-apply/next" ]] && read -r step <"$git_dir/rebase-apply/next"
		[[ -r "$git_dir/rebase-apply/last" ]] && read -r total <"$git_dir/rebase-apply/last"
	elif [[ -f "$git_dir/MERGE_HEAD" ]]; then
		p+=" | ${RED}MERGE${YELLOW}"
		return 0
	elif [[ -f "$git_dir/CHERRY_PICK_HEAD" ]]; then
		p+=" | ${RED}CHERRY-PICK${YELLOW}"
		return 0
	elif [[ -f "$git_dir/REVERT_HEAD" ]]; then
		p+=" | ${RED}REVERT${YELLOW}"
		return 0
	elif [[ -f "$git_dir/BISECT_LOG" ]]; then
		p+=" | ${ORANGE}BISECT${YELLOW}"
		return 0
	else
		return 0
	fi

	if [[ -n $step && -n $total ]]; then
		p+=" | ${RED}REBASE ${step}/${total}${YELLOW}"
	else
		p+=" | ${RED}REBASE${YELLOW}"
	fi
	return 0
}

function __git_tag_prompt()
{
	[[ ${PROMPT_SHOW_TAG:-1} == 1 ]] || return 0
	local git_tag
	git_tag=$(command git tag -l --points-at HEAD 2>/dev/null)
	[[ -n $git_tag ]] && p+=" | ${WHITE}tag: ${git_tag}${YELLOW}"
	return 0
}

function __git_file_counts()
{
	local added="$1" deleted="$2" modified="$3" renamed="$4" unmerged="$5" untracked="$6"
	((added || deleted || modified || renamed || unmerged || untracked)) || return 0

	p+=" | files:"
	((added > 0)) && p+=" ${GREEN}✚${added}"
	((deleted > 0)) && p+=" ${RED}✖${deleted}"
	((modified > 0)) && p+=" ${BLUE}~${modified}"
	((renamed > 0)) && p+=" ${MAGENTA}➜${renamed}"
	((unmerged > 0)) && p+=" ${YELLOW}≠${unmerged}"
	((untracked > 0)) && p+=" ${WHITE}??${untracked}"
	p+="$YELLOW"
	return 0
}

function __git_line_counts()
{
	local shortstat
	shortstat=$(command git diff --shortstat 2>/dev/null)
	[[ -z $shortstat ]] && return 0

	# "1 file changed, 12 insertions(+), 3 deletions(-)" parsed with globs.
	local plus=0 minus=0 rest
	if [[ $shortstat == *" insertion"* ]]; then
		rest="${shortstat%% insertion*}"
		plus="${rest##*, }"
	fi
	if [[ $shortstat == *" deletion"* ]]; then
		rest="${shortstat%% deletion*}"
		minus="${rest##*, }"
	fi
	((plus > 0 || minus > 0)) || return 0

	p+=" | lines:"
	((plus > 0)) && p+=" ${GREEN}+${plus}"
	((minus > 0)) && p+=" ${RED}-${minus}"
	p+="$YELLOW"
	return 0
}

function __git_commit_status()
{
	local ahead="$1" behind="$2" upstream="$3" detached="${4:-0}"

	# A branch with no upstream is exactly the state where a nudge helps: it has
	# never been pushed, so nothing above can tell you how far it has drifted.
	if [[ -z $upstream ]]; then
		((detached)) || p+=" | ${ORANGE}no upstream${YELLOW}"
		return 0
	fi

	((ahead || behind)) || return 0

	p+=" | ${VIOLET}"
	if ((ahead > 0 && behind > 0)); then
		p+="(${ahead}⬆ ${behind}⬇)"
	elif ((ahead > 0)); then
		p+="↑${ahead}"
	else
		p+="↓${behind}"
	fi
	p+="$YELLOW"
	return 0
}

function __git_feature_branch_commits()
{
	local git_dir="$1" current_branch="$2"

	# Base branch discovery is several git calls; cache it per repository.
	local base_branch="${__PROMPT_BASE_BRANCH[$git_dir]-}"
	if [[ -z $base_branch ]]; then
		base_branch=$(command git rev-parse --abbrev-ref origin/HEAD 2>/dev/null)
		if [[ -z $base_branch || $base_branch == "origin/HEAD" ]]; then
			local ref
			for ref in master main develop; do
				if command git show-ref --verify --quiet "refs/heads/$ref"; then
					base_branch="$ref"
					break
				fi
			done
		fi
		if [[ -z $base_branch ]]; then
			local ref
			for ref in master main develop; do
				if command git show-ref --verify --quiet "refs/remotes/origin/$ref"; then
					base_branch="origin/$ref"
					break
				fi
			done
		fi
		# "-" marks "looked, found nothing" so we do not re-probe every prompt.
		__PROMPT_BASE_BRANCH[$git_dir]="${base_branch:--}"
	fi
	[[ -z $base_branch || $base_branch == "-" ]] && return 0
	[[ $current_branch == "${base_branch#origin/}" ]] && return 0

	local counts
	counts=$(command git rev-list --left-right --count "${base_branch}...HEAD" 2>/dev/null)
	[[ -z $counts ]] && return 0

	local commits_behind commits_ahead
	read -r commits_behind commits_ahead <<<"$counts"
	((commits_ahead > 0)) || return 0

	p+=" | ${CYAN}↑${commits_ahead} from ${base_branch}"
	if ((commits_behind > 0)); then
		p+=" ${ORANGE}(↓${commits_behind}, rebase?)${YELLOW}"
	else
		p+="$YELLOW"
	fi
	return 0
}

# Drop the per-shell caches (docker context, node version, base branches).
# Run this after changing a repo's default branch or switching docker context.
function prompt_refresh()
{
	unset -v __PROMPT_STATIC_DONE __PROMPT_SSH __PROMPT_DOCKER __PROMPT_ROOT
	unset -v __PROMPT_NODE_PATH __PROMPT_NODE_VER
	unset -v __PROMPT_BASE_BRANCH
	source "${BASH_SOURCE[0]}"
}

# Executed rather than sourced (tcsh path): render and print.
if [[ ${BASH_SOURCE[0]} == "$0" ]]; then
	__prompt_command "$@"
	printf '%s' "$__PROMPT_OUT"
fi

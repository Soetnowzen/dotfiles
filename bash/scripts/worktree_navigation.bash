# Git worktree navigation and management functions
# Usage: wt [worktree-name] - navigate to worktree or list all
# Usage: wtcode [worktree-name] - open worktree in VS Code

# Smart worktree navigation with tab completion
wt() {
    case $1 in
        ls|list) git worktree list ;;
        '') git worktree list ;;
        *)
            local repo_root=$(git rev-parse --show-toplevel 2>/dev/null)
            if [[ -n $repo_root && -d "$repo_root/.worktrees/$1" ]]; then
                cd "$repo_root/.worktrees/$1"
            else
                echo "Worktree '$1' not found"
                echo "Available worktrees:"
                if [[ -n $repo_root && -d "$repo_root/.worktrees" ]]; then
                    ls "$repo_root/.worktrees" 2>/dev/null | sed 's/^/  /'
                fi
            fi
        ;;
    esac
}

# VS Code integration for worktrees
wtcode() {
    if [[ $# -eq 0 ]]; then
        echo "Usage: wtcode <worktree-name>"
        echo "Available worktrees:"
        local repo_root=$(git rev-parse --show-toplevel 2>/dev/null)
        if [[ -n $repo_root && -d "$repo_root/.worktrees" ]]; then
            ls "$repo_root/.worktrees" 2>/dev/null | sed 's/^/  /'
        fi
        return 1
    fi

    local repo_root=$(git rev-parse --show-toplevel 2>/dev/null)
    if [[ -n $repo_root && -d "$repo_root/.worktrees/$1" ]]; then
        code "$repo_root/.worktrees/$1"
    else
        echo "Worktree '$1' not found"
    fi
}

# Tab completion for worktree names
_wt_completion() {
    local repo_root=$(git rev-parse --show-toplevel 2>/dev/null)
    if [[ -n $repo_root && -d "$repo_root/.worktrees" ]]; then
        COMPREPLY=($(compgen -W "$(ls "$repo_root/.worktrees" 2>/dev/null)" -- "${COMP_WORDS[COMP_CWORD]}"))
    fi
}

# Enable tab completion
complete -F _wt_completion wt
complete -F _wt_completion wtcode
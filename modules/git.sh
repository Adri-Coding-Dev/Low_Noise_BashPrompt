# modules/git.sh - Git repository status detection

lnp::git::update() {
    # Quick check if inside a git work tree
    if ! git rev-parse --is-inside-work-tree &>/dev/null; then
        lnp::git::_clear_context
        return
    fi

    local git_dir
    git_dir="$(git rev-parse --git-dir 2>/dev/null)" || return

    # Build cache key: HEAD ref, index mtime, stash count, special state files existence
    local head_ref index_mtime stash_count state_files_md5 cache_key
    head_ref="$(git rev-parse HEAD 2>/dev/null || echo 'none')"
    index_mtime="$(stat -c %Y "$git_dir/index" 2>/dev/null || echo '0')"
    stash_count="$(git stash list 2>/dev/null | wc -l)"
    state_files_md5="$(ls "$git_dir/MERGE_HEAD" "$git_dir/REBASE_HEAD" "$git_dir/CHERRY_PICK_HEAD" "$git_dir/BISECT_LOG" 2>/dev/null | sort | md5sum | cut -d' ' -f1)"
    cache_key="${head_ref}:${index_mtime}:${stash_count}:${state_files_md5}"

    # If cache matches, restore from cache
    if lnp::cache::validate "git_cache_key" "$cache_key"; then
        lnp::git::_load_from_cache
        return
    fi

    # Full detection
    local branch="" ahead=0 behind=0 staged=0 modified=0 untracked=0 conflicts=0
    local detached=0
    local state=""

    # Branch and upstream info
    local status_output
    status_output="$(git status --porcelain=v1 -b 2>/dev/null)" || status_output=""

    if [[ -z "$status_output" ]]; then
        # Fallback if status fails
        branch="$(git rev-parse --abbrev-ref HEAD 2>/dev/null)"
        if [[ "$branch" == "HEAD" ]]; then
            detached=1
            branch="$(git rev-parse --short HEAD 2>/dev/null)"
        fi
    else
        # Parse the branch line (first line)
        local branch_line
        branch_line="$(echo "$status_output" | head -n1)"

        if [[ "$branch_line" == "## HEAD (no branch)" ]]; then
            detached=1
            branch="$(git rev-parse --short HEAD 2>/dev/null)"
        elif [[ "$branch_line" =~ ^##\ ([^\.]*?)(\.\.\..*)?$ ]]; then
            branch="${BASH_REMATCH[1]}"
            # ahead/behind counts
            if [[ "$branch_line" =~ ahead\ ([0-9]+) ]]; then
                ahead="${BASH_REMATCH[1]}"
            fi
            if [[ "$branch_line" =~ behind\ ([0-9]+) ]]; then
                behind="${BASH_REMATCH[1]}"
            fi
        else
            branch="$(git rev-parse --abbrev-ref HEAD 2>/dev/null)"
            if [[ "$branch" == "HEAD" ]]; then
                detached=1
                branch="$(git rev-parse --short HEAD 2>/dev/null)"
            fi
        fi

        # Parse file statuses (skip first line)
        while IFS= read -r line; do
            [[ -z "$line" ]] && continue
            local xy="${line:0:2}"
            local x="${xy:0:1}"
            local y="${xy:1:1}"

            # Count staged (index not space, not '?', not '!')
            if [[ "$x" != " " && "$x" != "?" && "$x" != "!" ]]; then
                ((staged++))
            fi
            # Count modified (worktree not space, not '?')
            if [[ "$y" != " " && "$y" != "?" ]]; then
                ((modified++))
            fi
            # Untracked
            if [[ "$xy" == "??" ]]; then
                ((untracked++))
            fi
            # Conflicts: standard conflict codes (DD, AU, UD, UA, DU, AA, UU)
            if [[ "$xy" =~ ^(DD|AU|UD|UA|DU|AA|UU)$ ]]; then
                ((conflicts++))
            fi
        done < <(echo "$status_output" | tail -n +2)
    fi

    # Stash count (already computed for cache key, strip spaces)
    stash_count="${stash_count##* }"

    # Special states
    if [[ -f "$git_dir/MERGE_HEAD" ]]; then
        state="merge"
    elif [[ -f "$git_dir/REBASE_HEAD" ]]; then
        state="rebase"
    elif [[ -f "$git_dir/CHERRY_PICK_HEAD" ]]; then
        state="cherry-pick"
    elif [[ -f "$git_dir/BISECT_LOG" ]]; then
        state="bisect"
    fi

    # Store in context
    lnp::git::_set_context "$branch" "$detached" "$ahead" "$behind" "$staged" "$modified" "$untracked" "$conflicts" "$stash_count" "$state"

    # Persist to cache
    lnp::cache::set "git_cache_key" "$cache_key"
    lnp::git::_save_to_cache "$branch" "$detached" "$ahead" "$behind" "$staged" "$modified" "$untracked" "$conflicts" "$stash_count" "$state"
}

lnp::git::_clear_context() {
    LNP_CONTEXT[git_branch]=""
    LNP_CONTEXT[git_detached]="0"
    LNP_CONTEXT[git_ahead]="0"
    LNP_CONTEXT[git_behind]="0"
    LNP_CONTEXT[git_staged]="0"
    LNP_CONTEXT[git_modified]="0"
    LNP_CONTEXT[git_untracked]="0"
    LNP_CONTEXT[git_conflicts]="0"
    LNP_CONTEXT[git_stash]="0"
    LNP_CONTEXT[git_state]=""
    lnp::cache::set "git_cache_key" ""
}

lnp::git::_set_context() {
    local branch=$1 detached=$2 ahead=$3 behind=$4 staged=$5 modified=$6 untracked=$7 conflicts=$8 stash=$9 state=${10}
    LNP_CONTEXT[git_branch]="$branch"
    LNP_CONTEXT[git_detached]="$detached"
    LNP_CONTEXT[git_ahead]="$ahead"
    LNP_CONTEXT[git_behind]="$behind"
    LNP_CONTEXT[git_staged]="$staged"
    LNP_CONTEXT[git_modified]="$modified"
    LNP_CONTEXT[git_untracked]="$untracked"
    LNP_CONTEXT[git_conflicts]="$conflicts"
    LNP_CONTEXT[git_stash]="$stash"
    LNP_CONTEXT[git_state]="$state"
}

lnp::git::_save_to_cache() {
    local branch=$1 detached=$2 ahead=$3 behind=$4 staged=$5 modified=$6 untracked=$7 conflicts=$8 stash=$9 state=${10}
    lnp::cache::set "git_branch" "$branch"
    lnp::cache::set "git_detached" "$detached"
    lnp::cache::set "git_ahead" "$ahead"
    lnp::cache::set "git_behind" "$behind"
    lnp::cache::set "git_staged" "$staged"
    lnp::cache::set "git_modified" "$modified"
    lnp::cache::set "git_untracked" "$untracked"
    lnp::cache::set "git_conflicts" "$conflicts"
    lnp::cache::set "git_stash" "$stash"
    lnp::cache::set "git_state" "$state"
}

lnp::git::_load_from_cache() {
    LNP_CONTEXT[git_branch]="$(lnp::cache::get "git_branch")"
    LNP_CONTEXT[git_detached]="$(lnp::cache::get "git_detached")"
    LNP_CONTEXT[git_ahead]="$(lnp::cache::get "git_ahead")"
    LNP_CONTEXT[git_behind]="$(lnp::cache::get "git_behind")"
    LNP_CONTEXT[git_staged]="$(lnp::cache::get "git_staged")"
    LNP_CONTEXT[git_modified]="$(lnp::cache::get "git_modified")"
    LNP_CONTEXT[git_untracked]="$(lnp::cache::get "git_untracked")"
    LNP_CONTEXT[git_conflicts]="$(lnp::cache::get "git_conflicts")"
    LNP_CONTEXT[git_stash]="$(lnp::cache::get "git_stash")"
    LNP_CONTEXT[git_state]="$(lnp::cache::get "git_state")"
}

# Register module
LNP_MODULES+=("git")

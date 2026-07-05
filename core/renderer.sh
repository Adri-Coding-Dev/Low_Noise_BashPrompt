# core/renderer.sh - Build PS1 from context and theme

lnp::renderer::prompt() {
    local ps1=""
    local sep=" "

    # Identity block
    if [[ "${LNP_SHOW_IDENTITY:-1}" -eq 1 ]]; then
        local identity="${LNP_IDENTITY:-${LNP_CONTEXT[user]}@${LNP_CONTEXT[hostname]}}"
        ps1+="$(lnp::colorize "$LNP_COLOR_IDENTITY" "[${identity}]")"
    fi

    # Project name with language colour
    local project_name="${LNP_CONTEXT[project_name]}"
    if [[ -n "$project_name" ]]; then
        local lang="${LNP_CONTEXT[project_language]:-unknown}"
        local proj_color="${LNP_LANG_COLORS[$lang]}"
        [[ -z "$proj_color" ]] && proj_color="${LNP_LANG_COLORS[unknown]}"
        ps1+="${sep}$(lnp::colorize "$proj_color" "$project_name")"
    else
        if [[ "${LNP_SHOW_DIR_NO_PROJECT:-1}" -eq 1 ]]; then
            ps1+="${sep}$(lnp::colorize "$LNP_COLOR_SEPARATOR" "$(lnp::get_pwd)")"
        fi
    fi

    # Git segment
    local git_branch="${LNP_CONTEXT[git_branch]}"
    if [[ -n "$git_branch" ]]; then
        local git_str
        git_str="$(lnp::renderer::_git_segment)"
        ps1+="${sep}${git_str}"
    fi

    # Runtime segment
    if [[ "${LNP_SHOW_RUNTIMES:-1}" -eq 1 ]]; then
        local runtime_str
        runtime_str="$(lnp::renderer::_runtime_segment)"
        if [[ -n "$runtime_str" ]]; then
            ps1+="${sep}${runtime_str}"
        fi
    fi

    # Prompt symbol
    ps1+="${sep}$(lnp::colorize "$LNP_COLOR_PROMPT_SYMBOL" "$LNP_SYMBOL_PROMPT") "

    PS1="\[${ps1}\]"
}

# Build the git status segment string
lnp::renderer::_git_segment() {
    local branch="${LNP_CONTEXT[git_branch]}"
    local detached="${LNP_CONTEXT[git_detached]}"
    local ahead="${LNP_CONTEXT[git_ahead]}"
    local behind="${LNP_CONTEXT[git_behind]}"
    local staged="${LNP_CONTEXT[git_staged]}"
    local modified="${LNP_CONTEXT[git_modified]}"
    local untracked="${LNP_CONTEXT[git_untracked]}"
    local conflicts="${LNP_CONTEXT[git_conflicts]}"
    local stash="${LNP_CONTEXT[git_stash]}"
    local state="${LNP_CONTEXT[git_state]}"

    local branch_color="$LNP_COLOR_GIT_BRANCH"
    [[ "$detached" == "1" ]] && branch_color="$LNP_COLOR_GIT_DETACHED"

    local gits=""
    gits+="$(lnp::colorize "$branch_color" "$branch")"

    local info_color="$LNP_COLOR_GIT_INFO"
    [[ "$staged" != "0" ]] && gits+=" $(lnp::colorize "$info_color" "${LNP_SYMBOL_GIT_STAGED}${staged}")"
    [[ "$modified" != "0" ]] && gits+=" $(lnp::colorize "$info_color" "${LNP_SYMBOL_GIT_MODIFIED}${modified}")"
    [[ "$untracked" != "0" ]] && gits+=" $(lnp::colorize "$info_color" "${LNP_SYMBOL_GIT_UNTRACKED}${untracked}")"
    [[ "$conflicts" != "0" ]] && gits+=" $(lnp::colorize "$info_color" "${LNP_SYMBOL_GIT_CONFLICT}${conflicts}")"
    [[ "$ahead" != "0" ]] && gits+=" $(lnp::colorize "$info_color" "${LNP_SYMBOL_GIT_AHEAD}${ahead}")"
    [[ "$behind" != "0" ]] && gits+=" $(lnp::colorize "$info_color" "${LNP_SYMBOL_GIT_BEHIND}${behind}")"
    [[ "$stash" != "0" ]] && gits+=" $(lnp::colorize "$info_color" "${LNP_SYMBOL_GIT_STASH}${stash}")"

    local state_symbol=""
    case "$state" in
        merge) state_symbol="$LNP_SYMBOL_GIT_MERGE" ;;
        rebase) state_symbol="$LNP_SYMBOL_GIT_REBASE" ;;
        cherry-pick) state_symbol="$LNP_SYMBOL_GIT_CHERRY" ;;
        bisect) state_symbol="$LNP_SYMBOL_GIT_BISECT" ;;
    esac
    [[ -n "$state_symbol" ]] && gits+=" $(lnp::colorize "$info_color" "$state_symbol")"

    local paren_color="$LNP_COLOR_GIT_PARENTHESES"
    local open="$(lnp::colorize "$paren_color" "(")"
    local close="$(lnp::colorize "$paren_color" ")")"
    echo "${open}${gits}${close}"
}

# Build runtime indicators
lnp::renderer::_runtime_segment() {
    local parts=()

    # Python
    local python_env="${LNP_CONTEXT[python_env]}"
    if [[ -n "$python_env" ]]; then
        parts+=("$(lnp::colorize "$LNP_COLOR_PYTHON" "${LNP_SYMBOL_PYTHON}${python_env}")")
    fi

    # Node
    local node_version="${LNP_CONTEXT[node_version]}"
    if [[ -n "$node_version" ]]; then
        parts+=("$(lnp::colorize "$LNP_COLOR_NODE" "${LNP_SYMBOL_NODE}${node_version}")")
    fi

    # Rust
    local rust_version="${LNP_CONTEXT[rust_version]}"
    if [[ -n "$rust_version" ]]; then
        parts+=("$(lnp::colorize "$LNP_COLOR_RUST" "${LNP_SYMBOL_RUST}${rust_version}")")
    fi

    # Java
    local java_version="${LNP_CONTEXT[java_version]}"
    if [[ -n "$java_version" ]]; then
        parts+=("$(lnp::colorize "$LNP_COLOR_JAVA" "${LNP_SYMBOL_JAVA}${java_version}")")
    fi

    # Docker
    local docker_active="${LNP_CONTEXT[docker_active]}"
    local docker_compose="${LNP_CONTEXT[docker_compose]}"
    if [[ -n "$docker_active" ]]; then
        local docker_icon="$LNP_SYMBOL_DOCKER"
        [[ -n "$docker_compose" ]] && docker_icon+="$LNP_SYMBOL_DOCKER_COMPOSE"
        parts+=("$(lnp::colorize "$LNP_COLOR_DOCKER" "$docker_icon")")
    fi

    # Kubernetes
    local k8s_context="${LNP_CONTEXT[k8s_context]}"
    if [[ -n "$k8s_context" ]]; then
        parts+=("$(lnp::colorize "$LNP_COLOR_KUBERNETES" "${LNP_SYMBOL_KUBERNETES}${k8s_context}")")
    fi

    # Join with spaces
    if [[ ${#parts[@]} -gt 0 ]]; then
        local IFS=" "
        echo "${parts[*]}"
    fi
}

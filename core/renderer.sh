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

    # Future: Git status, runtime, etc.

    # Prompt symbol
    ps1+="${sep}$(lnp::colorize "$LNP_COLOR_PROMPT_SYMBOL" "$LNP_SYMBOL_PROMPT") "

    # Wrap entire string as non-printing for proper line editing
    PS1="\[${ps1}\]"
}

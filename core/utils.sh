# core/utils.sh - Common utility functions

lnp::is_command() {
    command -v "$1" &>/dev/null
}

lnp::get_pwd() {
    local pwd="${PWD/#$HOME/~}"
    echo "$pwd"
}

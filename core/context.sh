# core/context.sh - Global context object (associative array)

declare -A LNP_CONTEXT

lnp::context::init() {
    LNP_CONTEXT=()
    LNP_CONTEXT[user]="$USER"
    LNP_CONTEXT[hostname]="$(hostname -s 2>/dev/null || echo "unknown")"
    LNP_CONTEXT[pwd]="$PWD"
}

lnp::context::set() {
    local key="$1" value="$2"
    LNP_CONTEXT[$key]="$value"
}

lnp::context::get() {
    local key="$1"
    echo "${LNP_CONTEXT[$key]}"
}

# Initialize on source
lnp::context::init

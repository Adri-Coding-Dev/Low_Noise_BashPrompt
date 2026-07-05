# modules/node.sh - Node.js version detection (when in a Node project)

lnp::node::update() {
    # Only show version if we are inside a Node project (has package.json)
    if [[ ! -f "$PWD/package.json" ]]; then
        LNP_CONTEXT[node_version]=""
        return
    fi

    if ! command -v node &>/dev/null; then
        LNP_CONTEXT[node_version]=""
        return
    fi

    local node_bin
    node_bin="$(command -v node)"

    # Cache key: node binary path + current directory
    local cache_key="node_${node_bin}_${PWD}"

    if lnp::cache::validate "$cache_key" "1"; then
        LNP_CONTEXT[node_version]="$(lnp::cache::get "node_version")"
        return
    fi

    local node_version
    node_version="$(node -v 2>/dev/null)"
    # Strip leading 'v' if present
    node_version="${node_version#v}"

    LNP_CONTEXT[node_version]="$node_version"

    lnp::cache::set "$cache_key" "1"
    lnp::cache::set "node_version" "$node_version"
}

LNP_MODULES+=("node")

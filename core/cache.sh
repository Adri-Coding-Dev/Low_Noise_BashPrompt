# core/cache.sh - Simple file-based cache

: "${LNP_CACHE_DIR:=$HOME/.cache/low-noise-prompt}"
mkdir -p "$LNP_CACHE_DIR" 2>/dev/null

lnp::cache::set() {
    local key="$1" value="$2"
    echo "$value" > "$LNP_CACHE_DIR/$key"
}

lnp::cache::get() {
    local key="$1"
    if [[ -f "$LNP_CACHE_DIR/$key" ]]; then
        cat "$LNP_CACHE_DIR/$key"
    fi
}

lnp::cache::validate() {
    local key="$1" expected="$2"
    local cached
    cached=$(lnp::cache::get "$key")
    [[ "$cached" == "$expected" ]]
}

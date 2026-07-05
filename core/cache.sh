# core/cache.sh - Simple file-based cache with safe key encoding

: "${LNP_CACHE_DIR:=$HOME/.cache/low-noise-prompt}"
mkdir -p "$LNP_CACHE_DIR" 2>/dev/null

# Encode a cache key so it can be used as a filename
lnp::__sanitize_key() {
    local key="$1"
    # Replace '%' with '%25' first, then '/' with '%2F'
    key="${key//\%/\%25}"
    key="${key//\//\%2F}"
    echo "$key"
}

lnp::cache::set() {
    local key="$1" value="$2"
    local safe_key
    safe_key="$(lnp::__sanitize_key "$key")"
    echo "$value" > "$LNP_CACHE_DIR/$safe_key"
}

lnp::cache::get() {
    local key="$1"
    local safe_key
    safe_key="$(lnp::__sanitize_key "$key")"
    if [[ -f "$LNP_CACHE_DIR/$safe_key" ]]; then
        cat "$LNP_CACHE_DIR/$safe_key"
    fi
}

lnp::cache::validate() {
    local key="$1" expected="$2"
    local cached
    cached="$(lnp::cache::get "$key")"
    [[ "$cached" == "$expected" ]]
}

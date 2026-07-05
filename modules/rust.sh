# modules/rust.sh - Rust version detection (when Cargo.toml exists)

lnp::rust::update() {
    if [[ ! -f "$PWD/Cargo.toml" ]]; then
        LNP_CONTEXT[rust_version]=""
        return
    fi

    if ! command -v rustc &>/dev/null; then
        LNP_CONTEXT[rust_version]=""
        return
    fi

    local rustc_bin
    rustc_bin="$(command -v rustc)"

    local cache_key="rust_${rustc_bin}_${PWD}"

    if lnp::cache::validate "$cache_key" "1"; then
        LNP_CONTEXT[rust_version]="$(lnp::cache::get "rust_version")"
        return
    fi

    local rust_version
    rust_version="$(rustc --version | awk '{print $2}')"

    LNP_CONTEXT[rust_version]="$rust_version"

    lnp::cache::set "$cache_key" "1"
    lnp::cache::set "rust_version" "$rust_version"
}

LNP_MODULES+=("rust")

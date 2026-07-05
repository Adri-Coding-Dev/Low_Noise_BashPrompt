# modules/kubernetes.sh - Kubernetes context detection

lnp::kubernetes::update() {
    if ! command -v kubectl &>/dev/null; then
        LNP_CONTEXT[k8s_context]=""
        return
    fi

    local kubeconfig="${KUBECONFIG:-$HOME/.kube/config}"

    if [[ ! -f "$kubeconfig" ]]; then
        LNP_CONTEXT[k8s_context]=""
        return
    fi

    local config_mtime
    config_mtime="$(stat -c %Y "$kubeconfig" 2>/dev/null || echo '0')"

    local cache_key="k8s_${config_mtime}"

    if lnp::cache::validate "$cache_key" "1"; then
        LNP_CONTEXT[k8s_context]="$(lnp::cache::get "k8s_context")"
        return
    fi

    local context
    context="$(kubectl config current-context 2>/dev/null)"

    LNP_CONTEXT[k8s_context]="$context"

    lnp::cache::set "$cache_key" "1"
    lnp::cache::set "k8s_context" "$context"
}

LNP_MODULES+=("kubernetes")

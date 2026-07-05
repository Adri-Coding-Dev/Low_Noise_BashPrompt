# modules/docker.sh - Docker & Docker Compose detection (zero-external-process)

lnp::docker::update() {
    # Detect Docker availability by checking if the socket is writable
    local docker_active=""
    if [[ -w /var/run/docker.sock ]]; then
        docker_active="1"
    else
        docker_active=""
    fi

    LNP_CONTEXT[docker_active]="$docker_active"

    # Docker Compose: check if compose file exists in project root
    local compose_file=""
    if [[ -n "${LNP_CONTEXT[project_root]}" ]]; then
        if [[ -f "${LNP_CONTEXT[project_root]}/docker-compose.yml" || -f "${LNP_CONTEXT[project_root]}/compose.yml" ]]; then
            compose_file="1"
        fi
    fi
    LNP_CONTEXT[docker_compose]="$compose_file"
}

LNP_MODULES+=("docker")

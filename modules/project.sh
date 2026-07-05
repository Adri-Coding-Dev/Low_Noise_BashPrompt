# modules/project.sh - Project root and language detection

lnp::project::update() {
    local current_pwd="$PWD"

    # Return cached results if directory hasn't changed
    if lnp::cache::validate "project_pwd" "$current_pwd"; then
        LNP_CONTEXT[project_root]="$(lnp::cache::get "project_root")"
        LNP_CONTEXT[project_name]="$(lnp::cache::get "project_name")"
        LNP_CONTEXT[project_language]="$(lnp::cache::get "project_language")"
        return
    fi

    local dir="$current_pwd"
    local project_root=""

    # Markers that signal a project root (order matters for performance)
    local markers=(
        ".git"
        "Cargo.toml"
        "pom.xml"
        "build.gradle"
        "pyproject.toml"
        "package.json"
        "go.mod"
        "composer.json"
        "CMakeLists.txt"
        "build.zig"
        "pubspec.yaml"
        ".project-root"   # custom override
    )

    # Walk upwards until we find a marker
    while [[ "$dir" != "/" ]]; do
        for marker in "${markers[@]}"; do
            if [[ -e "$dir/$marker" ]]; then
                project_root="$dir"
                break 2
            fi
        done
        dir="$(dirname "$dir")"
    done

    if [[ -z "$project_root" ]]; then
        # No project detected
        LNP_CONTEXT[project_name]=""
        LNP_CONTEXT[project_root]=""
        LNP_CONTEXT[project_language]=""
        lnp::cache::set "project_pwd" "$current_pwd"
        lnp::cache::set "project_root" ""
        lnp::cache::set "project_name" ""
        lnp::cache::set "project_language" ""
        return
    fi

    local project_name
    project_name="$(basename "$project_root")"

    # Detect language based on the first matching marker
    local lang="unknown"
    if [[ -f "$project_root/Cargo.toml" ]]; then
        lang="rust"
    elif [[ -f "$project_root/pom.xml" ]]; then
        lang="java"
    elif [[ -f "$project_root/build.gradle" ]]; then
        lang="java"
    elif [[ -f "$project_root/pyproject.toml" ]]; then
        lang="python"
    elif [[ -f "$project_root/package.json" ]]; then
        lang="node"
    elif [[ -f "$project_root/go.mod" ]]; then
        lang="go"
    elif [[ -f "$project_root/composer.json" ]]; then
        lang="php"
    elif [[ -f "$project_root/CMakeLists.txt" ]]; then
        lang="cpp"
    elif [[ -f "$project_root/build.zig" ]]; then
        lang="zig"
    elif [[ -f "$project_root/pubspec.yaml" ]]; then
        lang="dart"
    fi

    LNP_CONTEXT[project_root]="$project_root"
    LNP_CONTEXT[project_name]="$project_name"
    LNP_CONTEXT[project_language]="$lang"

    # Persist to cache
    lnp::cache::set "project_pwd" "$current_pwd"
    lnp::cache::set "project_root" "$project_root"
    lnp::cache::set "project_name" "$project_name"
    lnp::cache::set "project_language" "$lang"
}

# Register this module
LNP_MODULES+=("project")

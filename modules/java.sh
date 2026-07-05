# modules/java.sh - Java version detection (when pom.xml or build.gradle exists)

lnp::java::update() {
    if [[ ! -f "$PWD/pom.xml" && ! -f "$PWD/build.gradle" ]]; then
        LNP_CONTEXT[java_version]=""
        return
    fi

    if ! command -v java &>/dev/null; then
        LNP_CONTEXT[java_version]=""
        return
    fi

    local java_bin
    java_bin="$(command -v java)"

    local cache_key="java_${java_bin}_${PWD}"

    if lnp::cache::validate "$cache_key" "1"; then
        LNP_CONTEXT[java_version]="$(lnp::cache::get "java_version")"
        return
    fi

    local java_version
    java_version="$(java -version 2>&1 | head -1 | awk -F '"' '{print $2}')"

    LNP_CONTEXT[java_version]="$java_version"

    lnp::cache::set "$cache_key" "1"
    lnp::cache::set "java_version" "$java_version"
}

LNP_MODULES+=("java")

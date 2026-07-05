# modules/python.sh - Python virtual environment detection

lnp::python::update() {
    # No venv / conda at all → clear and return
    if [[ -z "$VIRTUAL_ENV" && -z "$CONDA_DEFAULT_ENV" ]]; then
        LNP_CONTEXT[python_env]=""
        return
    fi

    local venv_name=""

    # Prefer explicit VIRTUAL_ENV (pipenv, venv, virtualenv)
    if [[ -n "$VIRTUAL_ENV" ]]; then
        venv_name="$(basename "$VIRTUAL_ENV")"
    elif [[ -n "$CONDA_DEFAULT_ENV" ]]; then
        venv_name="$CONDA_DEFAULT_ENV"
    fi

    LNP_CONTEXT[python_env]="$venv_name"
}

LNP_MODULES+=("python")

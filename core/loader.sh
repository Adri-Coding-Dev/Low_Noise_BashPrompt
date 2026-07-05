# core/loader.sh - Automatic module and theme loading

_LNP_MODULE_DIR="$LNP_ROOT/modules"
_LNP_THEME_DIR="$LNP_ROOT/themes"

# Load active theme
if [[ -f "$_LNP_THEME_DIR/${LNP_THEME}.sh" ]]; then
    source "$_LNP_THEME_DIR/${LNP_THEME}.sh"
else
    echo "LNP: Theme '${LNP_THEME}' not found" >&2
fi

# Load all modules
LNP_MODULES=()
for _mod_file in "$_LNP_MODULE_DIR"/*.sh; do
    [[ -f "$_mod_file" ]] || continue
    source "$_mod_file"
done
unset _mod_file

# Iterate over registered modules and call their update function
lnp::loader::update_all() {
    local mod
    for mod in "${LNP_MODULES[@]}"; do
        if declare -F "lnp::${mod}::update" &>/dev/null; then
            "lnp::${mod}::update"
        fi
    done
}

#!/usr/bin/env bash
# Low Noise Prompt - Main entry point
# Source this file from .bashrc

# Determine root directory of LNP installation
LNP_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ----------------------------------------------------------------------
# Load core components in dependency order
# ----------------------------------------------------------------------
source "$LNP_ROOT/config.sh"
source "$LNP_ROOT/core/context.sh"
source "$LNP_ROOT/core/utils.sh"
source "$LNP_ROOT/core/cache.sh"
source "$LNP_ROOT/core/colors.sh"
source "$LNP_ROOT/core/loader.sh"
source "$LNP_ROOT/core/renderer.sh"

# ----------------------------------------------------------------------
# Prompt command (called before every prompt)
# ----------------------------------------------------------------------
lnp::prompt_command() {
    # 1. Update context from all registered modules
    lnp::loader::update_all
    # 2. Build PS1 from current context + theme
    lnp::renderer::prompt
}

PROMPT_COMMAND='lnp::prompt_command'

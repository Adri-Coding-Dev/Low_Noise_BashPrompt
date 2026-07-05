# core/colors.sh - ANSI escape code utilities (PS1-safe)

LNP_RESET="\e[0m"

# Return a string with the color sequence wrapped in \[...\] so it is
# properly ignored in prompt length calculations.
lnp::colorize() {
    local color="$1" text="$2"
    # The final format: \[color\]text\[reset\]
    printf "%b" "\[${color}\]${text}\[${LNP_RESET}\]"
}

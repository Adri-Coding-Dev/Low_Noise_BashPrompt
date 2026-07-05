# core/colors.sh - ANSI escape code utilities

LNP_RESET="\e[0m"
LNP_BOLD="\e[1m"
LNP_DIM="\e[2m"
LNP_ITALIC="\e[3m"
LNP_UNDERLINE="\e[4m"

lnp::colorize() {
    local color="$1" text="$2"
    printf "%b" "${color}${text}${LNP_RESET}"
}

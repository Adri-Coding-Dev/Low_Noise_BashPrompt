# themes/default.sh - Default Low Noise theme

# Basic colours
LNP_COLOR_IDENTITY="\e[38;5;39m"      # blue-ish
LNP_COLOR_PROMPT_SYMBOL="\e[38;5;15m" # white
LNP_COLOR_SEPARATOR="\e[38;5;242m"    # grey

# Language → colour mapping
declare -A LNP_LANG_COLORS
LNP_LANG_COLORS[rust]="\e[38;5;202m"   # orange
LNP_LANG_COLORS[java]="\e[38;5;196m"   # red
LNP_LANG_COLORS[python]="\e[38;5;46m"  # green
LNP_LANG_COLORS[go]="\e[38;5;51m"      # cyan
LNP_LANG_COLORS[node]="\e[38;5;118m"   # lime
LNP_LANG_COLORS[csharp]="\e[38;5;127m" # purple
LNP_LANG_COLORS[cpp]="\e[38;5;27m"     # blue
LNP_LANG_COLORS[zig]="\e[38;5;226m"    # yellow
LNP_LANG_COLORS[php]="\e[38;5;99m"     # purple-ish
LNP_LANG_COLORS[dart]="\e[38;5;33m"    # darker blue
LNP_LANG_COLORS[unknown]="\e[38;5;250m" # light grey

# Symbols
LNP_SYMBOL_PROMPT="→"
LNP_SYMBOL_GIT_MODIFIED="~"   # reserve for later

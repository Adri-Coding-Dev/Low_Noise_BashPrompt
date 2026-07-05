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

# Git colours and symbols
LNP_COLOR_GIT_BRANCH="\e[38;5;51m"       # cyan
LNP_COLOR_GIT_DETACHED="\e[38;5;196m"    # red
LNP_COLOR_GIT_PARENTHESES="\e[38;5;242m" # grey
LNP_COLOR_GIT_INFO="\e[38;5;250m"        # light grey for numbers/symbols

LNP_SYMBOL_GIT_STAGED="+"
LNP_SYMBOL_GIT_MODIFIED="~"
LNP_SYMBOL_GIT_UNTRACKED="?"
LNP_SYMBOL_GIT_CONFLICT="!"
LNP_SYMBOL_GIT_AHEAD="↑"
LNP_SYMBOL_GIT_BEHIND="↓"
LNP_SYMBOL_GIT_STASH="⚑"
LNP_SYMBOL_GIT_MERGE="M"
LNP_SYMBOL_GIT_REBASE="R"
LNP_SYMBOL_GIT_CHERRY="C"
LNP_SYMBOL_GIT_BISECT="B"


# Runtime colours
LNP_COLOR_PYTHON="\e[38;5;46m"        # green
LNP_COLOR_NODE="\e[38;5;118m"         # lime
LNP_COLOR_RUST="\e[38;5;202m"         # orange
LNP_COLOR_JAVA="\e[38;5;196m"         # red
LNP_COLOR_DOCKER="\e[38;5;39m"        # blue
LNP_COLOR_KUBERNETES="\e[38;5;63m"    # purple-blue

# Runtime symbols
LNP_SYMBOL_PYTHON="🐍"
LNP_SYMBOL_NODE="⬢"
LNP_SYMBOL_RUST="🦀"
LNP_SYMBOL_JAVA="☕"
LNP_SYMBOL_DOCKER="🐳"
LNP_SYMBOL_DOCKER_COMPOSE="🐙"
LNP_SYMBOL_KUBERNETES="☸️ "

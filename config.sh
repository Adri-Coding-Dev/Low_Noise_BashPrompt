# config.sh - User-configurable settings for Low Noise Prompt

# Theme (must exist as a file in themes/<name>.sh)
LNP_THEME="default"

# Show identity block (0 = hide, 1 = show)
LNP_SHOW_IDENTITY=1

# Custom identity string; leave empty to use user@host
LNP_IDENTITY="Lord Noise|Bash_Hunter"

# When not inside a project, show current directory (0 = hide, 1 = show)
LNP_SHOW_DIR_NO_PROJECT=1

# Cache directory (will be created if missing)
LNP_CACHE_DIR="$HOME/.cache/low-noise-prompt"

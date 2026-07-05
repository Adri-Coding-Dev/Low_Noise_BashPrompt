#!/usr/bin/env bash
# Low Noise Prompt - Installer
# Adds the prompt framework to the user's .bashrc

set -euo pipefail

# ---------- Defaults ----------
LNP_INSTALL_DIR="${HOME}/.low-noise-prompt"
LNP_IDENTITY=""
LNP_THEME="default"
LNP_YES=0

# ---------- Help ----------
usage() {
    cat <<EOF
Usage: $0 [OPTIONS]

Install Low Noise Prompt into your shell.

Options:
  -d, --dir DIR          Installation directory (default: ~/.low-noise-prompt)
  -i, --identity STR     Custom identity string (default: user@host)
  -t, --theme NAME       Theme to use (default: default)
  -y, --yes              Skip confirmation prompts
  -h, --help             Show this help

EOF
    exit 1
}

# ---------- Args ----------
while [[ $# -gt 0 ]]; do
    case "$1" in
        -d|--dir) LNP_INSTALL_DIR="$2"; shift 2 ;;
        -i|--identity) LNP_IDENTITY="$2"; shift 2 ;;
        -t|--theme) LNP_THEME="$2"; shift 2 ;;
        -y|--yes) LNP_YES=1; shift ;;
        -h|--help) usage ;;
        *) echo "Unknown option: $1"; usage ;;
    esac
done

# ---------- Source directory (where install.sh is located) ----------
LNP_SOURCE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ---------- Safety checks ----------
if [[ "$LNP_SOURCE_DIR" == "$LNP_INSTALL_DIR" ]]; then
    echo "Error: source and installation directories are the same." >&2
    echo "Please choose a different installation directory." >&2
    exit 1
fi

if [[ ! -f "$LNP_SOURCE_DIR/prompt.sh" ]]; then
    echo "Error: Cannot find prompt.sh in source directory." >&2
    echo "Run this script from the root of the Low Noise Prompt project." >&2
    exit 1
fi

# ---------- Confirmation ----------
if [[ $LNP_YES -eq 0 ]]; then
    echo "Low Noise Prompt will be installed to: $LNP_INSTALL_DIR"
    echo "Your .bashrc will be modified to source it on every new terminal."
    read -rp "Proceed? [y/N] " confirm
    if [[ "$confirm" != "y" && "$confirm" != "Y" ]]; then
        echo "Installation cancelled."
        exit 0
    fi
fi

# ---------- Create install directory ----------
echo "→ Installing to $LNP_INSTALL_DIR ..."
mkdir -p "$LNP_INSTALL_DIR"

# Copy all files (excluding the install script itself and uninstall)
rsync -a --exclude='install.sh' --exclude='uninstall.sh' --exclude='.git' "$LNP_SOURCE_DIR/" "$LNP_INSTALL_DIR/"

# ---------- Apply custom configuration ----------
if [[ -n "$LNP_IDENTITY" ]]; then
    # Replace the identity in the copied config if user wants a custom one
    sed -i'' -e "s/^LNP_IDENTITY=.*/LNP_IDENTITY=\"$LNP_IDENTITY\"/" "$LNP_INSTALL_DIR/config.sh"
fi
if [[ "$LNP_THEME" != "default" ]]; then
    # Validate theme file exists
    if [[ ! -f "$LNP_INSTALL_DIR/themes/${LNP_THEME}.sh" ]]; then
        echo "Warning: theme '${LNP_THEME}' not found. Keeping 'default'."
    else
        sed -i'' -e "s/^LNP_THEME=.*/LNP_THEME=\"$LNP_THEME\"/" "$LNP_INSTALL_DIR/config.sh"
    fi
fi

# ---------- Modify .bashrc ----------
BASHRC="$HOME/.bashrc"
BACKUP_BASHRC="$HOME/.bashrc.backup.$(date +%Y%m%d%H%M%S)"

# Marker lines used to delimit the LNP block
MARKER_START="# >>> Low Noise Prompt >>>"
MARKER_END="# <<< Low Noise Prompt <<<"
SOURCE_LINE="source \"$LNP_INSTALL_DIR/prompt.sh\""

if [[ -f "$BASHRC" ]]; then
    # Check if already installed
    if grep -qF "$SOURCE_LINE" "$BASHRC"; then
        echo "✓ Low Noise Prompt is already sourced in $BASHRC. No changes made."
    else
        # Backup
        cp "$BASHRC" "$BACKUP_BASHRC"
        echo "→ Backup saved: $BACKUP_BASHRC"

        # Append block
        {
            echo ""
            echo "$MARKER_START"
            echo "# Low Noise Prompt - modular prompt framework"
            echo "$SOURCE_LINE"
            echo "$MARKER_END"
        } >> "$BASHRC"

        echo "✓ Added source line to $BASHRC"
    fi
else
    # .bashrc doesn't exist yet
    echo "→ Creating $BASHRC ..."
    {
        echo "$MARKER_START"
        echo "# Low Noise Prompt - modular prompt framework"
        echo "$SOURCE_LINE"
        echo "$MARKER_END"
    } > "$BASHRC"
    echo "✓ Created $BASHRC with LNP integration."
fi

echo ""
echo "Installation complete."
echo "To start using the new prompt, open a new terminal or run:"
echo "  source ~/.bashrc"

#!/usr/bin/env bash
# Low Noise Prompt - Uninstaller
# Removes the prompt framework from .bashrc and optionally deletes the installation directory.

set -euo pipefail

# ---------- Defaults ----------
LNP_INSTALL_DIR="${HOME}/.low-noise-prompt"
LNP_YES=0
LNP_REMOVE_FILES=0

# ---------- Help ----------
usage() {
    cat <<EOF
Usage: $0 [OPTIONS]

Uninstall Low Noise Prompt from your shell.

Options:
  -d, --dir DIR        Installation directory to remove (default: ~/.low-noise-prompt)
  -y, --yes            Skip confirmation prompts
  -p, --purge          Also delete the installation directory (otherwise only .bashrc is cleaned)
  -h, --help           Show this help

EOF
    exit 1
}

# ---------- Args ----------
while [[ $# -gt 0 ]]; do
    case "$1" in
        -d|--dir) LNP_INSTALL_DIR="$2"; shift 2 ;;
        -y|--yes) LNP_YES=1; shift ;;
        -p|--purge) LNP_REMOVE_FILES=1; shift ;;
        -h|--help) usage ;;
        *) echo "Unknown option: $1"; usage ;;
    esac
done

BASHRC="$HOME/.bashrc"
MARKER_START="# >>> Low Noise Prompt >>>"
MARKER_END="# <<< Low Noise Prompt <<<"

# ---------- Confirmation ----------
if [[ $LNP_YES -eq 0 ]]; then
    if [[ $LNP_REMOVE_FILES -eq 1 ]]; then
        echo "This will remove the LNP block from $BASHRC AND delete the installation directory: $LNP_INSTALL_DIR"
    else
        echo "This will remove the LNP block from $BASHRC (files in $LNP_INSTALL_DIR will be kept)."
    fi
    read -rp "Proceed? [y/N] " confirm
    if [[ "$confirm" != "y" && "$confirm" != "Y" ]]; then
        echo "Uninstall cancelled."
        exit 0
    fi
fi

# ---------- Remove from .bashrc ----------
if [[ -f "$BASHRC" ]]; then
    if grep -qF "$MARKER_START" "$BASHRC"; then
        BACKUP_BASHRC="$HOME/.bashrc.backup.$(date +%Y%m%d%H%M%S)"
        cp "$BASHRC" "$BACKUP_BASHRC"
        echo "→ Backup of .bashrc saved to $BACKUP_BASHRC"

        # Remove everything between (and including) the markers
        sed -i'' -e "/^${MARKER_START//\//\\/}/,/^${MARKER_END//\//\\/}/d" "$BASHRC"

        # Remove any trailing blank lines left at the end (optional)
        sed -i'' -e '${/^$/d;}' "$BASHRC"

        echo "✓ Removed LNP block from $BASHRC"
    else
        echo "✓ No LNP markers found in $BASHRC. Nothing to remove."
    fi
else
    echo "→ $BASHRC does not exist. Skipping."
fi

# ---------- Purge installation directory ----------
if [[ $LNP_REMOVE_FILES -eq 1 ]]; then
    if [[ -d "$LNP_INSTALL_DIR" ]]; then
        echo "→ Deleting $LNP_INSTALL_DIR ..."
        rm -rf "$LNP_INSTALL_DIR"
        echo "✓ Installation directory removed."
    else
        echo "→ $LNP_INSTALL_DIR does not exist. Nothing to delete."
    fi
fi

echo ""
echo "Uninstall complete."
echo "Please restart your terminal or run:"
echo "  source ~/.bashrc"

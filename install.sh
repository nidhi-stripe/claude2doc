#!/usr/bin/env bash
set -euo pipefail

INSTALL_PATH="/usr/local/bin/claude2doc"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "=== claude2doc installer ==="
echo ""

# Check we have write access
if [[ ! -w "$(dirname "$INSTALL_PATH")" ]]; then
    echo "Error: Cannot write to $(dirname "$INSTALL_PATH")." >&2
    echo "Re-run with: sudo ./install.sh" >&2
    exit 1
fi

# Check for claude CLI
if ! command -v claude &>/dev/null; then
    echo "Error: 'claude' CLI is required but not found." >&2
    echo "Install it from: https://claude.ai/claude-code" >&2
    exit 1
fi

echo "claude CLI found: $(which claude)"

# Install
echo "Installing to $INSTALL_PATH ..."
cp "$SCRIPT_DIR/claude2doc.sh" "$INSTALL_PATH"
chmod +x "$INSTALL_PATH"

echo ""
echo "=== Installation complete ==="
echo ""
echo "You can now run 'claude2doc' from anywhere."
echo ""
echo "Before first use, make sure you have:"
echo "  1. Toolshed Google Drive MCP added:"
echo "     claude mcp add --scope=user --transport stdio toolshed_gdrive '\${TOOLSHED_STDIO_SHIM}' google_drive"
echo ""
echo "  2. Toolshed OAuth delegated:"
echo "     https://toolshed.corp.stripe.com/oauth"

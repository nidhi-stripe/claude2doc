#!/usr/bin/env bash
set -euo pipefail

INSTALL_PATH="/usr/local/bin/claude2doc"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "=== claude2doc installer ==="
echo ""

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
echo "Usage: claude2doc"
echo ""
echo "Prerequisites:"
echo "  - claude CLI with Toolshed MCP configured"
echo "  - Toolshed OAuth for private docs: https://toolshed.corp.stripe.com/oauth"

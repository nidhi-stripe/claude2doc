# claude2doc

Paste Claude's markdown output directly into a Google Doc — formatted headers, bold, code blocks and all — without touching the clipboard or browser.

## How it works

```
terminal (paste markdown) → claude CLI → Toolshed API → Google Doc
```

Toolshed's `append_to_google_drive_doc` handles markdown-to-Doc rendering server-side, so formatting is applied correctly every time.

## Setup (one-time)

### 1. Install Claude Code CLI

Follow https://claude.ai/claude-code to install and authenticate.

### 2. Add the Toolshed Google Drive MCP server

```bash
claude mcp add --scope=user --transport stdio toolshed_gdrive '${TOOLSHED_STDIO_SHIM}' google_drive
```

### 3. Delegate OAuth to Toolshed

Visit https://toolshed.corp.stripe.com/oauth and grant Google Drive editing access. This lets Toolshed write to docs on your behalf.

### 4. Install claude2doc

```bash
git clone https://github.com/nidhi-stripe/claude2doc.git
cd claude2doc
sudo ./install.sh
```

This copies `claude2doc` to `/usr/local/bin/`. You need `sudo` because `/usr/local/bin/` is a system directory.

## Usage

### Interactive mode

```bash
claude2doc
```

1. Paste your Claude output
2. Press **Ctrl+D** or type `END` on its own line
3. Paste the Google Doc URL (or just the doc ID)
4. Done — open the doc and see formatted content

### With --doc flag

```bash
claude2doc --doc https://docs.google.com/document/d/1abc123def456/edit
```

Then just paste content and press Ctrl+D.

### Piped input

```bash
echo "## My heading" | claude2doc --doc 1abc123def456
```

## Testing

Quick test to verify everything is wired up:

```bash
printf '## Hello from claude2doc\n\nIf you can read this, **it works!**\nEND\n' | claude2doc --doc <YOUR_DOC_URL>
```

Open the doc — you should see a formatted heading and bold text appended at the bottom.

## Requirements

- Stripe engineer (depends on internal Toolshed MCP)
- `claude` CLI installed and authenticated
- Toolshed Google Drive OAuth delegated
- `TOOLSHED_STDIO_SHIM` env var (set automatically by Stripe dev environment)

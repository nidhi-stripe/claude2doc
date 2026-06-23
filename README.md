# claude2doc

Paste Claude's markdown output directly into a Google Doc — formatted headers, bold, code blocks and all — without touching the clipboard or browser.

## How it works

```
terminal (paste markdown) → claude CLI → Toolshed API → Google Doc
```

Toolshed's `append_to_google_drive_doc` handles markdown-to-Doc rendering server-side, so formatting is applied correctly every time.

## Install

```bash
git clone https://github.com/nidhig/claude2doc.git
cd claude2doc
./install.sh
```

This copies `claude2doc` to `/usr/local/bin/`.

## Prerequisites

- [Claude Code CLI](https://claude.ai/claude-code) installed and authenticated
- Toolshed MCP configured in your Claude CLI
- (For private docs) Toolshed OAuth: https://toolshed.corp.stripe.com/oauth

## Usage

```bash
claude2doc
```

1. Paste your Claude output
2. Press **Ctrl+D** or type `END` on its own line
3. Paste the Google Doc URL (or just the doc ID)
4. Done — open the doc and see formatted content

## Sharing with others

Anyone at Stripe with `claude` CLI and Toolshed MCP can use this:

```bash
git clone https://github.com/nidhig/claude2doc.git
cd claude2doc
./install.sh
```

That's it. No Python, no pip, no dependencies beyond `claude`.

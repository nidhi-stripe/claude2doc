#!/usr/bin/env bash
set -euo pipefail

# Parse arguments
target=""
while [[ $# -gt 0 ]]; do
    case "$1" in
        --doc)
            target="$2"
            shift 2
            ;;
        *)
            echo "Usage: claude2doc [--doc <URL|ID>]" >&2
            exit 1
            ;;
    esac
done

# Read markdown content from stdin
echo "Paste your Claude output below, then press Ctrl+D or type END on its own line:" >&2
echo "---" >&2

content=""
while IFS= read -r line; do
    if [[ "$line" == "END" ]]; then
        break
    fi
    content="${content}${line}"$'\n'
done

if [[ -z "${content// /}" ]]; then
    echo "Error: No content provided." >&2
    exit 1
fi

# Get the target document (if not passed via --doc)
if [[ -z "$target" ]]; then
    echo "---" >&2
    echo "" >&2
    echo "Target Google Doc (paste URL, doc ID, or type 'new'):" >&2
    read -r target </dev/tty

    if [[ -z "$target" ]]; then
        echo "Error: No target provided." >&2
        exit 1
    fi
fi

# Extract doc ID from URL if needed
if [[ "$target" == *"docs.google.com/document/d/"* ]]; then
    doc_id=$(echo "$target" | sed -n 's|.*docs.google.com/document/d/\([^/]*\).*|\1|p')
elif [[ "$target" == "new" ]]; then
    echo "Error: 'new' doc creation is not yet supported. Please provide an existing doc URL or ID." >&2
    exit 1
else
    doc_id="$target"
fi

if [[ -z "$doc_id" ]]; then
    echo "Error: Could not extract document ID." >&2
    exit 1
fi

echo "" >&2
echo "Appending to doc: $doc_id ..." >&2

# Write prompt to a temp file to avoid shell interpretation issues
prompt_file=$(mktemp)
cat > "$prompt_file" <<PROMPT
Use the append_to_google_drive_doc tool to append the following markdown to document ID '$doc_id'. Do not modify the content, append it exactly as-is. Here is the markdown content:

$content
PROMPT

output=$(claude -p --allowedTools 'mcp__toolshed_gdrive__append_to_google_drive_doc' < "$prompt_file" 2>&1)
rm -f "$prompt_file"

if echo "$output" | grep -qi "error\|failed\|permission\|denied"; then
    echo "" >&2
    echo "Error: Append failed." >&2
    echo "$output" >&2
    exit 1
fi

echo "" >&2
echo "Done! Content appended to: https://docs.google.com/document/d/${doc_id}/edit" >&2

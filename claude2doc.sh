#!/usr/bin/env bash
set -euo pipefail

# Read markdown content from stdin
echo "Paste your Claude output below, then press Ctrl+D or type END on its own line:"
echo "---"

content=""
while IFS= read -r line; do
    if [[ "$line" == "END" ]]; then
        break
    fi
    content="${content}${line}"$'\n'
done

# Handle Ctrl+D (EOF) — content is already captured by the loop above

if [[ -z "${content// /}" ]]; then
    echo "Error: No content provided." >&2
    exit 1
fi

# Get the target document
echo "---"
echo ""
echo "Target Google Doc (paste URL, doc ID, or type 'new'):"
read -r target

if [[ -z "$target" ]]; then
    echo "Error: No target provided." >&2
    exit 1
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

echo ""
echo "Appending to doc: $doc_id ..."

# Use claude CLI to call the Toolshed append tool
claude -p --allowedTools 'mcp__toolshed__append_to_google_drive_doc' \
    "Use the append_to_google_drive_doc tool to append the following markdown to document ID '$doc_id'. Do not modify the content, append it exactly as-is. Here is the markdown content:

$content"

echo ""
echo "Done! Content appended to: https://docs.google.com/document/d/${doc_id}/edit"

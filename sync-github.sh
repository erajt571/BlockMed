#!/bin/bash

# BlockMed GitHub Sync Script
echo "🔄 Starting BlockMed GitHub Sync..."

REPO_URL="https://api.github.com/repos/erajt571/BlockMed"
RAW_URL="https://raw.githubusercontent.com/erajt571/BlockMed/main"
WORK_DIR="."
SKIP_PATTERNS="node_modules|\.git|\.env|package-lock.json"

# Function to recursively download files
download_tree() {
    local path="$1"
    local depth="${2:-0}"
    
    if [ $depth -gt 3 ]; then
        return
    fi
    
    echo "📁 Scanning: $path"
    
    local contents=$(curl -s "$REPO_URL/contents/$path")
    
    if echo "$contents" | grep -q "API rate limit"; then
        echo "⚠️  Rate limited. Skipping..."
        return
    fi
    
    echo "$contents" | grep -o '"path":"[^"]*"' | sed 's/"path":"//' | sed 's/"$//' | while read -r item_path; do
        # Skip patterns
        if echo "$item_path" | grep -qE "$SKIP_PATTERNS"; then
            continue
        fi
        
        local type=$(echo "$contents" | grep -A2 "\"path\":\"$item_path\"" | grep '"type"' | head -1 | grep -o '"type":"[^"]*"' | sed 's/"type":"//' | sed 's/"$//')
        
        if [ "$type" = "dir" ]; then
            mkdir -p "$item_path"
            download_tree "$item_path" $((depth + 1))
        elif [ "$type" = "file" ]; then
            local url="$RAW_URL/$item_path"
            echo "⬇️  Downloading: $item_path"
            mkdir -p "$(dirname "$item_path")"
            curl -s "$url" -o "$item_path" 2>/dev/null || echo "❌ Failed: $item_path"
        fi
    done
}

echo "Starting download..."
download_tree ""

echo "✅ Sync complete!"

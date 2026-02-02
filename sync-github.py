#!/usr/bin/env python3
import os
import json
import urllib.request
import urllib.error
from pathlib import Path
from urllib.parse import urljoin

# GitHub API URL
REPO_URL = "https://api.github.com/repos/erajt571/BlockMed"
RAW_URL = "https://raw.githubusercontent.com/erajt571/BlockMed/main"
LOCAL_DIR = "."

def get_repo_contents(path=""):
    """Fetch repository contents recursively"""
    try:
        url = f"{REPO_URL}/contents/{path}"
        headers = {'Accept': 'application/vnd.github.v3+json'}
        req = urllib.request.Request(url, headers=headers)
        
        with urllib.request.urlopen(req) as response:
            return json.loads(response.read().decode())
    except Exception as e:
        print(f"❌ Error fetching {path}: {e}")
        return []

def download_file(file_path, content_url):
    """Download a single file from GitHub"""
    try:
        local_file = os.path.join(LOCAL_DIR, file_path)
        
        # Skip certain files
        if any(skip in file_path for skip in ['.git', 'node_modules', '.env', '.DS_Store']):
            return False
            
        os.makedirs(os.path.dirname(local_file), exist_ok=True)
        
        req = urllib.request.Request(content_url, headers={'Accept': 'application/vnd.github.v3.raw'})
        with urllib.request.urlopen(req) as response:
            with open(local_file, 'wb') as out_file:
                out_file.write(response.read())
        
        print(f"✅ Downloaded: {file_path}")
        return True
    except Exception as e:
        print(f"❌ Failed to download {file_path}: {e}")
        return False

def sync_repo(path=""):
    """Recursively sync all files from GitHub repo"""
    contents = get_repo_contents(path)
    
    if not isinstance(contents, list):
        print(f"Error: Expected list, got {type(contents)}")
        return
    
    for item in contents:
        item_path = item.get('path', '')
        item_type = item.get('type', '')
        
        print(f"Processing: {item_path} ({item_type})")
        
        if item_type == "dir":
            # Recursively sync subdirectories
            sync_repo(item_path)
        elif item_type == "file":
            download_file(item_path, item.get('download_url', ''))

if __name__ == "__main__":
    print("🔄 Starting GitHub sync...\n")
    sync_repo()
    print("\n✅ Sync complete!")

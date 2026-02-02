#!/usr/bin/env node

/**
 * BlockMed GitHub Sync Tool
 * Syncs all files from GitHub repository: https://github.com/erajt571/BlockMed
 */

const fs = require('fs');
const path = require('path');
const https = require('https');

const REPO_OWNER = 'erajt571';
const REPO_NAME = 'BlockMed';
const BRANCH = 'main';
const API_URL = `https://api.github.com/repos/${REPO_OWNER}/${REPO_NAME}/contents`;
const RAW_URL = `https://raw.githubusercontent.com/${REPO_OWNER}/${REPO_NAME}/${BRANCH}`;

// Files/patterns to skip
const SKIP_PATTERNS = [
  'node_modules',
  '.git',
  '.env',
  'package-lock.json',
  '.DS_Store',
  'dist',
  'build'
];

function shouldSkip(filePath) {
  return SKIP_PATTERNS.some(pattern => filePath.includes(pattern));
}

function httpsGet(url) {
  return new Promise((resolve, reject) => {
    https.get(url, {
      headers: { 'User-Agent': 'BlockMed-Sync-Tool' }
    }, (res) => {
      let data = '';
      res.on('data', chunk => data += chunk);
      res.on('end', () => resolve(data));
    }).on('error', reject);
  });
}

function httpsGetBinary(url) {
  return new Promise((resolve, reject) => {
    https.get(url, {
      headers: { 'User-Agent': 'BlockMed-Sync-Tool' }
    }, (res) => {
      let data = Buffer.alloc(0);
      res.on('data', chunk => data = Buffer.concat([data, chunk]));
      res.on('end', () => resolve(data));
    }).on('error', reject);
  });
}

async function downloadFile(filePath, downloadUrl) {
  try {
    if (shouldSkip(filePath)) {
      console.log(`⏭️  Skipped: ${filePath}`);
      return;
    }

    const localPath = path.join(process.cwd(), filePath);
    const dir = path.dirname(localPath);

    // Create directory if it doesn't exist
    if (!fs.existsSync(dir)) {
      fs.mkdirSync(dir, { recursive: true });
    }

    console.log(`⬇️  Downloading: ${filePath}`);
    const fileContent = await httpsGetBinary(downloadUrl);
    fs.writeFileSync(localPath, fileContent);
    console.log(`✅ Downloaded: ${filePath}`);
  } catch (error) {
    console.error(`❌ Error downloading ${filePath}:`, error.message);
  }
}

async function fetchContents(path = '') {
  try {
    const url = path ? `${API_URL}/${path}` : API_URL;
    console.log(`📁 Fetching: ${url}`);
    const response = await httpsGet(url);
    return JSON.parse(response);
  } catch (error) {
    console.error(`❌ Error fetching ${path}:`, error.message);
    return [];
  }
}

async function syncDirectory(dirPath = '', depth = 0) {
  if (depth > 4) return; // Limit recursion depth

  const contents = await fetchContents(dirPath);
  
  if (!Array.isArray(contents)) {
    console.error('❌ Invalid response, expected array');
    return;
  }

  for (const item of contents) {
    const itemPath = item.path;

    if (shouldSkip(itemPath)) {
      console.log(`⏭️  Skipped: ${itemPath}`);
      continue;
    }

    if (item.type === 'dir') {
      console.log(`📂 ${itemPath}/`);
      await syncDirectory(itemPath, depth + 1);
    } else if (item.type === 'file') {
      await downloadFile(itemPath, item.download_url);
    }
  }
}

async function main() {
  console.log('🔄 BlockMed GitHub Sync Tool');
  console.log('================================');
  console.log(`Repository: ${REPO_OWNER}/${REPO_NAME}`);
  console.log(`Branch: ${BRANCH}`);
  console.log(`Target: ${process.cwd()}`);
  console.log('================================\n');

  try {
    await syncDirectory();
    console.log('\n✅ Sync Complete!');
  } catch (error) {
    console.error('\n❌ Sync Failed:', error);
    process.exit(1);
  }
}

main();

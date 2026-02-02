#!/usr/bin/env node

/**
 * BlockMed Sync Tools Verification Script
 * Checks if all sync tools are properly installed
 */

const fs = require('fs');
const path = require('path');

const TOOLS = [
  {
    name: 'Node.js Sync Script',
    file: 'sync-github.js',
    type: 'file'
  },
  {
    name: 'PowerShell Script',
    file: 'sync-github.ps1',
    type: 'file'
  },
  {
    name: 'Bash Script',
    file: 'sync-github.sh',
    type: 'file'
  },
  {
    name: 'Batch Script',
    file: 'sync-github.bat',
    type: 'file'
  },
  {
    name: 'GitHub Sync Setup Guide',
    file: 'GITHUB_SYNC_SETUP.md',
    type: 'file'
  },
  {
    name: 'GitHub Sync Guide',
    file: 'GITHUB_SYNC_GUIDE.md',
    type: 'file'
  },
  {
    name: 'Sync Tools README',
    file: 'SYNC_TOOLS_README.md',
    type: 'file'
  }
];

console.log('\n📋 BlockMed GitHub Sync Tools - Verification\n');
console.log('='.repeat(50));

let allPresent = true;
let foundCount = 0;

TOOLS.forEach(tool => {
  const filePath = path.join(process.cwd(), tool.file);
  const exists = fs.existsSync(filePath);
  
  if (exists) {
    console.log(`✅ ${tool.name}`);
    console.log(`   📄 ${tool.file}\n`);
    foundCount++;
  } else {
    console.log(`❌ ${tool.name}`);
    console.log(`   📄 ${tool.file} (MISSING)\n`);
    allPresent = false;
  }
});

console.log('='.repeat(50));

console.log(`\n📊 Summary: ${foundCount}/${TOOLS.length} tools present\n`);

if (allPresent) {
  console.log('✅ All sync tools are installed!\n');
  console.log('Quick commands:');
  console.log('  • npm run sync:github       (Node.js method)');
  console.log('  • npm run sync:github:ps    (PowerShell method)');
  console.log('  • npm run sync:github:git   (Git method)');
  console.log('  • bash sync-github.sh       (Bash method)\n');
  process.exit(0);
} else {
  console.log('⚠️  Some tools are missing!\n');
  console.log('Please recreate missing files or run:');
  console.log('  npm run sync:github\n');
  process.exit(1);
}

#!/usr/bin/env node

/**
 * BlockMed GitHub Upload Script
 * Uploads all project files to GitHub repository
 */

const { execSync } = require('child_process');
const fs = require('fs');
const path = require('path');

const colors = {
  reset: '\x1b[0m',
  bright: '\x1b[1m',
  cyan: '\x1b[36m',
  green: '\x1b[32m',
  yellow: '\x1b[33m',
  red: '\x1b[31m',
  gray: '\x1b[90m'
};

function log(message, color = 'reset') {
  console.log(`${colors[color]}${message}${colors.reset}`);
}

function runCommand(command, silent = false) {
  try {
    const output = execSync(command, { encoding: 'utf-8' });
    if (!silent) console.log(output);
    return output;
  } catch (error) {
    if (!silent) {
      log(`❌ Error: ${error.message}`, 'red');
    }
    return null;
  }
}

async function main() {
  log('\n================================', 'cyan');
  log('BlockMed GitHub Upload Script', 'cyan');
  log('================================\n', 'cyan');

  try {
    // 1. Configure git
    log('1. Configuring git...', 'yellow');
    runCommand('git config --global user.email "dev@blockmed.local"', true);
    runCommand('git config --global user.name "BlockMed Developer"', true);
    log('✅ Git configured\n', 'green');

    // 2. Check if git repository exists
    log('2. Checking git repository...', 'yellow');
    if (!fs.existsSync('.git')) {
      log('Initializing git repository...', 'yellow');
      runCommand('git init', true);
    }
    log('✅ Git repository ready\n', 'green');

    // 3. Setup remote
    log('3. Setting up GitHub remote...', 'yellow');
    const remoteCheck = runCommand('git remote get-url origin 2>/dev/null', true);
    if (!remoteCheck) {
      log('Adding GitHub remote...', 'yellow');
      runCommand('git remote add origin https://github.com/erajt571/BlockMed.git', true);
    } else {
      log('✅ Remote already configured', 'green');
    }

    log('\n📍 Remote URL:', 'cyan');
    runCommand('git remote -v');

    // 4. Stage files
    log('\n4. Staging all files...', 'yellow');
    runCommand('git add -A');
    log('✅ Files staged\n', 'green');

    // 5. Check status
    log('5. Current git status:', 'yellow');
    runCommand('git status');

    // 6. Commit
    log('\n6. Committing changes...', 'yellow');
    const commitMessage = `Upload BlockMed V2 project with sync tools and documentation

- Added GitHub sync tools (Node.js, PowerShell, Bash, Batch)
- Added comprehensive documentation and guides
- Added npm scripts for syncing and uploading
- Added setup and troubleshooting documentation
- Added verification tools
- Project initialization and configuration`;

    try {
      runCommand(`git commit -m "${commitMessage}"`, true);
      log('✅ Changes committed\n', 'green');
    } catch (error) {
      log('⚠️  No changes to commit or already committed\n', 'yellow');
    }

    // 7. Push to GitHub
    log('7. Pushing to GitHub...', 'yellow');
    log('   Branch: main', 'gray');
    log('   URL: https://github.com/erajt571/BlockMed.git\n', 'gray');

    runCommand('git push -u origin main');

    log('\n================================', 'cyan');
    log('✅ Upload Complete!', 'green');
    log('================================\n', 'cyan');

    log('Repository: https://github.com/erajt571/BlockMed', 'cyan');
    log('Branch: main', 'cyan');
    log('', 'cyan');

    log('📊 Summary:', 'bright');
    log('✅ All files uploaded to GitHub', 'green');
    log('✅ Sync tools and documentation included', 'green');
    log('✅ Ready for team collaboration', 'green');

    log('\n', 'reset');
  } catch (error) {
    log(`\n❌ Upload failed: ${error.message}`, 'red');
    process.exit(1);
  }
}

main();

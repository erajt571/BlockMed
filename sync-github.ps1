# BlockMed GitHub Sync - PowerShell Script
# Syncs all files from https://github.com/erajt571/BlockMed

param(
    [string]$Branch = "main",
    [switch]$Force = $false
)

$RepoOwner = "erajt571"
$RepoName = "BlockMed"
$ApiUrl = "https://api.github.com/repos/$RepoOwner/$RepoName/contents"
$RawUrl = "https://raw.githubusercontent.com/$RepoOwner/$RepoName/$Branch"

# Patterns to skip
$SkipPatterns = @(
    "node_modules",
    ".git",
    ".env",
    "package-lock.json",
    ".DS_Store",
    "dist",
    "build",
    ".next"
)

function Should-Skip {
    param([string]$Path)
    
    foreach ($pattern in $SkipPatterns) {
        if ($Path -like "*$pattern*") {
            return $true
        }
    }
    return $false
}

function Download-File {
    param(
        [string]$FilePath,
        [string]$Url
    )
    
    try {
        $LocalPath = Join-Path (Get-Location) $FilePath
        $Directory = Split-Path $LocalPath
        
        if (!(Test-Path $Directory)) {
            New-Item -ItemType Directory -Path $Directory -Force | Out-Null
        }
        
        Write-Host "⬇️  Downloading: $FilePath" -ForegroundColor Cyan
        
        $Response = Invoke-WebRequest -Uri $Url -UseBasicParsing
        [System.IO.File]::WriteAllBytes($LocalPath, $Response.Content)
        
        Write-Host "✅ Downloaded: $FilePath" -ForegroundColor Green
        return $true
    }
    catch {
        Write-Host "❌ Error downloading $FilePath : $_" -ForegroundColor Red
        return $false
    }
}

function Fetch-Contents {
    param([string]$Path = "")
    
    try {
        $Url = if ($Path) { "$ApiUrl/$Path" } else { $ApiUrl }
        Write-Host "📁 Fetching: $Url" -ForegroundColor Gray
        
        $Response = Invoke-RestMethod -Uri $Url -UseBasicParsing
        return $Response
    }
    catch {
        Write-Host "❌ Error fetching $Path : $_" -ForegroundColor Red
        return @()
    }
}

function Sync-Directory {
    param(
        [string]$DirPath = "",
        [int]$Depth = 0
    )
    
    if ($Depth -gt 4) {
        Write-Host "⚠️  Maximum recursion depth reached" -ForegroundColor Yellow
        return
    }
    
    $Contents = Fetch-Contents $DirPath
    
    if ($null -eq $Contents -or $Contents.Count -eq 0) {
        return
    }
    
    foreach ($Item in $Contents) {
        $ItemPath = $Item.path
        
        if (Should-Skip $ItemPath) {
            Write-Host "⏭️  Skipped: $ItemPath" -ForegroundColor DarkGray
            continue
        }
        
        if ($Item.type -eq "dir") {
            Write-Host "📂 $ItemPath/" -ForegroundColor Magenta
            Sync-Directory $ItemPath ($Depth + 1)
        }
        elseif ($Item.type -eq "file") {
            Download-File $ItemPath $Item.download_url
        }
    }
}

# Main execution
Write-Host ""
Write-Host "🔄 BlockMed GitHub Sync Tool" -ForegroundColor Cyan
Write-Host "================================" -ForegroundColor Cyan
Write-Host "Repository: $RepoOwner/$RepoName" -ForegroundColor White
Write-Host "Branch: $Branch" -ForegroundColor White
Write-Host "Target: $(Get-Location)" -ForegroundColor White
Write-Host "================================" -ForegroundColor Cyan
Write-Host ""

if (!$Force) {
    $Confirm = Read-Host "Continue with sync? (y/n)"
    if ($Confirm -ne "y") {
        Write-Host "Cancelled." -ForegroundColor Yellow
        exit
    }
}

Write-Host ""
Sync-Directory
Write-Host ""
Write-Host "✅ Sync Complete!" -ForegroundColor Green
Write-Host ""

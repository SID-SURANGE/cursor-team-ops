# sync-project.ps1 — copy team rules and skills into a repo's .cursor/ for Settings UI visibility
# Usage: .\sync-project.ps1 [repo-path]
# Defaults to current directory. Safe to re-run.

param(
    [string]$RepoDir = (Get-Location).Path
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$KitDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
$RepoDir = (Resolve-Path $RepoDir).Path

Write-Host "Syncing team kit rules and skills into: $RepoDir"
Write-Host ""

$rulesDst = Join-Path $RepoDir ".cursor\rules"
$skillsDst = Join-Path $RepoDir ".cursor\skills"
New-Item -ItemType Directory -Force -Path $rulesDst, $skillsDst | Out-Null

Get-ChildItem (Join-Path $KitDir "rules") -Filter "*.mdc" | ForEach-Object {
    Copy-Item $_.FullName (Join-Path $rulesDst $_.Name) -Force
    Write-Host "  [rule]  $($_.Name)"
}

foreach ($tier in @("core", "community")) {
    $tierPath = Join-Path $KitDir "skills\$tier"
    if (-not (Test-Path $tierPath)) { continue }
    Get-ChildItem $tierPath -Directory | ForEach-Object {
        $target = Join-Path $skillsDst $_.Name
        if (Test-Path $target) { Remove-Item $target -Recurse -Force }
        Copy-Item $_.FullName $target -Recurse -Force
        Write-Host "  [skill] $($_.Name)"
    }
}

Write-Host ""
Write-Host "Done. Reload Cursor (Developer: Reload Window) and check Settings → Rules, Commands"
Write-Host "with the project tab selected."

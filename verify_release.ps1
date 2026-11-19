# Verify an IRIS release: the signature on SHA256SUMS, then every download against SHA256SUMS.
# Usage: .\verify_release.ps1 [-Dir <folder>] [-PublicKey <file>]
#   -Dir        the folder holding your downloads plus SHA256SUMS and SHA256SUMS.minisig (default: current folder)
#   -PublicKey  default: iris-release.pub next to this script
# Needs minisign.exe on PATH (https://jedisct1.github.io/minisign/). Exit code 0 only if the signature is valid AND at
# least one download was found AND every one found matches.
param(
    [string]$Dir = '.',
    [string]$PublicKey = (Join-Path $PSScriptRoot 'iris-release.pub')
)
$ErrorActionPreference = 'Stop'

function Fail([string]$m) { [Console]::Error.WriteLine("VERIFY FAILED: $m"); exit 1 }

if (-not (Test-Path -LiteralPath $PublicKey -PathType Leaf)) { Fail "public key file not found: $PublicKey" }
if ((Get-Content -LiteralPath $PublicKey -TotalCount 1) -like 'PLACEHOLDER*') {
    Fail "$PublicKey is still the placeholder: the release key has not been published yet. Do not trust this release."
}
if (-not (Get-Command minisign -ErrorAction SilentlyContinue)) { Fail 'minisign.exe is not on PATH (https://jedisct1.github.io/minisign/)' }
$sums = Join-Path $Dir 'SHA256SUMS'
$sig = Join-Path $Dir 'SHA256SUMS.minisig'
if (-not (Test-Path -LiteralPath $sums)) { Fail "$sums not found" }
if (-not (Test-Path -LiteralPath $sig)) { Fail "$sig not found: this release is not signed" }

& minisign -Vm $sums -p $PublicKey -x $sig
if ($LASTEXITCODE -ne 0) { Fail 'the signature on SHA256SUMS is NOT valid' }
Write-Host 'signature on SHA256SUMS: valid'

$checked = 0; $bad = 0
foreach ($line in Get-Content -LiteralPath $sums) {
    if ($line -notmatch '^([0-9a-fA-F]{64}) [ *](.+)$') { continue }
    $want = $Matches[1].ToLower(); $name = $Matches[2]
    $file = Join-Path $Dir $name
    if (Test-Path -LiteralPath $file -PathType Leaf) {
        $got = (Get-FileHash -LiteralPath $file -Algorithm SHA256).Hash.ToLower()
        if ($got -eq $want) { Write-Host "OK      $name"; $checked++ }
        else { [Console]::Error.WriteLine("MISMATCH $name"); $bad++ }
    }
}
if ($bad -gt 0) { Fail "$bad file(s) do not match SHA256SUMS: do not install them" }
if ($checked -eq 0) { Fail "none of the files listed in SHA256SUMS is in $Dir" }
Write-Host "verified: $checked file(s) match a correctly signed SHA256SUMS"

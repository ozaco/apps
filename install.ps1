# Written by the ozaco release tool, from the release this file names.
# Do not edit it here: the next release run overwrites every change.
$ErrorActionPreference = "Stop"
$ProgressPreference = "SilentlyContinue"

$version = "0.0.2"

$arch = switch ($env:PROCESSOR_ARCHITECTURE) {
  "AMD64" { "x64" }
  "ARM64" { "arm64" }
  default { throw "ozc: no ozc is built for $env:PROCESSOR_ARCHITECTURE" }
}
$sha256 = @{ x64 = "269b273edf33cb710689f4e0f53aec8355672d7b372a0547d52f50239b161341"; arm64 = "6968f3f511c7f5dea212c49a2d5ad392f870329fffe1a90c67326ae9257acebb" }[$arch]

if (-not $sha256) {
  throw "ozc: ozc $version was not released for win32-$arch"
}

$archive = "ozc-$version-win32-$arch.tar.gz"
$base = if ($env:OZC_DOWNLOAD_BASE) { $env:OZC_DOWNLOAD_BASE } else { "https://github.com/ozaco/apps/releases/download" }
$bin = if ($env:OZC_BIN_DIR) { $env:OZC_BIN_DIR } else { Join-Path $HOME ".local\bin" }
$work = Join-Path ([IO.Path]::GetTempPath()) ("ozc-" + [Guid]::NewGuid().ToString("N"))

New-Item -ItemType Directory -Path $work | Out-Null

try {
  Write-Host "ozc $version for win32-$arch"
  Invoke-WebRequest -UseBasicParsing -Uri "$base/ozc-v$version/$archive" -OutFile (Join-Path $work $archive)

  $have = (Get-FileHash -Algorithm SHA256 (Join-Path $work $archive)).Hash.ToLower()

  if ($have -ne $sha256) {
    throw "ozc: $archive is not the file that was released (its sha256 is $have)"
  }

  & (Join-Path $env:SystemRoot "System32\tar.exe") -xzf (Join-Path $work $archive) -C $work

  if ($LASTEXITCODE -ne 0) {
    throw "ozc: $archive could not be unpacked"
  }

  New-Item -ItemType Directory -Force -Path $bin | Out-Null

  $target = Join-Path $bin "ozc.exe"
  $aside = "$target.old"

  if (Test-Path $target) {
    Remove-Item -Force $aside -ErrorAction SilentlyContinue
    Move-Item -Force $target $aside
  }

  Copy-Item (Join-Path $work "bin\ozc.exe") $target
  Remove-Item -Force $aside -ErrorAction SilentlyContinue
  Write-Host "installed $target"

  if (-not $env:OZC_BIN_DIR) {
    $listed = @([Environment]::GetEnvironmentVariable("Path", "User") -split ";" | Where-Object { $_ })
    $missing = @(@($bin, (Join-Path $HOME ".ozaco\bin")) | Where-Object { $listed -notcontains $_ })

    if ($missing.Count -gt 0) {
      [Environment]::SetEnvironmentVariable("Path", (($listed + $missing) -join ";"), "User")
      Write-Host "added to your Path: $($missing -join ', ') - open a new terminal to run ozc"
    }
  }
} finally {
  Remove-Item -Recurse -Force $work -ErrorAction SilentlyContinue
}

function TestFiles {
    param(
        [Parameter(Mandatory, Position=0)]
        [string]$targetDir,

        [Parameter(Mandatory, Position=1)]
        [string[]]$files
    )

    foreach ($file in $files) {
        $path = Join-Path $targetDir $file
        $existed = Test-Path $path
        if ($existed) {
            "$path already exists! Remove it before installation or run with option '-f'." | Out-Host
            exit 1
        }
    }
}

function RemoveFiles {
    param(
        [Parameter(Mandatory, Position=0)]
        [string]$targetDir,

        [Parameter(Mandatory, Position=1)]
        [string[]]$files
    )

    foreach ($file in $files) {
        $path = Join-Path $targetDir $file
        $existed = Test-Path $path
        if ($existed) {
            "Removing $path" | Out-Host
            Remove-Item $path -Force -Recurse
        }
    }
}

function CopyFiles {
    param(
        [Parameter(Mandatory, Position=0)]
        [string]$targetDir,

        [Parameter(Mandatory, Position=1)]
        [string]$SourceDir,

        [Parameter(Mandatory, Position=2)]
        $fileMap
    )

    foreach ($kvp in $fileMap.GetEnumerator()) {
        $tarFile = $kvp.Key
        $srcFile = $kvp.Value
        $tarPath = Join-Path $targetDir $tarFile
        $srcPath = Join-Path $SourceDir $srcFile
        "Installing $tarPath" | Out-Host
        Copy-Item $srcPath $tarPath -Recurse
    }
}


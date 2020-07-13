# FastDL Builder Script 
# Author: Azzen <github.com/azzen>
# Date 2020-07-13 10:49:51
# Purpose: compresses a directory recursively
#          using bzip2 and creates a lua download enforcer 
# Dependencies : 7zip
#                Powershell >= 7.0.2

$files = Get-ChildItem -Path .\ -Recurse -File -Name -Exclude "*.lua", "*.ps1", "*.bz2"
$outPath = ".\compressed"

$cmd = "C:\Program Files\7-Zip\7z.exe"

$date = Get-Date -Format "dddd yyyy.MM.dd HH:mm K"

$extensions = ".vvd", ".vtx", ".phy"

Write-Host "Creating fastdl.lua..." -ForegroundColor DarkMagenta
Write-Output "-- File created using FastDL Builder script by Azzen <github.com/azzen>" | Out-File -FilePath .\fastdl.lua
Write-Output "-- Last update $date" | Out-File -Append -FilePath .\fastdl.lua
Write-Output "local AddFile = resource.AddFile" | Out-File -Append -FilePath .\fastdl.lua

$i = 0
$host.privatedata.ProgressForegroundColor = $host.ui.rawui.ForegroundColor;
$host.privatedata.ProgressBackgroundColor = $host.ui.rawui.BackgroundColor;

foreach ( $f in $files ) {

    # Before doing anything we need to construct the destination path
    $compressedPath = "$f.bz2"
    $path = Join-Path -Path $outPath -ChildPath $compressedPath
    
    # If the file already exists, don't compress it again
    if ( -Not ( Test-Path -Path $path ) ) {
        &$cmd a -tbzip2 $path $f -y | Select-String "Error" -Context 10
    }
    
    $f = $f.Replace( '\', '/' )
    if ( -Not $extensions.Contains( [System.IO.Path]::GetExtension($f) ) ) {
        # Replace backslashes with slashes
        Write-Output "AddFile('$f')" | Out-File -Append -FilePath .\fastdl.lua
    }
    Write-Progress -Activity "Building fastdl" -Status "Progress: " -PercentComplete ( $i / $files.Count * 100) `
    -CurrentOperation $f
    $i++
}

Write-Host "`rFastDL has been successfully built." -ForegroundColor Green
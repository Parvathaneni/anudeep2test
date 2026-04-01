$RootPath   = "\\server\share\folder"
$OutputFile = "C:\Temp\NetworkShare_File_List.csv"

# Ensure output folder exists
$OutputDir = Split-Path $OutputFile
if (!(Test-Path $OutputDir)) {
    New-Item -ItemType Directory -Path $OutputDir -Force | Out-Null
}

# Write header first
"Type,Name,ParentFolder,FullPath,LastWriteDate,LastWriteTime" | Out-File $OutputFile -Encoding UTF8

Get-ChildItem -LiteralPath $RootPath -Recurse -Force -ErrorAction SilentlyContinue | ForEach-Object {

    $type = if ($_.PSIsContainer) { "Folder" } else { "File" }
    $name = $_.Name
    $parent = $_.DirectoryName
    $full = $_.FullName
    $date = $_.LastWriteTime.ToString("yyyy-MM-dd")
    $time = $_.LastWriteTime.ToString("HH:mm:ss")

    # Write each row immediately
    "$type,""$name"",""$parent"",""$full"",""$date"",""$time""" | Out-File $OutputFile -Append -Encoding UTF8
}

Write-Host "Done. File created at: $OutputFile"

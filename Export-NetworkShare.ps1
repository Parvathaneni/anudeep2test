# ============================
# Export folder/file inventory
# ============================

$RootPath   = "\\server\share\folder"
$OutputFile = "$env:USERPROFILE\Desktop\NetworkShare_File_List.csv"

Get-ChildItem -LiteralPath $RootPath -Recurse -Force -ErrorAction SilentlyContinue |
    Select-Object `
        @{Name='Type'; Expression={ if ($_.PSIsContainer) { 'Folder' } else { 'File' } }},
        @{Name='Name'; Expression={ $_.Name }},
        @{Name='ParentFolder'; Expression={ $_.DirectoryName }},
        @{Name='FullPath'; Expression={ $_.FullName }},
        @{Name='LastWriteDate'; Expression={ $_.LastWriteTime.ToString('yyyy-MM-dd') }},
        @{Name='LastWriteTime'; Expression={ $_.LastWriteTime.ToString('HH:mm:ss') }} |
    Export-Csv -Path $OutputFile -NoTypeInformation -Encoding UTF8

Write-Host "Done. File created at: $OutputFile"

$imagesPath = "C:\Users\Georges\Desktop\MUC2TrainingHematoxylin\Images"
$masksPath = "C:\Users\Georges\Desktop\MUC2Training\Masks"
$logFile = "C:\Users\Georges\Desktop\Deleted_Unmatched_Masks.txt"

# Clear/Create log file
Clear-Content -Path $logFile -ErrorAction SilentlyContinue
"`n--- Deletion Log Started: $(Get-Date) ---`n" | Out-File -FilePath $logFile

# Build lookup tables (case-insensitive)
$imageFiles = @{}
Get-ChildItem -Path $imagesPath -File | ForEach-Object { 
    $imageFiles[$_.BaseName.ToLower()] = $_.FullName 
}

$maskFiles = @{}
Get-ChildItem -Path $masksPath -File | ForEach-Object { 
    $maskFiles[$_.BaseName.ToLower()] = $_.FullName 
}

# Find unmatched masks
$masksWithoutImages = @()
foreach ($baseName in $maskFiles.Keys) {
    if (-not $imageFiles.ContainsKey($baseName)) {
        $masksWithoutImages += $maskFiles[$baseName]
    }
}

Write-Output "Unmatched masks found: $($masksWithoutImages.Count)"

# Delete unmatched masks forcibly
foreach ($mask in $masksWithoutImages) {
    try {
        # Remove read-only, hidden, system attributes safely quoting path for attrib
        $quotedPath = '"' + $mask + '"'
        attrib -r -h -s $quotedPath -ErrorAction SilentlyContinue

        # Use -LiteralPath to handle special characters safely
        Remove-Item -LiteralPath $mask -Force -ErrorAction Stop

        "Deleted mask: $mask" | Out-File -FilePath $logFile -Append
        Write-Output "Deleted mask: $mask"
    }
    catch {
        "Failed to delete mask: $mask. Error: $_" | Out-File -FilePath $logFile -Append
        Write-Output "Failed to delete mask: $mask"
    }
}

Write-Output "Deletion complete. Log saved to $logFile"

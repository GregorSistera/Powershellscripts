$imagesPath = "C:\Users\Georges\Desktop\MUC2TrainingHematoxylin\Images"
$masksPath = "C:\Users\Georges\Desktop\MUC2Training\Masks"

# Build lookup tables (case-insensitive)
$imageFiles = @{}
Get-ChildItem -Path $imagesPath -File | ForEach-Object { $imageFiles[$_.BaseName.ToLower()] = $_.FullName }

$maskFiles = @{}
Get-ChildItem -Path $masksPath -File | ForEach-Object { $maskFiles[$_.BaseName.ToLower()] = $_.FullName }

# Identify unmatched images
$imagesWithoutMasks = @()
foreach ($baseName in $imageFiles.Keys) {
    if (-not $maskFiles.ContainsKey($baseName)) {
        $imagesWithoutMasks += $imageFiles[$baseName]
    }
}

# Identify unmatched masks
$masksWithoutImages = @()
foreach ($baseName in $maskFiles.Keys) {
    if (-not $imageFiles.ContainsKey($baseName)) {
        $masksWithoutImages += $maskFiles[$baseName]
    }
}

# Save lists to Desktop
$desktop = [Environment]::GetFolderPath('Desktop')
$unmatchedImagesFile = Join-Path $desktop "Unmatched_Images.txt"
$unmatchedMasksFile = Join-Path $desktop "Unmatched_Masks.txt"

$imagesWithoutMasks | Out-File $unmatchedImagesFile
$masksWithoutImages | Out-File $unmatchedMasksFile

Write-Output "Saved unmatched images to: $unmatchedImagesFile"
Write-Output "Saved unmatched masks to: $unmatchedMasksFile"

# Confirm before deletion
Write-Output "Number of unmatched masks: $($masksWithoutImages.Count)"
if ($masksWithoutImages.Count -gt 0) {
    foreach ($mask in $masksWithoutImages) {
        Remove-Item $mask -Force
        Write-Output "Deleted mask: $mask"
    }
}

<# 
Optional: Delete unmatched images too
Write-Output "Number of unmatched images: $($imagesWithoutMasks.Count)"
if ($imagesWithoutMasks.Count -gt 0) {
    foreach ($image in $imagesWithoutMasks) {
        Remove-Item $image -Force
        Write-Output "Deleted image: $image"
    }
}
#>

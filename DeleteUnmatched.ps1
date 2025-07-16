$imagesPath = "C:\Users\Georges\Desktop\MUC2TrainingHematoxylin\Images"
$masksPath = "C:\Users\Georges\Desktop\MUC2Training\Masks"

# Build lookup tables
$imageFiles = @{}
Get-ChildItem -Path $imagesPath -File | ForEach-Object { $imageFiles[$_.BaseName.ToLower()] = $_.FullName }

$maskFiles = @{}
Get-ChildItem -Path $masksPath -File | ForEach-Object { $maskFiles[$_.BaseName.ToLower()] = $_.FullName }

# Identify unmatched masks
$masksWithoutImages = @()
foreach ($baseName in $maskFiles.Keys) {
    if (-not $imageFiles.ContainsKey($baseName)) {
        $masksWithoutImages += $maskFiles[$baseName]
    }
}

# Confirm before deleting
Write-Output "Number of unmatched masks: $($masksWithoutImages.Count)"
$masksWithoutImages | Out-File "C:\Users\Georges\Desktop\Unmatched_Masks.txt"

# Delete unmatched masks
foreach ($mask in $masksWithoutImages) {
    Remove-Item $mask -Force
    Write-Output "Deleted mask: $mask"
}

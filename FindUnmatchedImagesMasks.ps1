$imagesPath = "C:\Users\Georges\Desktop\MUC2TrainingHematoxylin\Images"
$masksPath = "C:\Users\Georges\Desktop\MUC2Training\Masks"

# Create lookup tables (case-insensitive)
$imageFiles = @{}
Get-ChildItem -Path $imagesPath -File | ForEach-Object { $imageFiles[$_.BaseName.ToLower()] = $_.FullName }

$maskFiles = @{}
Get-ChildItem -Path $masksPath -File | ForEach-Object { $maskFiles[$_.BaseName.ToLower()] = $_.FullName }

# Find images without corresponding masks
$imagesWithoutMasks = @()
foreach ($baseName in $imageFiles.Keys) {
    if (-not $maskFiles.ContainsKey($baseName)) {
        $imagesWithoutMasks += $imageFiles[$baseName]
    }
}

# Find masks without corresponding images
$masksWithoutImages = @()
foreach ($baseName in $maskFiles.Keys) {
    if (-not $imageFiles.ContainsKey($baseName)) {
        $masksWithoutImages += $maskFiles[$baseName]
    }
}

# Output results
Write-Output "Images without matching masks:"
$imagesWithoutMasks

Write-Output "`nMasks without matching images:"
$masksWithoutImages

# Optional: Save results to files
$imagesWithoutMasks | Out-File "Unmatched_Images.txt"
$masksWithoutImages | Out-File "Unmatched_Masks.txt"

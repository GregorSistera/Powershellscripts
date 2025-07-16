$imagesPath = "C:\Users\Georges\Desktop\MUC2TrainingHematoxylin\Images"
$masksPath = "C:\Users\Georges\Desktop\MUC2Training\Masks"

# Get file names without extension
$imageFiles = Get-ChildItem -Path $imagesPath -File | ForEach-Object { $_.BaseName }
$maskFiles = Get-ChildItem -Path $masksPath -File | ForEach-Object { $_.BaseName }

# Remove images without corresponding mask
$imageFiles | ForEach-Object {
    if (-not ($maskFiles -contains $_)) {
        $fullPath = Join-Path $imagesPath "$_.jpg"  # Adjust extension if needed
        Remove-Item $fullPath -Force
        Write-Output "Deleted image: $fullPath"
    }
}

# Remove masks without corresponding image
$maskFiles | ForEach-Object {
    if (-not ($imageFiles -contains $_)) {
        $fullPath = Join-Path $masksPath "$_.png"  # Adjust extension if needed
        Remove-Item $fullPath -Force
        Write-Output "Deleted mask: $fullPath"
    }
}

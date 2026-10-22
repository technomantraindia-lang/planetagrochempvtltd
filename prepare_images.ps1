Add-Type -AssemblyName System.Drawing

$src = "C:\Users\techn\.gemini\antigravity-ide\brain\c36c5cf0-2275-4dbe-8827-db96e60917cf\hero_freight_truck_1792404112408.jpg"
$destNormal = "hero-freight.jpg"
$destFlipped = "hero-freight-flipped.jpg"

if (Test-Path $src) {
    $img = [System.Drawing.Image]::FromFile($src)
    Write-Host "Loaded image: $($img.Width)x$($img.Height)"
    
    # Save direct copy
    $img.Save($destNormal, [System.Drawing.Imaging.ImageFormat]::Jpeg)
    
    # Create flipped bitmap
    $flipped = New-Object System.Drawing.Bitmap($img)
    $flipped.RotateFlip([System.Drawing.RotateFlipType]::RotateNoneFlipX)
    $flipped.Save($destFlipped, [System.Drawing.Imaging.ImageFormat]::Jpeg)
    
    $img.Dispose()
    $flipped.Dispose()
    Write-Host "Saved hero-freight.jpg and hero-freight-flipped.jpg successfully."
} else {
    Write-Error "Source image not found: $src"
}

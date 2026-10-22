Add-Type -AssemblyName System.Drawing

$srcPath = "C:\Users\techn\.gemini\antigravity-ide\brain\9c1ec8d9-95f0-4be5-a261-b93ad59f7713\.user_uploaded\media_1792563927868.png"
$img = [System.Drawing.Bitmap]::FromFile($srcPath)

function CropArea($img, $x, $y, $w, $h, $outName) {
    $bmp = New-Object System.Drawing.Bitmap($w, $h)
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $dest = New-Object System.Drawing.Rectangle(0, 0, $w, $h)
    $src = New-Object System.Drawing.Rectangle($x, $y, $w, $h)
    $g.DrawImage($img, $dest, $src, [System.Drawing.GraphicsUnit]::Pixel)
    $g.Dispose()
    $bmp.Save($outName, [System.Drawing.Imaging.ImageFormat]::Png)
    $bmp.Dispose()
    Write-Host "Saved $outName"
}

CropArea $img 62 244 34 34 "testi-avatar-martin.png"
CropArea $img 332 244 34 34 "testi-avatar-james.png"
CropArea $img 604 244 34 34 "testi-avatar-natasha.png"

$img.Dispose()

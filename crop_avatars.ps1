Add-Type -AssemblyName System.Drawing

$srcPath = "C:\Users\techn\.gemini\antigravity-ide\brain\9c1ec8d9-95f0-4be5-a261-b93ad59f7713\.user_uploaded\media_1792563927868.png"
$img = [System.Drawing.Bitmap]::FromFile($srcPath)
Write-Host "Width=$($img.Width) Height=$($img.Height)"

# In media_1792563927868.png:
# Width is 1000px, Height is 500px.
# Martin Edwards yellow circle avatar is at X=80, Y=330 approx
# Let's crop 3 avatars:
# Martin: X=75, Y=315, W=45, H=45
# James: X=420, Y=315, W=45, H=45
# Natasha: X=765, Y=315, W=45, H=45

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

# Scan for yellow circle (Martin) around X=60..120, Y=300..360
$mX = 78
$mY = 320
for ($y = 300; $y -lt 360; $y++) {
    for ($x = 60; $x -lt 120; $x++) {
        $c = $img.GetPixel($x, $y)
        if ($c.R -gt 230 -and $c.G -gt 180 -and $c.B -lt 80) {
            $mX = $x
            $mY = $y
            break
        }
    }
}
Write-Host "Detected Martin start: X=$mX, Y=$mY"

# Let's crop circular avatars:
CropArea $img 78 320 44 44 "testi-avatar-martin.png"
CropArea $img 423 320 44 44 "testi-avatar-james.png"
CropArea $img 768 320 44 44 "testi-avatar-natasha.png"

$img.Dispose()
Write-Host "All avatars cropped successfully!"

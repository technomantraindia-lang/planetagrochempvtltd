Add-Type -AssemblyName System.Drawing

$bmp = [System.Drawing.Bitmap]::FromFile((Join-Path (Get-Location) "hero-inner.jpg"))
Write-Output "Image loaded: $($bmp.Width) x $($bmp.Height)"

# The container ribs are vertically uniform from x=0 to x=500, between y=70 and y=380.
# At y=300 to y=360, x=20 to x=460, there is NO text on the container!
# We can sample vertical slices from y=300..360 and fill y=70..280!
# Also in the sky: y=0..65 has sky, we can sample the clouds from x=150..300, y=0..60 and fill x=0..120 and x=260..800!

$cleanBmp = New-Object System.Drawing.Bitmap($bmp.Width, $bmp.Height)
$g = [System.Drawing.Graphics]::FromImage($cleanBmp)
$g.DrawImage($bmp, 0, 0, $bmp.Width, $bmp.Height)

# 1. Fill the container text area (x: 20 to 460, y: 70 to 270) using the clean container area below (y: 290 to 360)
for ($x = 20; $x -lt 470; $x++) {
    for ($y = 70; $y -lt 280; $y++) {
        # sample y from 300 to 350
        $sampleY = 300 + (($y - 70) % 55)
        $pixel = $bmp.GetPixel($x, $sampleY)
        # Apply slight darkening towards top to match container shadow
        $cleanBmp.SetPixel($x, $y, $pixel)
    }
}

# 2. Fill the top nav text area in the sky (y: 0 to 50, x: 0 to 480) using the sky texture around x=180..260, y=10..50
for ($x = 0; $x -lt 480; $x++) {
    for ($y = 0; $y -lt 68; $y++) {
        $sampleX = 180 + ($x % 80)
        $sampleY = 15 + ($y % 35)
        $pixel = $bmp.GetPixel($sampleX, $sampleY)
        $cleanBmp.SetPixel($x, $y, $pixel)
    }
}

# 3. Fill the top-right button area in the sky (y: 0 to 55, x: 680 to 820)
for ($x = 680; $x -lt 820; $x++) {
    for ($y = 0; $y -lt 60; $y++) {
        $sampleX = 580 + ($x % 80)
        $sampleY = 15 + ($y % 35)
        $pixel = $bmp.GetPixel($sampleX, $sampleY)
        $cleanBmp.SetPixel($x, $y, $pixel)
    }
}

# 4. Fill the bottom subtitle text (x: 20 to 260, y: 385 to 430) using clean tarmac at x: 280..400, y: 385..430
for ($x = 20; $x -lt 265; $x++) {
    for ($y = 385; $y -lt 430; $y++) {
        $sampleX = 280 + ($x % 90)
        $pixel = $bmp.GetPixel($sampleX, $y)
        $cleanBmp.SetPixel($x, $y, $pixel)
    }
}

$cleanBmp.Save((Join-Path (Get-Location) "hero-clean.jpg"), [System.Drawing.Imaging.ImageFormat]::Jpeg)
$g.Dispose()
$cleanBmp.Dispose()
$bmp.Dispose()
Write-Output "Saved clean background hero-clean.jpg successfully!"

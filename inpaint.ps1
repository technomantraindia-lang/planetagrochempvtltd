Add-Type -AssemblyName System.Drawing

$bmp = [System.Drawing.Bitmap]::FromFile((Join-Path (Get-Location) "hero-inner.jpg"))
$w = $bmp.Width
$h = $bmp.Height
$clean = New-Object System.Drawing.Bitmap($bmp)

# Function to check if a pixel is text (white/light gray)
function IsTextPixel($c) {
    return ($c.R -gt 185 -and $c.G -gt 185 -and $c.B -gt 185)
}

# 1. In the container region (y: 65 to 300, x: 0 to 520)
# Replace text pixels with pixel from 25 pixels below (which has the exact same vertical corrugation rib color!)
for ($iter = 0; $iter -lt 3; $iter++) {
    for ($y = 65; $y -lt 300; $y++) {
        for ($x = 0; $x -lt 520; $x++) {
            $c = $clean.GetPixel($x, $y)
            if (IsTextPixel $c) {
                # Look down for clean container pixel at y + 30 or y + 45
                $targetY = [Math]::Min($h - 100, $y + 35)
                while ($targetY -lt ($h - 90) -and (IsTextPixel ($bmp.GetPixel($x, $targetY)))) {
                    $targetY += 10
                }
                $clean.SetPixel($x, $y, $bmp.GetPixel($x, $targetY))
            }
        }
    }
}

# 2. In the sky nav text region (y: 0 to 60, x: 0 to 600)
for ($y = 0; $y -lt 60; $y++) {
    for ($x = 0; $x -lt 600; $x++) {
        $c = $clean.GetPixel($x, $y)
        if ($c.R -gt 160 -and $c.G -gt 160 -and $c.B -gt 160) {
            # sample from nearby sky
            $sampleY = [Math]::Min($h - 1, $y + 40)
            $clean.SetPixel($x, $y, $bmp.GetPixel($x, $sampleY))
        }
    }
}

# 3. In the top-right button region (y: 0 to 60, x: 700 to 860)
for ($y = 0; $y -lt 60; $y++) {
    for ($x = 700; $x -lt 860; $x++) {
        $c = $clean.GetPixel($x, $y)
        # yellow button or text
        if ($c.R -gt 170 -and $c.G -gt 130) {
            $sampleY = [Math]::Min($h - 1, $y + 50)
            $clean.SetPixel($x, $y, $bmp.GetPixel($x, $sampleY))
        }
    }
}

# 4. In the bottom-left subtitle region (y: 380 to 440, x: 0 to 280)
for ($y = 380; $y -lt 440; $y++) {
    for ($x = 0; $x -lt 280; $x++) {
        $c = $clean.GetPixel($x, $y)
        if (IsTextPixel $c) {
            # sample from wet tarmac to the right (x + 80)
            $sampleX = [Math]::Min($w - 1, $x + 100)
            $clean.SetPixel($x, $y, $bmp.GetPixel($sampleX, $y))
        }
    }
}

$clean.Save((Join-Path (Get-Location) "hero-clean-inpaint.jpg"), [System.Drawing.Imaging.ImageFormat]::Jpeg)
$clean.Dispose()
$bmp.Dispose()
Write-Output "Inpainted clean background successfully!"

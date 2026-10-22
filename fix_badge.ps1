Add-Type -AssemblyName System.Drawing

$img = [System.Drawing.Bitmap]::FromFile("hero-freight-clean.jpg")

# Search for the bright white badge letters near the truck front grille
# Truck front is around x=950..1200, y=500..620
$badgeMinX = 9999
$badgeMaxX = 0
$badgeMinY = 9999
$badgeMaxY = 0

for ($y = 520; $y -lt 620; $y++) {
    for ($x = 980; $x -lt 1160; $x++) {
        $c = $img.GetPixel($x, $y)
        # Silver/white badge text has high brightness and low saturation
        if ($c.R -gt 170 -and $c.G -gt 170 -and $c.B -gt 170) {
            if ($x -lt $badgeMinX) { $badgeMinX = $x }
            if ($x -gt $badgeMaxX) { $badgeMaxX = $x }
            if ($y -lt $badgeMinY) { $badgeMinY = $y }
            if ($y -gt $badgeMaxY) { $badgeMaxY = $y }
        }
    }
}

Write-Host "Badge bounds: X: $badgeMinX..$badgeMaxX, Y: $badgeMinY..$badgeMaxY"

# Let's paint over this area using the red grille bar color sampled from right next to it
if ($badgeMaxX -gt $badgeMinX) {
    $g = [System.Drawing.Graphics]::FromImage($img)
    # Sample the red grille bar at x = $badgeMinX - 15, y = ($badgeMinY + $badgeMaxY)/2
    $sampleColor = $img.GetPixel([int]($badgeMinX - 15), [int](($badgeMinY + $badgeMaxY) / 2))
    Write-Host "Sample color: R=$($sampleColor.R) G=$($sampleColor.G) B=$($sampleColor.B)"
    
    $brush = New-Object System.Drawing.SolidBrush($sampleColor)
    # Fill the badge rectangle with slight padding
    $pad = 3
    $g.FillRectangle($brush, $badgeMinX - $pad, $badgeMinY - $pad, ($badgeMaxX - $badgeMinX + 2*$pad), ($badgeMaxY - $badgeMinY + 2*$pad))
    $g.Dispose()
}

$img.Save("hero-freight-perfect.jpg", [System.Drawing.Imaging.ImageFormat]::Jpeg)
$img.Dispose()
Write-Host "hero-freight-perfect.jpg saved!"

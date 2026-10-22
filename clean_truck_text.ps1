Add-Type -AssemblyName System.Drawing

$img = [System.Drawing.Bitmap]::FromFile("hero-freight-flipped.jpg")
$g = [System.Drawing.Graphics]::FromImage($img)

# On the container: KNIL THGIERF is around x=700..790, y=380..430
# Let's clone horizontal slices from adjacent container ribs at x=640..680 to cover x=690..800
$srcRect = New-Object System.Drawing.Rectangle(630, 370, 60, 80)
$destRect = New-Object System.Drawing.Rectangle(700, 370, 100, 80)
# Use a TextureBrush or draw repeating vertical container slats
for ($x = 700; $x -lt 800; $x += 20) {
    $slice = New-Object System.Drawing.Rectangle(640, 370, 20, 80)
    $target = New-Object System.Drawing.Rectangle($x, 370, 20, 80)
    $g.DrawImage($img, $target, $slice, [System.Drawing.GraphicsUnit]::Pixel)
}

# On the truck grille: AIMACS badge is around x=1050..1110, y=430..455
# Fill with the dark charcoal grille color
$brush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(40, 42, 45))
# Grille badge area:
# Let's find exact position
$g.Dispose()
$img.Save("hero-freight-clean.jpg", [System.Drawing.Imaging.ImageFormat]::Jpeg)
$img.Dispose()
Write-Host "hero-freight-clean.jpg created"

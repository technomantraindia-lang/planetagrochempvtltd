Add-Type -AssemblyName System.Drawing

$img = [System.Drawing.Image]::FromFile("example.webp")
Write-Host "example.webp Width=$($img.Width) Height=$($img.Height)"

# Testimonials section is after Section 5 (Precision Handling).
# Let's crop from Y = 2800 to Y = 3700
$cropHeight = 900
$bmp = New-Object System.Drawing.Bitmap(1600, $cropHeight)
$g = [System.Drawing.Graphics]::FromImage($bmp)
$srcRect = New-Object System.Drawing.Rectangle(0, [int]($img.Height * 0.70), $img.Width, [int]($img.Height * 0.20))
$dstRect = New-Object System.Drawing.Rectangle(0, 0, 1600, $cropHeight)
$g.DrawImage($img, $dstRect, $srcRect, [System.Drawing.GraphicsUnit]::Pixel)
$g.Dispose()

$bmp.Save("sec6-preview.jpg", [System.Drawing.Imaging.ImageFormat]::Jpeg)
$bmp.Dispose()
$img.Dispose()
Write-Host "sec6-preview.jpg saved!"

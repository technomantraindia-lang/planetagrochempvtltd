Add-Type -AssemblyName System.Drawing

$srcPath = "C:\Users\techn\.gemini\antigravity-ide\brain\9c1ec8d9-95f0-4be5-a261-b93ad59f7713\.user_uploaded\media_1792563927868.png"
$img = [System.Drawing.Bitmap]::FromFile($srcPath)

# Search across the whole image for the distinct yellow circle (R>240, G>180, B<70)
$found = @()
for ($y = 0; $y -lt $img.Height; $y += 2) {
    for ($x = 0; $x -lt [int]($img.Width * 0.4); $x += 2) {
        $c = $img.GetPixel($x, $y)
        if ($c.R -gt 240 -and $c.G -gt 180 -and $c.B -lt 70) {
            $found += New-Object System.Drawing.Point($x, $y)
        }
    }
}

if ($found.Count -gt 0) {
    $minX = ($found | Measure-Object -Property X -Minimum).Minimum
    $maxX = ($found | Measure-Object -Property X -Maximum).Maximum
    $minY = ($found | Measure-Object -Property Y -Minimum).Minimum
    $maxY = ($found | Measure-Object -Property Y -Maximum).Maximum
    Write-Host "Found Yellow Circle at: X=$minX..$maxX, Y=$minY..$maxY, Width=$($maxX-$minX) Height=$($maxY-$minY)"
} else {
    Write-Host "Not found"
}
$img.Dispose()

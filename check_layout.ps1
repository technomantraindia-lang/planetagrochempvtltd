Add-Type -AssemblyName PresentationCore, WindowsBase
$filePath = Join-Path (Get-Location) "example.webp"
$uri = New-Object System.Uri($filePath)
$dec = [System.Windows.Media.Imaging.BitmapDecoder]::Create($uri, [System.Windows.Media.Imaging.BitmapCreateOptions]::None, [System.Windows.Media.Imaging.BitmapCacheOption]::OnLoad)
$f = $dec.Frames[0]

# Total height is 3217. Let's sample colors at x=10 (near left edge) every 200px:
Write-Output "Image size: $($f.PixelWidth) x $($f.PixelHeight)"
for ($y = 100; $y -lt $f.PixelHeight; $y += 200) {
    $rect = New-Object System.Windows.Int32Rect(10, $y, 1, 1)
    $pixels = New-Object byte[] 4
    $f.CopyPixels($rect, $pixels, 4, 0)
    Write-Output "y=$y : R=$($pixels[2]), G=$($pixels[1]), B=$($pixels[0])"
}

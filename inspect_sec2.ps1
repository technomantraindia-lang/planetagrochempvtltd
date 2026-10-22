Add-Type -AssemblyName PresentationCore
Add-Type -AssemblyName WindowsBase

$filePath = Join-Path (Get-Location) "example.webp"
$uri = New-Object System.Uri($filePath)
$decoder = [System.Windows.Media.Imaging.BitmapDecoder]::Create($uri, [System.Windows.Media.Imaging.BitmapCreateOptions]::None, [System.Windows.Media.Imaging.BitmapCacheOption]::OnLoad)
$frame = $decoder.Frames[0]

Write-Host "example.webp total size: $($frame.PixelWidth)x$($frame.PixelHeight)"

# In example.webp (width=1024, height=3072 or similar):
# Section 2 is roughly around y=560..950
# Let's crop Section 2 area to inspect
$rectSec2 = New-Object System.Windows.Int32Rect(60, 560, 904, 400)
$crop = New-Object System.Windows.Media.Imaging.CroppedBitmap($frame, $rectSec2)
$enc = New-Object System.Windows.Media.Imaging.JpegBitmapEncoder
$enc.Frames.Add([System.Windows.Media.Imaging.BitmapFrame]::Create($crop))
$fs = [System.IO.File]::OpenWrite((Join-Path (Get-Location) "sec2-preview.jpg"))
$enc.Save($fs)
$fs.Close()
Write-Host "Saved sec2-preview.jpg"

Add-Type -AssemblyName PresentationCore
Add-Type -AssemblyName WindowsBase

$filePath = Join-Path (Get-Location) "example.webp"
$uri = New-Object System.Uri($filePath)
$decoder = [System.Windows.Media.Imaging.BitmapDecoder]::Create($uri, [System.Windows.Media.Imaging.BitmapCreateOptions]::None, [System.Windows.Media.Imaging.BitmapCacheOption]::OnLoad)
$frame = $decoder.Frames[0]

# Section 3: around y=960..1320
$rectSec3 = New-Object System.Windows.Int32Rect(60, 960, 904, 360)
$crop = New-Object System.Windows.Media.Imaging.CroppedBitmap($frame, $rectSec3)
$enc = New-Object System.Windows.Media.Imaging.JpegBitmapEncoder
$enc.Frames.Add([System.Windows.Media.Imaging.BitmapFrame]::Create($crop))
$fs = [System.IO.File]::OpenWrite((Join-Path (Get-Location) "sec3-preview.jpg"))
$enc.Save($fs)
$fs.Close()
Write-Host "Saved sec3-preview.jpg"

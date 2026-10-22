Add-Type -AssemblyName PresentationCore
Add-Type -AssemblyName WindowsBase

$filePath = Join-Path (Get-Location) "example.webp"
$uri = New-Object System.Uri($filePath)
$decoder = [System.Windows.Media.Imaging.BitmapDecoder]::Create($uri, [System.Windows.Media.Imaging.BitmapCreateOptions]::None, [System.Windows.Media.Imaging.BitmapCacheOption]::OnLoad)
$frame = $decoder.Frames[0]

# Let's crop from y=545 with height=405 to ensure top and bottom of both cards are 100% complete
# Middle card: x=365, y=545, width=288, height=405
$rectAir = New-Object System.Windows.Int32Rect(365, 545, 288, 405)
$cropAir = New-Object System.Windows.Media.Imaging.CroppedBitmap($frame, $rectAir)
$encAir = New-Object System.Windows.Media.Imaging.JpegBitmapEncoder
$encAir.Frames.Add([System.Windows.Media.Imaging.BitmapFrame]::Create($cropAir))
$fsAir = [System.IO.File]::OpenWrite((Join-Path (Get-Location) "card-air-freight-new.jpg"))
$encAir.Save($fsAir)
$fsAir.Close()

# Right card: x=668, y=545, width=288, height=405
$rectOcean = New-Object System.Windows.Int32Rect(668, 545, 288, 405)
$cropOcean = New-Object System.Windows.Media.Imaging.CroppedBitmap($frame, $rectOcean)
$encOcean = New-Object System.Windows.Media.Imaging.JpegBitmapEncoder
$encOcean.Frames.Add([System.Windows.Media.Imaging.BitmapFrame]::Create($cropOcean))
$fsOcean = [System.IO.File]::OpenWrite((Join-Path (Get-Location) "card-ocean-freight-new.jpg"))
$encOcean.Save($fsOcean)
$fsOcean.Close()

Write-Host "New cards cropped from y=545"

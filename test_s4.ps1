Add-Type -AssemblyName PresentationCore, WindowsBase
$filePath = Join-Path (Get-Location) "example.webp"
$uri = New-Object System.Uri($filePath)
$dec = [System.Windows.Media.Imaging.BitmapDecoder]::Create($uri, [System.Windows.Media.Imaging.BitmapCreateOptions]::None, [System.Windows.Media.Imaging.BitmapCacheOption]::OnLoad)
$f = $dec.Frames[0]

# Let's crop from y=1200 to y=1600 (height 400)
$rect = New-Object System.Windows.Int32Rect(48, 1220, 480, 400)
$crop = New-Object System.Windows.Media.Imaging.CroppedBitmap($f, $rect)
$enc = New-Object System.Windows.Media.Imaging.JpegBitmapEncoder
$enc.Frames.Add([System.Windows.Media.Imaging.BitmapFrame]::Create($crop))
$fs = [System.IO.File]::Create((Join-Path (Get-Location) "test_s4_box.jpg"))
$enc.Save($fs)
$fs.Close()

Write-Host "Exported test_s4_box.jpg"

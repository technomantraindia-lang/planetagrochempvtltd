Add-Type -AssemblyName PresentationCore, WindowsBase
$filePath = Join-Path (Get-Location) "example.webp"
$uri = New-Object System.Uri($filePath)
$dec = [System.Windows.Media.Imaging.BitmapDecoder]::Create($uri, [System.Windows.Media.Imaging.BitmapCreateOptions]::None, [System.Windows.Media.Imaging.BitmapCacheOption]::OnLoad)
$f = $dec.Frames[0]

# Let's crop full width (x=0 to 1000) of Section 4: y=1240, height=380
$rect = New-Object System.Windows.Int32Rect(0, 1240, $f.PixelWidth, 380)
$crop = New-Object System.Windows.Media.Imaging.CroppedBitmap($f, $rect)
$enc = New-Object System.Windows.Media.Imaging.JpegBitmapEncoder
$enc.Frames.Add([System.Windows.Media.Imaging.BitmapFrame]::Create($crop))
$fs = [System.IO.File]::Create((Join-Path (Get-Location) "orig_s4_fullwidth.jpg"))
$enc.Save($fs)
$fs.Close()

Write-Host "Exported orig_s4_fullwidth.jpg"

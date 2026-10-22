$ErrorActionPreference = "Continue"

$imageTargets = @(
    @{
        Url = "https://upload.wikimedia.org/wikipedia/commons/b/b6/Spices1.jpg"
        File = "card-spices.jpg"
    },
    @{
        Url = "https://upload.wikimedia.org/wikipedia/commons/e/ea/Raw_rice.jpg"
        File = "card-grains.jpg"
    },
    @{
        Url = "https://upload.wikimedia.org/wikipedia/commons/9/90/Spices_in_an_Indian_market.jpg"
        File = "card-spices-market.jpg"
    },
    @{
        Url = "https://upload.wikimedia.org/wikipedia/commons/0/07/Khyma_and_Basmati_rice.jpg"
        File = "card-basmati-rice.jpg"
    }
)

foreach ($target in $imageTargets) {
    Write-Host "Downloading $($target.File)..."
    try {
        Invoke-WebRequest -Uri $target.Url -Headers @{ "User-Agent" = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36" } -OutFile $target.File
        if (Test-Path $target.File) {
            $len = (Get-Item $target.File).Length
            Write-Host "Saved $($target.File) ($len bytes)"
        }
    } catch {
        Write-Warning "Failed $($target.File): $_"
    }
    Start-Sleep -Seconds 1
}

Write-Host "Download batch finished."

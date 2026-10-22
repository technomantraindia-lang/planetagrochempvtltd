$ErrorActionPreference = "Continue"

function Search-WikiImage($query, $outFile) {
    Write-Host "Searching Wikimedia for '$query'..."
    $encoded = [System.Uri]::EscapeDataString($query)
    $apiUrl = "https://commons.wikimedia.org/w/api.php?action=query&format=json&generator=search&gsrnamespace=6&gsrsearch=$encoded&gsrlimit=5&prop=imageinfo&iiprop=url"
    
    try {
        $wc = New-Object System.Net.WebClient
        $wc.Headers.Add("User-Agent", "Mozilla/5.0 (Windows NT 10.0; Win64; x64) PlanetAgro/1.0")
        $jsonStr = $wc.DownloadString($apiUrl)
        $data = $jsonStr | ConvertFrom-Json
        
        if ($data.query -and $data.query.pages) {
            foreach ($page in $data.query.pages.PSObject.Properties) {
                $info = $page.Value.imageinfo
                if ($info -and $info.Count -gt 0) {
                    $imgUrl = $info[0].url
                    # Skip svg/tif
                    if ($imgUrl -match '\.(jpg|jpeg|png)$') {
                        Write-Host "Found image: $imgUrl"
                        Write-Host "Downloading to $outFile..."
                        $wc.DownloadFile($imgUrl, $outFile)
                        if ((Test-Path $outFile) -and ((Get-Item $outFile).Length -gt 5000)) {
                            Write-Host "SUCCESS: Saved $outFile ($((Get-Item $outFile).Length) bytes)"
                            return $true
                        }
                    }
                }
            }
        }
    } catch {
        Write-Warning "Failed for '$query': $_"
    }
    return $false
}

# Queries for each image
$tasks = @(
    @{ Query = "Indian whole spices market burlap sacks turmeric"; Out = "card-spices.jpg" },
    @{ Query = "raw white basmati rice grains"; Out = "card-grains.jpg" },
    @{ Query = "Indian businessman portrait suit smiling"; Out = "avatar-vikramaditya.jpg" },
    @{ Query = "industrial food sorting color sorter machine"; Out = "tech-sortex-facility.jpg" },
    @{ Query = "agronomist field crop inspection tablet"; Out = "process-01-sourcing.jpg" },
    @{ Query = "quality control laboratory chemist testing food"; Out = "process-02-lab-grading.jpg" },
    @{ Query = "container loading forklift warehouse export"; Out = "process-03-packaging.jpg" },
    @{ Query = "grain silos agricultural storage facility"; Out = "process-04-silos.jpg" },
    @{ Query = "container port terminal crane shipping vessel"; Out = "process-05-port.jpg" },
    @{ Query = "middle eastern businessman portrait"; Out = "testi-avatar-tariq.jpg" },
    @{ Query = "german businessman portrait headshot"; Out = "testi-avatar-henrik.jpg" },
    @{ Query = "japanese businessman portrait"; Out = "testi-avatar-kenji.jpg" }
)

foreach ($t in $tasks) {
    Search-WikiImage $t.Query $t.Out
}

Write-Host "Done."

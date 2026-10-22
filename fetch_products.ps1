$ErrorActionPreference = "Continue"

function Get-PageThumbnail($title, $outFile) {
    Write-Host "Getting thumbnail for Wikipedia title: '$title'..."
    $encodedTitle = [System.Uri]::EscapeDataString($title)
    $url = "https://en.wikipedia.org/w/api.php?action=query&titles=$encodedTitle&prop=pageimages&format=json&pithumbsize=800"
    
    $req = [System.Net.HttpWebRequest]::Create($url)
    $req.UserAgent = "PlanetAgroBot/1.0 (https://planetagrochem.com; info@planetagrochem.com)"
    $req.Timeout = 10000
    
    try {
        $resp = $req.GetResponse()
        $reader = New-Object System.IO.StreamReader($resp.GetResponseStream())
        $json = $reader.ReadToEnd()
        $reader.Close()
        $resp.Close()
        
        $obj = $json | ConvertFrom-Json
        foreach ($p in $obj.query.pages.PSObject.Properties) {
            if ($p.Value.thumbnail -and $p.Value.thumbnail.source) {
                $imgUrl = $p.Value.thumbnail.source
                Write-Host "Found image URL for '$title': $imgUrl"
                
                $imgReq = [System.Net.HttpWebRequest]::Create($imgUrl)
                $imgReq.UserAgent = "PlanetAgroBot/1.0 (https://planetagrochem.com; info@planetagrochem.com)"
                $imgReq.Referer = "https://en.wikipedia.org/"
                $imgReq.Timeout = 15000
                $imgResp = $imgReq.GetResponse()
                
                $stream = $imgResp.GetResponseStream()
                $fs = [System.IO.File]::Create($outFile)
                $stream.CopyTo($fs)
                $fs.Close()
                $stream.Close()
                $imgResp.Close()
                
                if (Test-Path $outFile) {
                    $sz = (Get-Item $outFile).Length
                    Write-Host "SUCCESS: Saved $outFile ($sz bytes)"
                    return $true
                }
            }
        }
    } catch {
        Write-Warning "Error for '$title': $_"
    }
    return $false
}

$pageMap = @(
    @{ Title = "Basmati"; Out = "prod-basmati.jpg" },
    @{ Title = "Turmeric"; Out = "prod-turmeric.jpg" },
    @{ Title = "Cumin"; Out = "prod-cumin.jpg" },
    @{ Title = "Assam tea"; Out = "prod-tea.jpg" },
    @{ Title = "Chickpea"; Out = "prod-chickpeas.jpg" },
    @{ Title = "Sesame"; Out = "prod-sesame.jpg" },
    @{ Title = "Jaggery"; Out = "prod-jaggery.jpg" },
    @{ Title = "Garlic"; Out = "prod-dehydrated.jpg" }
)

foreach ($item in $pageMap) {
    if (-not (Test-Path $item.Out) -or (Get-Item $item.Out).Length -lt 5000) {
        $success = Get-PageThumbnail -title $item.Title -outFile $item.Out
        if (-not $success) {
            Write-Host "Trying fallback for $($item.Title)..."
        }
        Start-Sleep -Milliseconds 600
    } else {
        Write-Host "Already exists: $($item.Out)"
    }
}

$ErrorActionPreference = "Continue"

function Get-PageThumbnail($title, $outFile) {
    Write-Host "Getting thumbnail for Wikipedia title: '$title'..."
    $encodedTitle = [System.Uri]::EscapeDataString($title)
    $url = "https://en.wikipedia.org/w/api.php?action=query&titles=$encodedTitle&prop=pageimages&format=json&pithumbsize=1000"
    
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
                Write-Host "Found image URL: $imgUrl"
                
                # Download image
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
    @{ Title = "Silo"; Out = "process-04-silos.jpg" },
    @{ Title = "Laboratory"; Out = "process-02-lab-grading.jpg" },
    @{ Title = "Container ship"; Out = "process-05-port.jpg" },
    @{ Title = "Agronomy"; Out = "process-01-sourcing.jpg" },
    @{ Title = "Warehouse"; Out = "process-03-packaging.jpg" },
    @{ Title = "Food processing"; Out = "tech-sortex-facility.jpg" }
)

foreach ($item in $pageMap) {
    Get-PageThumbnail $item.Title $item.Out
    Start-Sleep -Seconds 1
}

Write-Host "All page thumbnail downloads finished."

$wc = New-Object System.Net.WebClient
$wc.Headers.Add("User-Agent", "PlanetAgroChemBot/1.0 (https://planetagrochem.com; info@planetagrochem.com)")
try {
    $url = "https://en.wikipedia.org/w/api.php?action=query&titles=Spice&prop=pageimages&format=json&pithumbsize=1000"
    $json = $wc.DownloadString($url)
    $obj = $json | ConvertFrom-Json
    $pages = $obj.query.pages
    foreach ($p in $pages.PSObject.Properties) {
        $thumb = $p.Value.thumbnail.source
        Write-Host "Found spice image: $thumb"
        if ($thumb) {
            $wc.DownloadFile($thumb, "test_spice.jpg")
            Write-Host "Downloaded test_spice.jpg: $((Get-Item 'test_spice.jpg').Length) bytes"
        }
    }
} catch {
    Write-Warning "Error: $_"
}

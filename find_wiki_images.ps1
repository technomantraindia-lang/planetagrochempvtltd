$wc = New-Object System.Net.WebClient
$wc.Headers.Add("User-Agent", "PlanetAgroChemBot/1.0 (https://planetagrochem.com; info@planetagrochem.com)")

function Get-WikiPageImage($title) {
    $url = "https://en.wikipedia.org/w/api.php?action=query&titles=$([System.Uri]::EscapeDataString($title))&prop=pageimages&format=json&pithumbsize=1200"
    $json = $wc.DownloadString($url)
    $obj = $json | ConvertFrom-Json
    foreach ($p in $obj.query.pages.PSObject.Properties) {
        if ($p.Value.thumbnail) {
            return $p.Value.thumbnail.source
        }
    }
    return $null
}

$titles = @(
    "Basmati",
    "Rice",
    "Agronomy",
    "Food science",
    "Intermodal container",
    "Silo",
    "Mundra Port",
    "Optical sorting"
)

foreach ($t in $titles) {
    $img = Get-WikiPageImage $t
    Write-Host "$t => $img"
}

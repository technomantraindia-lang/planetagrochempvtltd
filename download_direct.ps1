param()

function Download-Direct($url, $file) {
    try {
        $req = [System.Net.HttpWebRequest]::Create($url)
        $req.UserAgent = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36'
        $req.Referer = 'https://en.wikipedia.org/'
        $req.Timeout = 15000
        $resp = $req.GetResponse()
        $s = $resp.GetResponseStream()
        $fs = [System.IO.File]::Create($file)
        $s.CopyTo($fs)
        $fs.Close()
        $s.Close()
        $resp.Close()
        Write-Host "Downloaded $file ($((Get-Item $file).Length) bytes)"
    } catch {
        Write-Warning "Failed to download $url : $_"
    }
}

Download-Direct 'https://upload.wikimedia.org/wikipedia/commons/thumb/5/5b/Curcuma_longa_roots.jpg/800px-Curcuma_longa_roots.jpg' 'prod-turmeric.jpg'
Download-Direct 'https://upload.wikimedia.org/wikipedia/commons/thumb/b/b3/Jeera_or_Cumin_Seeds.jpg/800px-Jeera_or_Cumin_Seeds.jpg' 'prod-cumin.jpg'
Download-Direct 'https://upload.wikimedia.org/wikipedia/commons/thumb/1/1b/Garlic_cloves_wood.jpg/800px-Garlic_cloves_wood.jpg' 'prod-dehydrated.jpg'
Download-Direct 'https://upload.wikimedia.org/wikipedia/commons/thumb/f/f3/Sesame_seeds.jpg/800px-Sesame_seeds.jpg' 'prod-sesame.jpg'

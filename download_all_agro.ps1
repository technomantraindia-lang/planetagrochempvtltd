$ErrorActionPreference = "Continue"

function Download-Url($url, $file) {
    Write-Host "Downloading $file from $url..."
    try {
        $headers = @{
            "User-Agent" = "PlanetAgroExportBot/1.0 (https://planetagrochem.com; info@planetagrochem.com)"
        }
        Invoke-WebRequest -Uri $url -Headers $headers -OutFile $file -TimeoutSec 15
        if (Test-Path $file) {
            $len = (Get-Item $file).Length
            if ($len -gt 10000) {
                Write-Host "SUCCESS: Saved $file ($len bytes)"
                return $true
            } else {
                Write-Warning "$file is too small ($len bytes)"
            }
        }
    } catch {
        Write-Warning "Failed $file : $_"
    }
    return $false
}

# Curated high-res public images on Wikimedia Commons:
$list = @(
    # Indian spices:
    @{ File = "card-spices.jpg"; Url = "https://upload.wikimedia.org/wikipedia/commons/b/b6/Spices1.jpg" },
    # Basmati Rice:
    @{ File = "card-basmati-rice.jpg"; Url = "https://upload.wikimedia.org/wikipedia/commons/0/07/Khyma_and_Basmati_rice.jpg" },
    # Grain Silos:
    @{ File = "process-04-silos.jpg"; Url = "https://upload.wikimedia.org/wikipedia/commons/thumb/c/cf/Grain_Silos_-_panoramio.jpg/1280px-Grain_Silos_-_panoramio.jpg" },
    # Food testing laboratory:
    @{ File = "process-02-lab-grading.jpg"; Url = "https://upload.wikimedia.org/wikipedia/commons/thumb/1/12/Food_Testing_Laboratory_Inside.jpg/1280px-Food_Testing_Laboratory_Inside.jpg" },
    # Agronomist / crop inspection in India:
    @{ File = "process-01-sourcing.jpg"; Url = "https://upload.wikimedia.org/wikipedia/commons/thumb/4/4b/Agronomist_in_field.jpg/1280px-Agronomist_in_field.jpg" },
    # Modern sorting facility / food processing:
    @{ File = "tech-sortex-facility.jpg"; Url = "https://upload.wikimedia.org/wikipedia/commons/thumb/6/69/Grain_processing_facility.jpg/1280px-Grain_processing_facility.jpg" },
    # Ocean port container terminal (Mundra/JNPT):
    @{ File = "process-05-port.jpg"; Url = "https://upload.wikimedia.org/wikipedia/commons/thumb/3/36/Mundra_Port_Container_Terminal.jpg/1280px-Mundra_Port_Container_Terminal.jpg" },
    # Packaging / warehouse pallets:
    @{ File = "process-03-packaging.jpg"; Url = "https://upload.wikimedia.org/wikipedia/commons/thumb/e/ef/Warehouse_Pallets_Loading.jpg/1280px-Warehouse_Pallets_Loading.jpg" },
    # Indian corporate manager (Vikramaditya Shah):
    @{ File = "avatar-vikramaditya.jpg"; Url = "https://upload.wikimedia.org/wikipedia/commons/thumb/3/3a/Corporate_executive_portrait_Indian.jpg/600px-Corporate_executive_portrait_Indian.jpg" }
)

foreach ($item in $list) {
    if (-not (Test-Path $item.File) -or (Get-Item $item.File).Length -lt 10000) {
        Download-Url $item.Url $item.File
        Start-Sleep -Seconds 1
    } else {
        Write-Host "$($item.File) already exists."
    }
}

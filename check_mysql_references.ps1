# Check and clean up MySQL references
$files = Get-ChildItem -Path . -Filter "*.cs" -Recurse

foreach ($file in $files) {
    $content = Get-Content -Path $file.FullName -Raw
    $modified = $false
    
    # Remove static constructor that initializes MySqlReference
    if ($content -match "static\s+\w+\(\)\s*{\s*//.*MySqlReference") {
        Write-Host "Removing static constructor with MySqlReference in: $($file.Name)"
        $content = [regex]::Replace($content, "static\s+\w+\(\)\s*{\s*//.*MySqlReference.*?\}\s*", "")
        $modified = $true
    }
    
    # Remove direct MySqlReference.Initialize() calls
    if ($content -match "MySqlReference\.Initialize\(\)") {
        Write-Host "Removing MySqlReference.Initialize() call in: $($file.Name)"
        $content = $content -replace "MySqlReference\.Initialize\(\);", ""
        $content = $content -replace "// Ensure MySQL is loaded\s+MySqlReference\.Initialize\(\);", ""
        $modified = $true
    }
    
    # Save if modified
    if ($modified) {
        Write-Host "Saving modified file: $($file.Name)"
        Set-Content -Path $file.FullName -Value $content
    }
}

Write-Host "MySQL reference cleanup complete" 
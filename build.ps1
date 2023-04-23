[CmdletBinding()]
param (
    [Parameter()]
    [string]
    $Source = "E:\Documents\Data\Code\Repos\Portfolios\hugo-portfolio\public",
    
    [Parameter()]
    [string]
    $Destination = "\\192.168.1.3\appdata\swag\www\portfolio"
)

$remote = "192.168.1.3"

if ([bool](Test-Connection $remote -Quiet -Count 1)) {
    <# build hugo static files #>
    try {
        hugo -D
    }
    catch {
        Write-Error "Failed to build hugo site" -ErrorAction Stop
    }
    
  <#   if(Test-Path -Path $Destination){
        try {
            Remove-Item -Path "$Destination" -Force -recurse -Verbose
        }
        catch {
            Write-Error "Failed to clean up $Destination" -ErrorAction Stop
        }    
    } #>

    <# Move files to remote #>
    try {
        Copy-Item -Path $Source -Destination $Destination -Force -Recurse -Verbose
    }
    catch {
        Write-Error "Failed to move docs from $source to $destination Error: $_" -ErrorAction Stop
    }
}
else {
    Write-Error "Failed to connect to $remote" -ErrorAction stop
}

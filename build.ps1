[CmdletBinding(DefaultParameterSetName = 'Build')]
param (
    [Parameter(ParameterSetName = 'Build')]
    [switch]$Build,

    [Parameter(ParameterSetName = 'Watch')]
    [switch]$Watch,

    [Parameter(ParameterSetName = 'ProfilePreview')]
    [switch]$ProfilePreview,

    [Alias('DeployProfile')]
    [Parameter(ParameterSetName = 'Deploy')]
    [switch]$Deploy,

    [string]$Destination = "\\unraid.lan\appdata\swag\www\portfolio\docs"
)

$hugoCommand = Get-Command hugo -CommandType Application -ErrorAction SilentlyContinue
$hugoPath = if ($hugoCommand) { $hugoCommand.Source }
else {
    $wingetPackages = Join-Path $env:LOCALAPPDATA 'Microsoft\WinGet\Packages'
    $hugoPackage = Get-ChildItem -LiteralPath $wingetPackages -Directory -Filter 'Hugo.Hugo.Extended_*' -ErrorAction SilentlyContinue |
        Select-Object -First 1
    if ($hugoPackage) {
        $candidate = Join-Path $hugoPackage.FullName 'hugo.exe'
        if (Test-Path -LiteralPath $candidate -PathType Leaf) {
            $candidate
        }
    }
}

if (-not $hugoPath) {
    throw "Hugo was not found. Install Hugo and ensure it is available on PATH."
}

if ($PSCmdlet.ParameterSetName -eq 'Watch') {
    & $hugoPath server --source $PSScriptRoot --config (Join-Path $PSScriptRoot 'hugo-profile.yaml') --baseURL 'http://localhost:1313/' -D --renderToMemory --bind 127.0.0.1 --port 1313
    if ($LASTEXITCODE -ne 0) {
        throw "Hugo Profile preview server exited with code $LASTEXITCODE."
    }
    return
}

if ($PSCmdlet.ParameterSetName -eq 'ProfilePreview') {
    & $hugoPath server --source $PSScriptRoot --config (Join-Path $PSScriptRoot 'hugo-profile.yaml') -D --renderToMemory --bind 127.0.0.1 --port 1314
    if ($LASTEXITCODE -ne 0) {
        throw "Hugo Profile preview server exited with code $LASTEXITCODE."
    }
    return
}

$hugoArguments = @(
    '--source', $PSScriptRoot,
    '--config', (Join-Path $PSScriptRoot 'hugo-profile.yaml'),
    '--baseURL', 'https://michaelhanson.dev/',
    '--cleanDestinationDir'
)
$deployProfile = $PSCmdlet.ParameterSetName -eq 'Deploy'

& $hugoPath @hugoArguments
if ($LASTEXITCODE -ne 0) {
    throw "Hugo build failed with exit code $LASTEXITCODE."
}

if ($deployProfile) {
    $outputDirectory = Join-Path $PSScriptRoot 'docs'
    if (-not (Test-Path -LiteralPath $outputDirectory -PathType Container)) {
        throw "Hugo output directory was not found: $outputDirectory"
    }

    try {
        New-Item -ItemType Directory -Path $Destination -Force -ErrorAction Stop | Out-Null
        Get-ChildItem -LiteralPath $outputDirectory -Force -ErrorAction Stop |
            ForEach-Object {
                Copy-Item -LiteralPath $_.FullName -Destination $Destination -Recurse -Force -ErrorAction Stop
            }
    }
    catch {
        throw "Failed to copy Hugo output from '$outputDirectory' to '$Destination': $_"
    }

    Write-Host "Deployed Hugo output from '$outputDirectory' to '$Destination'"
}

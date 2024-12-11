param(
    [string]$TargetServer = $env:COMPUTERNAME,
    [string]$DownloadPath = "C:\SQLServerSetup",
    [string]$Edition = "Developer",
    [string]$InstanceName = "MSSQLSERVER",
    [string]$SAPassword = "Test@123"
)

function Download-SQLServer {
    if (-not (Test-Path $DownloadPath)) {
        New-Item -ItemType Directory -Path $DownloadPath | Out-Null
    }

    $downloadUrl = "https://go.microsoft.com/fwlink/p/?linkid=2215158&clcid=0x409&culture=en-us&country=us"
    $setupFile = "$DownloadPath\SQL2022-SSEI-Dev.exe"

    Write-Host "Downloading SQL Server installation media..."
    Invoke-WebRequest -Uri $downloadUrl -OutFile $setupFile

    return $setupFile
}

function Create-ConfigurationFile {
    $configFile = @"
[OPTIONS]
ACTION="Install"
IACCEPTSQLSERVERLICENSETERMS="True"
FEATURES=SQLENGINE,CONN,SSMS
INSTANCENAME="$InstanceName"
SQLSVCACCOUNT="NT Service\MSSQLSERVER"
SQLSYSADMINACCOUNTS="BUILTIN\Administrators"
SECURITYMODE="SQL"
SAPWD="$SAPassword"
SQLCOLLATION="SQL_Latin1_General_CP1_CI_AS"
"@

    $configPath = "$DownloadPath\ConfigurationFile.ini"
    $configFile | Out-File -FilePath $configPath -Encoding UTF8
    return $configPath
}

try {
    $setupFile = Download-SQLServer
    $configFile = Create-ConfigurationFile

    Write-Host "Extracting SQL Server installation files..."
    Start-Process -FilePath $setupFile -ArgumentList "/action=Download /MediaPath=$DownloadPath /MediaType=ISO /Quiet" -Wait

    $isoFile = Get-ChildItem -Path $DownloadPath -Filter "*.iso" | Select-Object -First 1
    $mountResult = Mount-DiskImage -ImagePath $isoFile.FullName -PassThru
    $driveLetter = ($mountResult | Get-Volume).DriveLetter

    Write-Host "Starting SQL Server installation..."
    $setupPath = "${driveLetter}:\setup.exe"
    $arguments = "/ConfigurationFile=$configFile /IAcceptSQLServerLicenseTerms"
    
    Start-Process -FilePath $setupPath -ArgumentList $arguments -Wait -NoNewWindow

    Dismount-DiskImage -ImagePath $isoFile.FullName
    
    Write-Host "Installing SQL Server PowerShell module..."
    Install-Module -Name SqlServer -Force -AllowClobber

    Write-Host "SQL Server installation completed successfully!"
}
catch {
    Write-Error "An error occurred: $_"
}

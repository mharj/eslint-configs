<#
Invoke-WebRequest -URI  'https://raw.githubusercontent.com/mharj/eslint-configs/main/AvanioDeveloper.psm1' -OutFile ( New-Item -Force -Path "$env:USERPROFILE\Documents\PowerShell\Modules\AvanioDeveloper\AvanioDeveloper.psm1" )
 #>

function Setup-Eslint {
    param (
        [ValidateSet("backend")]
        [string] $type
    )
    switch ($type)
    {
        "backend" {
            Write-Output "Download typescript-backend.ps1 from github"
            Invoke-WebRequest -URI  'https://raw.githubusercontent.com/mharj/eslint-configs/main/typescript-backend.ps1' -OutFile "$env:TEMP\typescript-backend.ps1"
            Write-Output "Run typescript-backend.ps1"
            . "$env:TEMP\typescript-backend.ps1"
        }
    }
}

Export-ModuleMember -Function Setup-Eslint

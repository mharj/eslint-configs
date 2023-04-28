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
            $file = "typescript-backend-eslint.ps1"
            Write-Output "Download $file from github"
            Invoke-WebRequest -URI  "https://raw.githubusercontent.com/mharj/eslint-configs/main/$file" -OutFile "$env:TEMP\$file"
            Write-Output "Run $file"
            . "$env:TEMP\$file"
        }
    }
}

Export-ModuleMember -Function Setup-Eslint

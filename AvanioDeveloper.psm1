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
            $file = "typescript-backend-eslintrc.ps1"
            $url = "https://raw.githubusercontent.com/mharj/eslint-configs/main/$file"
            $tmpFile = "$env:TEMP\$file"
            Write-Output "Download $url => $tmpFile"
            Invoke-WebRequest -URI  $url -OutFile $tmpFile
            Write-Output "Run $tmpFile"
            . $tmpFile
        }
    }
}

function Setup-Typescript {
    param (
        [ValidateSet("backend")]
        [string] $type
    )
    switch ($type)
    {
        "backend" {
            $file = "typescript-backend.ps1"
            $url = "https://raw.githubusercontent.com/mharj/eslint-configs/main/$file"
            $tmpFile = "$env:TEMP\$file"
            Write-Output "Download $url => $tmpFile"
            Invoke-WebRequest -URI  $url -OutFile $tmpFile
            Write-Output "Run $tmpFile"
            . $tmpFile
        }
    }
}

Export-ModuleMember -Function Setup-Eslint

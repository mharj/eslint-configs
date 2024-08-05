$NpmCmd = "npm"
if (-not(Test-Path 'package.json')) {
  Write-Output "package.json not found, not valid node project!"
  return
}
# check if pnpm-lock.yaml exists and change npm command to pnpm
if (Test-Path 'pnpm-lock.yaml') {
  $NpmCmd = "pnpm"
}

$BackendPackageList = @(
  "typescript",
  "@types/node",
  "ts-node",
  "source-map-support"
)

Write-Output "setup ${type} typescript"
Write-Output "install typescript packages"
Invoke-Expression "$NpmCmd i -D $($BackendPackageList -join ' ')"
# update gitattributes
Invoke-WebRequest -URI 'https://raw.githubusercontent.com/mharj/eslint-configs/main/git/gitattributes_nodejs' -OutFile '.gitattributes'
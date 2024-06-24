$NpmCmd = "npm"
if (-not(Test-Path 'package.json')) {
  Write-Output "package.json not found, not valid node project!"
  return
}
# check if pnpm-lock.yaml exists and change npm command to pnpm
if (Test-Path 'pnpm-lock.yaml') {
  $NpmCmd = "pnpm"
}
Write-Output "setup ${type} eslint"
Write-Output "download eslint-configs template from github"
Invoke-WebRequest -URI 'https://raw.githubusercontent.com/mharj/eslint-configs/main/typescript-backend-eslintrc.json' -OutFile '.eslintrc.json'
Write-Output "install eslint packages"
Invoke-Expression "$NpmCmd i -D eslint@8 eslint-config-standard prettier eslint-config-prettier eslint-plugin-deprecation eslint-plugin-prettier eslint-plugin-sonarjs@0.23 @typescript-eslint/parser @typescript-eslint/eslint-plugin @stylistic/eslint-plugin"
if (-not(Test-Path 'tsconfig.test.json')) {
  Write-Output "tsconfig.test.json not found, eslint needs it to work properly!"
  return
}

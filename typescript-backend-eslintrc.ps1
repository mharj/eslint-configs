if (-not(Test-Path 'package.json')) {
  Write-Output "package.json not found, not valid node project!"
  return
}
Write-Output "setup ${type} eslint"
Write-Output "download eslint-configs template from github"
Invoke-WebRequest -URI 'https://raw.githubusercontent.com/mharj/eslint-configs/main/typescript-backend-eslintrc.json' -OutFile '.eslintrc.json'
Write-Output "install eslint packages"
npm i -D eslint eslint-config-standard prettier@^3 eslint-config-prettier eslint-plugin-deprecation eslint-plugin-prettier@alpha eslint-plugin-sonarjs @typescript-eslint/parser @typescript-eslint/eslint-plugin
if (-not(Test-Path 'tsconfig.test.json')) {
  Write-Output "tsconfig.test.json not found, eslint needs it to work properly!"
  return
}

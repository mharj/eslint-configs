if (-not(Test-Path 'package.json')) {
  Write-Output "package.json not found, not valid node project!"
  return
}
Write-Output "setup ${type} eslint"
if (-not(Test-Path '.eslintrc.json')) {
  Write-Output "download eslint-configs template from github"
  Invoke-WebRequest -URI 'https://raw.githubusercontent.com/mharj/eslint-configs/main/typescript-frontend-eslintrc.json' -OutFile '.eslintrc.json'
}
else {
  Write-Output ".eslintrc.json already exists, skipping download"
}
Write-Output "install eslint packages"
npm i -D eslint eslint-config-standard prettier eslint-config-prettier eslint-plugin-deprecation eslint-plugin-prettier eslint-plugin-sonarjs @typescript-eslint/parser@^5.5 @typescript-eslint/eslint-plugin@^5.5
if (-not(Test-Path 'tsconfig.test.json')) {
  Write-Output "tsconfig.test.json not found, eslint needs it to work properly!"
  return
}

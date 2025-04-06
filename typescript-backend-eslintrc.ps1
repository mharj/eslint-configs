$NpmCmd = "npm"

function RemoveDevDependency {
  param (
    [string] $key
  )
  Write-Output "remove package.json:devDependencies $key"
  $content = Get-Content "package.json" | ConvertFrom-Json -Depth 99
  $content.devDependencies = $content.devDependencies | Select-Object -ExcludeProperty $key
  $content | ConvertTo-Json -Depth 99 | Set-Content "package.json"
}

function SetEslintRule {
  param (
    [string] $key,
    [string] $rule
  )
  if (-not(Test-Path '.eslintrc.json')) {
    Write-Output "eslintrc.json not found!"
    return
  }
  Write-Output "set eslintrc.json:rules $key : $rule"
  $content = Get-Content ".eslintrc.json" | ConvertFrom-Json -Depth 99
  $content.rules = $content.rules | Select-Object -ExcludeProperty $key
  $content.rules | Add-Member -Type NoteProperty -Name "$key" -Value "$value"
  $content | ConvertTo-Json -Depth 99 | Set-Content ".eslintrc.json"
}

function RemoveEslintRule {
  param (
    [string] $key
  )
  if (-not(Test-Path '.eslintrc.json')) {
    Write-Output "eslintrc.json not found!"
    return
  }
  Write-Output "remove eslintrc.json:rules $key"
  $content = Get-Content ".eslintrc.json" | ConvertFrom-Json -Depth 99
  $content.rules = $content.rules | Select-Object -ExcludeProperty $key
  $content | ConvertTo-Json -Depth 99 | Set-Content ".eslintrc.json"
}

function RemoveEslintPlugin {
  param (
    [string] $key
  )
  if (-not(Test-Path '.eslintrc.json')) {
    Write-Output "eslintrc.json not found!"
    return
  }
  Write-Output "remove eslintrc.json:plugins $key"
  $content = Get-Content ".eslintrc.json" | ConvertFrom-Json -Depth 99
  $content.plugins = $content.plugins | Where-Object { $_ -ne $key }
  $content | ConvertTo-Json -Depth 99 | Set-Content ".eslintrc.json"
}

if (-not(Test-Path 'package.json')) {
  Write-Output "package.json not found, not valid node project!"
  return
}
# check if pnpm-lock.yaml exists and change npm command to pnpm
if (Test-Path 'pnpm-lock.yaml') {
  $NpmCmd = "pnpm"
}
Write-Output "setup ${type} eslint 9"
if (-not(Test-Path 'eslint.config.mjs')) {
  Write-Output "download eslint-configs template from github"
  Invoke-WebRequest -URI 'https://raw.githubusercontent.com/mharj/eslint-configs/main/typescript-backend-eslint.config.mjs' -OutFile 'eslint.config.mjs'
}
else {
  Write-Output "eslint.config.mjs already exists (ignored)"
}
Write-Output "install eslint packages"

$EslintPackageList = @(
  "@cspell/eslint-plugin",
  "@eslint/js",
  "@stylistic/eslint-plugin",
  "@stylistic/eslint-plugin-ts",
  "@typescript-eslint/eslint-plugin",
  "@typescript-eslint/parser",
  "eslint",
  "eslint-config-prettier",
  "eslint-import-resolver-typescript",
  "eslint-plugin-import",
  "eslint-plugin-jsdoc",
  "eslint-plugin-prettier",
  "eslint-plugin-sonarjs",
  "prettier",
  "typescript-eslint"
)

Invoke-Expression "$NpmCmd update -D $($EslintPackageList -join ' ')"
if (-not(Test-Path 'tsconfig.test.json')) {
  Write-Output "tsconfig.test.json not found, eslint needs it to work properly!"
  return
}

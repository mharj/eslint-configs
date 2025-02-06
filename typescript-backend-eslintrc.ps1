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
  $content.rules.$key = $rule
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
Write-Output "setup ${type} eslint"
if (-not(Test-Path '.eslintrc.json')) {
  Write-Output "download eslint-configs template from github"
  Invoke-WebRequest -URI 'https://raw.githubusercontent.com/mharj/eslint-configs/main/typescript-backend-eslintrc.json' -OutFile '.eslintrc.json'
}
else {
  Write-Output ".eslintrc.json already exists, try to modify"
  Write-Output "remove deprecation rule and use @typescript-eslint/no-deprecated"
  RemoveEslintRule -key "deprecation/deprecation"
  RemoveEslintPlugin -key "deprecation"
  SetEslintRule -key "@typescript-eslint/no-deprecated" -rule "warn"
  RemoveDevDependency -key "eslint-plugin-deprecation"
}
Write-Output "install eslint packages"

$EslintPackageList = @(
  "eslint@^8",
  "eslint-config-standard",
  "prettier",
  "eslint-config-prettier",
  "eslint-plugin-prettier",
  "eslint-plugin-sonarjs@^0",
  "@typescript-eslint/parser",
  "@typescript-eslint/eslint-plugin",
  "@stylistic/eslint-plugin",
  "@stylistic/eslint-plugin-ts",
  "eslint-import-resolver-typescript",
  "eslint-plugin-import"
)

Invoke-Expression "$NpmCmd update -D $($EslintPackageList -join ' ')"
if (-not(Test-Path 'tsconfig.test.json')) {
  Write-Output "tsconfig.test.json not found, eslint needs it to work properly!"
  return
}

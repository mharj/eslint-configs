if (-not(Test-Path 'package.json')) {
  Write-Output "package.json not found, not valid node project!"
  return
}
Write-Output "setup ${type} typescript"
Write-Output "install typescript packages"
npm i -D typescript @types/node ts-node source-map-support

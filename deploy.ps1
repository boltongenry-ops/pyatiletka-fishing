# Обновление сайта 5letka.ru (хостинг: Netlify)
# Запуск: powershell -ExecutionPolicy Bypass -File .\deploy.ps1

$ErrorActionPreference = "Stop"
Set-Location -Path $PSScriptRoot

$SiteId = "51074f58-7bb1-4321-b10a-292cd461c138"
$NetlifyConfig = "$env:APPDATA\netlify\Config\config.json"

Write-Host "[1/3] Собираю чистую папку dist..." -ForegroundColor Cyan
$dist = "dist"
if (Test-Path $dist) { Remove-Item $dist -Recurse -Force }
New-Item -ItemType Directory -Path $dist | Out-Null

$files = @(
    "index.html",
    "favicon.png",
    "favicon.svg",
    "hero.jpg",
    "logo.jpg",
    "manifest.json",
    "robots.txt",
    "sitemap.xml",
    "og-image.svg",
    "og-preview-logo-v2.png",
    "og-preview-v2.png",
    "og-preview.png",
    "yandex_39660ec223c634cf.html"
)

foreach ($f in $files) {
    if (Test-Path $f) { Copy-Item $f -Destination $dist } else { Write-Host "  Пропуск (нет файла): $f" -ForegroundColor Yellow }
}
Copy-Item "gallery-*.jpg" -Destination $dist

Write-Host "[2/3] Упаковываю в архив..." -ForegroundColor Cyan
if (Test-Path dist.zip) { Remove-Item dist.zip -Force }
Compress-Archive -Path "dist\*" -DestinationPath dist.zip -Force

Write-Host "[3/3] Публикую на Netlify..." -ForegroundColor Cyan
$cfg = Get-Content $NetlifyConfig -Raw | ConvertFrom-Json
$token = ($cfg.users.PSObject.Properties | Select-Object -First 1).Value.auth.token
if (-not $token) { throw "Не найден токен Netlify. Выполните: npx netlify-cli login" }

$resp = Invoke-RestMethod -Method Post -Uri "https://api.netlify.com/api/v1/sites/$SiteId/deploys" `
    -Headers @{ Authorization = "Bearer $token" } -ContentType "application/zip" -InFile "dist.zip"

Write-Host ("Деплой отправлен: " + $resp.id) -ForegroundColor Green
Write-Host "Готово! Через 10-20 секунд изменения появятся на https://5letka.ru" -ForegroundColor Green

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
Copy-Item "assets" -Destination $dist -Recurse -Force

Write-Host "[2/3] Упаковываю в архив..." -ForegroundColor Cyan
if (Test-Path dist.zip) { Remove-Item dist.zip -Force }
python zip_dist.py

Write-Host "[3/3] Публикую на Firebase Hosting..." -ForegroundColor Cyan
npx --yes firebase-tools@latest deploy --only hosting --project pyatiletka-fishing

Write-Host "Готово! Через 10-20 секунд изменения появятся на https://5letka.ru" -ForegroundColor Green

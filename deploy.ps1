# Обновление сайта 5letka.ru (Cloudflare)
# Запуск: powershell -ExecutionPolicy Bypass -File .\deploy.ps1

$ErrorActionPreference = "Stop"
Set-Location -Path $PSScriptRoot

Write-Host "[1/2] Собираю чистую папку dist..." -ForegroundColor Cyan
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

Write-Host "[2/2] Публикую на Cloudflare (5letka.ru)..." -ForegroundColor Cyan
npx --yes wrangler@latest deploy

Write-Host "Готово! Проверь https://5letka.ru (может понадобиться 10-20 секунд)." -ForegroundColor Green

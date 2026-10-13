"""Упаковка папки dist в zip с ПРАВИЛЬНЫМИ путями (прямые слэши).

PowerShell-овский Compress-Archive на Windows пишет пути с обратными
слэшами, из-за чего Netlify не видит вложенные папки (assets/...).
"""
import os
import zipfile

SRC = "dist"
OUT = "dist.zip"

with zipfile.ZipFile(OUT, "w", zipfile.ZIP_DEFLATED) as z:
    for root, _dirs, files in os.walk(SRC):
        for name in files:
            full = os.path.join(root, name)
            arc = os.path.relpath(full, SRC).replace(os.sep, "/")
            z.write(full, arc)

count = 0
with zipfile.ZipFile(OUT) as z:
    count = len(z.namelist())
    names = z.namelist()[:5]

print(f"OK: {count} файлов в {OUT}")
for n in names:
    print("  " + n)

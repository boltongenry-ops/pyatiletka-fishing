from PIL import Image, ImageOps
import os

# файл: (лимит по большей стороне, качество JPEG)
jobs = {
    "gallery-1.jpg": (1400, 80),
    "gallery-2.jpg": (1400, 80),
    "gallery-3.jpg": (1600, 80),   # фон первого экрана
    "logo.jpg": (512, 88),
}

for f, (limit, q) in jobs.items():
    if not os.path.exists(f):
        print(f, "MISSING")
        continue
    before = os.path.getsize(f)
    im = ImageOps.exif_transpose(Image.open(f))
    w, h = im.size
    scale = limit / max(w, h)
    if scale < 1:
        im = im.resize((max(1, int(w * scale)), max(1, int(h * scale))), Image.LANCZOS)
    im = im.convert("RGB")
    im.save(f, "JPEG", quality=q, optimize=True, progressive=True)
    after = os.path.getsize(f)
    print(f"{f:<16} {im.size[0]}x{im.size[1]:<5} {before//1024:>5} KB -> {after//1024:>4} KB")

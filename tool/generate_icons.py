# Generates the placeholder app icon (see docs/product/BRAND.md for the brief).
# Usage: python3 tool/generate_icons.py <repo root>   (requires Pillow)
from PIL import Image, ImageDraw
import os, sys
root = sys.argv[1]
S = 1024
def make(size, rounded=False):
    k = 4  # supersample
    W = S * k
    im = Image.new('RGBA', (W, W), (31, 90, 166, 255))  # brand blue, full bleed (iOS requires opaque square)
    d = ImageDraw.Draw(im)
    u = W / 1024
    white = (255, 255, 255, 255)
    # House outline
    lw = int(56 * u)
    roof = [(212*u, 500*u), (512*u, 230*u), (812*u, 500*u)]
    d.line(roof, fill=white, width=lw, joint='curve')
    d.line([(292*u, 450*u), (292*u, 800*u), (732*u, 800*u), (732*u, 450*u)], fill=white, width=lw, joint='curve')
    # Check mark inside
    green = (126, 214, 154, 255)
    d.line([(390*u, 600*u), (475*u, 690*u), (640*u, 505*u)], fill=green, width=int(64*u), joint='curve')
    for x, y in [(212,500),(812,500),(512,230),(292,800),(732,800)]:
        r = lw/2
        d.ellipse([x*u-r, y*u-r, x*u+r, y*u+r], fill=white)
    for x, y in [(390,600),(640,505)]:
        r = 32*u
        d.ellipse([x*u-r, y*u-r, x*u+r, y*u+r], fill=green)
    im = im.resize((size, size), Image.LANCZOS)
    if rounded:
        mask = Image.new('L', (size, size), 0)
        ImageDraw.Draw(mask).ellipse([0, 0, size - 1, size - 1], fill=255)
        out = Image.new('RGBA', (size, size), (0, 0, 0, 0))
        out.paste(im, (0, 0), mask)
        return out
    return im.convert('RGB')

ios = os.path.join(root, 'ios/Runner/Assets.xcassets/AppIcon.appiconset')
for f in os.listdir(ios):
    if f.endswith('.png'):
        base = f[len('Icon-App-'):-4]
        dim, scale = base.split('@')
        px = round(float(dim.split('x')[0]) * int(scale[0]))
        make(px).save(os.path.join(ios, f))
android = {'mdpi': 48, 'hdpi': 72, 'xhdpi': 96, 'xxhdpi': 144, 'xxxhdpi': 192}
for k, px in android.items():
    make(px, rounded=True).save(os.path.join(root, f'android/app/src/main/res/mipmap-{k}/ic_launcher.png'))
os.makedirs(os.path.join(root, 'release/assets'), exist_ok=True)
make(1024).save(os.path.join(root, 'release/assets/icon-1024.png'))
make(512).save(os.path.join(root, 'release/assets/play-icon-512.png'))
print('ok')

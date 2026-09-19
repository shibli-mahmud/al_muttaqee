"""Generates the app icon, the adaptive-icon layers and the splash mark.

Run from the repo root:

    python tool/branding/build_brand_assets.py

The mark is the one already on onboarding frame ০৯: a gold rounded square
carrying a crescent and star, on the deep-teal khatim ground. The design brief
rules out mosque imagery and illustration — geometry and type only — so the
icon is drawn from the same primitives as the app's hero: the gradient, the
khatim tile, and one gold form.

Everything is drawn with Pillow rather than traced from art, so a palette
change is a one-line edit here and a re-run, not a round trip to a designer.
"""

from __future__ import annotations

import json
import math
from pathlib import Path

from PIL import Image, ImageDraw

ROOT = Path(__file__).resolve().parents[2]
ANDROID_RES = ROOT / "android" / "app" / "src" / "main" / "res"
IOS_ICONS = (
    ROOT / "ios" / "Runner" / "Assets.xcassets" / "AppIcon.appiconset"
)
ASSETS = ROOT / "assets" / "images"

# ── Dusk palette ────────────────────────────────────────────────────────────
DUSK_DEEP = (0x06, 0x31, 0x2F, 255)
DUSK_MID = (0x0B, 0x4A, 0x45, 255)
DUSK_LIGHT = (0x14, 0x65, 0x5A, 255)
GOLD = (0xC9, 0xA2, 0x27, 255)
GOLD_INK = (0x24, 0x1A, 0x00, 255)
ON_DEEP = (0xF5, 0xEF, 0xE1, 255)
IVORY = (0xFB, 0xF8, 0xF3, 255)

# Supersampling factor. Everything is drawn large and downsampled, because
# Pillow has no antialiased primitives.
SS = 8


def gradient(size: int) -> Image.Image:
    """The hero gradient, running top-left to bottom-right at about 165°."""
    image = Image.new("RGBA", (size, size))
    pixels = image.load()
    for y in range(size):
        for x in range(size):
            # Project onto the gradient axis, normalised to 0..1.
            t = (x * 0.35 + y) / (size * 1.35)
            t = min(max(t, 0.0), 1.0)
            if t < 0.55:
                u = t / 0.55
                a, b = DUSK_DEEP, DUSK_MID
            else:
                u = (t - 0.55) / 0.45
                a, b = DUSK_MID, DUSK_LIGHT
            pixels[x, y] = tuple(
                int(a[i] + (b[i] - a[i]) * u) for i in range(4)
            )
    return image


def khatim(size: int, opacity: float = 0.13) -> Image.Image:
    """The tiled eight-point star, as the heroes wear it."""
    layer = Image.new("RGBA", (size, size), (0, 0, 0, 0))
    draw = ImageDraw.Draw(layer)

    tile = max(size // 7, 8)
    inset = tile / 4
    side = tile / 2
    width = max(int(tile * 0.02), 1)
    ink = ON_DEEP[:3] + (int(255 * opacity),)

    for row in range(-1, size // tile + 2):
        for column in range(-1, size // tile + 2):
            ox, oy = column * tile, row * tile
            box = [
                (ox + inset, oy + inset),
                (ox + inset + side, oy + inset),
                (ox + inset + side, oy + inset + side),
                (ox + inset, oy + inset + side),
            ]
            draw.polygon(box, outline=ink, width=width)

            cx, cy = ox + tile / 2, oy + tile / 2
            rotated = []
            for px, py in box:
                dx, dy = px - cx, py - cy
                angle = math.pi / 4
                rotated.append(
                    (
                        cx + dx * math.cos(angle) - dy * math.sin(angle),
                        cy + dx * math.sin(angle) + dy * math.cos(angle),
                    )
                )
            draw.polygon(rotated, outline=ink, width=width)

    return layer


def crescent_and_star(size: int, colour) -> Image.Image:
    """A crescent with a five-pointed star, drawn as pure geometry.

    The crescent is the difference of two circles; the star is a ten-point
    polygon. Both are supersampled and downsampled for clean edges.
    """
    s = size * SS
    layer = Image.new("RGBA", (s, s), (0, 0, 0, 0))

    outer = Image.new("L", (s, s), 0)
    ImageDraw.Draw(outer).ellipse(
        [s * 0.10, s * 0.10, s * 0.82, s * 0.82], fill=255
    )

    cut = Image.new("L", (s, s), 0)
    ImageDraw.Draw(cut).ellipse(
        [s * 0.30, s * 0.05, s * 1.02, s * 0.77], fill=255
    )

    mask = Image.new("L", (s, s), 0)
    mask.paste(outer, (0, 0))
    # Subtract the offset circle to leave the crescent.
    mask_pixels = mask.load()
    cut_pixels = cut.load()
    for y in range(s):
        for x in range(s):
            if cut_pixels[x, y]:
                mask_pixels[x, y] = 0

    layer.paste(colour, (0, 0), mask)

    # The star sits in the crescent's opening.
    star = Image.new("L", (s, s), 0)
    star_draw = ImageDraw.Draw(star)
    cx, cy, r = s * 0.70, s * 0.30, s * 0.115
    points = []
    for i in range(10):
        angle = -math.pi / 2 + i * math.pi / 5
        radius = r if i % 2 == 0 else r * 0.42
        points.append((cx + radius * math.cos(angle),
                       cy + radius * math.sin(angle)))
    star_draw.polygon(points, fill=255)
    layer.paste(colour, (0, 0), star)

    return layer.resize((size, size), Image.LANCZOS)


def rounded_square(size: int, radius_ratio: float, colour) -> Image.Image:
    s = size * SS
    layer = Image.new("RGBA", (s, s), (0, 0, 0, 0))
    ImageDraw.Draw(layer).rounded_rectangle(
        [0, 0, s - 1, s - 1], radius=int(s * radius_ratio), fill=colour
    )
    return layer.resize((size, size), Image.LANCZOS)


def build_icon(size: int, *, safe: float = 1.0) -> Image.Image:
    """The full icon.

    [safe] shrinks the mark for adaptive icons, whose foreground layer is
    cropped to a circle by the launcher — anything past the inner 66% can be
    cut off.
    """
    canvas = gradient(size)
    canvas.alpha_composite(khatim(size, 0.15))

    plate = int(size * 0.58 * safe)
    mark = rounded_square(plate, 0.30, GOLD)

    glyph_size = int(plate * 0.62)
    glyph = crescent_and_star(glyph_size, GOLD_INK)
    mark.alpha_composite(
        glyph,
        ((plate - glyph_size) // 2, (plate - glyph_size) // 2),
    )

    canvas.alpha_composite(mark, ((size - plate) // 2, (size - plate) // 2))
    return canvas


def build_foreground(size: int) -> Image.Image:
    """The adaptive-icon foreground: the mark alone, on transparency."""
    canvas = Image.new("RGBA", (size, size), (0, 0, 0, 0))
    plate = int(size * 0.42)
    mark = rounded_square(plate, 0.30, GOLD)

    glyph_size = int(plate * 0.62)
    glyph = crescent_and_star(glyph_size, GOLD_INK)
    mark.alpha_composite(
        glyph,
        ((plate - glyph_size) // 2, (plate - glyph_size) // 2),
    )

    canvas.alpha_composite(mark, ((size - plate) // 2, (size - plate) // 2))
    return canvas


def build_background(size: int) -> Image.Image:
    canvas = gradient(size)
    canvas.alpha_composite(khatim(size, 0.15))
    return canvas


def build_splash(size: int) -> Image.Image:
    """The splash mark: the same plate, on ivory, for the launch screen."""
    canvas = Image.new("RGBA", (size, size), (0, 0, 0, 0))
    plate = int(size * 0.72)
    mark = rounded_square(plate, 0.30, GOLD)

    glyph_size = int(plate * 0.62)
    glyph = crescent_and_star(glyph_size, GOLD_INK)
    mark.alpha_composite(
        glyph,
        ((plate - glyph_size) // 2, (plate - glyph_size) // 2),
    )
    canvas.alpha_composite(mark, ((size - plate) // 2, (size - plate) // 2))
    return canvas


ANDROID_DENSITIES = {
    "mdpi": 48,
    "hdpi": 72,
    "xhdpi": 96,
    "xxhdpi": 144,
    "xxxhdpi": 192,
}

# Every slot iOS asks for, keyed by the file name already in the asset set.
IOS_SIZES = {
    "Icon-App-20x20@1x.png": 20,
    "Icon-App-20x20@2x.png": 40,
    "Icon-App-20x20@3x.png": 60,
    "Icon-App-29x29@1x.png": 29,
    "Icon-App-29x29@2x.png": 58,
    "Icon-App-29x29@3x.png": 87,
    "Icon-App-40x40@1x.png": 40,
    "Icon-App-40x40@2x.png": 80,
    "Icon-App-40x40@3x.png": 120,
    "Icon-App-60x60@2x.png": 120,
    "Icon-App-60x60@3x.png": 180,
    "Icon-App-76x76@1x.png": 76,
    "Icon-App-76x76@2x.png": 152,
    "Icon-App-83.5x83.5@2x.png": 167,
    "Icon-App-1024x1024@1x.png": 1024,
}


def main() -> None:
    print("drawing the master icon …", flush=True)
    master = build_icon(1024)
    ASSETS.mkdir(parents=True, exist_ok=True)
    master.save(ASSETS / "app_icon.png")

    print("android launcher icons …", flush=True)
    for density, size in ANDROID_DENSITIES.items():
        folder = ANDROID_RES / f"mipmap-{density}"
        folder.mkdir(parents=True, exist_ok=True)
        master.resize((size, size), Image.LANCZOS).save(
            folder / "ic_launcher.png"
        )
        build_foreground(size * 2).save(folder / "ic_launcher_foreground.png")
        build_background(size * 2).save(folder / "ic_launcher_background.png")

    print("android adaptive icon …", flush=True)
    anydpi = ANDROID_RES / "mipmap-anydpi-v26"
    anydpi.mkdir(parents=True, exist_ok=True)
    adaptive = (
        '<?xml version="1.0" encoding="utf-8"?>\n'
        '<adaptive-icon xmlns:android="http://schemas.android.com/apk/res/android">\n'
        '    <background android:drawable="@mipmap/ic_launcher_background" />\n'
        '    <foreground android:drawable="@mipmap/ic_launcher_foreground" />\n'
        '    <monochrome android:drawable="@mipmap/ic_launcher_foreground" />\n'
        "</adaptive-icon>\n"
    )
    (anydpi / "ic_launcher.xml").write_text(adaptive, encoding="utf-8")
    (anydpi / "ic_launcher_round.xml").write_text(adaptive, encoding="utf-8")

    print("ios app icons …", flush=True)
    if IOS_ICONS.exists():
        for name, size in IOS_SIZES.items():
            # iOS rejects alpha in app icons, so these are flattened.
            flat = Image.new("RGB", (size, size), DUSK_DEEP[:3])
            flat.paste(
                master.resize((size, size), Image.LANCZOS),
                (0, 0),
                master.resize((size, size), Image.LANCZOS),
            )
            flat.save(IOS_ICONS / name)

    print("splash mark …", flush=True)
    for scale, suffix in ((1, ""), (2, "@2x"), (3, "@3x")):
        build_splash(240 * scale).save(ASSETS / f"splash_mark{suffix}.png")

    # The glyph on its own, so the app can draw the plate itself in whatever
    # colour a screen calls for and tint the crescent to match.
    print("brand glyph …", flush=True)
    for scale, suffix in ((1, ""), (2, "@2x"), (3, "@3x")):
        crescent_and_star(96 * scale, GOLD_INK).save(
            ASSETS / f"brand_glyph{suffix}.png"
        )

    print("done")


if __name__ == "__main__":
    main()

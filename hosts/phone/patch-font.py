#!/usr/bin/env python3
"""Add the codepoints Claude Code draws that the base Nerd Font is missing.

Android's Typeface.createFromFile() loads exactly one file and does no
fallback, so unlike the NixOS host (where fontconfig quietly borrows a glyph
from any of the ~60 installed font packages) the phone's single terminal font
has to cover everything itself. Anything it lacks renders as a tofu box.

The gap that forced this: Claude Code's bypass-permissions badge is
U+23F5 BLACK MEDIUM RIGHT-POINTING TRIANGLE, which is absent from every font
on the device - all 208 in /system/fonts, DejaVu, and every Nerd Font cut
checked (Fira Mono, Fira Code, DejaVu Sans Mono). No font swap fixes it, so
the glyph has to be mapped in here.

This only edits the cmap table: each missing codepoint is pointed at a glyph
the font already contains. No outlines are added and no metrics change, so
every advance width stays identical and the monospace grid is preserved.
The output embeds no store paths, so the base font package is a build-time
dependency only and is free to be garbage-collected afterwards.
"""

import sys

from fontTools.ttLib import TTFont

# target codepoint -> donor candidates, best visual match first.
# The first donor actually present in the base font wins.
REMAP = {
    0x23F5: [0x25B6, 0x25BA, 0x25B8],  # bypass permissions badge (drawn twice)
    0x2442: [0xE0A0, 0xF126, 0xF418],  # fork / branch
    0x203B: [0x2731, 0xF005, 0x002A],  # reference mark
    0x29C9: [0xF24D, 0x25A3, 0xF0C5],  # nested session / worktree
    0x21BB: [0xF021, 0x27F3, 0xF01E],  # retry
    0x26A0: [0xF071, 0xF12A],          # warning
    0x2714: [0xF00C, 0x2713, 0x221A],  # check
    0x2715: [0x00D7, 0xF00D],          # cancel
    0x25B8: [0x25BA, 0x25B6],          # small right triangle
    0xFE0E: [0x200B, 0x0020],          # VS15: zero-width/space filler
}


def main(src, dst):
    font = TTFont(src)
    best = font.getBestCmap()
    subtables = [t for t in font["cmap"].tables if t.isUnicode()]

    for target, donors in REMAP.items():
        if target in best:
            continue  # base font already has it; leave the real glyph alone
        glyph = next((best[d] for d in donors if d in best), None)
        if glyph is None:
            # Loud rather than silently shipping a font with a tofu box.
            raise SystemExit(f"no donor glyph available for U+{target:04X}")
        for table in subtables:
            table.cmap.setdefault(target, glyph)

    font.save(dst)


if __name__ == "__main__":
    main(sys.argv[1], sys.argv[2])

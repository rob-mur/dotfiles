#!/bin/sh
export PATH="$PATH:/home/robert.murphy/.nix-profile/bin/"
GEOM=$(slurp)
if [ -n "$GEOM" ]; then
    grim -g "$GEOM" - | wl-copy
fi

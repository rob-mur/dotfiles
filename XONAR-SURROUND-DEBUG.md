# Xonar SE 5.1 Speaker Fill Debug Notes

## Goal
Enable "speaker fill" for the ASUS Xonar SE: stereo audio (e.g. Spotify) should upmix to all 5.1 speakers including rear-left and rear-right.

## Current Config State

### `nixos/services/pulseaudio.nix`
- WirePlumber rule sets Xonar device profile to `analog-surround-51`
- `extraConfig.pipewire-pulse."99-upmix"` sets `channelmix.upmix = true` and `channelmix.upmix-method = "psd"` via `stream.properties`

### `hosts/desktop/desktop.nix`
- Combined sink (`combined_xonar_d1`) references `alsa_output.usb-ASUSTeK_Xonar_SoundCard-00.analog-surround-51`
- Combined sink `combine.props` also has `channelmix.upmix = true` / `channelmix.upmix-method = "psd"`

## What Is Working

- Xonar device profile successfully switched to `analog-surround-51` via WirePlumber rule
- PipeWire shows Xonar sink as 6-channel: `audio.position = "FL,FR,RL,RR,FC,LFE"`
- `channelmix.upmix` and `channelmix.upmix-method = "psd"` ARE applied to Spotify's stream (confirmed via `wpctl inspect`)
- Spotify stream has all 6 ports active and connected: `output_RL > Xonar SoundCard:playback_RL [active]` etc.
- Front-left and front-right speakers work fine
- Rear-right speaker works (both for direct channel playback and upmix)

## The Problem

**Rear-left is always silent.** This has been consistent across `upmix-method = simple` and `psd`.

## Hardware Investigation

USB audio descriptor reports:
```
Channels: 6
Channel map: FL FR FC LFE SL SR
```

Physical channel order on the USB device is `FL FR FC LFE SL SR` — **not** the standard 5.1 logical order `FL FR RL RR FC LFE`.

The ALSA `surround51` plugin (defined in `USB-Audio.conf`) has a route table to handle this:
```
ttable.0.0 1   # RL(2) → hw SL(4) = rear-left
ttable.1.1 1
ttable.2.4 1
ttable.3.5 1   # RR(3) → hw SR(5) = rear-right
ttable.4.2 1
ttable.5.3 1
```

This remapping should correctly route logical RL to hardware SL (rear-left output).

## Channel Mapping Tests

Played 6-channel WAV files via `pw-play --target=...analog-surround-51` with a distinct tone on each channel:

| Logical ch | Label | Tone | Output heard    |
|-----------|-------|------|-----------------|
| 0         | FL    | 220  | Front-left ✓    |
| 1         | FR    | 330  | Front-right ✓   |
| 2         | RL    | 440  | **SILENT**      |
| 3         | RR    | 550  | Rear-right ✓    |
| 4         | FC    | 660  | Silent (no FC speaker) |
| 5         | LFE   | 770  | "Rear-right" area |

Key observations:
- **ch2 (RL) is always silent** — even with direct test tones, not just upmix
- ch5 (LFE) also appears to come from the rear-right area, same as ch3 (RR)

## Hypotheses

### Most Likely: surround51 ttable NOT applied
The ALSA `surround51` route plugin may not be active. If PipeWire (with `api.alsa.use-acp = true`) opens `hw:0,0` directly (bypassing the plugin), channels are written in raw order:
- ch2 (RL) → USB FC physical output → no speaker connected → **silent** ✓
- ch3 (RR) → USB LFE physical output → possibly near rear-right
- ch5 (LFE) → USB SR physical output → rear-right ✓

This would explain why ch2 is silent (front-center jack has no speaker).

### Alternative: Hardware SL channel is muted
The Xonar SE's SL DAC/output channel may be at 0 volume via ALSA USB mixer controls.

## Next Steps to Try

1. **Check ALSA mixer** (need `amixer`):
   ```bash
   nix-shell -p alsa-utils --run "amixer -c SoundCard scontents"
   ```
   Look for any per-channel volume at 0 or muted.

2. **Confirm surround51 routing** — if not remapping, fix options:

   **Option A**: Override `audio.position` on the Xonar node via WirePlumber to match actual hardware channel order:
   ```
   audio.position = "FL,FR,FC,LFE,RL,RR"
   ```
   This would tell PipeWire's upmix to put RL signal at position 4 (which goes to hardware SL = rear-left).

   **Option B**: Force use of surround51 remapping by verifying the ALSA device path in PipeWire ACP config.

3. **Direct hw:0,0 test** — use `aplay` or `pw-play` with a file specifically crafted to put a tone on channel 4 (which would be rear-left if passthrough to hw:0,0):
   ```bash
   # If this produces rear-left audio, confirms passthrough (no surround51 remapping)
   # and Option A above is the fix
   ```

## Notes on What Didn't Work

- Setting `channelmix.upmix` on the Xonar SINK NODE via WirePlumber has no effect — PipeWire pre-negotiates format to match the sink channel count
- `session.rules` is not a valid WirePlumber 0.5 config section (silently ignored)
- The fix is applied on the STREAM side via `pipewire-pulse.conf` `stream.properties`
- `upmix-method = "simple"` and `"psd"` both exhibit the same rear-left silence

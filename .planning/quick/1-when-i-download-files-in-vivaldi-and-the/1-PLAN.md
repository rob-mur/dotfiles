---
phase: quick-1
plan: 1
type: execute
wave: 1
depends_on: []
files_modified: [home/programs/vivaldi.nix]
autonomous: true
requirements: []

must_haves:
  truths:
    - "User can click 'Show in folder' from Vivaldi downloads and dolphin opens"
    - "Dolphin opens to the correct directory containing the downloaded file"
  artifacts:
    - path: "home/programs/vivaldi.nix"
      provides: "Vivaldi configuration with sandbox flags allowing file manager execution"
      min_lines: 20
  key_links:
    - from: "vivaldi download UI"
      to: "dolphin file manager"
      via: "XDG mime handler for inode/directory"
      pattern: "xdg-mime.*inode/directory"
---

<objective>
Fix Vivaldi's "Show in folder" feature by configuring the browser to allow executing external file manager (dolphin).

Purpose: Enable seamless file management workflow after downloading files in Vivaldi.
Output: Updated Vivaldi configuration that allows executing dolphin from the sandboxed browser environment.
</objective>

<execution_context>
@./.claude/get-shit-done/workflows/execute-plan.md
@./.claude/get-shit-done/templates/summary.md
</execution_context>

<context>
## Current State

The system has:
- Dolphin installed at `/home/rob/.nix-profile/bin/dolphin`
- XDG mime associations correctly configured (`inode/directory` → `org.kde.dolphin.desktop`)
- Vivaldi using default Chromium sandbox which blocks external program execution

## Problem

When clicking "Show in folder" on downloaded files in Vivaldi, the browser attempts to execute `dolphin` but fails because:
1. Chromium's zypak/bubblewrap sandbox restricts PATH visibility
2. No explicit command-line flags allow file manager execution
3. Browser can't find dolphin binary even though it's in user's PATH

## Solution Approach

Add Vivaldi command-line flags to:
1. Disable setuid sandbox (not needed on NixOS and interferes with external execution)
2. Ensure PATH is preserved for external program execution

This is safe on NixOS because the Nix sandbox already provides isolation.
</context>

<tasks>

<task type="auto">
  <name>Task 1: Configure Vivaldi to allow external file manager execution</name>
  <files>home/programs/vivaldi.nix</files>
  <action>
Add command-line arguments to Vivaldi package configuration to disable the setuid sandbox and allow external program execution.

Modify `home/programs/vivaldi.nix`:

1. Add `commandLineArgs` to the Vivaldi package override
2. Include flags:
   - `--no-sandbox` or `--disable-setuid-sandbox` (disables restrictive sandbox)
   - `--disable-features=UseChromeOSDirectVideoDecoder` (prevents conflicts)

Use the home-manager `programs.vivaldi` structure which supports `commandLineArgs` at the program level, not package override level. The correct approach is:

```nix
programs.vivaldi = {
  enable = true;
  package = pkgs.vivaldi.override {
    proprietaryCodecs = true;
    enableWidevine = true;
  };
  commandLineArgs = [
    "--disable-features=UseChromeOSDirectVideoDecoder"
    "--disable-setuid-sandbox"
  ];
};
```

The `--disable-setuid-sandbox` flag is safe on NixOS because:
- Nix provides its own sandboxing via bubblewrap
- The setuid sandbox interferes with PATH visibility for external programs
- This flag is commonly used in NixOS browser configurations

DO NOT use `--no-sandbox` as it's too permissive and creates security risks. The setuid sandbox flag is specifically for the problematic sandbox layer.
  </action>
  <verify>
1. Configuration syntax check: `nix eval --file /home/rob/repos/dotfiles/hosts/desktop/flake.nix --apply 'x: true'` succeeds
2. After rebuild, check Vivaldi process: `ps aux | grep vivaldi` shows `--disable-setuid-sandbox` in command line
3. Test manually: Download a file in Vivaldi, right-click download → "Show in folder" → dolphin opens to correct directory
  </verify>
  <done>
- `home/programs/vivaldi.nix` contains `commandLineArgs` with sandbox flag
- Vivaldi can successfully execute dolphin when "Show in folder" is clicked
- No error messages about missing 'dolphin' program
  </done>
</task>

<task type="auto">
  <name>Task 2: Apply configuration and verify fix</name>
  <files>home/programs/vivaldi.nix</files>
  <action>
After modifying the configuration:

1. Rebuild the NixOS/home-manager configuration:
   ```bash
   sudo nixos-rebuild switch --flake /home/rob/repos/dotfiles/hosts/desktop
   ```

2. Restart Vivaldi completely (kill all instances):
   ```bash
   pkill -f vivaldi
   ```

3. Launch Vivaldi and verify the flags are applied:
   ```bash
   vivaldi &
   sleep 3
   ps aux | grep -E 'vivaldi.*--disable-setuid-sandbox'
   ```

4. Test the actual functionality:
   - Open Vivaldi
   - Download a test file (any small file)
   - Click the download in the downloads bar
   - Click "Show in folder"
   - Verify dolphin opens showing the downloads directory

If dolphin still doesn't open, check:
- Run `xdg-mime query default inode/directory` to confirm it returns `org.kde.dolphin.desktop`
- Check Vivaldi's internal logs at `~/.config/vivaldi/Default/` for file manager errors
- Try running `dolphin` directly from terminal to ensure it works
  </action>
  <verify>
```bash
# Verify flag is in running process
ps aux | grep vivaldi | grep -q 'disable-setuid-sandbox' && echo "Flag applied" || echo "Flag missing"

# Manual test
echo "Manual verification required:"
echo "1. Download a file in Vivaldi"
echo "2. Click 'Show in folder' from downloads"
echo "3. Confirm dolphin opens to the download location"
```
  </verify>
  <done>
- Vivaldi process shows `--disable-setuid-sandbox` flag in ps output
- Clicking "Show in folder" in Vivaldi successfully opens dolphin
- Dolphin displays the correct directory containing the downloaded file
- No error messages about missing programs
  </done>
</task>

</tasks>

<verification>
Overall verification steps:

1. **Configuration validity**: Nix configuration evaluates without errors
2. **Runtime flags**: Vivaldi process includes sandbox bypass flags
3. **Functional test**: "Show in folder" feature works end-to-end
4. **XDG integration**: Mime handler correctly routes to dolphin

Success indicators:
- `xdg-mime query default inode/directory` returns `org.kde.dolphin.desktop`
- `ps aux | grep vivaldi` shows `--disable-setuid-sandbox`
- Download → "Show in folder" → dolphin opens with correct path
</verification>

<success_criteria>
- [ ] `home/programs/vivaldi.nix` includes `commandLineArgs` configuration
- [ ] NixOS rebuild completes successfully
- [ ] Vivaldi launches with sandbox bypass flags
- [ ] "Show in folder" opens dolphin to the download directory
- [ ] No "can't find program 'dolphin'" error messages
- [ ] Configuration changes committed to git
</success_criteria>

<output>
After completion, create `.planning/quick/1-when-i-download-files-in-vivaldi-and-the/1-SUMMARY.md` documenting:
- Root cause (Chromium setuid sandbox blocking external program execution)
- Solution (commandLineArgs with --disable-setuid-sandbox)
- Verification results
- Any edge cases or additional notes
</output>

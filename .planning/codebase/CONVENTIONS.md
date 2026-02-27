# Coding Conventions

**Analysis Date:** 2026-02-27

## Naming Patterns

**Files:**
- Nix modules: `lowercase.nix` (e.g., `boot.nix`, `fonts.nix`, `openssh.nix`)
- Nix defaults: `default.nix` in each directory
- Lua plugins: `kebab-case.lua` (e.g., `harpoon.lua`, `web-dev-pairs.lua`)
- Shell scripts: `lowercase.sh` (e.g., `preview.sh`)

**Functions:**
- Lua: `snake_case` (e.g., `is_hidden_file`, `toggle_telescope`)
- Shell: `snake_case` (e.g., `handle_extension`, `handle_mime`)

**Variables:**
- Nix: `camelCase` for attributes (e.g., `enableDefaultPackages`, `canTouchEfiVariables`)
- Lua: `snake_case` for locals (e.g., `harpoon_files`, `current_picker`)
- Shell: `SCREAMING_SNAKE_CASE` for environment vars (e.g., `FILE_PATH`, `PREVIEW_WIDTH`)

**Types:**
- Lua type annotations: `---@type oil.SetupOpts`, `---@module 'oil'`, `---@param client vim.lsp.Client`

## Code Style

**Formatting:**
- Nix: No explicit formatter config detected
- Lua: Tabs converted to spaces (2-space indent based on `init.lua` modeline: `ts=2 sts=2 sw=2 et`)
- Shell: Mixed 2 and 4-space indent

**Linting:**
- No ESLint, Prettier, or similar config files detected
- Neovim uses conform.nvim for formatting:
  - Lua: `stylua`
  - Python: `black`, `isort`
  - JavaScript: `prettier`, `prettierd`
  - Nix: `nixpkgs_fmt`, `alejandra`

## Import Organization

**Nix:**
```nix
{ config, pkgs, lib, ... }:
let
  localVar = import ./local.nix;
in {
  # configuration
}
```
Order:
1. Function parameters in curly braces
2. `let` bindings for local imports
3. Main attribute set

**Lua:**
```lua
return {
  'plugin/name',
  dependencies = { 'dep1', 'dep2' },
  config = function()
    local module = require('module')
    -- setup
  end,
}
```
Order:
1. External requires at top of function
2. Local variables after requires
3. Configuration/setup

**Path Aliases:**
- Neovim uses `custom.` for user plugins: `require('custom.keymaps')`
- Nix uses relative imports: `import ./../../user/theme {}`

## Error Handling

**Patterns:**
- Nix: Declarative - invalid config fails at evaluation/build time
- Lua: Conditional checks and early returns
- Shell: `set -o errexit` equivalent (`set -o pipefail`) in `preview.sh`
- Shell uses exit codes: `exit 0` for success, `exit 1` for failure

## Logging

**Framework:** Native language constructs

**Patterns:**
- Nix: Build-time errors appear during `nixos-rebuild`
- Lua: Neovim `:checkhealth` for diagnostics
- Shell: Direct stdout/stderr output

## Comments

**When to Comment:**
- Nix: Inline comments for non-obvious attribute purposes
- Lua: Extensive block comments explaining concepts (see `init.lua` header)
- Lua: Inline comments for keymap descriptions
- Shell: Section markers for different file type handlers

**JSDoc/TSDoc:**
- Lua uses LuaLS annotations:
  ```lua
  ---@type vim.Option
  ---@param client vim.lsp.Client
  ---@diagnostic disable-next-line: missing-fields
  ```

## Function Design

**Size:** Functions range from 5-50 lines. Larger functions (like telescope setup) broken into logical sections with comments.

**Parameters:**
- Nix: Attribute sets with `...` for forward compatibility
- Lua: Named parameters via tables or positional
- Shell: Uses `$1`, `$2` with `while`/`case` for named args

**Return Values:**
- Nix: Attribute sets
- Lua: Explicit returns or implicit nil
- Shell: Exit codes (0/1) and stdout

## Module Design

**Exports:**
- Nix: All modules export attribute sets
- Lua plugins: Return plugin spec table
- No explicit `module.exports` pattern

**Barrel Files:**
- Nix: `default.nix` serves as module entry point, imports submodules
- Example: `nixos/system/default.nix` imports all system modules

## Nix-Specific Conventions

**Options:**
```nix
lib.mkOption {
  type = lib.types.str;
  default = "value";
  description = "Human description";
}
```

**Conditionals:**
- Use `lib.mkIf` for conditional activation
- Use `lib.mkDefault` for overridable defaults

**Configuration Pattern:**
```nix
{config, pkgs, lib, ...}: {
  imports = [ ./module1.nix ./module2.nix ];

  services.foo = {
    enable = true;
    settings = { ... };
  };
}
```

## Lua/Neovim Specific Conventions

**Plugin Configuration:**
- Lazy.nvim for plugin management
- Plugins in `lua/custom/plugins/` as separate files
- Each plugin returns a table with setup

**Keymaps:**
```lua
vim.keymap.set('mode', 'keys', function, { desc = 'Description' })
```
- Always include `desc` for which-key integration
- Use `<leader>` prefix for custom bindings

**LSP Setup:**
- Mason for automatic LSP installation (optional)
- Manual LSP config via `vim.lsp.config` for non-Mason servers
- Capabilities extended via `blink.cmp`

---

*Convention analysis: 2026-02-27*

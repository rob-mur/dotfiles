-- This cache will store whether a directory (represented by its buffer number) is a git repo.
local oil_git_cache = {}

local is_hidden_file =
  function(name, bufnr)
    -- If the name is "." or "..", we always hide it.
    if name == '.' or name == '..' then
      return true
    end

    -- Lazily populate the cache for this buffer
    if oil_git_cache[bufnr] == nil then
      -- Get the directory path from the oil buffer name
      local cwd = vim.api.nvim_buf_get_name(bufnr):gsub('^oil://', '')
      -- Check if we are inside a git work tree
      vim.fn.system('git -C ' .. vim.fn.shellescape(cwd) .. ' rev-parse --is-inside-work-tree > /dev/null 2>&1')

      oil_git_cache[bufnr] = {
        is_git = (vim.v.shell_error == 0),
        cwd = cwd,
      }
    end

    local cache = oil_git_cache[bufnr]

    if cache.is_git then
      -- In a git repo, a file is "hidden" if it's gitignored.
      -- We use `check-ignore -q` which is quiet and fast.
      -- It returns exit code 0 if the file IS ignored, and 1 otherwise.
      local cmd = 'git -C ' .. vim.fn.shellescape(cache.cwd) .. ' check-ignore -q ' .. vim.fn.shellescape(name)
      vim.fn.system(cmd)
      return vim.v.shell_error == 0
    else
      -- Default behavior: hide files starting with a dot
      return name:match '^%.' ~= nil
    end
  end,
  -- It's good practice to clear the cache when the buffer is closed.
  vim.api.nvim_create_autocmd('BufDelete', {
    pattern = 'oil://*',
    callback = function(args)
      oil_git_cache[args.buf] = nil
    end,
  })

return {
  {
    'stevearc/oil.nvim',
    ---@module 'oil'
    ---@type oil.SetupOpts
    opts = {
      view_options = { show_hidden = true, is_hidden_file = is_hidden_file },
      vim.keymap.set('n', '-', '<CMD>Oil<CR>', { desc = 'Open parent directory' }),
    },
    dependencies = { { 'echasnovski/mini.icons', opts = {} }, { 'nvim-tree/nvim-web-devicons' } },
    lazy = false,
  },
}

return {
  'mbbill/undotree',
  config = function()
    vim.keymap.set('n', '<leader>u', vim.cmd.UndotreeToggle)
    vim.opt.undofile = true
    local undodir = vim.fn.expand '~/.undodir'
    if vim.fn.isdirectory(undodir) == 0 then
      vim.fn.mkdir(undodir, 'p', 0700)
    end
    vim.opt.undodir = undodir

    vim.g.undotree_SetFocusWhenToggle = 1
  end,
}

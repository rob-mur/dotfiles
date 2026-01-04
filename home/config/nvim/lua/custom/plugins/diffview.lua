return {
  'sindrets/diffview.nvim',
  cmd = { 'DiffviewOpen', 'DiffviewFileHistory', 'DiffviewClose' },
  keys = {
    {
      '<leader>gv',
      '<cmd>DiffviewOpen<cr>',
      desc = 'Diff view for changes since last commit (or rebase/merge)',
    },
    {
      '<leader>gfv',
      '<cmd>DiffviewFileHistory<cr>',
      desc = 'Diff file history view for repo',
    },
    {
      '<leader>gfv',
      function()
        vim.cmd "'<,'>DiffviewFileHistory"
      end,
      mode = 'v',
      desc = 'Diff file history view for repo (visual mode)',
    },
    {
      '<leader>gsfv',
      '<cmd>DiffviewFileHistory %<cr>',
      desc = 'Diff file history view for the currently open file',
    },
    {
      '<leader>gc',
      '<cmd>DiffviewClose<cr>',
      desc = 'Close the current diffview',
    },
    {
      '<leader>gi',
      function()
        vim.ui.input({ prompt = 'DiffviewOpen ' }, function(input)
          if input and input ~= '' then
            vim.cmd('DiffviewOpen ' .. input)
          end
        end)
      end,
      desc = 'DiffviewOpen with user input',
    },
  },
}

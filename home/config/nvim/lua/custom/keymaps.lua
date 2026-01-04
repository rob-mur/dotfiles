vim.keymap.set({ 'n', 'v' }, '<leader>y', '"+y', { desc = 'Copy to system clipboard' })
vim.keymap.set({ 'n', 'v' }, '<leader>p', '"+p', { desc = 'Paste from system clipboard' })
vim.keymap.set({ 'n', 'v' }, '<leader>P', '"+P', { desc = 'Paste from system clipboard (before)' })
vim.keymap.set({ 'n', 'v' }, '<leader>d', '"+d', { desc = 'Cut to system clipboard' })

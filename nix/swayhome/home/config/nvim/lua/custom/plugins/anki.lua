		vim.keymap.set('n', '<leader>bc','<cmd>Anki Basic<cr>', {desc = 'Basic Anki Card'})
		vim.keymap.set('n', '<leader>bs','<cmd>AnkiSend<cr>', {desc = 'Send card to anki'})
return {
  "rareitems/anki.nvim",
  opts = {
      -- this function will add support for associating '.anki' extension with both 'anki' and 'tex' filetype.
      tex_support = false,
      models = {
        ["Basic"] = "Complete French Grammar",
      },
  },
}

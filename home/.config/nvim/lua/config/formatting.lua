local conform = require('conform')

local function format()
  conform.format({ async = true, lsp_fallback = true })
end

vim.keymap.set('n', '<leader>cf', format, { desc = 'Format buffer' })

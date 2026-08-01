vim.keymap.set('n', '<Esc>', '<cmd>write<cr>', { desc = 'Save' })
vim.keymap.set('n', '<C-a>', 'ggVG', { desc = 'Select All' })
vim.keymap.set('x', 'p', 'pgv"' .. vim.v.register .. 'y', { expr = true, desc = 'Paste without replacing clipboard' })

vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Previous diagnostic' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Next diagnostic' })
vim.keymap.set('n', '<leader>d', vim.diagnostic.open_float, { desc = 'Line diagnostics' })

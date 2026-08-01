return {
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    config = function()
      require('nvim-treesitter.configs').setup({
        ensure_installed = {
          'astro', 'bash', 'css', 'html', 'javascript', 'json', 'jsonc',
          'lua', 'markdown', 'markdown_inline', 'nix', 'python', 'rust',
          'tsx', 'typescript', 'yaml',
        },
        highlight = { enable = true },
        indent = { enable = true },
      })
    end,
  },
  {
    'mrcjkb/rustaceanvim',
    version = '^6',
    ft = { 'rust' },
  },
  {
    'saghen/blink.cmp',
    version = '1.*',
    dependencies = { 'rafamadriz/friendly-snippets' },
    opts = {
      keymap = { preset = 'default' },
      appearance = { nerd_font_variant = 'mono' },
      completion = { documentation = { auto_show = true } },
      sources = { default = { 'lsp', 'path', 'snippets', 'buffer' } },
      fuzzy = { implementation = 'prefer_rust_with_warning' },
    },
  },
  {
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    opts = {
      formatters_by_ft = {
        lua = { 'stylua' },
        nix = { 'nixfmt' },
        python = { 'ruff_format' },
        rust = { 'rustfmt' },
        sh = { 'shfmt' },
        javascript = { 'prettier' },
        javascriptreact = { 'prettier' },
        typescript = { 'prettier' },
        typescriptreact = { 'prettier' },
        astro = { 'prettier' },
        css = { 'prettier' },
        html = { 'prettier' },
        json = { 'prettier' },
        jsonc = { 'prettier' },
        yaml = { 'prettier' },
        markdown = { 'prettier' },
      },
      format_on_save = function(bufnr)
        if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
          return
        end
        return { timeout_ms = 500, lsp_fallback = true }
      end,
    },
    config = function(_, opts)
      require('conform').setup(opts)
      require('config.formatting')
    end,
    keys = {
      { '<leader>cf', function() require('conform').format({ async = true, lsp_fallback = true }) end, desc = 'Format' },
    },
  },
}

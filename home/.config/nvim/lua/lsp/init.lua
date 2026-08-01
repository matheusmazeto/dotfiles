local M = {}

function M.setup()
  local capabilities = require('blink.cmp').get_lsp_capabilities()
  local groups = {
    require('lsp.python'),
    require('lsp.frontend'),
    require('lsp.other'),
  }

  for _, servers in ipairs(groups) do
    for name, config in pairs(servers) do
      config.capabilities = capabilities
      vim.lsp.config(name, config)
      vim.lsp.enable(name)
    end
  end
end

return M

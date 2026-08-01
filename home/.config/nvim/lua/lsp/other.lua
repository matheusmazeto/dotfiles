return {
  lua_ls = {
    settings = {
      Lua = {
        diagnostics = { globals = { 'vim' } },
        workspace = { checkThirdParty = false },
      },
    },
  },
  nixd = {},
  bashls = {},
  marksman = {},
}

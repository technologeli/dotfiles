vim.g.completion_matching_strategy_list = { 'exact', 'substring', 'fuzzy' }

-- Setup nvim-cmp.
local has_cmp, cmp = pcall(require, 'cmp')
if not has_cmp then return end

local format = nil
local has_lspkind, lspkind = pcall(require, 'lspkind')
if has_lspkind then
  format = lspkind.cmp_format({with_text = true, menu = ({
    buffer = "[buf]",
    nvim_lsp = "[LSP]",
    nvim_lua = "[lua]",
    luasnip = "[snip]",
    path = "[path]",
  })})
end

cmp.setup({
  snippet = {
    expand = function(args)
      local has_luasnip, luasnip = pcall(require, 'luasnip')
      if has_luasnip then
        luasnip.lsp_expand(args.body)
      end
    end,
  },
  mapping = {
    ['<C-u>'] = cmp.mapping.scroll_docs(-4),
    ['<C-d>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.close(),
    ['<C-y>'] = cmp.mapping.confirm({
      select = true,
    }),
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-n>'] = cmp.mapping.select_next_item(),
  },
  sources = {
    { name = 'nvim_lsp', max_item_count = 5 },
    { name = 'luasnip' },
    { name = 'nvim_lua', max_item_count = 5 },
    { name = 'path', max_item_count = 5 },
    { name = 'buffer', keyword_length = 5, max_item_count = 5 },
  },
  confirmation = {
    get_commit_characters = function(commit_characters)
      return vim.tbl_filter(function(char)
        return char ~= ',' and char ~= '(' and char ~= '.'
      end, commit_characters)
    end
  },
  formatting = { format = format  },
  experimental = {
    native_menu = false,
    ghost_text = true
  }
})

local capabilities = nil
local has_cmp_nvim_lsp, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
if has_cmp_nvim_lsp then
  capabilities = cmp_nvim_lsp.update_capabilities(vim.lsp.protocol.make_client_capabilities())
end

local on_attach = function ()
  -- use K again to go into the window
  vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = 0 })

  -- use ctrl t to go back
  vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = 0 })
  vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, { buffer = 0 })

  -- errors
  vim.keymap.set("n", "<leader>ej", vim.diagnostic.goto_next, { buffer = 0 })
  vim.keymap.set("n", "<leader>ek", vim.diagnostic.goto_next, { buffer = 0 })
  vim.keymap.set("n", "<leader>el", "<cmd>Telescope diagnostics<cr>", { buffer = 0 })

  -- refactor
  vim.keymap.set("n", "<leader>R", vim.lsp.buf.rename, { buffer = 0 })

  -- code actions
  vim.keymap.set("n", "<leader>c", vim.lsp.buf.code_action, { buffer = 0 })
end

local has_lspconfig, lspconfig = pcall(require, 'lspconfig')
if not has_lspconfig then
  return
end

-- Setup lspconfig.
lspconfig.pyright.setup {
  capabilities = capabilities,
  on_attach = on_attach,
}

lspconfig.vimls.setup {
  capabilities = capabilities,
  on_attach = on_attach,
}

lspconfig.clangd.setup {
  capabilities = capabilities,
  on_attach = on_attach,
}

lspconfig.gopls.setup {
  capabilities = capabilities,
  on_attach = on_attach,
}

lspconfig.html.setup {
  capabilities = capabilities,
  on_attach = on_attach,
}

lspconfig.tsserver.setup {
  capabilities = capabilities,
  on_attach = on_attach,
}

lspconfig.tailwindcss.setup {
  capabilities = capabilities,
  on_attach = on_attach,
}

lspconfig.rust_analyzer.setup {
  capabilities = capabilities,
  on_attach = on_attach,
}


lspconfig.prismals.setup {
  capabilities = capabilities,
  on_attach = on_attach,
}

local pid = vim.fn.getpid()
local omnisharp_bin = "/home/eli/sources/omnisharp/run"
lspconfig.omnisharp.setup {
  capabilities = capabilities,
  on_attach = on_attach,
  cmd = { omnisharp_bin, "--languageserver", "--hostPID", tostring(pid) };
}


--[[

lspconfig.bashls.setup {
  capabilities = capabilities
}

--]]

-- lua only on linux
local sumneko_root_path = "/home/eli/lua-language-server"
local sumneko_binary = sumneko_root_path.."/bin/lua-language-server"
lspconfig.sumneko_lua.setup {
  capabilities = capabilities,
  on_attach = on_attach,
  cmd = {sumneko_binary, "-E", sumneko_root_path .. "/main.lua"};
  settings = {
    Lua = {
      runtime = {
        -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
        version = 'LuaJIT',
        -- Setup your lua path
        path = vim.split(package.path, ';'),
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = {'vim'},
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = {
          [vim.fn.expand('$VIMRUNTIME/lua')] = true,
          [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true,
        },
      },
      -- Do not send telemetry data containing a randomized but unique identifier
      telemetry = {
        enable = false,
      },
    },
  },
}

capabilities.textDocument.completion.completionItem.snippetSupport = true
lspconfig.cssls.setup {
  capabilities = capabilities,
  on_attach = on_attach,
}

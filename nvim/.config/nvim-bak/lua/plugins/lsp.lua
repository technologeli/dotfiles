return {
    "VonHeikemen/lsp-zero.nvim",
    dependencies = {
        -- LSP Support
        { "neovim/nvim-lspconfig" },
        {
            "williamboman/mason.nvim",
            keys = {
                { "<leader>m", "<cmd>Mason<cr>", desc = '[M]ason' },
            }
        },
        { "williamboman/mason-lspconfig.nvim" },

        -- Autocompletion
        { "hrsh7th/nvim-cmp" },
        { "hrsh7th/cmp-buffer" },
        { "hrsh7th/cmp-path" },
        { "saadparwaiz1/cmp_luasnip" },
        { "hrsh7th/cmp-nvim-lsp" },
        { "hrsh7th/cmp-nvim-lua" },

        -- Snippets
        { "L3MON4D3/LuaSnip" },
        { "rafamadriz/friendly-snippets" },
    },
    config = function()
        local lsp = require('lsp-zero')

        lsp.preset('recommended')

        lsp.ensure_installed({
            'lua_ls',
            'rust_analyzer',
        })

        local cmp = require('cmp')
        local cmp_select = { behavior = cmp.SelectBehavior.Select }
        local cmp_mappings = lsp.defaults.cmp_mappings({
            ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
            ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
            ['<C-y>'] = cmp.mapping.confirm({ select = true }),
            ["<C-Space>"] = cmp.mapping.complete(),
        })

        cmp_mappings['<CR>'] = nil
        cmp_mappings['<Tab>'] = nil
        cmp_mappings['<S-Tab>'] = nil

        lsp.setup_nvim_cmp({
            mapping = cmp_mappings
        })

        lsp.set_preferences({
            suggest_lsp_servers = false,
            sign_icons = {
                error = 'E',
                warn = 'W',
                hint = 'H',
                info = 'I'
            }
        })

        vim.diagnostic.config({
            virtual_text = true,
        })

        lsp.configure('lua_ls', {
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
                        globals = { 'vim' },
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
        })

        lsp.on_attach(function(_, bufnr)
            local opts = { buffer = bufnr, remap = false }

            vim.keymap.set("n", "gd", vim.lsp.buf.definition, { unpack(opts), desc = '[G]oto [D]efinition' })
            vim.keymap.set("n", "K", vim.lsp.buf.hover, { unpack(opts), desc = 'Hover' })
            vim.keymap.set("n", "<leader>lws", vim.lsp.buf.workspace_symbol,
                { unpack(opts), desc = '[L]sp [W]orkspace [S]ymbol' })
            vim.keymap.set("n", "<leader>ld", vim.diagnostic.open_float, { unpack(opts), desc = '[L]sp Diagnostic' })
            vim.keymap.set("n", "[d", vim.diagnostic.goto_next, { unpack(opts), desc = 'Next Diagnostic' })
            vim.keymap.set("n", "]d", vim.diagnostic.goto_prev, { unpack(opts), desc = 'Previous Diagnostic' })
            vim.keymap.set("n", "<leader>lca", vim.lsp.buf.code_action, { unpack(opts), desc = '[L]sp [C]ode [A]ction' })
            vim.keymap.set("n", "<leader>lrr", vim.lsp.buf.references, { unpack(opts), desc = '[L]sp [R]eferences' })
            vim.keymap.set("n", "<leader>lrn", vim.lsp.buf.rename, { unpack(opts), desc = '[L]sp [R]e[N]ame' })
        end)

        lsp.setup()
    end
}

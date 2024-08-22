return {
    "hrsh7th/nvim-cmp",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
        "hrsh7th/cmp-path", -- Source for completion of paths
        "hrsh7th/cmp-buffer", -- Source for completion of words in buffers
        "hrsh7th/cmp-cmdline", -- Source for commandline completion
        "hrsh7th/cmp-nvim-lua", -- Source for completion of Neovim's Lua API
        "hrsh7th/cmp-nvim-lsp-signature-help", -- Source for function signature
        "hrsh7th/cmp-emoji", -- Source for emojis
        { "zbirenbaum/copilot-cmp", dependencies = "zbirenbaum/copilot.lua", config = true }, -- Source for copilot
        { "saadparwaiz1/cmp_luasnip", dependencies = "L3MON4D3/LuaSnip" }, -- Source for completion of LuaSnip snippets
        "onsails/lspkind.nvim", -- Pictograms in completion menu
        "brenoprata10/nvim-highlight-colors", -- Highlight colors in completion menu
    },
    config = function()
        local luasnip = require("luasnip")

        local cmp = require("cmp")

        -- Set color for copilot suggestions
        vim.api.nvim_set_hl(0, "CmpItemKindCopilot", { fg = "#aa7de8" })

        -- Setup nvim-cmp
        cmp.setup({
            completion = {
                completeopt = "menu,menuone,preview,noselect,noinsert",
            },

            -- Configure how nvim-cmp interacts with luasnip
            snippet = {
                expand = function(args)
                    luasnip.lsp_expand(args.body)
                end,
            },

            sources = cmp.config.sources({
                -- { name = "supermaven" }, -- Supermaven works great outside also
                { name = "copilot" },
                {
                    name = "nvim_lsp",
                    entry_filter = function(entry, ctx)
                        return require("cmp").lsp.CompletionItemKind.Text ~= entry:get_kind()
                    end,
                },
                { name = "lazydev" },
                { name = "nvim_lsp_signature_help" },
                { name = "path" },
                { name = "luasnip" },
                { name = "pandoc_references" },
                { name = "buffer" },
                { name = "nvim_lua" },
                { name = "emoji" },
            }),

            window = {
                -- completion = cmp.config.window.bordered(),
                -- documentation = cmp.config.window.bordered(),
            },

            -- Set formatting of completion menu
            formatting = {
                format = function(entry, item)
                    local color_item = require("nvim-highlight-colors").format(entry, { kind = item.kind })
                    item = require("lspkind").cmp_format({
                        mode = "symbol_text",
                        maxwidth = 80,
                        ellipsis_char = "...",
                        symbol_map = {
                            Supermaven = "",
                            Copilot = "",
                            Text = "󰉿",
                            Method = "󰆧",
                            Function = "󰊕",
                            Constructor = "",
                            Field = "󰜢",
                            Variable = "󰀫",
                            Class = "󰠱",
                            Interface = "",
                            Module = "",
                            Property = "󰜢",
                            Unit = "󰑭",
                            Value = "󰎠",
                            Enum = "",
                            Keyword = "󰌋",
                            Snippet = "",
                            Color = "󰏘",
                            File = "󰈙",
                            Reference = "󰈇",
                            Folder = "󰉋",
                            EnumMember = "",
                            Constant = "󰏿",
                            Struct = "󰙅",
                            Event = "",
                            Operator = "󰆕",
                            TypeParameter = "",
                        },
                        show_labelDetails = true,
                    })(entry, item)
                    if color_item.abbr_hl_group then
                        item.kind_hl_group = color_item.abbr_hl_group
                        item.kind = color_item.abbr
                    end
                    return item
                end,
            },

            mapping = cmp.mapping.preset.insert({
                ["<cr>"] = nil,
                ["<c-space>"] = cmp.mapping.complete(),
                ["<c-e>"] = cmp.mapping.abort(),
                ["<c-u>"] = cmp.mapping.scroll_docs(-4),
                ["<c-d>"] = cmp.mapping.scroll_docs(4),
                ["<c-p>"] = cmp.mapping.select_prev_item(),
                ["<c-n>"] = cmp.mapping.select_next_item(),
                ["<tab>"] = cmp.mapping(function(fallback)
                    local entry = cmp.get_selected_entry()
                    if luasnip.expand_or_locally_jumpable() and (not cmp.visible or (cmp.visible and not entry)) then
                        luasnip.expand_or_jump()
                    elseif cmp.visible() then
                        -- This snippet will confirm with tab, and if no entry is selected, will confirm the first item
                        if not entry then
                            cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
                        end
                        cmp.confirm()
                    else
                        fallback()
                    end
                end, { "i", "s" }),
                ["<S-Tab>"] = cmp.mapping(function(fallback)
                    local entry = cmp.get_selected_entry()
                    if luasnip.jumpable(-1) and (not cmp.visible or (cmp.visible and not entry)) then
                        luasnip.jump(-1)
                    elseif cmp.visible() then
                        cmp.select_next_item()
                    else
                        fallback()
                    end
                end, { "i", "s" }),
            }),
        })

        -- Add completion to search mode
        cmp.setup.cmdline({ "/", "?" }, {
            mapping = cmp.mapping.preset.cmdline(),
            sources = {
                { name = "buffer" },
            },
        })

        -- Add completion to command mode
        cmp.setup.cmdline(":", {
            mapping = cmp.mapping.preset.cmdline(),
            sources = cmp.config.sources({
                { name = "path" },
            }, {
                { name = "cmdline" },
            }),
            matching = { disallow_symbol_nonprefix_matching = false },
        })

        -- Enable completion in Cargo.toml files for crates
        vim.api.nvim_create_autocmd("BufRead", {
            group = vim.api.nvim_create_augroup("plugin-cmp-sources", { clear = true }),
            desc = "Enable completion in Cargo.toml files for crates",
            pattern = "Cargo.toml",
            callback = function()
                cmp.setup.buffer({ sources = { { name = "crates" } } })
            end,
        })
    end,
}

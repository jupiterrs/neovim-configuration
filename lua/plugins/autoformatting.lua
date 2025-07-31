return {
    'nvimtools/none-ls.nvim',
    dependencies = {
        'nvimtools/none-ls-extras.nvim',
        'jayp0521/mason-null-ls.nvim', -- ensure dependencies are installed
    },
    config = function()
        local null_ls = require 'null-ls'
        local formatting = null_ls.builtins.formatting -- to setup formatters
        local diagnostics = null_ls.builtins.diagnostics -- to setup linters

        -- Formatters & linters for mason to install
        require('mason-null-ls').setup {
            ensure_installed = {
                -- 'prettier', -- ts/js formatter
                'stylua', -- lua formatter
                -- 'eslint_d', -- ts/js linter
                'shfmt', -- Shell formatter
                -- 'checkmake', -- linter for Makefiles
                'ruff', -- Python linter and formatter
                'sqlfluff',
                -- 'clang-format',
            },
            automatic_installation = true,
        }

        local sources = {
            diagnostics.checkmake,
            formatting.clang_format.with {
                filetypes = {
                    'c',
                    'cpp',
                },
                extra_args = {
                    '--style',
                    '{BasedOnStyle: llvm, '
                        .. 'TabWidth: 8, '
                        .. 'IndentWidth: 8, '
                        .. 'UseTab: ForIndentation, '
                        .. 'AllowShortIfStatementsOnASingleLine: AllIfsAndElse, '
                        .. 'AllowShortBlocksOnASingleLine: Always, '
                        .. 'AllowShortFunctionsOnASingleLine: All, '
                        .. 'AllowShortLambdasOnASingleLine: All, '
                        .. 'AllowShortLoopsOnASingleLine: true, '
                        .. 'SpacesBeforeTrailingComments: 2}',
                },
            },
            formatting.ocamlformat.with { filetypes = { 'ocaml' } },
            formatting.fantomas.with { filetypes = { 'fsharp' }, timeout = 5000 },
            formatting.prettier.with { filetypes = { 'html', 'json', 'yaml', 'markdown' } },
            formatting.stylua,
            formatting.shfmt.with { args = { '-i', '4' } },
            formatting.terraform_fmt,
            -- require('none-ls.formatting.ruff').with { extra_args = { '--extend-select', 'I' } },
            require 'none-ls.formatting.ruff_format',

            -- SQLFluff for MySQL
            diagnostics.sqlfluff.with {
                extra_args = { '--dialect', 'mysql' },
            },
            formatting.sqlfluff.with {
                extra_args = { '--dialect', 'mysql', '--nocolor' },
            },
        }

        null_ls.setup {
            sources = sources,
            positional_encoding = 'utf-16',
            on_attach = function(client, bufnr)
                if client.supports_method 'textDocument/formatting' then
                    local augroup = vim.api.nvim_create_augroup('LspFormatting', { clear = false })
                    vim.api.nvim_clear_autocmds { group = augroup, buffer = bufnr }
                    vim.api.nvim_create_autocmd('BufWritePre', {
                        group = augroup,
                        buffer = bufnr,
                        callback = function()
                            -- Only run formatting if this is the active buffer to avoid race
                            if vim.api.nvim_get_current_buf() == bufnr then
                                vim.lsp.buf.format {
                                    async = true, -- use async to reduce blocking
                                    filter = function(format_client)
                                        -- For C/C++ use clangd, otherwise null-ls
                                        local filetype = vim.api.nvim_buf_get_option(bufnr, 'filetype')
                                        if filetype == 'c' or filetype == 'cpp' then
                                            return format_client.name == 'clangd'
                                        else
                                            return format_client.name == 'null-ls'
                                        end
                                    end,
                                    bufnr = bufnr,
                                }
                            end
                        end,
                    })
                end
            end,
        }
    end,
}

--         local augroup = vim.api.nvim_create_augroup('LspFormatting', {})
--         null_ls.setup {
--             -- debug = true, -- Enable debug mode. Inspect logs with :NullLsLog.
--             sources = sources,
--             -- you can reuse a shared lspconfig on_attach callback here
--             on_attach = function(client, bufnr)
--                 if client.supports_method 'textDocument/formatting' then
--                     vim.api.nvim_clear_autocmds { group = augroup, buffer = bufnr }
--                     vim.api.nvim_create_autocmd('BufWritePre', {
--                         group = augroup,
--                         buffer = bufnr,
--                         callback = function()
--                             vim.lsp.buf.format {
--                                 async = false,
--                                 filter = function(format_client)
--                                     return format_client.name == 'null-ls'
--                                 end,
--                                 bufnr = bufnr,
--                             }
--                         end,
--                     })
--                 end
--             end,
--         }
--     end,
-- }

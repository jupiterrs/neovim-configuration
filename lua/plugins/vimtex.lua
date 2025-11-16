return {
    {
        'lervag/vimtex',
        config = function()
            -- Use zathura for PDF viewing
            vim.g.vimtex_view_method = 'zathura'

            -- Use latexmk for compilation with options
            vim.g.vimtex_compiler_method = 'latexmk'
            vim.g.vimtex_compiler_latexmk = {
                options = {
                    '-pdf',
                    '-interaction=nonstopmode',
                    '-synctex=1',
                },
            }

            -- Enable continuous compilation
            vim.g.vimtex_compiler_latexmk_continuous = 1

            -- Optional: enable forward search by default (jump from tex -> pdf)
            vim.g.vimtex_view_forward_search_on_start = 1
        end,
    },
}

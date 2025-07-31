return {
    {
        'tpope/vim-dadbod',
        lazy = true,
        ft = { 'sql', 'mysql', 'plsql' },
    },
    {
        'kristijanhusak/vim-dadbod-ui',
        dependencies = { 'tpope/vim-dadbod' },
        cmd = { 'DBUI', 'DBUIToggle', 'DBUIAddConnection', 'DBUIFindBuffer' },
        init = function()
            -- Optional: Set default DB connection
            vim.g.db_ui_use_nerd_fonts = 1
            vim.g.db_ui_max_lines = 1000 -- or your desired value
        end,
    },
    {
        'kristijanhusak/vim-dadbod-completion',
        ft = { 'sql', 'mysql', 'plsql' },
        dependencies = { 'tpope/vim-dadbod' },
        config = function()
            require('cmp').setup.buffer {
                sources = {
                    { name = 'vim-dadbod-completion' },
                    { name = 'buffer' },
                },
            }
        end,
    },
}

return {
    'scalameta/nvim-metals',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
        local metals_config = require('metals').bare_config()
        -- Optional settings
        metals_config.settings = {
            showImplicitArguments = true,
            serverVersion = 'latest.snapshot',
        }
        metals_config.init_options.statusBarProvider = 'on'

        -- Autocmd to start Metals on Scala files
        vim.api.nvim_create_autocmd('FileType', {
            pattern = { 'scala', 'sbt', 'java' },
            callback = function()
                require('metals').initialize_or_attach(metals_config)
            end,
        })
    end,
}

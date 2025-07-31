-- Set leader key
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Disable the spacebar key's default behavior in Normal and Visual modes
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- For conciseness
local opts = { noremap = true, silent = true }

-- save file
vim.keymap.set('n', '<C-s>', '<cmd> w <CR>', opts)

-- save file without auto-formatting
vim.keymap.set('n', '<leader>sn', '<cmd>noautocmd w <CR>', opts)

-- quit file
vim.keymap.set('n', '<C-q>', '<cmd> q <CR>', opts)

-- delete single character without copying into register
vim.keymap.set('n', 'x', '"_x', opts)

-- Vertical scroll and center
vim.keymap.set('n', '<C-d>', '<C-d>zz', opts)
vim.keymap.set('n', '<C-u>', '<C-u>zz', opts)

-- Find and center
vim.keymap.set('n', 'n', 'nzzzv', opts)
vim.keymap.set('n', 'N', 'Nzzzv', opts)

-- Resize with arrows
vim.keymap.set('n', '<Up>', ':resize -2<CR>', opts)
vim.keymap.set('n', '<Down>', ':resize +2<CR>', opts)
vim.keymap.set('n', '<Left>', ':vertical resize -2<CR>', opts)
vim.keymap.set('n', '<Right>', ':vertical resize +2<CR>', opts)

-- Buffers
vim.keymap.set('n', '<Tab>', ':bnext<CR>', opts)
vim.keymap.set('n', '<S-Tab>', ':bprevious<CR>', opts)
vim.keymap.set('n', '<leader>x', ':bdelete!<CR>', opts) -- close buffer
vim.keymap.set('n', '<leader>b', '<cmd> enew <CR>', opts) -- new buffer

-- Window management
vim.keymap.set('n', '<leader>v', '<C-w>v', opts) -- split window vertically
vim.keymap.set('n', '<leader>h', '<C-w>s', opts) -- split window horizontally
vim.keymap.set('n', '<leader>se', '<C-w>=', opts) -- make split windows equal width & height
vim.keymap.set('n', '<leader>xs', ':close<CR>', opts) -- close current split window

-- Navigate between splits
vim.keymap.set('n', '<C-k>', ':wincmd k<CR>', opts)
vim.keymap.set('n', '<C-j>', ':wincmd j<CR>', opts)
vim.keymap.set('n', '<C-h>', ':wincmd h<CR>', opts)
vim.keymap.set('n', '<C-l>', ':wincmd l<CR>', opts)

-- Tabs
vim.keymap.set('n', '<leader>to', ':tabnew<CR>', opts) -- open new tab
vim.keymap.set('n', '<leader>tx', ':tabclose<CR>', opts) -- close current tab
vim.keymap.set('n', '<leader>tn', ':tabn<CR>', opts) --  go to next tab
vim.keymap.set('n', '<leader>tp', ':tabp<CR>', opts) --  go to previous tab

-- Toggle line wrapping
vim.keymap.set('n', '<leader>lw', '<cmd>set wrap!<CR>', opts)

-- Stay in indent mode
vim.keymap.set('v', '<', '<gv', opts)
vim.keymap.set('v', '>', '>gv', opts)

-- Keep last yanked when pasting
vim.keymap.set('v', 'p', '"_dP', opts)

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>d', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

--Running Python files everywhere
-- vim.api.nvim_set_keymap('n', '<leader>r', ':lua RunPython()<CR>', { noremap = true, silent = true })
-- function RunPython()
--     -- Save the current file
--     vim.cmd 'write'
--     --
--     -- Get the absolute path of the current file
--     local filepath = vim.fn.expand '%:p'
--
--     -- Check if the filepath is valid
--     if filepath == '' then
--         print 'No file to run!'
--         return
--     end
--
--     -- Open a floating terminal and execute the Python file
--     require('toggleterm').exec('python ' .. filepath, 1, 12, 'float')
-- end
local function run_current_file()
    -- Save the current file
    vim.cmd 'w'

    local bufname = vim.api.nvim_buf_get_name(0) -- Get full file path
    local filetype = vim.bo.filetype -- Detect filetype
    local term_cmd

    if filetype == 'c' then
        -- Compile and run C program
        term_cmd = string.format('gcc %s -o output && ./output', bufname)
    elseif filetype == 'cpp' then
        -- Compile and run C++ program
        term_cmd = string.format('g++ "%s" -o /tmp/output && /tmp/output', bufname)
    elseif filetype == 'python' then
        -- Run Python script
        term_cmd = string.format('python3 %s', bufname)
    else
        print 'Unsupported file type'
        return
    end

    -- Open a floating terminal and execute the command
    require('toggleterm').exec(term_cmd, 1, 12, 'float')
end

-- local function run_current_file()
--     vim.cmd 'w' -- Save current buffer
--
--     local bufname = vim.api.nvim_buf_get_name(0)
--     local filetype = vim.bo.filetype
--     local compile_cmd, run_cmd
--
--     -- Determine compile and run commands
--     if filetype == 'cpp' then
--         compile_cmd = string.format('g++ "%s" -o /tmp/output', bufname)
--         run_cmd = '/tmp/output < /tmp/input.txt'
--     elseif filetype == 'c' then
--         compile_cmd = string.format('gcc "%s" -o /tmp/output', bufname)
--         run_cmd = '/tmp/output < /tmp/input.txt'
--     elseif filetype == 'python' then
--         compile_cmd = ''
--         run_cmd = string.format('python3 "%s" < /tmp/input.txt', bufname)
--     else
--         print('Unsupported filetype: ' .. filetype)
--         return
--     end
--
--     -- Open a split buffer to accept input
--     vim.cmd 'new' -- horizontal split
--     local input_buf = vim.api.nvim_get_current_buf()
--     vim.api.nvim_buf_set_name(input_buf, 'Input for Program')
--     vim.bo[input_buf].buftype = 'acwrite' -- allow writing
--     vim.bo[input_buf].bufhidden = 'wipe'
--     vim.bo[input_buf].swapfile = false
--     print 'Write your input here. Save (:w) to run the program.'
--
--     -- Define BufWriteCmd handler
--     vim.api.nvim_buf_create_user_command(input_buf, 'RunWithInput', function()
--         local lines = vim.api.nvim_buf_get_lines(input_buf, 0, -1, false)
--         local input_text = table.concat(lines, '\n')
--
--         -- Write to input.txt
--         local f = io.open('/tmp/input.txt', 'w')
--         f:write(input_text)
--         f:close()
--
--         -- Compile if needed
--         if compile_cmd and #compile_cmd > 0 then
--             os.execute(compile_cmd)
--         end
--
--         -- Close input buffer
--         vim.cmd 'bd!'
--
--         -- Run the program with input file in a floating terminal
--         require('toggleterm').exec(run_cmd, 1, 12, 'float')
--     end, {})
--
--     -- Automatically run RunWithInput when saving input buffer
--     vim.api.nvim_create_autocmd('BufWriteCmd', {
--         buffer = input_buf,
--         callback = function()
--             vim.cmd 'RunWithInput'
--         end,
--     })
-- end

vim.api.nvim_set_keymap('n', '<leader>r', '<cmd>lua run_with_input()<CR>', { noremap = true, silent = true })

-- Keymap (optional)
vim.api.nvim_set_keymap('n', '<leader>ri', '', {
    noremap = true,
    callback = run_current_file_with_input,
    desc = 'Run file with input from split',
})
-- Keymap to save & run the current file with Space + R
vim.keymap.set('n', '<leader>r', run_current_file, { noremap = true, silent = true })

-- Commands for SQL files
vim.keymap.set('n', '<leader>db', function()
    vim.cmd 'DB mysql://root:Endothermic12345!@127.0.0.1:3306/sakila'
end, { desc = 'Connect to Sakila DB' })

vim.keymap.set('n', '<leader>du', ':DBUI<CR>', { desc = 'Open DB UI' })

vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufReadPost' }, {
    pattern = '*.cpp',
    callback = function(args)
        local buf = args.buf
        local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)

        -- Only insert template if file is empty
        if #lines == 1 and lines[1] == '' then
            local template_path = vim.fn.stdpath 'config' .. '/templates/cpp_template.cpp'
            local file = io.open(template_path, 'r')
            if not file then
                return
            end
            local content = file:read '*a'
            file:close()

            -- Replace placeholders
            content = content:gsub('%%ID%%', 'jupiter21'):gsub('%%LANG%%', 'C++17')

            vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.split(content, '\n'))
        end
    end,
})

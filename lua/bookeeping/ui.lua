local Buffer = require("bookeeping.buffer")
local Data = require('bookeeping.data')

local BookeepingUI = {}

function BookeepingUI.create_window()
    local buf = Buffer.setup_buffer()
    local buf_lines = Buffer.get_contents(buf)


    -- Determine size and position
    local width = 120
    local height = math.min(#buf_lines + 6, vim.o.lines - 6)
    local row = vim.o.lines / 8                         -- vertical center
    local col = math.floor((vim.o.columns - width) / 2) -- horizontal center


    -- Create a floating window
    local win = vim.api.nvim_open_win(buf, false, {
        title = "Bookeeping",
        relative = "editor",
        width = width,
        height = height,
        row = row,
        col = col,
        style = 'minimal',
        border = "rounded",
        title_pos = 'center'
    })

    vim.api.nvim_win_set_option(win, "number", false)


    -- New note window
    -- local w_height = math.min(math.floor(height / 4), vim.o.lines / 3)
    local w_height = 4
    local w_buf = Buffer.setup_write_buffer()
    local w_row = row * 4
    local w_win = vim.api.nvim_open_win(w_buf, true, {
        title = 'Add Entry',
        relative = 'win',
        win = win,
        height = w_height,
        width = width,
        style = 'minimal',
        border = 'single',
        row = w_row,
        col = -1,
        title_pos = 'left',
    })

    vim.api.nvim_set_option_value('number', true, { win = w_win })

    -- Map's
    local map_function = '<CMD>lua require("bookeeping.ui").close_window(' .. win .. ',' .. w_win .. ')<CR>'

    vim.api.nvim_buf_set_keymap(buf, "n", "<Esc>", map_function, { noremap = true, silent = true })
    vim.api.nvim_buf_set_keymap(w_buf, "n", "<Esc>", map_function, { noremap = true, silent = true })

    -- Save with ":w"
    vim.api.nvim_create_autocmd("BufWriteCmd", {
        buffer = w_buf,
        callback = function()
            local content_lines = Buffer.get_contents(w_buf)
            Data.save_note({ date = os.date('%c'), lines = content_lines })
            vim.api.nvim_set_option_value("modified", false, { buf = w_buf })
            print("Note saved!")
            BookeepingUI.close_window(win, w_win)
            BookeepingUI.create_window()
        end
    })
end

function BookeepingUI.close_window(w_parent, w_child)
    vim.api.nvim_win_close(w_parent, true)
    vim.api.nvim_win_close(w_child, true)
end

return BookeepingUI

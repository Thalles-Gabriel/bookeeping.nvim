local Buffer = require("notekeeper.buffer")


local NotekeeperUI = {}

function NotekeeperUI.create_window()
    local buf = Buffer.setup_buffer()
    local buf_lines = Buffer.get_contents(buf)


    -- Determine size and position 
    local width = 120
    local height = math.min(#buf_lines + 6, vim.o.lines - 4)
    local row = math.floor((vim.o.lines - height) / 2) -- vertical center
    local col = math.floor((vim.o.columns - width) / 2) -- horizontal center


    -- Create a floating window
    local win = vim.api.nvim_open_win(buf, true, {
        title = "NoteKeeper",
        relative = "editor",
        width = width,
        height = height,
        row = row,
        col = col,
        style = "minimal",
        border = "single",
    })

    vim.api.nvim_win_set_option(win, "number", true)

    -- Map's
    vim.api.nvim_buf_set_keymap(buf, "n", "<Esc>", [[<Cmd>lua vim.api.nvim_win_close(0, true)<CR>]], { noremap = true, silent = true })

end

return NotekeeperUI

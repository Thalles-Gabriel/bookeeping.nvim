local Buffer = require("notekeeper.buffer")


local NotekeeperUI = {}

function NotekeeperUI.create_window()

    local buf = Buffer.setup_buffer()

    local buf_size = Buffer.get_contents(buf)

    -- Determine size and position 
    local width = 40
    local height = #buf_size + 2
    local row = math.floor((vim.o.lines - height) / 2) -- vertical center
    local col = math.floor((vim.o.columns - width) / 2) -- horizontal center

    -- Create a floating window
    local _ = vim.api.nvim_open_win(buf, true, {
        relative = "editor",
        width = width,
        height = height,
        row = row,
        col = col,
        style = "minimal",
        border = "single",
    })

    -- Map <Esc> key to close
    vim.api.nvim_buf_set_keymap(buf, "n", "<Esc>", [[<Cmd>lua vim.api.nvim_win_close(0, true)<CR>]], { noremap = true, silent = true })
end

return NotekeeperUI

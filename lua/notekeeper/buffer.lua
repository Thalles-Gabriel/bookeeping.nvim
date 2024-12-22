local Buffer = {}


function Buffer.setup_buffer()
    -- Line Test
    local lines = {
        "popup test!",
        "Line 1: Test",
        "Line 2: Hello!",
        "Press <Esc> to exit",
    }

    -- Create floating buffer
    local buf = vim.api.nvim_create_buf(false, true) -- Non listed and temporary buffer
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

    -- Define opções do buffer
    vim.api.nvim_buf_set_option(buf, "modifiable", false)
    vim.api.nvim_buf_set_option(buf, "bufhidden", "wipe")

    return buf
end

---@param buf number
function Buffer.get_contents(buf)
    local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, true)
    local indices = {}

    for _, line in pairs(lines) do
        table.insert(indices, line)
    end

    return indices
end

return Buffer

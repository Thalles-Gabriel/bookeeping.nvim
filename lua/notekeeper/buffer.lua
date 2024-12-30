local Data = require("notekeeper.data")

local Buffer = {}


function Buffer.setup_buffer()
    local notes = Data.load_notes()

    -- Create floating buffer
    local buf = vim.api.nvim_create_buf(false, true) -- Non listed and temporary buffer

    -- Load saved notes
    local lines = {}
    for i, note in ipairs(notes) do
        local context = note.file and string.format("[%s:%d]", vim.fn.fnamemodify(note.file, ":t"), note.row or 0) or ""
        table.insert(lines, string.format("%d: %s %s", i, note.content, context))
    end
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

    -- Buffer options
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

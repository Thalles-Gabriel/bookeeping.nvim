local Data = require("notekeeper.data")

local Buffer = {}

function Buffer.setup_buffer()
    local note = Data.load_note()

    -- Create floating buffer
    local buf = vim.api.nvim_create_buf(false, true) -- Non listed and temporary buffer

    -- Load saved notes
    local lines = {}


    if note and note.lines then
        for _, line in ipairs(note.lines) do
            table.insert(lines, line)
        end
    end


    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

    -- Buffer options
    vim.api.nvim_buf_set_option(buf, "modifiable", true)
    vim.api.nvim_buf_set_option(buf, "bufhidden", "wipe")
    vim.api.nvim_buf_set_option(buf, "filetype", "notekeeper")
    vim.api.nvim_buf_set_option(buf, "buftype", "acwrite")


    -- Save with ":w"
    vim.api.nvim_create_autocmd("BufWriteCmd", {
        buffer = buf,
        callback = function()
            local content_lines = Buffer.get_contents(buf)
            Data.save_note({ lines = content_lines })
            print("Note saved!")
        end
    })

    return buf
end

---@param buf number
function Buffer.get_contents(buf)
    return vim.api.nvim_buf_get_lines(buf, 0, -1, false)
end

function Buffer.delete_note()
    local buf = vim.api.nvim_get_current_buf()
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, {})
    Data.save_note({ lines = {} })
    print("Note deleted!")
end

return Buffer

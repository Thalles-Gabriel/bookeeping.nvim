local Data = require("bookeeping.data")
local Utils = require("bookeeping.utils")

local Buffer = {}

function Buffer.setup_buffer()
    local notes = Data.load_notes()

    -- Create floating buffer
    local buf = vim.api.nvim_create_buf(false, true) -- Non listed and temporary buffer

    local set_lines = vim.api.nvim_buf_set_lines

    if notes then
        local buf_lines = Utils.get_note_text(notes)
        set_lines(buf, 0, -1, false, buf_lines)
    else
        set_lines(buf, 0, -1, false, { 'No notes yet!' })
    end

    vim.api.nvim_buf_set_name(buf, "Bookeeping")


    -- Buffer options
    vim.api.nvim_buf_set_option(buf, "buftype", "nowrite")
    vim.api.nvim_buf_set_option(buf, "modifiable", false)
    vim.api.nvim_buf_set_option(buf, "bufhidden", "wipe")
    vim.api.nvim_buf_set_option(buf, "filetype", "bookeeping")


    return buf
end

function Buffer.setup_write_buffer()
    local buf = vim.api.nvim_create_buf(true, true)

    vim.api.nvim_buf_set_name(buf, "Note")
    vim.api.nvim_set_option_value("buftype", "acwrite", { buf = buf })
    vim.api.nvim_set_option_value("modifiable", true, { buf = buf })
    vim.api.nvim_set_option_value("readonly", false, { buf = buf })
    vim.api.nvim_set_option_value("bufhidden", "wipe", { buf = buf })
    vim.api.nvim_set_option_value("filetype", "bookeeping", { buf = buf })

    return buf
end

---@param buf number
function Buffer.get_contents(buf)
    return vim.api.nvim_buf_get_lines(buf, 0, -1, false)
end

function Buffer.delete_note()
    local buf = vim.api.nvim_get_current_buf()
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, {})
    Data.delete_note()
end

return Buffer

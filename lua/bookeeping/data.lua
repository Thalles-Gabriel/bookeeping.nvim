local Data = {}

local data_path = string.format("%s/bookeeping", vim.fn.stdpath("data"))

-- Make sure the data path exists
local function ensure_data_path()
    if vim.fn.isdirectory(data_path) == 0 then
        vim.fn.mkdir(data_path) -- Create directory "bookeeping" if "~/.local/share/nvim/" exists
    end
end

-- Create an unique hash for the current project
local function hash()
    local cwd = vim.fn.getcwd()
    return vim.fn.sha256(cwd)
end

-- Get the path to the JSON file of the current project
local function get_project_path()
    ensure_data_path()
    local project_hash = hash()
    return string.format("%s/%s.json", data_path, project_hash)
end

-- Load note from the JSON file
function Data.load_notes()
    local path = get_project_path()

    if vim.fn.filereadable(path) == 0 then
        return nil
    end

    local content = vim.fn.readfile(path)
    local success, decoded = pcall(vim.fn.json_decode, table.concat(content, "\n"))

    if not success then
        return { "Error loading JSON file", vim.log.levels.ERROR }
    end

    return decoded
end

---@param note table
function Data.save_note(note)
    local path = get_project_path()
    local notes = Data.load_notes()

    if not notes then
        local content = vim.fn.json_encode({ note } or { { date = {}, lines = {} } })
        vim.fn.writefile(vim.split(content, '\n'), path)
        return
    end
    table.insert(notes, note)
    local json_notes = vim.fn.json_encode(notes)
    vim.fn.writefile(vim.split(json_notes, "\n"), path)
end

function Data.delete_note()
    Data.save_note({ date = {}, lines = {} })
    vim.notify("Note deleted!", vim.log.levels.INFO)
end

return Data

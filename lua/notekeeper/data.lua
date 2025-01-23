local Data = {}

local data_path = string.format("%s/notekeeper", vim.fn.stdpath("data"))

-- Make sure the data path exists
local function ensure_data_path()
    if vim.fn.isdirectory(data_path) == 0 then
        vim.fn.mkdir(data_path) -- Create directory "notekeeper" if "~/.local/share/nvim/" exists
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
    local full_path = string.format("%s/%s.json", data_path, project_hash)

    if vim.fn.filereadable(full_path) == 0 then
        vim.fn.writefile({vim.fn.json_encode({notes = {}})}, full_path)
    end

    return full_path
end

-- Load notes from the JSON file
function Data.load_notes()
    local path = get_project_path()

    local content = vim.fn.readfile(path)
    local success, decoded_file = pcall(vim.fn.json_decode, table.concat(content, "\n"))

    if not success then
        return {"Error loading JSON file"}
    end

    return decoded_file.notes or {}
end

---@param notes table
function Data.save_notes(notes)
    local path = get_project_path()
    local content = vim.fn.json_encode({notes = notes})
    vim.fn.writefile({content}, path)
end

---@param index number
function Data.delete_notes(index)
    local notes = Data.load_notes()
    if index > 0 and index <= #notes then
        table.remove(notes, index)
        Data.save_notes(notes)
        vim.notify("Note deleted!", vim.log.levels.INFO)
    else
        vim.notify("Invalid index for note deletion.", vim.log.levels.WARN)
    end
end

return Data

local Notekeeper = {}

function Notekeeper.setup()
    vim.api.nvim_set_keymap("n", "<leader>n", "<Cmd>lua require('notekeeper.ui').create_window()<CR>", { noremap = true, silent = true })

    vim.api.nvim_create_user_command("Notekeeper", function()
        require("notekeeper.ui").create_window()
    end, {})

end

return Notekeeper


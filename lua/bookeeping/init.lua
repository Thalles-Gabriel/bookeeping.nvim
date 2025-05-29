local Bookeeping = {}

function Bookeeping.setup()
    vim.api.nvim_set_keymap("n", "<leader>b", "<Cmd>lua require('bookeeping.ui').create_window()<CR>", { noremap = true, silent = true })

    vim.api.nvim_create_user_command("Bookeeping", function()
        require("bookeeping.ui").create_window()
    end, {})

end

return Bookeeping


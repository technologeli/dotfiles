return {
    "theprimeagen/harpoon",
    keys = {
        { "<leader>a", function() require("harpoon.mark").add_file() end,                 desc = "[A]dd File to Harpoon" },
        { "<C-e>",     function() require("harpoon.ui").toggle_quick_menu() end,          desc = "Toggle Harpoon Menu" },
        { "<leader>1", function() require("harpoon.ui").nav_file(1) end, desc = "Harpoon File 1" },
        { "<leader>2", function() require("harpoon.ui").nav_file(2) end, desc = "Harpoon File 2" },
        { "<leader>3", function() require("harpoon.ui").nav_file(3) end, desc = "Harpoon File 3" },
    }

}

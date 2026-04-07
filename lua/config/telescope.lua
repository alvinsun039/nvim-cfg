local telescope = require("telescope")
local builtin = require("telescope.builtin")
local actions = require("telescope.actions")

-- Telescope keymaps (shown in which-key)
vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find files" })
vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Live grep" })
vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Buffers" })
vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Help tags" })

-- dir-telescope keymaps
vim.keymap.set("n", "<leader>fd", "<cmd>Telescope dir live_grep<CR>", { desc = "Dir live grep" })
vim.keymap.set("n", "<leader>fD", "<cmd>Telescope dir find_files<CR>", { desc = "Dir find files" })


telescope.setup({

  defaults = {

    vimgrep_arguments = {
      "rg",
      "--color=never",
      "--no-heading",
      "--with-filename",
      "--line-number",
      "--column",
      "--smart-case",
      "--hidden",
    },

    file_ignore_patterns = {
      "%.o$", "%.a$", "%.so$", "%.pyc$", "%.dll$", "%.exe$",
      "%.png$", "%.jpg$", "%.jpeg$", "%.gif$", "%.ico$", "%.pdf$",
      "%.zip$", "%.tar%.gz$", "%.rar$", "%.rmeta$",
    },

    layout_strategy = "horizontal",

    layout_config = {
      width = 0.9,
      height = 0.85,
      preview_width = 0.55,
      prompt_position = "top",
    },

    path_display = { "truncate" },

    sorting_strategy = "ascending",

    mappings = {

      i = {
        ["<esc>"] = actions.close
      },

      n = {
        ["<esc>"] = actions.close
      }

    }

  }

})

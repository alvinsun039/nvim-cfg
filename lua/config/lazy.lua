local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim",
    lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)

require("lazy").setup({

  -- Smart yank: only copy to system clipboard on intentional yank (y), supports tmux/OSC52
  {
    "ibhagwan/smartyank.nvim",
    config = function()
      require("smartyank").setup({
        -- highlight = { enabled = true, higroup = "IncSearch", timeout = 2000 },
        -- clipboard = { enabled = true },
        -- tmux = { enabled = true, cmd = { "tmux", "set-buffer", "-w" } },
        -- osc52 = { enabled = true, ssh_only = true, silent = false, echo_hl = "Directory" },
      })
    end,
  },

  {"neovim/nvim-lspconfig"},

  {
    "simrat39/rust-tools.nvim",
    dependencies = {"neovim/nvim-lspconfig"}
  },

  {
    -- LuaSnip: snippet engine; pin major version to avoid breaking changes
    "L3MON4D3/LuaSnip",
    version = "v2.*",
    -- optional: regex support for snippet transforms
    build = "make install_jsregexp",
    dependencies = { "rafamadriz/friendly-snippets" }, -- prebuilt snippet collection
  },
  {
    -- nvim-cmp: completion
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",     -- LSP source
      "hrsh7th/cmp-buffer",       -- buffer source
      "hrsh7th/cmp-path",         -- path source
      "saadparwaiz1/cmp_luasnip", -- LuaSnip source
    },
  },

  {"nvim-treesitter/nvim-treesitter", build = ":TSUpdate"},

  {"nvim-telescope/telescope.nvim",
  dependencies = {"nvim-lua/plenary.nvim"}},

  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
      { "<leader>e", "<cmd>NvimTreeToggle<CR>", desc = "Toggle file tree" },
      { "<leader>E", "<cmd>NvimTreeFocus<CR>", desc = "Focus file tree" },
    },
    opts = {
      view = {
        width = 32,
        side = "left",
        number = false,
        relativenumber = false,
        signcolumn = "yes",
      },
      renderer = {
        group_empty = true,
        icons = {
          show = {
            file = true,
            folder = true,
            folder_arrow = true,
            git = true,
          },
          glyphs = {
            default = "",
            symlink = "",
            folder = {
              arrow_closed = "",
              arrow_open = "",
              default = "",
              open = "",
              empty = "",
              empty_open = "",
              symlink = "",
              symlink_open = "",
            },
            git = {
              unstaged = "",
              staged = "✓",
              unmerged = "",
              renamed = "➜",
              untracked = "",
              deleted = "",
              ignored = "◌",
            },
          },
        },
      },
      filters = {
        dotfiles = true,
        custom = {},
        exclude = {},
      },
      update_focused_file = {
        enable = true,                  -- reveal and focus current file
        update_cwd = false,             -- do not change cwd (recommend false)
      },
      git = {
        enable = true,
        ignore = false,
        timeout = 400,
      },
      actions = {
        open_file = {
          quit_on_open = false,
          window_picker = { enable = true },
        },
      },
      diagnostics = {
        enable = true,
        show_on_dirs = true,
        icons = {
          hint = "",
          info = "",
          warning = "",
          error = "",
        },
      },
    },
    config = function(_, opts)
      require("nvim-tree").setup(opts)
      -- open nvim-tree when opening a directory and close placeholder buffer
      vim.api.nvim_create_autocmd("VimEnter", {
        callback = function(data)
          local dir = vim.fn.isdirectory(data.file) == 1
          if dir then
            vim.cmd.cd(data.file)
            require("nvim-tree.api").tree.open()
            vim.cmd.bw(data.buf)
          end
        end,
      })
    end,
  },

  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup({
        on_attach = function(bufnr)
          local gs = require("gitsigns")

          -- shared opts for all keymaps
          local opts = { buffer = bufnr, noremap = true, silent = true }

          vim.keymap.set('n', '<leader>hs', gs.preview_hunk, vim.tbl_extend('force', opts, { desc = "Preview hunk" }))
        end
      })
    end
  },

  {
    "folke/trouble.nvim",
    dependencies = "nvim-tree/nvim-web-devicons",
    opts = {
      -- customize icons/position here, e.g. position = "bottom"
    },
    cmd = "Trouble", -- lazy-load on command
    keys = {
      { "<leader>xx", "<cmd>Trouble diagnostics toggle<CR>", desc = "Diagnostics" },
      { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<CR>", desc = "Buffer diagnostics" },
      { "<leader>xr", "<cmd>Trouble lsp_references toggle<CR>", desc = "LSP references" },
    },
  },

  {
    "ellisonleao/gruvbox.nvim",
    priority = 1000,
    config = function()
      require("gruvbox").setup({
        transparent_mode = true,
      })
      vim.cmd.colorscheme("gruvbox")
    end
  },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = {
      "williamboman/mason.nvim",
      "neovim/nvim-lspconfig",
    }
  },
  {
    url = "https://codeberg.org/andyg/leap.nvim",
    config = function()
      local leap = require('leap')
      leap.setup({
        case_sensitive = false,
        highlight_unlabeled_phase_one_targets = false,
        max_phase_one_targets = nil,
        labels = "asdfghjklqwertyuiopzxcvbnm",
      })
      vim.keymap.set({"n","x","o"}, "s", "<Plug>(leap-forward)")
      vim.keymap.set({"n","x","o"}, "S", "<Plug>(leap-backward)")
    end
  },
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" }, -- optional, file icons
    config = function()
      require("lualine").setup({
        options = {
          theme = "auto",        -- match colorscheme
          component_separators = { left = "", right = "" },
          section_separators = { left = "", right = "" },
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { "branch", "diff", "diagnostics" },
          lualine_c = { "filename" },
          -- right: LSP status
          lualine_x = {
            { "lsp_status" },   -- LSP name when attached
            { "encoding" },
            { "fileformat" },
            { "filetype" },
          },
          lualine_y = { "progress" },
          lualine_z = { "location" },
        },
        extensions = { "nvim-tree" },
      })
    end,
  },
  {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      options = {
        mode = "buffers",
        numbers = "ordinal",
        close_command = "bdelete! %d",
        right_mouse_command = "bdelete! %d",
        left_mouse_command = "buffer %d",
        indicator = { style = "icon", icon = "▎" },
        buffer_close_icon = "",
        modified_icon = "●",
        close_icon = "",
        left_trunc_marker = "",
        right_trunc_marker = "",
        max_name_length = 18,
        max_prefix_length = 15,
        truncate_names = true,
        diagnostics = "nvim_lsp",
        diagnostics_indicator = function(count, level)
          local icon = level:match("error") and " " or " "
          return icon .. count
        end,
        offsets = {
          { filetype = "nvim-tree", text = "File Explorer", text_align = "center" },
        },
        color_icons = true,
        show_buffer_icons = true,
        show_buffer_close_icons = true,
        show_close_icon = true,
        persist_buffer_sort = true,
        separator_style = "slant",
        enforce_regular_tabs = false,
        always_show_bufferline = true,
      },
    },
  },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",  -- load late to avoid slowing startup
    opts = {
      preset = "modern",
      delay = 200,
    },
    keys = {
      {
        "<leader>?",
        function()
          require("which-key").show({ global = false })
        end,
        desc = "Buffer-local keymaps",
      },
    },
    config = function()
      require("which-key").add({
        { "<leader>d", group = "LSP symbols" },
        { "<leader>e", group = "File tree" },
        { "<leader>f", group = "Find (Telescope)" },
        { "<leader>h", group = "Git Hunk" },
        { "<leader>r", group = "LSP" },
        { "<leader>w", group = "LSP workspace" },
        { "<leader>x", group = "Diagnostics (Trouble)" },
      })
    end,
  }
})

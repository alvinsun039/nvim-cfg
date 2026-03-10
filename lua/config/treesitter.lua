require("nvim-treesitter").setup({

  -- grammars to install
  ensure_installed = {
    "c",
    "rust",
    "lua",
    "bash"
  },

  -- syntax highlight
  highlight = {
    enable = true
  },

})

require("nvim-treesitter").setup({
  highlight = {
    enable = true
  },
})

require("nvim-treesitter").install({ "c", "rust", "lua", "bash" })

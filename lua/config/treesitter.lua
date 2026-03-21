require("nvim-treesitter").setup({
  highlight = {
    enable = true
  },
  ensure_installed = { "c", "rust", "lua", "bash" }
})

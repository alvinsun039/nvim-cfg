-- Leader key and config modules
vim.g.mapleader = " "

require("config.lazy")
require("config.lsp")
require("config.cmp")
require("config.treesitter")
require("config.telescope")
require("config.mason")

-- Default border for all floating windows (LSP hover, diagnostic, etc.); Neovim 0.11+ no longer uses global LSP handlers for this
vim.o.winborder = "rounded"

-- Core editor options
vim.o.number = true
vim.o.relativenumber = true
vim.o.tabstop = 8
vim.o.shiftwidth = 8
vim.o.expandtab = false
vim.o.smartindent = true
vim.o.termguicolors = true

-- Set maximum text width for automatic line wrapping
vim.opt.textwidth = 80
-- Continue comments when reformatting text
vim.opt.formatoptions:append('c')
-- Automatically insert comment leader on pressing Enter in a comment line
vim.opt.formatoptions:append('r')

-- Filetype-specific indentation
local indent = vim.api.nvim_create_augroup("indent_settings", { clear = true })

-- Rust
vim.api.nvim_create_autocmd("FileType", {
  group = indent,
  pattern = "rust",
  callback = function()
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
    vim.opt_local.expandtab = true
  end,
})

-- Lua
vim.api.nvim_create_autocmd("FileType", {
  group = indent,
  pattern = "lua",
  callback = function()
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.expandtab = true
  end,
})

-- C (Linux kernel style)
vim.api.nvim_create_autocmd("FileType", {
  group = indent,
  pattern = "c",
  callback = function()
    vim.opt_local.tabstop = 8
    vim.opt_local.shiftwidth = 8
    vim.opt_local.expandtab = false
  end,
})

vim.diagnostic.config({
  float = { border = "rounded" },
})

-- Show diagnostic float on CursorHold
vim.o.updatetime = 250
vim.api.nvim_create_autocmd("CursorHold", {
  callback = function()
    vim.diagnostic.open_float(nil, { focusable = false })
  end
})

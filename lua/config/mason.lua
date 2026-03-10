require("mason").setup({
    ui = {
        border = "rounded",      -- window border style
        icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗"
        },
    },
    -- LSPs to install automatically
    ensure_installed = {
        "lua-language-server",
        "rust-analyzer",
    },
})

require("mason-lspconfig").setup({
    -- auto-install and wire to lspconfig
    automatic_installation = true,
})

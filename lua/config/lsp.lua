local capabilities = require("cmp_nvim_lsp").default_capabilities()

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)

    local opts = { buffer = args.buf }

    --    vim.keymap.set("n","gd",vim.lsp.buf.definition,opts)
    --    vim.keymap.set("n","gr",vim.lsp.buf.references,opts)
    -- Hover uses default handler; border comes from vim.o.winborder (init.lua)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, vim.tbl_extend("force", opts, { desc = "Hover" }))
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, vim.tbl_extend("force", opts, { desc = "Rename symbol" }))

    local builtin = require("telescope.builtin")

    -- references
    vim.keymap.set("n", "gr", builtin.lsp_references, { desc = "LSP references" })

    -- definition
    vim.keymap.set("n", "gd", builtin.lsp_definitions, { desc = "LSP definition" })

    -- implementation
    vim.keymap.set("n", "gi", builtin.lsp_implementations, vim.tbl_extend("force", opts, { desc = "Implementations" }))

    -- symbols
    vim.keymap.set("n", "<leader>ds", builtin.lsp_document_symbols, vim.tbl_extend("force", opts, { desc = "Document symbols" }))

    -- workspace symbols
    vim.keymap.set("n", "<leader>ws", builtin.lsp_workspace_symbols, vim.tbl_extend("force", opts, { desc = "Workspace symbols" }))

    local client = vim.lsp.get_client_by_id(args.data.client_id)

    if client and client.name == "rust_analyzer" then
      vim.lsp.inlay_hint.enable(true, { bufnr = args.buf })
    end

  end
})

vim.lsp.config("rust_analyzer", {
  capabilities = capabilities,
  settings = {
    ["rust-analyzer"] = {
      cargo = {
        buildScripts = { enable = false }
      },
      procMacro = {
        enable = true
      },
      checkOnSave = false,
      inlayHints = {
        enable = true,
        typeHints = { enable = true },
        parameterHints = { enable = true },
        chainingHints = { enable = true },
        maxLength = 25,
      },
    }
  }
})

-- vim.lsp.config("clangd", {
--   capabilities = capabilities,
--   cmd = {
--     "clangd",
--     "--background-index",
--     "--clang-tidy",
--     "--header-insertion=never"
--   }
-- })


vim.lsp.config("ccls", {
  capabilities = capabilities,
  init_options = {
    cache = {
      directory = '.ccls-cache',
    },
    index = {
      threads = 4,
    },
    clang = {
      extraArgs = { '-I/usr/include', '-I/usr/local/include', '--gcc-toolchain=/usr' },
      excludeArgs = {
        "-mstack-protector-guard-reg=sp_el0",
        "-mstack-protector-guard-offset=1384",
        "-mabi=lp64",
        "-fconserve-stack",
        "-falign-jumps=1",
        "-falign-loops=1",
        "-fconserve-stack",
        "-fmerge-constants",
        "-fno-code-hoisting",
        "-fno-schedule-insns",
        "-fno-sched-pressure",
        "-fno-var-tracking-assignments",
        "-fsched-pressure",
        "-mhard-float",
        "-mindirect-branch-register",
        "-mindirect-branch=thunk-inline",
        "-mpreferred-stack-boundary=2",
        "-mpreferred-stack-boundary=3",
        "-mpreferred-stack-boundary=4",
        "-mrecord-mcount",
        "-mindirect-branch=thunk-extern",
        "-mno-fp-ret-in-387",
        "-mskip-rax-setup",
        "--param=allow-store-data-races=0",
        "-Wa,arch/x86/kernel/macros.s",
        "-Wa,-",
      },
    },
  },
})

-- ccls only for C-family buffers (not at startup for every filetype)
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "c", "cpp", "objc", "objcpp", "cuda" },
  callback = function()
    vim.schedule(function()
      vim.lsp.enable("ccls", true)
    end)
  end,
})

vim.lsp.config("lua_ls", {
  capabilities = capabilities,
  settings = {
    Lua = {
      runtime = {
        version = "LuaJIT",
      },
      diagnostics = {
        globals = { "vim" },
      },
      workspace = {
        library = vim.api.nvim_get_runtime_file("", true),
      },
      telemetry = {
        enable = false,
      },
    },
  },
})

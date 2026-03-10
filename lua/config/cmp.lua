local cmp = require("cmp")
local luasnip = require("luasnip")

-- Load friendly-snippets (VSCode-style); loads prebuilt snippets
require("luasnip.loaders.from_vscode").lazy_load()

cmp.setup({
  snippet = {
    -- use LuaSnip for snippet expansion
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  -- completion sources
  sources = cmp.config.sources({
    { name = "nvim_lsp" },   -- LSP
    { name = "luasnip" },    -- LuaSnip
    { name = "buffer" },     -- buffer
    { name = "path" },       -- path
  }),
  -- mappings
  mapping = cmp.mapping.preset.insert({
    -- prev/next item
    ["<C-k>"] = cmp.mapping.select_prev_item(),
    ["<C-j>"] = cmp.mapping.select_next_item(),
    -- confirm
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
    -- Tab: next item or jump snippet
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { "i", "s" }),
    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { "i", "s" }),
  }),
})

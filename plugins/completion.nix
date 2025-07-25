{ pkgs, ... }:
let
  cmp_luasnip_choice = (pkgs.vimUtils.buildVimPlugin {
    pname = "cmp_luasnip_choice";
    version = "2023-03-06";
    src = pkgs.fetchFromGitHub {
      owner = "L3MON4D3";
      repo = "cmp-luasnip-choice";
      rev = "4f49232e51c9df379b9daf43f25f7ee6320450f0";
      sha256 = "sha256-/s1p/WLfrHZHX6fU1p2PUQ0GIocAB4mvhjZ0XUMzkaw=";
    };
    meta.homepage = "https://github.com/L3MON4D3/cmp-luasnip-choice";
    dependencies = [ pkgs.vimPlugins.nvim-cmp ];
  });
in
{
  binaries = [ ];
  lazy =
    with pkgs.vimPlugins;
    # lua
    ''
      {
        -- "L3MON4D3/cmp-luasnip-choice",
        dir = "${cmp_luasnip_choice}",
        name = "cmp_luasnip_choice",
        lazy = true,
        config = function()
          require("cmp_luasnip_choice").setup({
            auto_open = true, -- Automatically open nvim-cmp on choice node (default: true)
          })
        end,
      },
      {
        -- "hrsh7th/nvim-cmp",
        dir = "${nvim-cmp}",
        event = "VeryLazy",
        dependencies = {
          -- vs-code like pictograms
          { dir = "${lspkind-nvim}", name = "lspkind" },

          -- TODO maybe give otter-nvim another try

          { dir = "${luasnip}" },
          { dir = "${cmp_luasnip}", name = "cmp_luasnip" },
          { dir = "${cmp_luasnip_choice}", name = "cmp_luasnip_choice" },

          { dir = "${cmp-nvim-lua}", name = "cmp-nvim-lua" }, -- for nvim lua api comp
          { dir = "${cmp-nvim-lsp}", name = "cmp-nvim-lsp" }, -- do i need this?
          { dir = "${cmp-nvim-lsp-signature-help}", name = "cmp-nvim-lsp-signature-help" },

          { dir = "${cmp-path}", name = "cmp-path" },
          -- "FelipeLema/cmp-async-path", -- might replace cmp-path
          { dir = "${cmp-buffer}", name = "cmp-path"},
          -- "hrsh7th/cmp-calc", -- actually useless

          { dir = "${cmp-cmdline}", name = "cmp-cmdline" },

          -- latex symbols from julia, yet this is not perfect, missing combined utf-8 characters
          { dir = "${cmp-latex-symbols}", name = "cmp-latex-symbols" },
          -- emoji
          { dir = "${cmp-emoji}", name = "cmp-emoji" },

          -- maybe this: https://github.com/petertriho/cmp-git
        },
        config = function()
          -- Not all LSP servers add brackets when completing a function.

          local lspkind = require("lspkind")

          local cmp = require("cmp")
          local cmp_select = { behavior = cmp.SelectBehavior.Select }

          cmp.setup({
            snippet = {
              -- REQUIRED - you must specify a snippet engine
              expand = function(args)
                -- vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
                require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
                -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
                -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
              end,
            },

            mapping = {
              ["<C-d>"] = cmp.mapping.scroll_docs(4),
              ["<C-u>"] = cmp.mapping.scroll_docs(-4),
              ["<C-e>"] = cmp.mapping.close(),

              ["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
              ["<C-n>"] = cmp.mapping.select_next_item(cmp_select),
              ["<C-y>"] = cmp.mapping.confirm({
                select = true,
                behavior = cmp.ConfirmBehavior.Insert,
              }),
              ["<C-r>"] = cmp.mapping.confirm({
                select = true,
                behavior = cmp.ConfirmBehavior.Replace,
              }),
              ["<C-Space>"] = cmp.mapping.complete(),

              -- not use tab
              ["<Tab>"] = nil,
              ["<S-Tab>"] = nil,
            },

            -- i dont like them bordered
            -- window = {
            --     completion = cmp.config.window.bordered(),
            --     documentation = cmp.config.window.bordered(),
            -- },

            sources = cmp.config.sources({
              { name = "luasnip_choice" },
              --{ name = "calc" }, -- kinda useless
              { name = "nvim_lua" },
              { name = "nvim_lsp" },
              { name = "nvim_lsp_signature_help" },
              { name = "luasnip" },
            }, {
              { name = "path" },
              { name = "buffer", keyword_length = 3 },
            }, {
              {
                name = "latex_symbols",
                option = {
                  strategy = 0, -- mixed
                },
              },
            }, {
              { name = "emoji" },
            }),

            formatting = {
              format = lspkind.cmp_format({
                with_text = true,
                menu = {
                  buffer = "[buf]",
                  nvim_lsp = "[LSP]",
                  nvim_lua = "[api]",
                  path = "[path]",
                  luasnip = "[snip]",
                  calc = "[calc]",
                  latex_symbols = "[sym]",
                },
              }),
            },

            experimental = {
              ghost_text = true,
            },
          })

          -- `/` cmdline setup.
          cmp.setup.cmdline({ "/", "?" }, {
            mapping = cmp.mapping.preset.cmdline(),
            sources = {
              { name = "buffer", keyword_length = 2 },
            },
          })

          -- `:` cmdline setup.
          cmp.setup.cmdline(":", {
            mapping = cmp.mapping.preset.cmdline(),
            sources = cmp.config.sources({
              { name = "path" },
            }, {
              {
                name = "cmdline",
                option = {
                  ignore_cmds = { "Man", "!" },
                },
                keyword_length = 2,
              },
            }),
          })

          -- to fix cmp https://github.com/hrsh7th/nvim-cmp/issues/1511
          vim.keymap.set("c", "<tab>", "<C-z>", { silent = false }) -- <C-Space> jank (cursor jumps)
        end,
      },
      {
        -- "L3MON4D3/LuaSnip",
        dir = "${luasnip}",
        name = "luasnip",

        dependencies = { { dir = "${friendly-snippets}", name = "friendly-snippets" } },
        lazy = true, -- required by cmp

        config = function()
          local ls = require("luasnip")

          -- make aware of injected languages
          ls.setup({ ft_func = require("luasnip.extras.filetype_functions").from_pos_or_filetype })

          vim.keymap.set({ "i", "s" }, "<C-L>", function()
            ls.jump(1)
          end, { silent = true })
          vim.keymap.set({ "i", "s" }, "<C-J>", function()
            vim.print("goil")
            ls.jump(-1)
          end)

          vim.keymap.set({ "i", "s" }, "<C-E>", function()
            if ls.choice_active() then
              ls.change_choice(1)
            end
          end, { silent = true })

          require("luasnip.loaders.from_vscode").lazy_load() -- for friendly-snippets
        end,
      },

      --vim.keymap.set({ "i", "s" }, "<C-L>", function()
      --    require("luasnip").jump(1)
      --end, { silent = true })
      -- vim.keymap.set({ "i", "s" }, "<C-s>n", function()
      --     require("luasnip").jump(1)
      -- end, { silent = true })
      -- vim.keymap.set({ "i", "s" }, "<C-s>p", function()
      --     require("luasnip").jump(-1)
      -- end, { silent = true })

      --local ls = require("luasnip")
      --ls.filetype_extend("javascript", { "jsdoc" })

      ----- TODO: What is expand?
      --vim.keymap.set({ "i" }, "<C-s>e", function() ls.expand() end, { silent = true })

      --vim.keymap.set({ "i", "s" }, "<C-s>;", function() ls.jump(1) end, { silent = true })
      --vim.keymap.set({ "i", "s" }, "<C-s>,", function() ls.jump(-1) end, { silent = true })

      --vim.keymap.set({ "i", "s" }, "<C-E>", function()
      --    if ls.choice_active() then
      --        ls.change_choice(1)
      --    end
      --end, { silent = true })

      -- copied from https://sbulav.github.io/vim/neovim-setting-up-luasnip/

      --local ls = require("luasnip")
      ---- some shorthands...
      --local snip = ls.snippet
      --local node = ls.snippet_node
      --local text = ls.text_node
      --local insert = ls.insert_node
      --local func = ls.function_node
      --local choice = ls.choice_node
      --local dynamicn = ls.dynamic_node
      --
      ----local date = function() return {vim.fn.date('%Y-%m-%d')} end
      --
      --ls.add_snippets(nil, {
      --  all = {
      --    --snip({
      --    --    trig = "date",
      --    --    namr = "Date",
      --    --    dscr = "Date in the form of YYYY-MM-DD",
      --    --}, {
      --    --    func(date, {}),
      --    --}),
      --    --snip({
      --    --    trig = "meta",
      --    --    namr = "Metadata",
      --    --    dscr = "Yaml metadata format for markdown"
      --    --},
      --    --{
      --    --    text({"---",
      --    --    "title: "}), insert(1, "note_title"), text({"",
      --    --    "author: "}), insert(2, "author"), text({"",
      --    --    "date: "}), func(date, {}), text({"",
      --    --    "categories: ["}), insert(3, ""), text({"]",
      --    --    "lastmod: "}), func(date, {}), text({"",
      --    --    "tags: ["}), insert(4), text({"]",
      --    --    "comments: true",
      --    --    "---", ""}),
      --    --    insert(0)
      --    --})
      --  },
      --  java = {
      --    snip({
      --      trig = "main",
      --      namr = "Main",
      --      dsrc = "Static Main Method",
      --    }, {
      --      text({ "public static void main(String[] args) {", "    " }),
      --      insert(1, "statements"),
      --      text({ "", "}" }),
      --    })
      --  }
      --})
    '';
}

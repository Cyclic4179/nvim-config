local opts = { noremap = true, silent = true }
vim.keymap.set("i", "<C-J>", function() require 'luasnip'.jump(1) end, opts)
vim.keymap.set("i", "<C-K>", function() require 'luasnip'.jump(-1) end, opts)
--vim.keymap.set({ "i", "s" }, "<C-J>", function() require 'luasnip'.jump(1) end, opts)
--vim.keymap.set({ "i", "s" }, "<C-K>", function() require 'luasnip'.jump(-1) end, opts)



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

-- `:help nvim_set_keymap`, belong to nvim api
-- `:help nvim_buf_set_keymap`, belong to nvim api

vim.g.mapleader = " "
-- vim.g.maplocalleader = " "
--
-- local map = vim.api.nvim_set_keymap
-- local opt = {noremap = true, silent = true}
--
-- -- cancel substitute
-- --map("n", "s", "", opt)
--
-- -- alt + hkjl to move between windows
-- map("n", "<A-h>", "<C-w>h", opt)
-- map("n", "<A-j>", "<C-w>j", opt)
-- map("n", "<A-k>", "<C-w>k", opt)
-- map("n", "<A-l>", "<C-w>l", opt)
--
-- -- Terminal related
-- map("n", "<leader>t", ":sp | terminal<CR>", opt)
-- map("n", "<leader>vt", ":vsp | terminal<CR>", opt)
-- map("t", "<Esc>", "<C-\\><C-n>", opt)
-- map("t", "<A-h>", [[ <C-\><C-n><C-w>h ]], opt)
-- map("t", "<A-j>", [[ <C-\><C-n><C-w>j ]], opt)
-- map("t", "<A-k>", [[ <C-\><C-n><C-w>k ]], opt)
-- map("t", "<A-l>", [[ <C-\><C-n><C-w>l ]], opt)
--
-- -- visual mode indentation and shifting up/down
-- map("v", "J", ":move '>+1<CR>gv-gv", opt)
-- map("v", "K", ":move '<-2<CR>gv-gv", opt)
--
--
-- -- insert mode, I insert at first char and A append at last char
-- -- `:help i_CTRL-C`
-- map("i", "<C-h>", "<ESC>I", opt)
-- map("i", "<C-l>", "<ESC>A", opt)

local ls = require("luasnip")

----------------
-- Keymap Keyremap asd81923
----------------
local k = vim.keycode
vim.g.mapleader=k'<C-l>'
-- useless, vim.g.mapleader='<C-l>'

vim.keymap.set({"i"}, '<leader>h', function() ls.expand() end, {silent = true}) -- don't use <C-K>, collide with digraph, <C-;> is buggy for SUSE's
vim.keymap.set({"i", "s"}, '<leader>l', function() ls.jump( 1) end, {silent = true})
vim.keymap.set({"i", "s"}, '<leader>j', function() ls.jump(-1) end, {silent = true})

vim.keymap.set({"i", "s"}, "<leader>e", function()
  if ls.choice_active() then
    ls.change_choice(1)
  end
end, {silent = true})
vim.g.mapleader=nil

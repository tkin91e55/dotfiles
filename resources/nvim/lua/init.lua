-- Ref: https://github.com/nicknisi/dotfiles/blob/main/config/nvim/init.lua
-- Note that init.lua and init.vim cannot both exists under ~/.config/nvim/, they are both auto-loaded by neovim

local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath) --rtp: runtimepath

-- Load the *.lua under lua, for .lua under other subfolder: require('subforlder.filename')
-- Load the nvim plguins, look for plugins.lua under lua/

-- control on my different machines' config

-- on nvim 0.10
SUSEenv = {
  TS_VERSION='v0.9.3', -- the treesitter version, but html highlight is buggy, causing nvim to terminate
  TS_92_HTML_HL_BUG=true,  -- specfic and workaround to disable TS html highlight
  TELESCOPE_SEND_SELECTED_TO_QFLIST="<A-q>", -- the keyremap for telescope, don't use single quote, no idea why
}

-- on nvim 0.9.2
MacOSenv  = {
  TS_VERSION='v0.9.3',
  TELESCOPE_SEND_SELECTED_TO_QFLIST="œ",
}


-- # MyMistakes: lua quirk, 0 is not false, but positive
if vim.fn.has('macunix')==1 then
  vim.g.diffEnvs = MacOSenv
else
  vim.g.diffEnvs = SUSEenv
end


-- loading major components
require("plugins")
require("lsp")
-- DON'T ADD PLUGIN SPECIFIC CONFIG HERE, PUT THEM IN PLUGINS.LUA
local opt = vim.opt

--
-- Opts
--
opt.history = 1000
-- more realtime preview search
-- substitute in preview, exclusive to nvim : https://dev.to/voyeg3r/my-ever-growing-neovim-init-lua-h0p
opt.inccommand = 'nosplit'

-----------------------
-- WSL nvim clipboard support
-- https://mitchellt.com/2022/05/15/WSL-Neovim-Lua-and-the-Windows-Clipboard.html
-- need to download the win32yank.exe first
-- https://github.com/neovim/neovim/wiki/FAQ#how-to-use-the-windows-clipboard-from-wsl
-----------------------

--in_wsl = os.getenv('WSL_DISTRO_NAME') ~= nil
--
--  -- sym link the nvim_paste to /usr/local/bin/
--if in_wsl then
--    vim.g.clipboard = {
--        name = 'wsl clipboard',
--        copy =  { ["+"] = { "clip.exe" },   ["*"] = { "clip.exe" } },
--        paste = { ["+"] = { "nvim_paste" }, ["*"] = { "nvim_paste" } },
--        cache_enabled = true
--    }
--end

-- highlight yank
vim.api.nvim_create_autocmd('TextYankPost', {
  group = vim.api.nvim_create_augroup('highlight_yank', {}),
  desc = 'Hightlight selection on yank',
  pattern = '*',
  callback = function()
    vim.highlight.on_yank { higroup = 'OctoBubbleYellow', timeout = 750 }
  end,
})
-----------------------
-- everything in .vimrc,
-- can be wrapped here...,
-----------------------
vim.cmd([[
]])



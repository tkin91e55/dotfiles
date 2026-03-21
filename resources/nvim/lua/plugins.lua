-- This file can be loaded by calling `lua require('plugins')` from your init.vim
-- try as most as possible for nvim specific plugins, and init.vim or plug.vim are for both vim and neovim

require('lazy').setup({
    ----------------
    -- Colorscheme
    ----------------
    --for SUSE, ellisonleao work better, but not for mac
    --use 'ellisonleao/gruvbox.nvim'
    -- 'morhetz/gruvbox',
    {
      'tkin91e55/gruvbox-material',
      lazy = false,
      priority = 1000,
      branch='ts0.9.1',
      config = function()
        -- Optionally configure and load the colorscheme
        -- directly inside the plugin declaration.
        vim.g.gruvbox_material_enable_italic = true
        vim.g.gruvbox_material_background = 'soft'
        vim.g.gruvbox_material_foreground = 'mix'
        vim.g.gruvbox_material_statusline_style = 'material'
        -- vim.cmd.colorscheme('gruvbox-material')
      end
    },

    ----------------
    -- Git
    ----------------
    'tpope/vim-fugitive',
    -- Use dependency and run lua function after load
    {
      'lewis6991/gitsigns.nvim',
      --dependencies = { 'nvim-lua/plenary.nvim' },
      --config = function() require('gitsigns').setup() end
    },

    ----------------
    -- Editing
    ----------------
    -- use { 'tpope/vim-rails', ft = "ruby" }, -- only load when opening Ruby file

    'mg979/vim-visual-multi',
    --'sukima/xmledit', -- not usable, only for vim, I guess Ultisnips
    'mattn/emmet-vim', -- https://docs.emmet.io/
    'tkhren/vim-fake',
    'tpope/vim-surround',
    'tpope/vim-commentary',
    'tpope/vim-repeat',
    'mbbill/undotree',

    ----------------
    -- Finder
    ----------------
   -- 0.1.7 for nvim 0.10
    {'nvim-telescope/telescope.nvim', tag='0.1.7', dependencies = {'nvim-lua/plenary.nvim'}},

    --'nvim-telescope/telescope-fzf-native.nvim',
    ----------------
    -- LSP
    ----------------
    'folke/neodev.nvim',

    {'neovim/nvim-lspconfig', dependencies = {'williamboman/mason.nvim', 'williamboman/mason-lspconfig.nvim' }},
    --use 'williamboman/nvim-lsp-installer' --decpreated
    --use {'williamboman/mason.nvim'}

    -- Autocompletion
    {
      "L3MON4D3/LuaSnip",
      -- follow latest release.
      version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
      -- install jsregexp (optional!).
      build = "make install_jsregexp",
      dependencies={"tkin91e55/friendly-snippets"},
    },
    {'hrsh7th/nvim-cmp', dependencies =
      { 'hrsh7th/cmp-nvim-lsp', 'L3MON4D3/LuaSnip', 'saadparwaiz1/cmp_luasnip' }
    },

    ----------------
    -- CPP
    ----------------
    -- could be found in under  .local/share/nvim/site/pack/packer/start/a.vim/plugin/a.vim

    -- 'vim-scripts/a.vim', -- as 'cis' in insert mode make trouble
  --
    ----------------
    -- Markdown

    -- its config is in treesitter.lua
    ----------------
    -- {
    -- 'MeanderingProgrammer/render-markdown.nvim',
    -- opts = {},
    -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.nvim' },
    -- },

    ----------------
    -- IDE
    ----------------
    -- {'nvim-treesitter/nvim-treesitter',
    --   dependencies={'nvim-treesitter/nvim-treesitter-textobjects'},
    --   --tag='v0.9.1', -- it looks nvim 0.10 needs v0.9.2
    --   tag= vim.g.diffEnvs['TS_VERSION'],
    --   config = function()
    --     pcall(require('nvim-treesitter.install').update { with_sync = true })
    --   end,
    -- },

    --{ import = 'custom.plugins' },
    --'jiangmiao/auto-pairs',
    'ap/vim-css-color',
    'Asheq/close-buffers.vim',
    -- 'SirVer/ultisnips', -- as LuaSnip installed
    --'honza/vim-snippets',-- as LuaSnip installed
    'bkad/CamelCaseMotion',
    --'vim-airline/vim-airline',
    --'vim-airline/vim-airline-themes',
    {
        'nvim-lualine/lualine.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' }
    },
    'preservim/tagbar',
    'ludovicchabant/vim-gutentags',
    --'dbeniamine/cheat.sh-vim', -- not really useful, if have docs ready...
    'github/copilot.vim',
    -- {'luckasRanarison/nvim-devdocs',
    --   dependenices = {'nvim-lua/plenary.nvim','nvim-telescope/telescope.nvim','nvim-treesitter/nvim-treesitter'},
    --   opts = {}
    -- },
    {
      "NickvanDyke/opencode.nvim",
      dependencies = {
        -- Recommended for `ask()` and `select()`.
        -- Required for `snacks` provider.
        ---@module 'snacks' <- Loads `snacks.nvim` types for configuration intellisense.
        { "folke/snacks.nvim", opts = { input = {}, picker = {}, terminal = {} } },
      },
      config = function()
        ---@type opencode.Opts
        vim.g.opencode_opts = {


          server = {
            enabled = "tmux", -- Default when running inside a `tmux` session.
            -- tmux = {
            --   options = "-h", -- options to pass to `tmux split-window`
            -- }
          }
        }

        -- Required for `opts.auto_reload`.
        vim.o.autoread = true

        -- Recommended/example keymaps.
        vim.keymap.set({ "n", "x" }, "<C-b>", function() require("opencode").ask("@this: ", { submit = true }) end, { desc = "Ask opencode" })
        vim.keymap.set({ "n", "x" }, "<C-x>", function() require("opencode").select() end,                          { desc = "Execute opencode action…" })
        vim.keymap.set({ "n", "x" },    "ga", function() require("opencode").prompt("@this") end,                   { desc = "Add to opencode" })
        vim.keymap.set({ "n", "t" }, "<C-.>", function() require("opencode").toggle() end,                          { desc = "Toggle opencode" })
        vim.keymap.set("n",        "<S-C-u>", function() require("opencode").command("session.half.page.up") end,   { desc = "opencode half page up" })
        vim.keymap.set("n",        "<S-C-d>", function() require("opencode").command("session.half.page.down") end, { desc = "opencode half page down" })

        vim.keymap.set('n', '+', '<C-a>', { desc = 'Increment', noremap = true })
        vim.keymap.set('n', '-', '<C-x>', { desc = 'Decrement', noremap = true })
      end,
    }
  },
  {
    --refer to ~/.local/share/nvim/lazy/lazy.nvim/lua/lazy/core/config.lua
    --         `:help lazy.nvim-lazy.nvim-structuring-your-plugins`
    --         https://github.com/folke/lazy.nvim#%EF%B8%8F-configuration
    -- This is to avoid rtp being reset, to make compatiable with Plug's packages
    performance = {
      reset_packpath = false,
      rtp = {
        reset = false
      }
    },

  }
)

require('telescope_setup').setup()
-- require('treesitter_setup').setup()
require('lualine_setup')

require('gitsigns').setup()


require("luasnip.loaders.from_vscode").lazy_load(
  {
    exclude = {'markdown'}
  }
)

vim.cmd('command! LuaSnipEdit lua require("luasnip.loaders").edit_snippet_files()<cr>')

-- require('nvim-devdocs').setup(
--   {
--     dir_path = vim.fn.stdpath("data") .. "/devdocs", -- installation directory
--     telescope = {}, -- passed to the telescope picker
--     filetypes = {
--       -- extends the filetype to docs mappings used by the `DevdocsOpenCurrent` command, the version doesn't have to be specified
--       -- scss = "sass",
--       -- javascript = { "node", "javascript" }
--     },
--     float_win = { -- passed to nvim_open_win(), see :h api-floatwin
--       relative = "editor",
--       height = 25,
--       width = 100,
--       border = "rounded",
--     },
--     wrap = true, -- text wrap, only applies to floating window
--     previewer_cmd = nil, -- for example: "glow"
--     cmd_args = {}, -- example using glow: { "-s", "dark", "-w", "80" }
--     cmd_ignore = {}, -- ignore cmd rendering for the listed docs
--     picker_cmd = false, -- use cmd previewer in picker preview
--     picker_cmd_args = {}, -- example using glow: { "-s", "dark", "-w", "50" }
--     mappings = { -- keymaps for the doc buffer
--       open_in_browser = ""
--     },
--     ensure_installed = {}, -- get automatically installed
--     after_open = function(bufnr) end, -- callback that runs after the Devdocs window is opened. Devdocs buffer ID will be passed in
--   }
-- )

----------------
-- Keyremap asd81923
-- placeholder
--   A B C D E F G H I J K L M N O P Q R S T U V W X Y Z           / ; :
-- Insert mode factory used:
-- @ A   C D E   G H I J K   M N O P Q R   T U V W X Y   [ \ ] ^ _
-- plugins used:
--     B       F   H       L             S
-- not useful factory setting:
-- @               H I J     M       Q                           _
----------------




-- emmet
-- but for other emmit key leader, still <C-y>
vim.g.user_emmet_expandabbr_key = '<C-m>'

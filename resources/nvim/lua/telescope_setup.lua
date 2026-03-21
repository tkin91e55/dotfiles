require('telescope').setup{
  defaults = {
    path_display = { shorten = {len=3,exclude={1,-2,-1}} },
    -- check `:Telescope picker`, the previous query is cached
    cache_picker = { num_pickers=4, limit_entries=20000 },
    -- https://www.lua.org/manual/5.1/manual.html#5.4.1 lua regix is different
    file_ignore_patterns = { "%.py[ci]", "%.so" },
  }
}

-- If you want to configure the `vim_buffer_` previewer (e.g. you want the line to wrap), do this:
-- ```vim
-- autocmd User TelescopePreviewerLoaded setlocal wrap
-- ```
vim.api.nvim_create_autocmd("User", {
  pattern = "TelescopePreviewerLoaded",
  callback = function(args)
    -- if args.data.filetype ~= "help" then
    --   vim.wo.number = true
    -- elseif args.data.bufname:match("*.md") then
    --   vim.wo.wrap = true
    -- end
    -- if args then
    --   print(vim.inspect(args)) -- args is table with file, buf, event, id, match, all not proper...
    -- end
    vim.wo.wrap = true
  end,
})


-- Multigrep: https://www.youtube.com/watch?v=xdXE1tOT-qg
-- live grep augmentw with path pattern with '  '
-- e.g KEYWORD  **/folder/**
-- e.g KEYWORD  *.py

local pickers = require('telescope.pickers')
local finders = require('telescope.finders')
local make_entry = require('telescope.make_entry')
local conf = require('telescope.config').values
local M = {}

local live_multigrep = function(opts)
  opts = opts or {}
  opts.cwd = opts.cwd or vim.uv.cwd()

  local finder = finders.new_async_job {
    command_generator = function(prompt)
      if not prompt or prompt == "" then
        return nil
      end

      local pieces = vim.split(prompt, "  ")
      local args = { "rg" }
      if pieces[1] then
        table.insert(args, "-e")
        table.insert(args, pieces[1])
      end

      if pieces[2] then
        table.insert(args, "-g")
        table.insert(args, pieces[2])
      end

      return vim.tbl_flatten {
        args,
        { "--color=never", "--no-heading", "--with-filename", "--line-number", "--column", "--smart-case" },
      }
    end,
    entry_maker = make_entry.gen_from_vimgrep(opts),
    cwd = opts.cwd,
  }

  pickers.new(opts, {
    debounce = 100,
    prompt_title = "Live Grep (filter)",
    finder = finder,
    preview = conf.grep_previewer(opts),
    sorter = require("telescope.sorters").empty(),
  }):find()

end


----------------
-- Keyremap asd81923
----------------

vim.g.mapleader=' '

local tele_action  = require('telescope.actions')
require("telescope").setup{
  defaults = {
    mappings = {
      n = {
        -- :help telescope.actions.generate
        ["<M-q>"] = false,
        [vim.g.diffEnvs['TELESCOPE_SEND_SELECTED_TO_QFLIST']] = tele_action.send_selected_to_qflist + tele_action.open_qflist,
        --["<A-q>"] = tele_action.send_selected_to_qflist + tele_action.open_qflist, -- for suse
      },
    },
  }
}

local tele_builtin = require('telescope.builtin')
--vim.g.mapleader = '<F2>'  --don't work
--vim.keymap.set('n', '<F2>ff', tele_builtin.find_files, {}) -- work
vim.keymap.set('n', '<leader>ff', tele_builtin.find_files, {})
vim.keymap.set('n', '<leader>fh', tele_builtin.help_tags, {})
vim.keymap.set('n', '<leader>fb', tele_builtin.buffers, {})

-- for ctags' tags, only_sort_tags more sensible, no filenames
--vim.keymap.set('n', '<leader>ft', tele_builtin.tags, {})
vim.keymap.set('n', '<leader>ft', function()
  tele_builtin.tags({
    only_sort_tags=true,
    fname_width=50
  })
end, { desc = '[F]ind [T]ags in the sources'})

vim.keymap.set('n', '<leader>gg', function()
  tele_builtin.live_grep({
    --no such opt: git_files=true, may use .gitignore

    --attach_mappings = function(_, map) -- check lua/telescope/mappings.lua
    --  map({"i", "n"}, "<C-r>", function(_prompt_bufnr)
    --    print "You typed <C-r>"
    --  end)
    --  return true
    --end,
  })
  --tele_builtin.git_files() -- only find file names
end, { desc='[G]rep in [G]itted files'})

vim.keymap.set('n', '<leader>/', function()
  require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    -- You can pass additional configuration to telescope to change theme, layout, etc.
    --winblend = 10, --previewer = false, --windblend is no good as transparent
  })

end, { desc = '[/] Fuzzily search in current buffer' })
M.setup = function()
  vim.keymap.set("n", "<leader>fg", live_multigrep)
  vim.keymap.set("n", "<leader>tp", tele_builtin.pickers)
  vim.keymap.set("n", "<leader>tl", ":Telescope resume<CR>")
end

return M

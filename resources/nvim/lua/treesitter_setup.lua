require'nvim-treesitter.configs'.setup {
  -- A list of parser names, or "all"
  -- markdown_inline is for markdown's link highlighting
  -- The more language parser listed here, the more supported at the markdown ```lang block```
  ensure_installed = { "python", "lua", "markdown", "markdown_inline", "vim", "bash","json", "java", "javascript"},

  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,

  -- List of parsers to ignore installing (for "all")
  -- ignore_install = { "javascript" },

  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
  indent = { enable = true, },
  incremental_selection = {
    enable = true,
    keymaps = {
      --init_selection = 'gnn',
      --node_incremental = 'grn',
      ----scope_incremental = 'grc',
      --node_decremental = 'grm',
    },
  },
 --textobjects = {
 --  select = {
 --    enable = true,
 --    lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
 --    keymaps = {
 --      -- You can use the capture groups defined in textobjects.scm
 --      ['aa'] = '@parameter.outer',
 --      ['ia'] = '@parameter.inner',
 --      ['af'] = '@function.outer',
 --      ['if'] = '@function.inner',
 --      ['ac'] = '@class.outer',
 --      ['ic'] = '@class.inner',
 --    },
 --  },
 --  move = {
 --    enable = true,
 --    set_jumps = true, -- whether to set jumps in the jumplist
 --    goto_next_start = {
 --      [']m'] = '@function.outer',
 --      [']]'] = '@class.outer',
 --    },
 --    goto_next_end = {
 --      [']M'] = '@function.outer',
 --      [']['] = '@class.outer',
 --    },
 --    goto_previous_start = {
 --      ['[m'] = '@function.outer',
 --      ['[['] = '@class.outer',
 --    },
 --    goto_previous_end = {
 --      ['[M'] = '@function.outer',
 --      ['[]'] = '@class.outer',
 --    },
 --  },
 --  swap = {
 --    enable = false,
 --    swap_next = {
 --      ['<leader>a'] = '@parameter.inner',
 --    },
 --    swap_previous = {
 --      ['<leader>A'] = '@parameter.inner',
 --    },
 --  },
 --}
}

vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"

-- command TSHighlightGroupAtCursor lua print(vim.inspect(vim.treesitter.get_captures_at_cursor(0)))
vim.cmd('command! -nargs=0 TSHighlightGroupAtCursor lua print(vim.inspect(vim.treesitter.get_captures_at_cursor(0)))')

if vim.g.diffEnvs['TS_92_HTML_HL_BUG'] then
  vim.api.nvim_create_autocmd( 'FileType', { pattern = 'html',
      callback = function(args)
          --print('hi stop html')
          vim.treesitter.stop(args.buf)
          vim.execute('TSBufDisable indent')
      end
  })
  vim.api.nvim_create_autocmd( 'FileType', { pattern = 'htmldjango',
      callback = function(args)
          vim.treesitter.stop(args.buf)
          -- vim.execute('TSBufDisable indent')
      end
  })
  vim.api.nvim_create_autocmd( 'FileType', { pattern = 'help',
      callback = function(args)
          vim.treesitter.stop(args.buf)
      end
  })
end

require('render-markdown').setup({
    -- Whether Markdown should be rendered by default or not
    enabled = false,
})

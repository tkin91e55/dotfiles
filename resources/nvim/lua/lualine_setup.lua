local function BufNo()
  return 'BN: ' .. vim.fn.bufnr('%')
end
local function WinNo()
  return 'WN: ' .. vim.fn.winnr()
end

require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = 'gruvbox-material',
    component_separators = { left = '', right = ''},
    section_separators = { left = '', right = ''},
    disabled_filetypes = {
      statusline = {},
      winbar = {},
    },
    ignore_focus = {},
    always_divide_middle = true,
    globalstatus = false,
    refresh = {
      statusline = 100,
      tabline = 100,
      winbar = 100,
    }
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch', 'diff', 'diagnostics'},
    lualine_c = {{'filename',path=1,shorting_target=40}},
    lualine_x = {'encoding', 'fileformat'},
    lualine_y = {'progress'},
    lualine_z = {'location', BufNo}
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {'filename'},
    lualine_x = {},
    lualine_y = {WinNo},
    lualine_z = {BufNo}
  },
  tabline = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {
      {
        'tabs',
        tab_max_length = 40,
        max_length= vim.o.columns,
        mode = 2,
        path = 0,
        tabs_color = {
          active = 'lualine_a_normal',
          inactive = 'lualine_a_inactive'
        },
        show_modified_status = true,   -- Shows a symbol next to the tab name if the file has been modified.
        symbols = {
          modified = '[+]',            -- Text to show when the file is modified.
        },
        fmt = function(name, context)
          local winnr = vim.fn.tabpagewinnr(context.tabnr,'$')
          return name .. "{" ..winnr .. "}"
        end
      }
    },
    lualine_x = {},
    lualine_y = {},
    lualine_z = {}
  },
  winbar = {},
  inactive_winbar = {},
  extensions = {}
}

vim.opt.showmode = false

vim.cmd([[
  function! LualineSwitchTab(tabnr, mouseclicks, mousebutton, modifiers)
    execute a:tabnr . "tabnext"
  endfunction

  function! LualineRenameTab(...)
    if a:0 == 1
      let t:tabname = a:1
    else
      unlet t:tabname
    end
    redrawtabline
  endfunction

  command! -nargs=? LualineRenameTab call LualineRenameTab("<args>")
]])

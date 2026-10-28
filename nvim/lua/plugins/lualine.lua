return {
  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      local icons = LazyVim.config.icons.diagnostics
      opts.sections.lualine_c = {
        LazyVim.lualine.root_dir(),
        {
          "diagnostics",
          symbols = { error = icons.Error, warn = icons.Warn, info = icons.Info, hint = icons.Hint },
        },
        { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
        { LazyVim.lualine.pretty_path({ length = 0 }) },
      }
      return opts
    end,
  },
}

return {
  {
    "loctvl842/monokai-pro.nvim",
    lazy = false,
    priority = 1000,
  },
  { "tanvirtin/monokai.nvim", priority = 1000 },
  {
    "f-person/auto-dark-mode.nvim",
    lazy = false,
    opts = {
      update_interval = 1000,
      set_dark_mode = function()
        vim.o.background = "dark"
        vim.cmd.colorscheme("monokai-pro")
      end,
      set_light_mode = function()
        vim.o.background = "light"
        vim.cmd.colorscheme("monokai-pro-light")
      end,
    },
  },
}

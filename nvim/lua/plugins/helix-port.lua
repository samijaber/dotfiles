return {
  { "catppuccin/nvim", name = "catppuccin", opts = { flavour = "mocha" } },
  { "LazyVim/LazyVim", opts = { colorscheme = "catppuccin" } },

  -- Helix `file-picker.hidden = false`: show dotfiles, still respect .gitignore
  {
    "folke/snacks.nvim",
    opts = {
      picker = {
        sources = {
          files = { hidden = true },
          grep = { hidden = true },
          explorer = { hidden = true },
        },
      },
    },
  },

  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        vtsls = {
          settings = {
            typescript = { tsserver = { maxTsServerMemory = 8192 } },
          },
        },
      },
    },
  },
}

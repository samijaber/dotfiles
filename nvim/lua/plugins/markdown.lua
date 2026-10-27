return {
  -- The prebuilt macOS binary is unsigned and macOS refuses to run it; use Node instead.
  { "iamcco/markdown-preview.nvim", build = "cd app && npm install --no-fund --no-audit" },

  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown.mdx" },
    opts = {
      -- "hide" conceals fence lines, which also hides snacks' Mermaid images anchored to them.
      code = { border = "thin" },
      -- The preview pane mirrors the editing cursor, so don't un-render that line there.
      overrides = { preview = { render_modes = true, anti_conceal = { enabled = false } } },
    },
    keys = {
      { "<leader>cv", "<cmd>RenderMarkdown preview<cr>", ft = { "markdown", "markdown.mdx" }, desc = "Markdown Preview (split)" },
    },
  },

  -- Inline images and Mermaid diagrams (Ghostty supports the Kitty graphics protocol).
  {
    "folke/snacks.nvim",
    opts = {
      image = {
        enabled = true,
        convert = {
          mermaid = function()
            local theme = vim.o.background == "light" and "neutral" or "dark"
            return {
              "-p", vim.fn.expand("~/.config/mermaid/puppeteer.json"),
              "-i", "{src}", "-o", "{file}", "-b", "transparent", "-t", theme, "-s", "{scale}",
            }
          end,
        },
      },
    },
  },
}

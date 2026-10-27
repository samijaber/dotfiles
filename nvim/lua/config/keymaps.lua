-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua

vim.keymap.set({ "n", "i" }, "<C-M-p>", function()
  Snacks.picker.commands()
end, { desc = "Command palette" })

local function gh_browse(branch)
  local dir = vim.fn.expand("%:p:h")
  local target = vim.fn.expand("%:t") .. ":" .. vim.fn.line(".")
  branch = branch or vim.trim(vim.fn.system({ "git", "-C", dir, "branch", "--show-current" }))
  vim.system({ "gh", "browse", target, "--branch", branch }, { cwd = dir, text = true }, function(res)
    if res.code ~= 0 then
      vim.schedule(function()
        vim.notify(res.stderr, vim.log.levels.ERROR, { title = "gh browse" })
      end)
    end
  end)
end

vim.keymap.set("n", "<leader>ob", function()
  gh_browse()
end, { desc = "Open line on GitHub (current branch)" })

vim.keymap.set("n", "<leader>om", function()
  gh_browse("main")
end, { desc = "Open line on GitHub (main)" })

-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set

-- IDEA-like search and navigation
map("n", "<leader>p", function()
  Snacks.picker.files({ cwd = LazyVim.root() })
end, { desc = "Find File" })

map("n", "<leader>O", function()
  Snacks.picker.recent({ filter = { cwd = true } })
end, { desc = "Recent Files" })

map("n", "<leader>F", function()
  Snacks.picker.grep({ cwd = LazyVim.root() })
end, { desc = "Find in Files" })

map("n", "<leader>S", function()
  Snacks.picker.smart({ cwd = LazyVim.root() })
end, { desc = "Search Everywhere" })

-- IDEA-like tool windows
map("n", "<leader>1", function()
  Snacks.explorer({ cwd = LazyVim.root() })
end, { desc = "Project" })

map("n", "<leader>6", "<cmd>Trouble diagnostics toggle<cr>", { desc = "Problems" })

map("n", "<leader>4", function()
  Snacks.terminal(nil, { cwd = LazyVim.root() })
end, { desc = "Terminal" })

-- Window resizing without macOS Mission Control conflicts
map("n", "<leader>wh", "<cmd>vertical resize -5<cr>", { desc = "Decrease Window Width" })
map("n", "<leader>wl", "<cmd>vertical resize +5<cr>", { desc = "Increase Window Width" })
map("n", "<leader>wj", "<cmd>resize -5<cr>", { desc = "Decrease Window Height" })
map("n", "<leader>wk", "<cmd>resize +5<cr>", { desc = "Increase Window Height" })

-- IDEA-like code actions
map({ "n", "v" }, "<leader>a", vim.lsp.buf.code_action, { desc = "Code Action" })
map("n", "<leader>R", vim.lsp.buf.rename, { desc = "Rename" })

map("n", "<leader>U", function()
  Snacks.picker.lsp_references()
end, { desc = "Find Usages" })

-- Debug helpers
local function force_stop_debug()
  local port = vim.fn.input("Kill Java debug port: ", tostring(vim.g.debug_kill_port or 8080))
  if port == nil or port == "" then
    return
  end

  pcall(function()
    require("dap").disconnect({ terminateDebuggee = true })
  end)
  pcall(function()
    require("dap").terminate()
  end)
  pcall(function()
    require("dap").close()
  end)
  pcall(function()
    require("dapui").close({})
  end)

  local function java_listener_pids()
    local listeners = vim.tbl_filter(function(pid)
      return pid:match("^%d+$") ~= nil
    end, vim.fn.systemlist({ "lsof", "-nP", "-tiTCP:" .. port, "-sTCP:LISTEN" }))

    return vim.tbl_filter(function(pid)
      local command = table.concat(vim.fn.systemlist({ "ps", "-p", pid, "-o", "comm=" }), " ")
      return command:lower():match("java") ~= nil
    end, listeners)
  end

  local pids = java_listener_pids()

  if #pids == 0 then
    vim.notify("No Java listener found on port " .. port, vim.log.levels.INFO)
    return
  end

  vim.fn.system(vim.list_extend({ "kill", "-TERM" }, pids))
  vim.defer_fn(function()
    local alive = java_listener_pids()

    if #alive > 0 then
      vim.fn.system(vim.list_extend({ "kill", "-KILL" }, alive))
    end
  end, 1200)

  vim.notify("Stopped Java debug process on port " .. port, vim.log.levels.INFO)
end

map("n", "<leader>dK", force_stop_debug, { desc = "Force Stop Debug Port" })

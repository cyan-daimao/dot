-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

local java_template_group = vim.api.nvim_create_augroup("user_java_file_template", { clear = true })

local function insert_java_template()
  if vim.b.java_template_inserted then
    return
  end

  local path = vim.api.nvim_buf_get_name(0)
  if path == "" or not path:match("%.java$") then
    return
  end

  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  if #lines > 1 or (#lines == 1 and lines[1] ~= "") then
    return
  end

  local class_name = vim.fn.fnamemodify(path, ":t:r")
  local normalized_path = path:gsub("\\", "/")
  local package = normalized_path:match("src/main/java/(.*)/[^/]+%.java$")
    or normalized_path:match("src/test/java/(.*)/[^/]+%.java$")

  if package then
    package = package:gsub("/", ".")
    vim.api.nvim_buf_set_lines(0, 0, -1, false, {
      "package " .. package .. ";",
      "",
      "/**",
      " * " .. class_name .. ".",
      " * @author cy.Y",
      " * @since ",
      " */",
      "public class " .. class_name .. " {",
      "}",
      "",
    })
  else
    vim.api.nvim_buf_set_lines(0, 0, -1, false, {
      "/**",
      " * " .. class_name .. ".",
      " * @author cy.Y",
      " * @since ",
      " */",
      "public class " .. class_name .. " {",
      "}",
      "",
    })
  end

  vim.b.java_template_inserted = true
end

vim.api.nvim_create_autocmd({ "BufNewFile", "BufReadPost", "BufEnter" }, {
  group = java_template_group,
  pattern = "*.java",
  callback = insert_java_template,
})

local autosave_group = vim.api.nvim_create_augroup("user_auto_save", { clear = true })

vim.api.nvim_create_autocmd({ "InsertLeave", "FocusLost", "BufLeave" }, {
  group = autosave_group,
  callback = function()
    if vim.bo.buftype ~= "" or not vim.bo.modifiable or vim.bo.readonly or not vim.bo.modified then
      return
    end

    if vim.api.nvim_buf_get_name(0) == "" then
      return
    end

    vim.cmd("silent! write")
  end,
})

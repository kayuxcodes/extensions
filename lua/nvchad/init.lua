local M = {}
local fn = vim.fn

M.list_themes = function()
  local default_themes = vim.fn.readdir(vim.fn.stdpath "data" .. "/lazy/base46/lua/base46/themes")

  local dirState = vim.loop.fs_stat(fn.stdpath "config" .. "/lua/custom/themes")

  if dirState and dirState.type == "directory" then
    local user_themes = fn.readdir(fn.stdpath "config" .. "/lua/custom/themes")
    default_themes = vim.tbl_deep_extend("force", default_themes, user_themes)
  end

  for index, theme in ipairs(default_themes) do
    default_themes[index] = fn.fnamemodify(fn.fnamemodify(theme, ":t"), ":r")
  end

  return default_themes
end

M.replace_word = function(filename, old, new)
  local file = io.open(filename, "r")
  local added_pattern = string.gsub(old, "-", "%%-") -- add % before - if exists
  local new_content = file:read("*all"):gsub(added_pattern, new)

  file = io.open(filename, "w")
  file:write(new_content)
  file:close()
end

return M

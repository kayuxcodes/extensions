local utils = require('nvchad')

local get_example_chadrc = function()
  local chadrc_path = require("nvchad.utils.config").custom.default_chadrc_example_path

  -- store in data variable
  local data = require("nvchad").file("r", chadrc_path)

  if not data then
    print "Error: Could not read example chadrc!"
    return false
  end

  return data
end

M.ensure_file_exists = function(file_path, default_content)
  -- store in data variable
  local data = utils.file("r", file_path)

  -- check if data is false or nil and create a default file if it is
  if not data then
    utils.file("w", file_path, default_content)
    data = utils.file("r", file_path)
  end

  -- if the file was still not created, then something went wrong
  if not data then
    print(
      "Error: Could not create: "
        .. file_path
        .. ". Please create it manually to set a default "
        .. "theme. Look at the documentation for more info."
    )
    return false
  end

  return true
end

return function(current_theme, new_theme)
  local misc = require "nvchad.utils.misc"
  local config = require "nvchad.utils.config"

  if current_theme == nil or new_theme == nil then
    print "Error: Provide current and new theme name"
    return false
  end

  if current_theme == new_theme then
    return
  end

  local result = misc.ensure_file_exists(config.custom.default_chadrc_path, get_example_chadrc())

  if not result then
    print "Error: Could not set a default theme. Please set it manually in your 'chadrc.lua'."
    return false
  end

  -- escape characters which can be parsed as magic chars
  current_theme = current_theme:gsub("%p", "%%%0")
  new_theme = new_theme:gsub("%p", "%%%0")

  local old_theme_txt = "theme = .?" .. current_theme .. ".?"
  local new_theme_txt = 'theme = "' .. new_theme .. '"'

  require("nvchad").write_data(old_theme_txt, new_theme_txt)
end

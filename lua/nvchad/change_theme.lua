return function(current_theme, new_theme)
  if current_theme == nil or new_theme == nil then
    print "Error: Provide current and new theme name"
    return false
  end

  if current_theme == new_theme then
    return
  end

  -- escape characters which can be parsed as magic chars
  current_theme = current_theme:gsub("%p", "%%%0")
  new_theme = new_theme:gsub("%p", "%%%0")

  current_theme = "theme = .?" .. current_theme .. ".?"
  new_theme = 'theme = "' .. new_theme .. '"'

  local chadrc = vim.fn.stdpath "config" .. "/lua/custom/" .. "chadrc.lua"

  require("nvchad").replace_word(chadrc, current_theme, new_theme)
end

local M = {}

M.custom = {
  config_dir_rel = "lua/custom",
  config_dir_abs = vim.fn.stdpath "config" .. "/lua/custom",
  default_chadrc_example_path = vim.fn.stdpath "data" .. "/lazy/extensions/examples/chadrc.lua",
  default_chadrc_path = vim.fn.stdpath "config" .. "/lua/custom/" .. "chadrc.lua",
}

return M

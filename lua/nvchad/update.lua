local api = vim.api
local cmd = vim.cmd
local fn = vim.fn

return function()
  local config_path = fn.stdpath "config"

  -- commands
  local pullcmd = "git -C " .. config_path .. " pull --progress"
  local updater_Msg = "echo '󰓂 Fetching updates via git pull...\n' && "
  local finalcmd = updater_Msg .. pullcmd

  -- branches
  local nvchad_opts = require("core.utils").load_config()
  local chadrc_branch = nvchad_opts.options.nvChad.update_branch
  local local_branch = fn.systemlist("git -C " .. config_path .. " rev-parse --abbrev-ref HEAD")[1]

  if local_branch ~= chadrc_branch then
    finalcmd = "git -C " .. config_path .. " switch " .. chadrc_branch
  end

  -- create buf & normal terminal
  cmd "split"

  vim.fn.feedkeys("i", "n")

  local buf = api.nvim_create_buf(false, true)
  local win = api.nvim_get_current_win()
  api.nvim_win_set_buf(win, buf)

  vim.opt_local.number = false

  fn.termopen(finalcmd, { exit_cb = function() end })
end

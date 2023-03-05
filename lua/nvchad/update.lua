local api = vim.api
local cmd = vim.cmd
local fn = vim.fn

local output = {
  " ",
  " 󰓂 Fetching updates via git pull ",
  "",
  "...",
}

return function()
  -- create buffer
  local buf = vim.api.nvim_create_buf(false, true)

  vim.api.nvim_set_current_buf(buf)
  vim.opt_local.number = false
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, output)

  local nvUpdater = api.nvim_create_namespace "nvdash"
  api.nvim_buf_add_highlight(buf, nvUpdater, "healthSuccess", 1, 0, -1)

  local config_path = fn.stdpath "config"

  -- commands
  local pullcmd = "git -C " .. config_path .. " pull --progress"
  local finalcmd = pullcmd

  -- branches
  local nvchad_opts = require("core.utils").load_config()
  local chadrc_branch = nvchad_opts.options.nvChad.update_branch
  local local_branch = fn.systemlist("git -C " .. config_path .. " rev-parse --abbrev-ref HEAD")[1]

  if local_branch ~= chadrc_branch then
    finalcmd = "git -C " .. config_path .. " switch " .. chadrc_branch
  end

  vim.defer_fn(function()
    local update_output = vim.fn.systemlist(finalcmd)

    for i = 1, #update_output, 1 do
      output[#output + 1] = update_output[i]
    end

    vim.api.nvim_buf_set_lines(buf, 0, -1, false, output)

    api.nvim_buf_add_highlight(buf, nvUpdater, "healthSuccess", 1, 0, -1)
  end, 0)
end

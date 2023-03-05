dofile(vim.g.base46_cache .. "nvchad_updater")

local api = vim.api
local cmd = vim.cmd
local fn = vim.fn

-- used to make each line have equal widths
local function add_whiteSpaces(tb)
  -- first get largest line's length
  local len = 0

  for _, value in ipairs(tb) do
    if len < #value then
      len = #value
    end
  end

  table.insert(tb, 1, string.rep(" ", len))

  -- now fill whitespaces
  for i, value in ipairs(tb) do
    local whitespaces_len = len - #value
    tb[i] = "  " .. value .. string.rep(" ", whitespaces_len) .. "  "
  end

  -- 4 = 2 spaces on left & right
  tb[#tb + 1] = string.rep(" ", len + 4)

  return tb
end

local output = { " ", " 󰓂 Fetching updates ", "", "", "" }
local spinners = { "", "󰪞", "󰪟", "󰪠", "󰪢", "󰪣", "󰪤", "󰪥" }

return function()
  -- create buffer
  local buf = vim.api.nvim_create_buf(false, true)

  vim.api.nvim_set_current_buf(buf)
  vim.opt_local.number = false

  output[4] = spinners[1]
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, output)

  local nvUpdater = api.nvim_create_namespace "nvUpdater"
  api.nvim_buf_add_highlight(buf, nvUpdater, "nvUpdaterTitle", 1, 0, -1)

  local git_outputs = {} -- some value gets assigned here after 3-4 seconds

  local index = 1

  -- update spinner icon until git_outputs is empty
  -- use a timer
  local timer = vim.loop.new_timer()

  timer:start(0, 50, function()
    index = index + 1

    vim.schedule(function()
      if #git_outputs == 0 then
        if index == #spinners then
          index = 1
        end

        output[4] = spinners[index]
        vim.api.nvim_buf_set_lines(buf, 0, -1, false, output)
        api.nvim_buf_add_highlight(buf, nvUpdater, "nvUpdaterTitle", 1, 0, -1)
      end
    end)
  end)

  local config_path = fn.stdpath "config"

  -- commands
  local pullcmd = "git -C " .. config_path .. " pull"
  local finalcmd = pullcmd

  -- branches
  local nvchad_opts = require("core.utils").load_config()
  local chadrc_branch = nvchad_opts.options.nvChad.update_branch
  local local_branch = fn.systemlist("git -C " .. config_path .. " rev-parse --abbrev-ref HEAD")[1]

  -- update local repo branch if it doesnt match to that of in chadrc
  if local_branch ~= chadrc_branch then
    finalcmd = "git -C " .. config_path .. " switch " .. chadrc_branch
  end

  -- capture cmd output & display on buffer
  vim.defer_fn(function()
    git_outputs = vim.fn.systemlist(finalcmd)
    add_whiteSpaces(git_outputs) -- so it looks like a padding

    output[4] = "" -- indiciate finish icon

    for i = 1, #git_outputs, 1 do
      output[#output + 1] = git_outputs[i]
    end

    vim.api.nvim_buf_set_lines(buf, 0, -1, false, output)

    api.nvim_buf_add_highlight(buf, nvUpdater, "nvUpdaterTitle", 1, 0, -1)

    for i = 5, #output do
      api.nvim_buf_add_highlight(buf, nvUpdater, "nvUpdaterGitPull", i, 0, -1)
    end
  end, 1000)
end

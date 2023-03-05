dofile(vim.g.base46_cache .. "nvchad_updater")

local api = vim.api
-- local cmd = vim.cmd
-- local fn = vim.fn
local uv = vim.loop

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

local spinners = { "", "󰪞", "󰪟", "󰪠", "󰪢", "󰪣", "󰪤", "󰪥" }
-- local spinners = { "󰸶", "󰸸", "󰸷", "󰸴", "󰸵", "󰸳" }
-- local spinners = { "", "", "", "󰺕", "", "" }
local content = { " ", " ", "" }

local header = " 󰓂 Fetching updates "

return function()
  -- create buffer
  local buf = vim.api.nvim_create_buf(false, true)

  vim.api.nvim_set_current_buf(buf)
  vim.opt_local.number = false

  -- set lines & highlight updater title
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, content)
  local nvUpdater = api.nvim_create_namespace "nvUpdater"
  api.nvim_buf_add_highlight(buf, nvUpdater, "nvUpdaterTitle", 1, 0, -1)

  local git_outputs = {} -- some value gets assigned here after 3-4 seconds

  local index = 1

  -- update spinner icon until git_outputs is empty
  -- use a timer
  local timer = vim.loop.new_timer()

  timer:start(0, 100, function()
    index = index + 1

    if #git_outputs ~= 0 then
      timer:stop()
    end

    vim.schedule(function()
      if #git_outputs == 0 then
        -- restart spinner animation
        if index == #spinners then
          index = 1
        end

        content[2] = header .. " " .. spinners[index] .. "  "
        vim.api.nvim_buf_set_lines(buf, 0, -1, false, content)
        api.nvim_buf_add_highlight(buf, nvUpdater, "nvUpdaterTitle", 1, 0, #header)
        api.nvim_buf_add_highlight(buf, nvUpdater, "nvUpdaterProgress", 1, #header, -1)
      end
    end)
  end)

  -----  get git pull output, use vim.loop.spawn
  local handle
  local stdio = uv.new_pipe()

  local function on_exit()
    uv.read_stop(stdio)
    uv.close(stdio)
    uv.close(handle)

    -- draw the output on buffer
    add_whiteSpaces(git_outputs)

    content[2] = " 󰓂 Fetching updates    "

    -- append gitpull table to content table
    for i = 1, #git_outputs, 1 do
      content[#content + 1] = git_outputs[i]
    end

    -- set lines & highlights
    -- using vim.schedule because we cant use set_lines in callback
    vim.schedule(function()
      vim.api.nvim_buf_set_lines(buf, 0, -1, false, content)

      -- highlight title & finish icon
      api.nvim_buf_add_highlight(buf, nvUpdater, "nvUpdaterTitle", 1, 0, #header)
      api.nvim_buf_add_highlight(buf, nvUpdater, "nvUpdaterProgress", 1, #header, -1)

      for i = 2, #content do
        api.nvim_buf_add_highlight(buf, nvUpdater, "nvUpdaterGitPull", i, 0, -1)
      end
    end)
  end

  local opts = {
    args = { "pull" },
    cwd = vim.fn.stdpath "config",
    stdio = { nil, stdio, nil },
  }

  handle = uv.spawn("git", opts, on_exit)

  uv.read_start(stdio, function(_, data)
    if data then
      git_outputs[#git_outputs + 1] = data:gsub("\n", "")
    end
  end)
end

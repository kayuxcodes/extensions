-- Credits to telescope buffer builtin, some code taken from it
-- Src: https://github.com/nvim-telescope/telescope.nvim/blob/master/lua/telescope/builtin/internal.lua

local pickers = require "telescope.pickers"
local finders = require "telescope.finders"

local conf = require("telescope.config").values
local actions = require "telescope.actions"
local make_entry = require "telescope.make_entry"
local action_state = require "telescope.actions.state"

local function term_picker()
  local get_bufnrs = function()
    local bufnrs = vim.api.nvim_list_bufs()

    return vim.tbl_filter(function(bufnr)
      return vim.api.nvim_buf_get_option(bufnr, "buftype") == "terminal"
    end, bufnrs)
  end

  local get_buffers = function()
    local buffers = {}

    for _, bufnr in ipairs(get_bufnrs()) do
      local flag = bufnr == vim.fn.bufnr "" and "%" or (bufnr == vim.fn.bufnr "#" and "#" or " ")
      local element = { bufnr = bufnr, flag = flag, info = vim.fn.getbufinfo(bufnr)[1] }

      table.insert(buffers, element)
    end

    return buffers
  end

  local opts = {}
  local max_bufnr = math.max(unpack(get_bufnrs()))

  opts.bufnr_width = #tostring(max_bufnr)

  -- our picker function: colors
  local picker = pickers.new {
    prompt_title = " Pick Term",
    previewer = conf.grep_previewer(opts),
    finder = finders.new_table {
      results = get_buffers(),
      entry_maker = make_entry.gen_from_buffer(opts),
    },
    sorter = conf.generic_sorter(),

    attach_mappings = function(prompt_bufnr)
      actions.select_default:replace(function()
        local entry = action_state.get_selected_entry()
        actions.close(prompt_bufnr)
        require("nvterm.terminal").get_and_show("buf", entry.bufnr)
      end)
      return true
    end,
  }

  picker:find()
end

return require("telescope").register_extension {
  exports = { terms = term_picker },
}

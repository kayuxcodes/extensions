local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local previewers = require "telescope.previewers"

local conf = require("telescope.config").values
local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"

local function switcher()
  local bufnr = vim.api.nvim_get_current_buf()
  local bufname = vim.api.nvim_buf_get_name(bufnr)

  -- show current buffer content in previewer
  local previewer = previewers.new_buffer_previewer {
    define_preview = function(self, entry)
      -- add content
      local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
      vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, lines)

      -- add syntax highlighting in previewer
      local ft = require("plenary.filetype").detect(bufname) or "diff"
      require("telescope.previewers.utils").highlighter(self.state.bufnr, ft)

      ----------- reload theme -------------
      vim.g.nvchad_theme = entry.value
      require("base46").load_all_highlights()
      vim.api.nvim_exec_autocmds("User", { pattern = "NvChadThemeReload" })
    end,
  }

  -- our picker function: colors
  local picker = pickers.new {
    prompt_title = "󱥚 Set NvChad Theme",
    previewer = previewer,
    finder = finders.new_table {
      results = require("nvchad").list_themes(),
    },
    sorter = conf.generic_sorter(),

    attach_mappings = function(prompt_bufnr, _)
      actions.select_default:replace(function()
        actions.close(prompt_bufnr)

        ------------ save theme to chadrc ----------------
        local current_theme = require("core.utils").load_config().ui.theme
        require("nvchad").replace_word(current_theme, action_state.get_selected_entry()[1])
      end)
      return true
    end,
  }

  picker:find()
end

return require("telescope").register_extension {
  exports = { themes = switcher },
}

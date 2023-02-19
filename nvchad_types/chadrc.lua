---@meta

---@class ChadrcConfig
local chadrc = {
  --- UI related configuration
  --- e.g. colorschemes, statusline themes, cmp themes, dashboard, some LSP ui related
  --- @class UIConfig
  ui = {
    --- List of highlights group to add.
    --- Should be highlights that is not a part of base46 defeault integration
    --- Example
    --- ```lua
    ---     hl_add = {
    ---       ["HLName"] = {fg = "red"},
    ---     }
    --- ```
    --- @see https://github.com/NvChad/base46/tree/master/lua/base46/integrations
    --- @type HLTable
    hl_add = nil,
    --- List of highlight groups that is part of base46 default integration that you want to change
    --- ```lua
    ---     hl_overrde = {
    ---       ["HLName"] = {fg = "red"},
    ---     }
    --- ```
    --- @see https://github.com/NvChad/base46/tree/master/lua/base46/integrations
    --- @type HLTable
    hl_override = nil,
    --- @see https://github.com/NvChad/base46/tree/master/lua/base46/themes for the colors of each theme
    --- @type table<ThemeName, Base46Table>
    changed_themes = {},
    --- A table with 2 strings, denoting the themes to toggle between.
    --- One of the 2 strings must be the value of `theme` field
    --- Example:
    --- ```lua
    ---     theme_toggle = { "onedark", "one_light", },
    --- ```
    --- @type {[1]: string, [2]: string}
    theme_toggle = { "onedark", "one_light" },
    --- Enable transparency or not
    --- @type boolean
    transparency = nil,
    --- Theme to use.
    --- You can try out the theme by executing `:Telescope themes`
    --- @see https://github.com/NvChad/base46/tree/master/lua/base46/themes
    --- @type string
    theme = nil,

    --- @class NvCmpConfig
    cmp = {
			--- Whether to add colors to icons in nvim-cmp popup menu
			--- @type boolean
			icons = nil,
			--- Whether to also have the lsp kind highlighted with the icons as well or not
			--- @type boolean
			lspkind_text = nil,
			--- nvim-cmp style
			--- @type '"default"'|'"flat_light"'|'"flat_dark"'|'"atom"'|'"atom_colored"'
			style = nil,
			--- Only has effects when the style is `default`
			--- @type string|Base30Colors
			border_color = nil,
      --- Whether to have more vibrant color for the currently selected entry in the popup menu
      --- @type "colored"|"simple"
      selected_item_bg = nil,
    },
    --- @class NvStatuslineConfig
    statusline = {
			--- statusline theme
			--- @type '"default"'|'"vscode"'|'"vscode_colored"'|'"minimal"'
			theme = nil,
			--- Separator style for NvChad Statusline
      ---     - Only when the *theme* is `minimal`, "round" or "block" will be having effect
			--- @type '"default"'|'"round"'|'"block"'
			separator_style = nil,

      --- List of modules that you overirde
      --- Check https://github.com/NvChad/ui/blob/main/lua/nvchad_ui/statusline/modules.lua for the list of modules
      --- @type fun(): table
      overriden_modules = nil,
    },
    --- @class NvTablineConfig
    tabufline = {
      --- Whether to use/load tabufline or not
      --- @type boolean
      enabled = nil,
      --- If false, load tabufline on startup
      --- If true, load tabufline when there is at least 2 buffers opened
      --- @type boolean
      lazyload = nil,
      --- List of modules that you overirde
      --- Check https://github.com/NvChad/ui/blob/main/lua/nvchad_ui/tabufline/modules.lua for the list of modules
      --- @type fun(): table
      overriden_modules = nil,
    },
    --- @class NvDashboardConfig
    nvdash = {
      --- Whether to open dashboard on opening nvim 
      --- @type boolean
      load_on_startup = false,
      --- Your ascii art
      --- Each string is one line
      --- @type string[],
      header = nil,
      --- List of buttons to show on the dashboard
      --- @type NvDashButtonConfig[]
      buttons = nil,
    },
    --- @class NvCheatsheetConfig
    cheatsheet = {
      --- Cheatsheet theme
      --- @type '"grid"'|'"simple"'
      theme = nil,
    },
  },
  
  --- A table of mappings
  ---     - `disabled` is used to define the keymaps that you don't want to keep
  ---     - Other keys are the list of default tables that is with NvChad
  ---     - You can define your custom table, such as the example below
  --- ```lua
  --- M.mappings = {
  ---   ["some table name"] = {
  ---     -- plugin = true, -- will make this table load only when you specify it to
  ---     ["some vim mode"] = {
  ---       ["some lhs"] = {
  ---         "rhs of a keymap", -- this must be here. This can also be a Lua function
  ---         "Description for the keymap",
  ---         opts = {}, -- Other opts for the keymaps
  ---       }
  ---     }
  ---   }
  --- }
  --- ```
  --- @see core.mappings
  --- @type MappingsTable
  mappings = nil,

  --- The module to be imported and merged with the default plugin settings
  --- @type string
  plugins = "",

  --- Lazy.nvim setup opts
  --- Check `:h lazy.nvim-configuration` for the exact options
  --- @type table
  lazy_nvim = {},
}


---@class NvDashButtonConfig
---@field [1] string Description for the button
---@field [2] string sequence of keys to press to trigger the keybind
---@field [3] string|fun() A Vim Command/A Lua function to be triggered when pressing the keybind/pressing enter on the line with the description on the dashboard

---@alias MappingsTable DefaultMappingsTable | table<string, KeymapsTable>

--- @class DefaultMappingsTable
--- @field disabled   DisabledTable Keymaps to be removed
--- @field general    KeymapsTable Keymaps that will be load on startup
--- @field tabufline  KeymapsTable Keymaps that will be load with NvChad's tabline
--- @field comment    KeymapsTable Keymaps for Comment.nvim
--- @field lspconfig  KeymapsTable Keymaps for nvim-lspconfig
--- @field nvimtree   KeymapsTable Keymaps for nvim-tree.lua
--- @field telescope  KeymapsTable Keymaps for telescope.nvim
--- @field nvterm     KeymapsTable Keymaps for NvChad/nvterm
--- @field whichkey   KeymapsTable Keymaps for which-key.nvim
--- @field blankline  KeymapsTable Keymaps for indent-blankline.nvim
--- @field gitsigns   KeymapsTable Keymaps for gitsigns.nvim

--- List of keymaps that is part of `core/mappings.lua` that will be removed
---@class DisabledTable 
---@field n   table<string, '""'|false> Normal Mode keymaps to remove
---@field x   table<string, '""'|false> Visual Mode keymaps to remove
---@field s   table<string, '""'|false> Select Mode keymaps to remove
---@field v   table<string, '""'|false> Visual + Select Mode keymaps to remove
---@field o   table<string, '""'|false> Operator-Pending Mode keymaps to remove
---@field i   table<string, '""'|false> Insert Mode keymaps to remove
---@field c   table<string, '""'|false> Command-Line Mode keymaps to remove
---@field l   table<string, '""'|false> Insert + Command-Line + Lang-Arg Mode keymaps to remove
---@field t   table<string, '""'|false> Terminal Mode keymaps to remove
---@field "!" table<string, '""'|false> Insert + Command-Line Mode keymaps to remove
---@field ""  table<string, '""'|false> Normal, Visual and Operating-Pending Mode keymaps to remove

---@class KeymapsTable
---@field plugin boolean Whether this whole table will be loaded on startup or not
---@field n   table<string, KeymapConfig> Normal Mode keymaps
---@field x   table<string, KeymapConfig> Visual Mode keymaps
---@field s   table<string, KeymapConfig> Select Mode keymaps
---@field v   table<string, KeymapConfig> Visual + Select Mode keymaps
---@field o   table<string, KeymapConfig> Operator-Pending Mode keymaps
---@field i   table<string, KeymapConfig> Insert Mode keymaps
---@field c   table<string, KeymapConfig> Command-Line Mode keymaps
---@field l   table<string, KeymapConfig> Insert + Command-Line + Lang-Arg Mode keymaps
---@field t   table<string, KeymapConfig> Terminal Mode keymaps
---@field "!" table<string, KeymapConfig> Insert + Command-Line Mode keymaps
---@field ""  table<string, KeymapConfig> Normal, Visual and Operating-Pending Mode keymaps

---@class KeymapConfig
---@field [1] string|fun() A Vimscript string or a Lua function. `rhs` of the keymap
---@field [2] string Description for the keymap
---@field opts NvKeymapOpts? List of additional options for the keymap

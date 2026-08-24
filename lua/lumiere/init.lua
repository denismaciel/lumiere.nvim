local config = require('lumiere.config')
local palettes = require('lumiere.palette')
local groups = require('lumiere.groups')
local integrations = require('lumiere.integrations')

local M = {}

M.setup = config.setup

M.load = function(opts)
    if opts then
        config.setup(opts)
    end

    local variant = config.options.variant
    local palette = palettes.get(variant)

    vim.o.background = variant
    vim.o.termguicolors = true
    vim.g.colors_name = 'lumiere'

    if vim.fn.exists('syntax_on') == 1 then
        vim.cmd.syntax('reset')
    end

    vim.api.nvim_set_hl(0, 'Normal', {})

    local all_groups = vim.tbl_extend(
        'force',
        groups.get(palette, config.options),
        integrations.get(palette, config.options)
    )

    for group, spec in pairs(all_groups) do
        vim.api.nvim_set_hl(0, group, spec)
    end
end

M.colors = palettes.get('light')
M.palettes = palettes.all

return M

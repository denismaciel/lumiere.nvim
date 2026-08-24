local config = require('lumiere.config')
local palettes = require('lumiere.palette')
local groups = require('lumiere.groups')
local integrations = require('lumiere.integrations')

local M = {}

M.setup = config.setup

local ansi_names = {
    'ansi_black',
    'ansi_red',
    'ansi_green',
    'ansi_yellow',
    'ansi_blue',
    'ansi_magenta',
    'ansi_cyan',
    'ansi_white',
    'ansi_bright_black',
    'ansi_bright_red',
    'ansi_bright_green',
    'ansi_bright_yellow',
    'ansi_bright_blue',
    'ansi_bright_magenta',
    'ansi_bright_cyan',
    'ansi_bright_white',
}

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

    for index, name in ipairs(ansi_names) do
        vim.g['terminal_color_' .. (index - 1)] = palette[name]
    end
end

M.colors = palettes.get('light')
M.palettes = palettes.all

return M

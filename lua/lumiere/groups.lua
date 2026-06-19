local base = require('lumiere.groups.base')
local treesitter = require('lumiere.groups.treesitter')

local M = {}

M.get = function(colors, opts)
    return vim.tbl_extend('force', base.get(colors, opts), treesitter.get(colors, opts))
end

return M

local palette_files = vim.api.nvim_get_runtime_file('palette.json', false)
local palette_file = assert(palette_files[1], 'lumiere.nvim: palette.json not found')
local palettes = vim.json.decode(table.concat(vim.fn.readfile(palette_file), '\n'))

local M = {}

M.get = function(variant)
    local colors = palettes[variant]
    assert(colors, 'lumiere.nvim: unknown variant ' .. vim.inspect(variant))
    return vim.deepcopy(colors)
end

M.all = vim.deepcopy(palettes)

return M

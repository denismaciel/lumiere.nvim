local script = debug.getinfo(1, 'S').source:sub(2)
local root = vim.fs.dirname(vim.fs.dirname(script))
vim.opt.runtimepath:prepend(root)

local lumiere = require('lumiere')
local palettes = require('lumiere.palette')

local function color(value)
    return tonumber(value:sub(2), 16)
end

local function highlight(name)
    return vim.api.nvim_get_hl(0, { name = name, link = false })
end

for _, variant in ipairs({ 'light', 'dark' }) do
    local palette = palettes.get(variant)
    lumiere.load({ variant = variant })

    assert(vim.o.background == variant)
    assert(highlight('Normal').fg == color(palette.text))
    assert(highlight('Normal').bg == color(palette.background))
    assert(highlight('Comment').fg == color(palette.text_muted))
    assert(highlight('@punctuation.bracket').fg == color(palette.punctuation))
    assert(highlight('Search').bg == color(palette.search_bg))
    assert(highlight('ErrorMsg').fg == color(palette.red))
    assert(highlight('WarningMsg').fg == color(palette.orange))
    assert(highlight('SpellBad').sp == color(palette.red))
    assert(highlight('SpellCap').sp == color(palette.blue))
    assert(highlight('Keyword').fg == color(palette.magenta))
    assert(highlight('LumiereControlFlow').fg == color(palette.magenta))
    assert(highlight('LumiereDeclaration').fg == color(palette.blue))
    assert(highlight('Function').fg == color(palette.blue))
    assert(highlight('Type').fg == color(palette.cyan))
    assert(highlight('@module').fg == color(palette.cyan))
    assert(highlight('String').fg == color(palette.green))
    assert(highlight('Number').fg == color(palette.orange))
    assert(highlight('Constant').fg == color(palette.yellow))

    for level, name in ipairs({ 'blue', 'green', 'yellow', 'magenta', 'orange', 'cyan' }) do
        assert(highlight('@markup.heading.' .. level .. '.markdown').fg == color(palette[name]))
    end

    assert(not highlight('Constant').bold)
    assert(not highlight('Keyword').bold)
    assert(not highlight('Type').bold)
    assert(not highlight('@tag').bold)
    assert(highlight('Conditional').bold)
    assert(highlight('Repeat').bold)
    assert(highlight('Define').bold)
    assert(highlight('@keyword.return').bold)

    local ansi_seen = {}
    for index, name in ipairs({
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
    }) do
        local value = vim.g['terminal_color_' .. (index - 1)]
        assert(value == palette[name])
        assert(not ansi_seen[value])
        ansi_seen[value] = true
    end
end

lumiere.load({ variant = 'light', bold = false })
assert(not highlight('LumiereControlFlow').bold)
assert(not highlight('LumiereDeclaration').bold)
assert(not highlight('@markup.heading.1.markdown').bold)

print('Lumiere highlight checks passed')

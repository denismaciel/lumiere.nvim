local M = {}

M.get = function(colors, opts)
    local groups = {}
    local bg = opts.transparent and colors.none or colors.bg

    if opts.integrations.gitsigns then
        groups.GitSignsAdd = { fg = colors.gray_10, bg = bg }
        groups.GitSignsChange = { fg = colors.gray_10, bg = bg }
        groups.GitSignsDelete = { fg = colors.gray_10, bg = bg }
        groups.GitSignsAddInline = { fg = colors.green, bg = colors.green_bg }
        groups.GitSignsChangeInline = { fg = colors.blue, bg = colors.blue_bg }
        groups.GitSignsDeleteInline = { fg = colors.red, bg = colors.red_bg }
    end

    if opts.integrations.blink then
        groups.BlinkCmpMenu = { link = 'Pmenu' }
        groups.BlinkCmpMenuSelection = { link = 'PmenuSel' }
        groups.BlinkCmpKind = { link = 'PmenuKind' }
        groups.BlinkCmpLabelDetail = { link = 'PmenuExtra' }
        groups.BlinkCmpDoc = { link = 'NormalFloat' }
        groups.BlinkCmpDocBorder = { link = 'FloatBorder' }
    end

    if opts.integrations.nvim_tree then
        groups.NvimTreeNormal = { fg = colors.fg, bg = bg }
        groups.NvimTreeNormalNC = { fg = colors.fg, bg = bg }
        groups.NvimTreeFolderName = { fg = colors.fg, bg = bg, bold = opts.bold }
        groups.NvimTreeOpenedFolderName = { fg = colors.fg, bg = bg, bold = opts.bold }
        groups.NvimTreeGitDirty = { fg = colors.orange, bg = bg }
        groups.NvimTreeGitNew = { fg = colors.green, bg = bg }
        groups.NvimTreeGitDeleted = { fg = colors.red, bg = bg }
    end

    if opts.integrations.snacks then
        groups.SnacksPicker = { link = 'NormalFloat' }
        groups.SnacksPickerBorder = { link = 'FloatBorder' }
        groups.SnacksPickerMatch = { fg = colors.blue, bg = colors.blue_bg, bold = opts.bold }
        groups.SnacksPickerSelected = { fg = colors.fg, bg = colors.ui_2, bold = opts.bold }
    end

    if opts.integrations.fff then
        groups.FffNormal = { link = 'NormalFloat' }
        groups.FffBorder = { link = 'FloatBorder' }
        groups.FffMatch = { fg = colors.blue, bg = colors.blue_bg, bold = opts.bold }
        groups.FffCursor = { fg = colors.fg, bg = colors.ui_2 }
        groups.FffDirectoryPath = { fg = colors.gray_15, bg = bg }
        groups.FffComment = { fg = colors.gray_14, bg = bg }
    end

    return groups
end

return M

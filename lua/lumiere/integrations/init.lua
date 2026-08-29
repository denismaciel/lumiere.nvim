local M = {}

M.get = function(colors, opts)
    local groups = {}
    local bg = opts.transparent and colors.none or colors.background

    if opts.integrations.gitsigns then
        groups.GitSignsAdd = { fg = colors.text_muted, bg = bg }
        groups.GitSignsChange = { fg = colors.text_muted, bg = bg }
        groups.GitSignsDelete = { fg = colors.text_muted, bg = bg }
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
        groups.NvimTreeNormal = { fg = colors.text, bg = bg }
        groups.NvimTreeNormalNC = { fg = colors.text_secondary, bg = bg }
        groups.NvimTreeCursorLine = { bg = colors.blue_bg }
        groups.NvimTreeFolderName = { fg = colors.text_strong, bold = opts.bold }
        groups.NvimTreeOpenedFolderName = { fg = colors.blue, bold = opts.bold }
        groups.NvimTreeRootFolder = { fg = colors.text_strong, bold = opts.bold }
        groups.NvimTreeFolderIcon = { fg = colors.blue }
        groups.NvimTreeIndentMarker = { fg = colors.text_invisible }
        groups.NvimTreeSymlink = { fg = colors.text_faint, italic = opts.italic }
        groups.NvimTreeSpecialFile = { fg = colors.text_strong, bold = opts.bold }
        groups.NvimTreeWinSeparator = { fg = colors.border, bg = bg }
        groups.NvimTreeGitDirty = { fg = colors.orange }
        groups.NvimTreeGitNew = { fg = colors.green }
        groups.NvimTreeGitDeleted = { fg = colors.red }
        groups.NvimTreeGitIgnored = { fg = colors.text_faint }
    end

    if opts.integrations.snacks then
        groups.SnacksPicker = { link = 'NormalFloat' }
        groups.SnacksPickerBorder = { link = 'FloatBorder' }
        groups.SnacksPickerMatch = { fg = colors.blue, bg = colors.blue_bg, bold = opts.bold }
        groups.SnacksPickerSelected =
            { fg = colors.text, bg = colors.surface_raised, bold = opts.bold }
    end

    if opts.integrations.fff then
        groups.FffNormal = { link = 'NormalFloat' }
        groups.FffBorder = { link = 'FloatBorder' }
        groups.FffMatch = { fg = colors.blue, bg = colors.blue_bg, bold = opts.bold }
        groups.FffCursor = { fg = colors.text, bg = colors.surface_raised }
        groups.FffDirectoryPath = { fg = colors.text_faint, bg = bg }
        groups.FffComment = { fg = colors.text_secondary, bg = bg }
    end

    return groups
end

return M

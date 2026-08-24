local util = require('lumiere.util')

local M = {}

M.get = function(colors, opts)
    local bg = opts.transparent and colors.none or colors.background
    local bg_nc = opts.transparent and colors.none or colors.background_inactive
    local inverse = opts.inverse
    local comments = util.merge({
        fg = colors.text_muted,
        bg = bg,
        italic = opts.italic,
    }, opts.styles.comments)
    local control_flow = util.syntax_style(
        { fg = colors.text, bg = bg, bold = true },
        opts.styles.control_flow,
        opts.bold
    )
    local declarations = util.syntax_style(
        { fg = colors.text, bg = bg, bold = true },
        opts.styles.declarations,
        opts.bold
    )

    return {
        Normal = { fg = colors.text, bg = bg },
        NormalNC = { fg = colors.text, bg = opts.dim_inactive and bg_nc or bg },
        NormalFloat = { fg = colors.text, bg = colors.surface },
        FloatBorder = { fg = colors.border_strong, bg = colors.surface },
        FloatTitle = { fg = colors.text_strong, bg = colors.surface, bold = opts.bold },
        ColorColumn = { fg = colors.orange, bg = colors.orange_bg },
        Conceal = { fg = colors.text_faint, bg = bg },
        Cursor = { reverse = true },
        CursorColumn = { bg = colors.surface_subtle },
        CursorLine = { bg = colors.surface_subtle },
        CursorLineNr = { fg = colors.text_strong, bg = bg, bold = opts.bold },
        Directory = { fg = colors.text, bg = bg, bold = opts.bold },
        EndOfBuffer = { fg = bg, bg = bg },
        ErrorMsg = { fg = colors.red, bg = bg, bold = opts.bold, reverse = inverse },
        FoldColumn = { fg = colors.text_secondary, bg = bg },
        Folded = { fg = colors.punctuation, bg = colors.surface_raised, italic = opts.italic },
        LineNr = { fg = colors.text_faint, bg = bg },
        MatchParen = { fg = colors.punctuation, bg = bg, reverse = opts.inverse },
        ModeMsg = { fg = colors.blue, bg = bg, bold = opts.bold },
        MoreMsg = { fg = colors.blue, bg = bg, bold = opts.bold },
        NonText = { fg = colors.text_invisible, bg = bg },
        Question = { fg = colors.green, bg = bg, bold = opts.bold },
        SignColumn = { fg = colors.blue, bg = bg },
        SpecialKey = { fg = colors.text_muted, bg = bg },
        LumiereCodeBlockLine = { bg = colors.surface_raised },
        StatusLine = { fg = colors.text_strong, bg = bg, underline = true },
        StatusLineNC = {
            fg = colors.text_secondary,
            bg = bg,
            underline = true,
            italic = opts.italic,
        },
        Substitute = { fg = colors.text_on_accent, bg = colors.search_bg, reverse = inverse },
        TabLine = { fg = colors.text_faint, bg = bg },
        TabLineFill = { bg = bg },
        TabLineSel = { fg = colors.text_strong, bg = colors.surface_selected, bold = opts.bold },
        Title = { fg = colors.text, bg = bg, bold = opts.bold },
        VertSplit = { fg = colors.border, bg = bg },
        Visual = { reverse = inverse },
        VisualNOS = { reverse = inverse },
        WarningMsg = { fg = colors.orange, bg = bg, bold = opts.bold },
        Whitespace = { fg = colors.text_invisible, bg = bg },
        WildMenu = { fg = colors.blue, bg = colors.white, bold = opts.bold, reverse = inverse },
        WinSeparator = { fg = colors.border, bg = bg },

        Search = { fg = colors.text_on_accent, bg = colors.search_bg },
        IncSearch = { fg = colors.text_on_accent, bg = colors.search_bg, reverse = inverse },
        CurSearch = {
            fg = colors.text_strong,
            bg = colors.none,
            bold = opts.bold,
            reverse = inverse,
        },

        LumiereControlFlow = control_flow,
        LumiereDeclaration = declarations,

        Comment = comments,
        Constant = { fg = colors.text, bg = bg },
        String = { fg = colors.text, bg = bg, italic = opts.italic },
        Character = { fg = colors.text, bg = bg, italic = opts.italic },
        Number = { fg = colors.text, bg = bg, italic = opts.italic },
        Boolean = { fg = colors.text, bg = bg },
        Float = { fg = colors.text, bg = bg, italic = opts.italic },
        Identifier = { fg = colors.text, bg = bg, italic = opts.italic },
        Function = util.merge(
            { fg = colors.text, bg = bg, italic = opts.italic },
            opts.styles.functions
        ),
        Statement = { fg = colors.text, bg = bg },
        Conditional = { link = 'LumiereControlFlow' },
        Repeat = { link = 'LumiereControlFlow' },
        Label = { link = 'LumiereDeclaration' },
        Operator = { fg = colors.text, bg = bg },
        Keyword = util.syntax_style({ fg = colors.text, bg = bg }, opts.styles.keywords, opts.bold),
        Exception = { link = 'LumiereControlFlow' },
        PreProc = { fg = colors.text, bg = bg },
        Include = { fg = colors.text, bg = bg, italic = opts.italic },
        Define = { link = 'LumiereDeclaration' },
        Macro = { link = 'LumiereDeclaration' },
        PreCondit = { fg = colors.text_muted, bg = bg, italic = opts.italic },
        Type = util.syntax_style({ fg = colors.text, bg = bg }, opts.styles.types, opts.bold),
        StorageClass = { link = 'LumiereDeclaration' },
        Structure = { link = 'LumiereDeclaration' },
        Typedef = { link = 'LumiereDeclaration' },
        Special = { fg = colors.text, bg = bg, italic = opts.italic },
        Underlined = { fg = colors.text, bg = bg, underline = true },
        Error = { fg = colors.red, bg = bg, bold = opts.bold, reverse = inverse },
        Todo = {
            fg = colors.text,
            bg = bg,
            bold = opts.bold,
            italic = opts.italic,
            reverse = inverse,
        },

        Pmenu = { fg = colors.text, bg = colors.surface_overlay },
        PmenuSel = { fg = colors.background, bg = colors.text, bold = opts.bold },
        PmenuKind = { fg = colors.blue, bg = colors.surface_overlay },
        PmenuExtra = { fg = colors.text_muted, bg = colors.surface_overlay },
        PmenuSbar = { bg = colors.surface_overlay },
        PmenuThumb = { bg = colors.text },

        DiffAdd = { fg = colors.green, bg = colors.green_bg },
        DiffChange = { fg = colors.blue, bg = colors.blue_bg },
        DiffDelete = { fg = colors.red, bg = colors.red_bg },
        DiffText = { fg = colors.blue, bg = colors.blue_bg, underline = true },
        Added = { fg = colors.green, bg = bg },
        Changed = { fg = colors.blue, bg = bg },
        Removed = { fg = colors.red, bg = bg },

        DiagnosticError = { fg = colors.red, bg = bg },
        DiagnosticWarn = { fg = colors.orange, bg = bg },
        DiagnosticInfo = { fg = colors.blue, bg = bg },
        DiagnosticHint = { fg = colors.green, bg = bg },
        DiagnosticOk = { fg = colors.green, bg = bg },
        DiagnosticVirtualTextError = { fg = colors.red, bg = bg },
        DiagnosticVirtualTextWarn = { fg = colors.orange, bg = bg },
        DiagnosticVirtualTextInfo = { fg = colors.blue, bg = bg },
        DiagnosticVirtualTextHint = { fg = colors.green, bg = bg },
        DiagnosticUnderlineError = { sp = colors.red, undercurl = true },
        DiagnosticUnderlineWarn = { sp = colors.orange, undercurl = true },
        DiagnosticUnderlineInfo = { sp = colors.blue, undercurl = true },
        DiagnosticUnderlineHint = { sp = colors.green, undercurl = true },
        DiagnosticFloatingError = { fg = colors.red, bg = colors.surface },
        DiagnosticFloatingWarn = { fg = colors.orange, bg = colors.surface },
        DiagnosticFloatingInfo = { fg = colors.blue, bg = colors.surface },
        DiagnosticFloatingHint = { fg = colors.green, bg = colors.surface },
        DiagnosticSignError = { fg = colors.red, bg = bg },
        DiagnosticSignWarn = { fg = colors.orange, bg = bg },
        DiagnosticSignInfo = { fg = colors.blue, bg = bg },
        DiagnosticSignHint = { fg = colors.green, bg = bg },

        LspReferenceText = { bg = colors.surface_raised },
        LspReferenceRead = { bg = colors.surface_raised },
        LspReferenceWrite = { bg = colors.surface_raised, underline = true },
        LspInlayHint = { fg = colors.text_faint, bg = colors.surface_raised },
        LspCodeLens = { fg = colors.text_faint, bg = bg },
        LspCodeLensSeparator = { fg = colors.text_invisible, bg = bg },

        SpellBad = { sp = colors.red, undercurl = true },
        SpellCap = { sp = colors.blue, undercurl = true },
        SpellLocal = { sp = colors.green, undercurl = true },
        SpellRare = { sp = colors.magenta, undercurl = true },
    }
end

return M

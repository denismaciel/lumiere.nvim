local M = {}

M.defaults = {
    variant = 'light',
    bold = true,
    italic = false,
    inverse = true,
    transparent = false,
    dim_inactive = true,
    integrations = {
        blink = true,
        fff = true,
        gitsigns = true,
        nvim_tree = true,
        snacks = true,
    },
    styles = {
        comments = {},
        control_flow = { bold = true },
        declarations = { bold = true },
        functions = {},
        keywords = {},
        types = {},
    },
}

M.options = vim.deepcopy(M.defaults)

M.setup = function(opts)
    M.options = vim.tbl_deep_extend('force', vim.deepcopy(M.defaults), opts or {})
end

return M

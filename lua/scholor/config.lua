local M = {}

M.defaults = {
    bold = true,
    italic = true,
    inverse = true,
    transparent = false,
    dim_inactive = false,
    integrations = {
        blink = true,
        fff = true,
        gitsigns = true,
        nvim_tree = true,
        snacks = true,
    },
    styles = {
        comments = { italic = true },
        functions = { italic = true },
        keywords = { bold = true },
        types = { bold = true },
    },
}

M.options = vim.deepcopy(M.defaults)

M.setup = function(opts)
    M.options = vim.tbl_deep_extend('force', vim.deepcopy(M.defaults), opts or {})
end

return M

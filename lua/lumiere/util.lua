local M = {}

local function hex_to_rgb(hex)
    hex = hex:gsub('#', '')
    return {
        tonumber(hex:sub(1, 2), 16),
        tonumber(hex:sub(3, 4), 16),
        tonumber(hex:sub(5, 6), 16),
    }
end

local function rgb_to_hex(rgb)
    return string.format('#%02x%02x%02x', rgb[1], rgb[2], rgb[3])
end

function M.blend(fg, bg, alpha)
    local foreground = hex_to_rgb(fg)
    local background = hex_to_rgb(bg)
    local blended = {}

    for i = 1, 3 do
        blended[i] = math.floor((alpha * foreground[i]) + ((1 - alpha) * background[i]) + 0.5)
    end

    return rgb_to_hex(blended)
end

function M.blend_bg(color, alpha, colors, opts)
    return M.blend(color, colors.background, alpha)
end

function M.style(enabled, value)
    return enabled and value or nil
end

function M.merge(base, extra)
    return vim.tbl_extend('force', base, extra or {})
end

return M

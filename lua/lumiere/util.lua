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

local function srgb_to_linear(channel)
    local value = channel / 255
    if value <= 0.04045 then
        return value / 12.92
    end
    return ((value + 0.055) / 1.055) ^ 2.4
end

local function linear_to_srgb(channel)
    local value
    if channel <= 0.0031308 then
        value = channel * 12.92
    else
        value = (1.055 * (channel ^ (1 / 2.4))) - 0.055
    end
    return math.floor((math.max(0, math.min(1, value)) * 255) + 0.5)
end

function M.blend(fg, bg, alpha)
    local foreground = hex_to_rgb(fg)
    local background = hex_to_rgb(bg)
    local blended = {}

    for i = 1, 3 do
        local foreground_linear = srgb_to_linear(foreground[i])
        local background_linear = srgb_to_linear(background[i])
        blended[i] = linear_to_srgb((alpha * foreground_linear) + ((1 - alpha) * background_linear))
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

function M.syntax_style(base, style, bold_enabled)
    local result = M.merge(base, style)
    if not bold_enabled then
        result.bold = nil
    end
    return result
end

return M

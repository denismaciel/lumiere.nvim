# lumiere.nvim

A Neovim-only light and dark colorscheme inspired by
[lumiere.vim](https://github.com/alexanderjeurissen/lumiere.vim).

Lumiere keeps syntax mostly grayscale and reserves color for search, diffs,
diagnostics, git state, and focused UI. Its light palette resembles warm paper;
the dark palette is the same restrained, warm-neutral system after nightfall.
Text, punctuation, chrome, and layered surfaces use separate contrast steps so
the editor stays legible without flattening everything into equal emphasis.
Accent hues share perceptual lightness and retain stable meanings: red errors,
orange warnings, yellow search, green success, blue information, and magenta
rare or exceptional state. Ordinary syntax, including strings, stays neutral.

## Install

```lua
vim.pack.add({
    { src = 'https://github.com/denismaciel/lumiere.nvim', name = 'lumiere.nvim' },
})
```

```lua
require('lumiere').setup({
    variant = 'light',
    bold = true,
    italic = false,
    inverse = true,
    dim_inactive = true,
})

vim.cmd.colorscheme('lumiere')
```

## Options

```lua
require('lumiere').setup({
    variant = 'light', -- 'light' or 'dark'
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
})
```

By default bold is reserved for control flow and declarations. Set
`bold = false` to remove theme-supplied bold everywhere, or override a specific
entry under `styles`.

The canonical palette also defines all 16 ANSI slots. Lumiere applies them to
Neovim terminals, including distinct cyan and bright variants.

## Credits

Inspired by Alexander Jeurissen's `lumiere.vim`.

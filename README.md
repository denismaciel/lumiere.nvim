# lumiere.nvim

A Neovim-only light colorscheme inspired by
[lumiere.vim](https://github.com/alexanderjeurissen/lumiere.vim).

Lumiere keeps syntax mostly grayscale and reserves color for search, diffs,
diagnostics, git state, and focused UI.

## Install

```lua
vim.pack.add({
    { src = 'https://github.com/denismaciel/lumiere.nvim', name = 'lumiere.nvim' },
})
```

```lua
require('lumiere').setup({
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
        functions = {},
        keywords = { bold = true },
        types = { bold = true },
    },
})
```

## Credits

Inspired by Alexander Jeurissen's `lumiere.vim`.

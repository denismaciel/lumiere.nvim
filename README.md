# scholor.nvim

A Neovim-only light colorscheme inspired by
[lumiere.vim](https://github.com/alexanderjeurissen/lumiere.vim).

Scholor keeps syntax mostly grayscale and reserves color for search, diffs,
diagnostics, git state, and focused UI.

## Install

```lua
vim.pack.add({
    { src = 'https://github.com/denismaciel/lumiere.nvim', name = 'scholor.nvim' },
})
```

```lua
require('scholor').setup({
    bold = true,
    italic = false,
    inverse = true,
    dim_inactive = true,
})

vim.cmd.colorscheme('scholor')
```

## Options

```lua
require('scholor').setup({
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

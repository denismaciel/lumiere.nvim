# lumiere.nvim

A Neovim-only light and dark colorscheme inspired by
[lumiere.vim](https://github.com/alexanderjeurissen/lumiere.vim).

Lumiere keeps its canvas and interface restrained while using calibrated color
for semantic syntax, search, diffs, diagnostics, git state, and focused UI. Its
light palette resembles warm paper; the dark palette is the same restrained,
warm-neutral system after nightfall.
Text, punctuation, chrome, and layered surfaces use separate contrast steps so
the editor stays legible without flattening everything into equal emphasis.
Accent hues share perceptual lightness and retain stable meanings. Syntax uses
magenta keywords, cyan types and modules, blue functions and declarations,
green strings, and orange numbers. Red remains reserved for errors.
Markdown heading levels use the six non-error accents with matching subtle
background tints, making document hierarchy visible at a glance.

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

## Quality checks

```sh
uv run scripts/check_palette.py
nvim --clean --headless -l tests/highlights.lua
```

The first check enforces schema parity, semantic roles, WCAG contrast bands,
OKLCH relationships, CVD-safe legibility, distinct ANSI slots, and the reviewed
SVG snapshot at `tests/snapshots/palette.svg`.

## Credits

Inspired by Alexander Jeurissen's `lumiere.vim`.

#!/usr/bin/env bash
set -euo pipefail

repo="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

exec nvim --clean \
  -O "$repo/reference/index.js" "$repo/reference/dependencies.py" \
  "+set runtimepath^=$repo" \
  '+set laststatus=2 showtabline=0 signcolumn=no' \
  '+lua vim.diagnostic.enable(false)' \
  "+source $repo/colors/scholor.lua" \
  '+windo set number relativenumber signcolumn=no' \
  '+wincmd ='

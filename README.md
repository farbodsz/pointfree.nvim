# pointfree.nvim

![](https://img.shields.io/badge/status-unstable-orange)

Convert Haskell code into point-free Haskell code, within Neovim!

This plugin lets you use the `pointfree` tool inside the editor.

<img src="https://github.com/farbodsz/pointfree.nvim/blob/master/demo.gif?raw=true" alt="demo-gif" width="680" height="350">

## Installation

Requirements:

- [`pointfree`](https://hackage.haskell.org/package/pointfree) package:
  ```sh
  $ stack install pointfree
  ```
- [`plenary.nvim`](https://github.com/nvim-lua/plenary.nvim) plugin

Then, add this plugin using your favourite Neovim package manager:

```lua
use({ "farbodsz/pointfree.nvim", requires = "nvim-lua/plenary.nvim" })
```

## Usage

- Run `:Pointfree` to replace your current line with the pointfree version

## About

### Motivation

Haskell programmers often write in
[pointfree style](https://wiki.haskell.org/Pointfree), which is considered
cleaner. The existing tools for transforming a function definition into
pointfree style are wonderful, but it would be even better if these were
integrated into the text-editing experience.

### Credits

- [bmillwood/pointfree](https://github.com/bmillwood/pointfree) for the
  standalone version of the Haskell point-free tool
- [keathley/pointfree.io](https://github.com/keathley/pointfree.io) for the web
  version of this tool, which I have used countless times

### License

This plugin is licensed under the
[MIT License](https://choosealicense.com/licenses/mit/).

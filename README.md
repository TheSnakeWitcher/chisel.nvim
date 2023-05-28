# Index


1. [Chisel.nvim](#Chisel.nvim)
2. [Installation](#Installation)
3. [Configuration](#Configuration)
4. [Documentation](#Documentation)
5. [License](#License)


# Chisel.nvim


Small plugin to more conveniently/easily interact with
[https://github.com/foundry-rs/foundry/tree/master/chisel](chisel) from
[https://github.com/foundry-rs/foundry](foundry) toolkit
inside neovim.


# Installation


Install using your prefered package manager. Next code
snippet corresponds to packer.

```lua
use {
    "TheSnakeWitcher/chisel.nvim,
    requires = {
        "akinsho/toggleterm.nvim",
        "nvim-telescope/telescope.nvim",
    },
}
```


# Configuration


Chisel.nvim doesn't register by default commands or keybindings so
you can personalize to whatever suits you. This section comes with
some configurations recipes/recommendations/samples.

### Options

Default configuration options next.

```lua
require('chisel').setup({

    -- others options are `vertical` or `horizontal` which corresponds to toggleterm
    open_direction = "float"   -- terminal direction when executing chisel.open
    load_direction = "float"   -- terminal direction when executing chisel.load
    view_direction = "float"   -- terminal direction when executing chisel.view

})
```

### Commands

```lua
local chisel = require("chisel")

vim.api.nvim_create_user_command("Chisel", function(opts)
    local args = opts.fargs
    if #args== 0 then
        chisel.open()
    else
        chisel.load(args[1])
    end
end,{
    desc = "launch a new chisel REPL, if an optional argument {id} was passed loads the corresponding cached session",
    nargs = "?",
})

vim.api.nvim_create_user_command("ChiselView", function(opts) chisel.view(opts.fargs[1]) end, {
    desc = "displays chisel sessions source code with {id}",
    nargs = 1,
})

vim.api.nvim_create_user_command("ChiselClearCache", chisel.clear_cache , {desc = "deletes all cache sessions"})
```

### Telescope integration

In some place of your [https://github.com/nvim-telescope/telescope.nvim](telescope) config put.

```lua
telescope.load_extension("chisel")
```

To use it you can run next command or map it to some keybinding.

```lua
:Telescope chisel
```


# Documentation


See `chisel`


# License


MIT

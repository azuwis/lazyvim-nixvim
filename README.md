# Setup LazyVim using NixVim

A [Nix flake][1] to setup [LazyVim][2] using [NixVim][3]

[1]: https://wiki.nixos.org/wiki/Flakes
[2]: http://www.lazyvim.org
[3]: https://github.com/nix-community/nixvim

### Quick test

```
nix run github:azuwis/lazyvim-nixvim
```

### Use in `nix shell`

```
nix shell github:azuwis/lazyvim-nixvim
nvim
```

### Use in `nix-shell`

```
nix-shell https://github.com/azuwis/lazyvim-nixvim/archive/refs/heads/master.zip
nvim
```

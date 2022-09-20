# dotfiles

Dotfiles for me, for syncing across computers!

## Installations

1. Install `brew` itself via https://brew.sh
1. Install `zprezto` via https://github.com/sorin-ionescu/prezto
1. Run this to install the brew packages we need

```
❯ brew list
==> Formulae
bash-git-prompt
cloudflared
diff-so-fancy
gh
go
nvm
pick
pnpm
pscale
the_silver_searcher
thefuck
zsh

==> Casks
1password-cli
apparency
graphiql
nightfall
notunes
qlimagesize
qlmarkdown
qlstephen
qlvideo
secretive
suspicious-package
syntax-highlight
```

## Copying files

1. Replace the contents of `zprezto/runcoms` folder with the `.z*` files as needed
1. Copy `.p10k.zsh` and the other dotfiles/contents of the folders in `dotfiles` to `~/`
1. Copy the contents of `xcode/UserData/FontsAndColorThemes` to `~/Library/Developer/Xcode/UserData/FontsAndColorThemes`
